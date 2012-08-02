//
//  Painting.m
//  KidsPaint
//
//  Created by Roman Smirnov on 13.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "Painting.h"
#import "Mathematics.h"
#import "KidsPaintAppDelegate.h"
#import "AnimationConstants.h"
#import "SoundManager.h"

@implementation Painting

@synthesize delegate;
@synthesize currentArea;
@synthesize countDrawingTrianglesPositions;
@synthesize brushSize;
@synthesize isCustomColorActive;
@synthesize currentPictureState;

- (Animation *)shadowing{
    if (!shadowing){
        shadowing = [[ShadingAnimation alloc] init];
    }
    return shadowing;
}
- (NSMutableArray *)animations{
    if (!animations) {
        animations = [NSMutableArray array];
        [animations retain];
    }
    
    return animations;
}

- (void)setAnimations:(NSMutableArray *)newanimations{
    if (animations != newanimations) {
        if (animations){
            [animations release];
        }
        animations = newanimations;
        [animations retain];
    }
}

- (GLfloat *) getBrushArray{
    return drawingTrianglesPositions;
}

- (BOOL)areTherePlayingAnimations{
    for (Animation *anima in self.animations) {
        if (anima.state == ANIMATION_STATE_PLAYING) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat *) getBrushColor{
    return brushColor;
}


- (void)changePictureStateToModified
{
    switch (self.currentPictureState) {
        case PICTURE_STATE_EXISTING_MODIFIED:{
            //do nothing
            break;
        }
            
        case PICTURE_STATE_EXISTING_UNMODIFIED:{
            self.currentPictureState = PICTURE_STATE_EXISTING_MODIFIED;
            break;
        }
            
        case PICTURE_STATE_NEW_UNMODIFIED:{
            self.currentPictureState = PICTURE_STATE_NEW_MODIFIED;
            break;
        }
            
        case PICTURE_STATE_NEW_MODIFIED:{
            //do nothing
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected picture's state: %d", self, NSStringFromSelector(_cmd), self.currentPictureState);
            break;
        }
    }
}

#pragma mark - Gesture handlers

// код поиска неоптимальный, так как проходит в каждом последующей итерации все предыдущие
- (float)findDrawableAreaNearPointWithXCoord:(int)xCoord YCoord:(int)yCoord
{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    int deltaCoord = 1;
    BOOL pointFound = FALSE;
    
    while (!pointFound) {
        
        for (int i = MAX(xCoord - deltaCoord, 0); i<MIN(xCoord + deltaCoord, 560); i++) {
            for (int j = MAX(yCoord - deltaCoord, 0); j<MIN(yCoord + deltaCoord, 800); j++) {
                
                if (areas[i][j] != UNPAINTED_AREA_NUMBER && areas[i][j] != BLACK_AREA_NUMBER){
                    return (float)areas[i][j];
                }
            }
        }
        deltaCoord ++;
    }
    
    return UNPAINTED_AREA_NUMBER;
}

- (void)touchBeganAtLocation:(CGPoint)location{
    
//    if (isLocationOnPaintingView(location) ) {

        CGPoint locationOnPaintingView = convertLocationToPaintingViewLocation(location);
        
        self.currentArea = areas[(int)locationOnPaintingView.x][(int)locationOnPaintingView.y];
    
    if ((self.currentArea == BLACK_AREA_NUMBER) || (self.currentArea == UNPAINTED_AREA_NUMBER) ) {
        self.currentArea = [self findDrawableAreaNearPointWithXCoord:(int)locationOnPaintingView.x 
                                                               YCoord:(int)locationOnPaintingView.y];
        
        NSLog(@"new self.currentArea = %f", self.currentArea);

    }
            
    self.currentArea /=255.0;
    
    #define MAX_VERTEX 1000
    #define MAX_AREAS_TO_FILL 10
        
        KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
        
        //        NSLog(@"%@ : %@ : app.paintMode = %d)", self, NSStringFromSelector(_cmd), app.paintMode);
        
        [self changePictureStateToModified];
        
        if (app.paintMode != paintModeSimple) {                    
            if (self.currentArea != BLACK_AREA_NUMBER / 255.0 && self.currentArea != UNPAINTED_AREA_NUMBER / 255.0){
                float radius = self.brushSize/2.0;
                [self addPoligonVertexesForBrushWithRadius:radius xpos:location.x ypos:location.y];

                self.shadowing.state = ANIMATION_STATE_PLAYING;
                self.shadowing.startTime = CFAbsoluteTimeGetCurrent();
                self.shadowing.unopaqueEndTime = self.shadowing.startTime + SHADING_TRANSPARENT_DURATION;
                self.shadowing.endTime = self.shadowing.startTime + SHADING_DURATION;
                self.shadowing.startAlpha = SHADING_START_ALPHA;
                self.shadowing.alpha = self.shadowing.startAlpha;
                self.shadowing.endAlpha = SHADING_END_ALPHA;
                           
            } else {
                self.shadowing.state = ANIMATION_STATE_STOPPED;
                self.shadowing.alpha = 0.0;

            }
        } 
        else if (app.paintMode == paintModeSimple) {
            
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/paint_3.mp3", [[NSBundle mainBundle] resourcePath]];  
            SoundManager *sm = [SoundManager sharedInstance];        
            [sm playEffectFilePath:soundFilePath];


            FillingAnimation *fa = [[FillingAnimation alloc] init];
            
            fa.startPosition = CGRectMake(location.x, location.y, 0, 0);
            fa.position = fa.startPosition;
            fa.endPosition = CGRectMake(location.x, 
                                        location.y, 
                                        100, 
                                        100);
            double currtime = CFAbsoluteTimeGetCurrent();
            fa.startTime = currtime;
            fa.endTime = fa.startTime + FILLING_DURATION;

            fa.fillingColor = [UIColor colorWithRed:brushColor[0] 
                                              green:brushColor[1] 
                                               blue:brushColor[2] 
                                              alpha:brushColor[3]];
            
            CGPoint locationOnPaintingView = convertLocationToPaintingViewLocation(location);
//            fa.area = areas[(int)locationOnPaintingView.x][(int)locationOnPaintingView.y] / 255.0;
            fa.area = self.currentArea;
            
            [fa addStarsAnimations:currtime];
            
            @synchronized(self.animations) {
                [self.animations addObject:fa];
            }
            
            [fa release];
        }
//        return YES;
//    }
//    return NO;
}

- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation{

    [self changePictureStateToModified];    
    
    KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];

    if (app.paintMode != paintModeSimple) {
        
//        NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/draw_fast_2.mp3", [[NSBundle mainBundle] resourcePath]];  
//        SoundManager *sm = [SoundManager sharedInstance];        
//        [sm playEffectFilePath:soundFilePath];
        
        float sl = sectorLength(location, previousLocation);
        
        float distanceBetweenPoints = self.brushSize / 12.0;
        if (distanceBetweenPoints < 1.0) 
        {
            distanceBetweenPoints = 1.0;
        }       
        
        int vertcount = (int) sl / distanceBetweenPoints;
        
        float deltaX = (location.x - previousLocation.x)/(vertcount);
        float deltaY = (location.y - previousLocation.y)/(vertcount);
        
        for (int i=0; i<vertcount; i++) {           
            float xpos = previousLocation.x + deltaX*(i + 1);
            float ypos = previousLocation.y + deltaY*(i + 1);
            float radius = self.brushSize/2.0;
            [self addPoligonVertexesForBrushWithRadius:radius xpos:xpos ypos:ypos];
            
        }  
    }
}

- (void)touchEndedAtLocation:(CGPoint)location{
    
    KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
    if (app.paintMode != paintModeSimple) {
        
        self.shadowing.state = ANIMATION_STATE_STOPPED;
        self.shadowing.alpha = 0.0;
        
        if (isLocationOnPaintingView(location) ) {
            
            [self changePictureStateToModified];
            
            float radius = self.brushSize/2.0;
            [self addPoligonVertexesForBrushWithRadius:radius xpos:location.x ypos:location.y];
        }
    }
}

- (void)touchesCancelledLocation:(CGPoint)location{
    [self touchEndedAtLocation:location];
}

- (void)updateAnimations:(double)currtime{
//    NSLog(@"%@ : %@, self, NSStringFromSelector(_cmd));
    
    for (Animation *an in self.animations) {
        [an updatePhysicsAtTime:currtime];
    }
    
    [self removeUnusedAnimations];
    
    [self.shadowing updatePhysicsAtTime:currtime];
}

- (void)removeUnusedAnimations{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.animations];
    
    @synchronized(self.animations) {    
        for (Animation *an in self.animations) {
            if (an.state != ANIMATION_STATE_PLAYING) {
                [tempArray removeObject:an];
            }
        }
        self.animations = tempArray;    
    }
}

- (BOOL)shouldPlayAnimation:(Animation *)anima{
    return (anima.state == ANIMATION_STATE_PLAYING);
}


- (void)setBrushColorRed:(GLfloat)red Green:(GLfloat)green Blue:(GLfloat)blue{
    brushColor[0] = red;
    brushColor[1] = green;
    brushColor[2] = blue;
}

- (void)setBrushColorRed:(GLfloat)red Green:(GLfloat)green Blue:(GLfloat)blue Alpha:(GLfloat)alpha{
    brushColor[0] = red;
    brushColor[1] = green;
    brushColor[2] = blue;
    brushColor[3] = alpha;
    //    brushColor[3] = currpencil.alpha;
}

- (void)addPoligonVertexesForBrushWithRadius:(float)radius xpos:(float)xpos ypos:(float)ypos {
    
#define MAX_TRIANGLES 10000
    
    if (!drawingTrianglesPositions) {
        drawingTrianglesPositions = malloc(MAX_TRIANGLES * 3 * 4 * sizeof(GLfloat));
    } 
    
    
    CGPoint point1 = convertLocationToPaintingViewLocation( CGPointMake(xpos - radius/2.0, ypos + radius) );
    point1 = convertPaintingViewPixelsToGLCoords(point1);
    CGPoint point1tex = CGPointMake(0.25, 1.0);
    
    CGPoint point2 = convertLocationToPaintingViewLocation( CGPointMake(xpos + radius/2.0, ypos + radius) );
    point2 = convertPaintingViewPixelsToGLCoords(point2);
    CGPoint point2tex = CGPointMake(0.75, 1.0);
    
    CGPoint point3 = convertLocationToPaintingViewLocation( CGPointMake(xpos + radius, ypos + radius/2.0) );
    point3 = convertPaintingViewPixelsToGLCoords(point3);
    CGPoint point3tex = CGPointMake(1.0, 0.75);
    
    CGPoint point4 = convertLocationToPaintingViewLocation( CGPointMake(xpos + radius, ypos - radius/2.0) );
    point4 = convertPaintingViewPixelsToGLCoords(point4);                
    CGPoint point4tex = CGPointMake(1.0, 0.25);
    
    CGPoint point5 = convertLocationToPaintingViewLocation( CGPointMake(xpos + radius/2.0, ypos - radius) );
    point5 = convertPaintingViewPixelsToGLCoords(point5);
    CGPoint point5tex = CGPointMake(0.75, 0.0);
    
    CGPoint point6 = convertLocationToPaintingViewLocation( CGPointMake(xpos - radius/2.0, ypos - radius) );
    point6 = convertPaintingViewPixelsToGLCoords(point6);
    CGPoint point6tex = CGPointMake(0.25, 0.0);
    
    CGPoint point7 = convertLocationToPaintingViewLocation( CGPointMake(xpos - radius, ypos - radius/2.0) );
    point7 = convertPaintingViewPixelsToGLCoords(point7);
    CGPoint point7tex = CGPointMake(0.0, 0.25);
    
    CGPoint point8 = convertLocationToPaintingViewLocation( CGPointMake(xpos - radius, ypos + radius/2.0) );
    point8 = convertPaintingViewPixelsToGLCoords(point8);
    CGPoint point8tex = CGPointMake(0.0, 0.75);
    
    // треугольник А (p1-p2-p8)
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point1.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point1.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point1tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point1tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point2.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point2.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point2tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point2tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point8.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point8.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point8tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point8tex.y;
    countDrawingTrianglesPositions++; 
    
    // треугольник B (p2-p6-p8)
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point2.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point2.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point2tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point2tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point6.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point6.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point6tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point6tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point8.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point8.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point8tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point8tex.y;
    countDrawingTrianglesPositions++; 
    
    // треугольник C (p2-p4-p6)
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point2.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point2.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point2tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point2tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point4.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point4.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point4tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point4tex.y;
    countDrawingTrianglesPositions++;     
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point6.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point6.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point6tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point6tex.y;
    countDrawingTrianglesPositions++; 
    
    // треугольник D (p2-p3-p4)
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point2.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point2.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point2tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point2tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point3.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point3.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point3tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point3tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point4.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point4.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point4tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point4tex.y;
    countDrawingTrianglesPositions++;     
    
    // треугольник E (p4-p5-p6)
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point4.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point4.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point4tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point4tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point5.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point5.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point5tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point5tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point6.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point6.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point6tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point6tex.y;
    countDrawingTrianglesPositions++; 
    
    // треугольник F (p6-p7-p8)
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point6.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point6.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point6tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point6tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point7.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point7.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point7tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point7tex.y;
    countDrawingTrianglesPositions++; 
    
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 0] = point8.y;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 1] = -point8.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 2] = point8tex.x;
    drawingTrianglesPositions[countDrawingTrianglesPositions * 4 + 3] = point8tex.y;
    countDrawingTrianglesPositions++;             
    
    if (countDrawingTrianglesPositions > MAX_TRIANGLES * 0.9) 
        NSLog(@"%@ : %@ Triangle Buffer Overflow Warning", self, NSStringFromSelector(_cmd));
}


#pragma mark - Init Areas

- (void) loadAreasFromFileForBookNumber:(int)booknumber PageNumber:(int)pagenumber{
    
//    NSLog(@"%@ : %@ begin", self, NSStringFromSelector(_cmd) );
    
    NSString *areaspath = [NSString stringWithFormat:@"%@/books/book%d/areas/%d", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];  
    //    BOOL areasFileExists = [[NSFileManager defaultManager] fileExistsAtPath:areaspath];
    //    
    //    if (!areasFileExists) {
    //        NSLog(@"PaintingView: file with areas data does not exist. Gonna create one.");
    //        NSString *areaspathpng = [NSString stringWithFormat:@"%@/books/book%d/areas/AREAS%d.png", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
    //        [self createAreasFileFromPNGFileInPath:areaspathpng ForBookNumber:booknumber ForPageNumber:pagenumber];
    //    }
    NSData *readeddata = [NSData dataWithContentsOfFile:areaspath];
    NSUInteger len = [readeddata length];    
    [readeddata getBytes:areas length:len];  
    
    //    [readeddata release];
    
//    NSLog(@"%@ : %@ end", self, NSStringFromSelector(_cmd) );
}

- (int)getAreaX:(int)i Y:(int)j{
    return areas[i][j];
}

- (void)freeArrays{
    free(drawingTrianglesPositions);
}

#pragma mark - save & restore state

- (void)saveState
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:brushColor[0] forKey:@"lastBrushColorRed"];
    [defaults setFloat:brushColor[1] forKey:@"lastBrushColorGreen"];
    [defaults setFloat:brushColor[2] forKey:@"lastBrushColorBlue"];
    [defaults setFloat:brushColor[3] forKey:@"lastBrushColorAlpha"];
    [defaults setBool:YES forKey:@"lastBrushColorSaved"];
    
//    [defaults setObject:[NSNumber numberWithFloat: self.brushSize] forKey:@"brushSize"];
    
    [defaults synchronize];
    
}

- (void)restoreState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"lastBrushColorSaved"])
    {
        float red = [defaults floatForKey:@"lastBrushColorRed"];
        float green = [defaults floatForKey:@"lastBrushColorGreen"];
        float blue = [defaults floatForKey:@"lastBrushColorBlue"];
        
        [self setBrushColorRed:red
                         Green:green
                          Blue:blue
                         Alpha:1.0];
        
        
    } else {
        NSLog(@"%@ : %@ failed to restore brushColor", self, NSStringFromSelector(_cmd));
    }
    
//    NSNumber bSizeNum = [defaults objectForKey:@"brushSize"];
//    if (bSizeNum){
//        self.brushSize = [bSizeNum floatValue];
//    }
//    [defaults setObject:[NSNumber numberWithFloat: self.brushSize] forKey:@"brushSize"];

    
}

- (void)dealloc{
    if (animations) [animations release];
    [super dealloc];
}

@end
