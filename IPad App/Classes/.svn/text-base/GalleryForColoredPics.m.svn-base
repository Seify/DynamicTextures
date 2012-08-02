//
//  GalleryForColoredPics.m
//  KidsPaint
//
//  Created by Roman Smirnov on 14.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "GalleryForColoredPics.h"
#import "SoundManager.h"

@interface GalleryForColoredPics()
{
    BOOL draggingOn;
    SheetColored *sheetToScale;
    
    SheetColored *sheetToStabilizeFrom;
    SheetColored *sheetToStabilizeTo;
}
@property galleryType gType;

- (SheetColored *)findNearestSheet;
@end



@implementation GalleryForColoredPics

@synthesize state;
@synthesize delegate;
@synthesize shouldChangeEdgeSheetsZ = _shouldChangeEdgeSheetsZ;
@synthesize startPositionShiftLeft;
@synthesize gType = _gType;

- (NSArray *)sheets{
    if (!sheets){
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (int i = 0; i < [self.delegate howManyColoredSheetsInGallery:self]; i++) {
            SheetColored *shright = [[SheetColored alloc] initWithType:SHEET_COLORED_TYPE_RIGHT];
            shright.state = SHEET_COLORED_STATE_SHOWING_PICS;
            shright.shouldChangeEdgeSheetsZ = self.shouldChangeEdgeSheetsZ;
//            shright.translationX = - self.startPositionShiftLeft + i * COLOR_HACK_CONSTANT;
            shright.translationX = (i-1) * COLOR_HACK_CONSTANT;
            shright.alpha = 1.0;
            shright.number = i;
            shright.scaleX = COLORED_SHEET_SCALE_X;
            shright.scaleY = COLORED_SHEET_SCALE_Y;
            shright.scaleZ = COLORED_SHEET_SCALE_Z;
            shright.shouldLoadTextureIfUnloaded = YES;
            [tempArray addObject:shright];
            [shright release];
        }
        
        sheets = [NSMutableArray arrayWithArray:tempArray];
        [sheets retain];
        
    }
    return sheets;
}

- (SheetColored *)findNearestSheet{
    
    SheetColored *nearestSheet = [self.sheets lastObject];    
    for (SheetColored *currentSheet in self.sheets){
        if (currentSheet.type == SHEET_COLORED_TYPE_RIGHT)
            if (fabs(nearestSheet.translationX) > fabs(currentSheet.translationX)){
                nearestSheet = currentSheet;
            }
    }
    
    return nearestSheet;
}

- (BOOL)shouldDrawSheet:(SheetColored *)sh{
    
//    return YES;

    BOOL retValue;
    
    switch (sh.state) {
        case SHEET_COLORED_STATE_SHOWING_PICS:{
            retValue = (abs(sh.translationX) < 3 * COLOR_HACK_CONSTANT);
            break;
            
        }
        case SHEET_COLORED_STATE_STABILIZING:{
            retValue =   (abs(sh.translationX) < 3 * COLOR_HACK_CONSTANT);
            break;
        }
            
        case SHEET_COLORED_STATE_SCALING_TO_PAINTING_AREA:{
            retValue = YES;
            break;
        }
            
        case SHEET_COLORED_STATE_HIDDEN:
        case SHEET_COLORED_STATE_HIDING:{
            
            retValue = NO;
//            //test
//            retValue = YES;
            break;
        }
            
        default:{
            NSLog(@"%@ : %@  Unexpected sheet state: %d", self, NSStringFromSelector(_cmd), sh.state);
            break;
        }
    }
    return retValue;
}

- (id)initWithType:(galleryType)galType
{
    if (self = [super init])
    {
        
        self.gType = galType;
        switch (galType) {
            case GALLERY_TYPE_FLAT:
            {
                self.shouldChangeEdgeSheetsZ = NO;
                break;
            }
                
            case GALLERY_TYPE_SIDES_SHEETS_FAR:
            {
                self.shouldChangeEdgeSheetsZ = YES;
                break;
            }
                
            default:
            {
                NSLog(@"%@ : %@ Warning! Unexpected gallery type : %d", self, NSStringFromSelector(_cmd), galType);
                break;
            }
        }
    }
    return self;
}


- (void)stabilize {
    
    self.state = GALLERY_COLORED_STATE_STABILIZING;
    
    SheetColored *nearestSheet = [self findNearestSheet];
    
    if (self.sheets.count > 1) 
    {
        if (nearestSheet == [self.sheets objectAtIndex:0])
        {
            nearestSheet = [self.sheets objectAtIndex:1];
        }
    }
    
    sheetToStabilizeTo = nearestSheet;
    double tr = nearestSheet.translationX;
    
    double time = CFAbsoluteTimeGetCurrent();
    
    for (SheetColored *sh in self.sheets){
        sh.stabilisation.startTime = time;
        sh.stabilisation.endTime = sh.stabilisation.startTime + COLORED_STABILIZATION_TIME;
        sh.stabilisation.startPosition = CGRectMake(sh.translationX, 0, 0, 0);
        sh.stabilisation.endPosition = CGRectMake(sh.translationX - tr, 0, 0, 0);
        sh.stabilisation.state = ANIMATION_STATE_PLAYING;
        sh.state = SHEET_COLORED_STATE_STABILIZING;
    }    
    
//    [self.delegate newActiveSheetNumber:nearestSheet.number];  
    
    [self.delegate coloredGallery: self WillStabilizeToSheetNumber:nearestSheet.number
                                                  StartTime:time
                                                    EndTime:time + COLORED_STABILIZATION_TIME];
}

#pragma mark - Gesture handlers

- (void)touchBeganAtLocation:(CGPoint)location{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
}

- (void)touchMovedAtLocation:(CGPoint)location 
            PreviousLocation:(CGPoint)previousLocation
               InsideGallery:(BOOL)inside{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    switch (self.state) {
        case GALLERY_COLORED_STATE_SHOWING_PICS:{
            
            if (inside) {
            
                draggingOn = YES;
                
                double deltaX = (location.x-previousLocation.x) * COLORED_TRANSLATION_SPEED_FACTOR;

                if ([self.sheets count] >= 2)
                {
                    SheetColored *firstSheet = [self.sheets objectAtIndex:0];
                    SheetColored *lastSheet = [self.sheets lastObject];

                    if( (firstSheet.translationX + deltaX < - 0.9 * COLOR_HACK_CONSTANT) &&
                        (lastSheet.translationX + deltaX >  0.9 * COLOR_HACK_CONSTANT) )
                    {
                        
                        for (SheetColored *sh in self.sheets){
                            sh.translationX += deltaX;
                        }
                    }
                }
            }
            else {
                if (self.state != GALLERY_COLORED_STATE_STABILIZING){
                    self.state = GALLERY_COLORED_STATE_STABILIZING;
                    [self stabilize];
                }
            }
            
            break;   
        }
            
        case GALLERY_COLORED_STATE_STABILIZING:{
            
            break;
        }  
            
            
        case GALLERY_COLORED_STATE_HIDDEN:{
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected gallery state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

- (void)touchEndedAtLocation:(CGPoint)location 
               InsideGallery:(BOOL)inside{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
        switch (self.state) {
            case GALLERY_COLORED_STATE_SHOWING_PICS:{
                if (draggingOn){
                    
                    if (self.state != GALLERY_COLORED_STATE_STABILIZING){
                        self.state = GALLERY_COLORED_STATE_STABILIZING;
                        [self stabilize];
                    }
                    
//                    [self.delegate newActiveColoredSheetNumber:nearestSheet.number];
                    
                } else {
                    
                    if (inside)
                    {
                        
                        NSLog(@"%@ : %@ location = (%f, %f)", self, NSStringFromSelector(_cmd), location.x, location.y);
                        
                        SheetColored *nearestSheet = [self findNearestSheet]; // ближний к центру экрана лист
                        
                        if (location.x < 768.0/3.0 && nearestSheet.number > 0)
                        {
                            // коснулись слева
                            nearestSheet = [self.sheets objectAtIndex:nearestSheet.number - 1];
                        }
                        else if ((location.x >= 768.0/3.0 && location.x <768.0*2.0/3.0))
                        {
                            // коснулись по центру
                        }
                        else if (location.x >= 768.0*2.0/3.0 && nearestSheet.number <= [self.sheets count] - 2)
                        {
                            // коснулись справа
                            nearestSheet = [self.sheets objectAtIndex:nearestSheet.number + 1];
                        }
                        else {
                            NSLog(@"%@ : %@ Warning! Unexpected touch location.x: %f", self, NSStringFromSelector(_cmd), location.x);
                        }
                        
                        [self.delegate userDidSelectSheetNumber:nearestSheet.number InGallery:self];

                        
                        if ([self.delegate shouldAnimateSelectedSheetInGallery:self])
                        {
                            [self changeStateTo:GALLERY_COLORED_STATE_SCALING_TO_PAINTING_AREA AtTime:CFAbsoluteTimeGetCurrent()];
                        }
                        else {
                            [self changeStateTo:GALLERY_COLORED_STATE_HIDDEN AtTime:CFAbsoluteTimeGetCurrent()];
                        }
                    }
                }
                draggingOn = NO;
                
                break;
            }
                
            case GALLERY_COLORED_STATE_STABILIZING:
            case GALLERY_COLORED_STATE_SCALING_TO_PAINTING_AREA:
            case GALLERY_COLORED_STATE_HIDDEN:
            case GALLERY_COLORED_STATE_UNSCALING_FROM_PAINTING_AREA:
            {
                //do nothing
                break;
            }
                
            default:{
                NSLog(@"%@ : %@ unexpected gallery state: %d", self, NSStringFromSelector(_cmd), self.state);
                break;
            }
        }
}

- (void)touchesCancelledLocation:(CGPoint)location
{
    [self touchEndedAtLocation:location InsideGallery:NO];
};

- (void)scrollToSheetNumber:(int)sheetNumber 
                  StartTime:(double)startTime 
                    EndTime:(double)endTime
{
    
    sheetToStabilizeFrom = [self findNearestSheet];

    if (sheetNumber < [self.sheets count]) {
        sheetToStabilizeTo = [self.sheets objectAtIndex:sheetNumber];
    } else {
        sheetToStabilizeTo = [self.sheets lastObject];
    }
    
    if (sheetToStabilizeFrom.number != sheetToStabilizeTo.number){
        SoundManager *sm = [SoundManager sharedInstance];
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/scroll_4.mp3", [[NSBundle mainBundle] resourcePath]];  
        [sm playEffectFilePath:soundFilePath];

    }
    
    self.state = GALLERY_COLORED_STATE_STABILIZING;

    double tr = sheetToStabilizeTo.translationX;
    
    for (SheetColored *sh in self.sheets){
        sh.stabilisation.startTime = startTime;
        sh.stabilisation.endTime = endTime;
        sh.stabilisation.startPosition = CGRectMake(sh.translationX, 0, 0, 0);
        sh.stabilisation.endPosition = CGRectMake(sh.translationX - tr, 0, 0, 0);
        sh.stabilisation.state = ANIMATION_STATE_PLAYING;
        sh.state = SHEET_COLORED_STATE_STABILIZING;
    }    
    
    [self.delegate coloredGallery: self 
       WillStabilizeToSheetNumber:sheetNumber
                        StartTime:startTime
                          EndTime:endTime];

}

#pragma mark - State Machine

- (void)changeStateTo:(galleryColoredState)newstate AtTime:(double)currtime{
    
    switch (newstate) {
            
        case GALLERY_COLORED_STATE_SCALING_TO_PAINTING_AREA:{
            
            SheetColored *nearestSheet = [self findNearestSheet];
            sheetToScale = nearestSheet;
            if (sheetToScale){
                
                sheetToScale.previousScaleX = sheetToScale.scaleX;
                sheetToScale.previousScaleY = sheetToScale.scaleY;
                sheetToScale.previousScaleZ = sheetToScale.scaleZ;
                
                sheetToScale.previousTranslationX = sheetToScale.translationX;
                sheetToScale.previousTranslationY = sheetToScale.translationY;
                sheetToScale.previousTranslationZ = sheetToScale.translationZ;
                
                sheetToScale.previousRotationY = sheetToScale.rotationY;
                
                [self.delegate coloredSheetWillAnimateToPaintingPage:sheetToScale.number InGallery:self];
            }
            
            for (SheetColored *sh in self.sheets){
                if (sh != nearestSheet) {
                    sh.state = SHEET_COLORED_STATE_HIDING;
                }
            }
            
            nearestSheet.state = SHEET_COLORED_STATE_SCALING_TO_PAINTING_AREA;
            
            double time = CFAbsoluteTimeGetCurrent();
            
            
            nearestSheet.animation.startTime = time;
            nearestSheet.animation.endTime = nearestSheet.animation.startTime + COLORED_SCALING_TO_PAINTING_PAGE_DURATION;
            
            nearestSheet.animation.startTranslationX = nearestSheet.translationX;
            nearestSheet.animation.startTranslationY = nearestSheet.translationY;
            nearestSheet.animation.startTranslationZ = nearestSheet.translationZ;
            
            nearestSheet.animation.endTranslationX = COLORED_SCALING_TO_PAINTING_PAGE_END_TRANSLATION_X;
            nearestSheet.animation.endTranslationY = COLORED_SCALING_TO_PAINTING_PAGE_END_TRANSLATION_Y;
            nearestSheet.animation.endTranslationZ = COLORED_SCALING_TO_PAINTING_PAGE_END_TRANSLATION_Z;
            
            nearestSheet.animation.startRotationX = 0.0;
            nearestSheet.animation.startRotationY = nearestSheet.rotationY;
            nearestSheet.animation.startRotationZ = 0.0;
            
            if (nearestSheet.type == SHEET_COLORED_TYPE_LEFT){
                nearestSheet.animation.endRotationX = COLORED_SCALING_TO_PAINTING_PAGE_END_ROTATION_X;
                nearestSheet.animation.endRotationY = COLORED_SCALING_TO_PAINTING_PAGE_END_ROTATION_Y;
                nearestSheet.animation.endRotationZ = COLORED_SCALING_TO_PAINTING_PAGE_END_ROTATION_Z;
            } else {
                nearestSheet.animation.endRotationX = COLORED_SCALING_TO_PAINTING_PAGE_END_ROTATION_X - 180;
                nearestSheet.animation.endRotationY = COLORED_SCALING_TO_PAINTING_PAGE_END_ROTATION_Y - 180;
                nearestSheet.animation.endRotationZ = COLORED_SCALING_TO_PAINTING_PAGE_END_ROTATION_Z - 180;
            }
            
            nearestSheet.animation.startScaleX = nearestSheet.scaleX;
            nearestSheet.animation.startScaleY = nearestSheet.scaleY;
            nearestSheet.animation.startScaleZ = nearestSheet.scaleZ;
            
            nearestSheet.animation.endScaleX = COLORED_SCALING_TO_PAINTING_PAGE_END_SCALE_X;
            nearestSheet.animation.endScaleY = COLORED_SCALING_TO_PAINTING_PAGE_END_SCALE_Y;
            nearestSheet.animation.endScaleZ = COLORED_SCALING_TO_PAINTING_PAGE_END_SCALE_Z;                    
            
            nearestSheet.animation.state = ANIMATION_STATE_PLAYING;

            
            break;
            
        }
            
        case GALLERY_COLORED_STATE_UNSCALING_FROM_PAINTING_AREA:{
            
            sheetToScale.translationX = sheetToScale.previousTranslationX;
            sheetToScale.translationY = sheetToScale.previousTranslationY;
            sheetToScale.translationZ = sheetToScale.previousTranslationZ;
            
            sheetToScale.scaleX = sheetToScale.previousScaleX;
            sheetToScale.scaleY = sheetToScale.previousScaleY;
            sheetToScale.scaleZ = sheetToScale.previousScaleZ;
            
            sheetToScale.rotationY = sheetToScale.previousRotationY;
            
            for (SheetColored *sh in self.sheets) {
                sh.state = SHEET_COLORED_STATE_UNSCALING_FROM_PAINTING_AREA;
                        
                sh.animation.startTime = currtime;
//                sh.animation.endTime = sh.animation.startTime + COLORED_SCALING_TO_GALLERY_PAGE_DURATION;
                sh.animation.endTime = sh.animation.startTime;
                
                sh.animation.startAlpha = 0.0;
                sh.animation.endAlpha = 1.0;

                sheetToScale.animation.state = ANIMATION_STATE_PLAYING;
            }
            
            break;
        }
            
        case GALLERY_COLORED_STATE_SHOWING_PICS:{
            for (SheetColored *sh in self.sheets) {
                sh.state = SHEET_COLORED_STATE_SHOWING_PICS;
            }
            break;
        }
    
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected ColoredGallery's new state: %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
    
    
    self.state = newstate;
}

#pragma mark - Physics

- (void)updateSheets:(double)currtime{
    
    switch (self.state) {
            
        case GALLERY_COLORED_STATE_SHOWING_PICS:{
            for (SheetColored *sh in self.sheets){
                [sh updatePhysicsAtTime:currtime];
            }
            break;
        }
            
        case GALLERY_COLORED_STATE_SCALING_TO_PAINTING_AREA:{
            if (sheetToScale.animation.state == ANIMATION_STATE_PLAYING){
                [sheetToScale.animation updatePhysicsAtTime:currtime];
                
                sheetToScale.translationX = sheetToScale.animation.translationX;
                sheetToScale.translationY = sheetToScale.animation.translationY;
                sheetToScale.translationZ = sheetToScale.animation.translationZ;
                
                //                    sh.rotationX = sh.animation.rotationX;
                sheetToScale.rotationY = sheetToScale.animation.rotationY;
                //                    sh.rotationZ = sh.animation.rotationZ;
                
                sheetToScale.scaleX = sheetToScale.animation.scaleX;
                sheetToScale.scaleY = sheetToScale.animation.scaleY;
                sheetToScale.scaleZ = sheetToScale.animation.scaleZ;
                
            } 
            
            
            else if (sheetToScale.animation.state == ANIMATION_STATE_STOPPED){
                [self.delegate coloredSheetDidAnimateToPaintingPage:sheetToScale.number
                                                          InGallery:self];
                
                self.state = GALLERY_COLORED_STATE_HIDDEN;
            }
            
            break;
            
        }
            
        case GALLERY_COLORED_STATE_STABILIZING:{
            
            BOOL allSheetsStabilized = YES;
            for (SheetColored *sh in self.sheets){
                [sh updatePhysicsAtTime:currtime];
                if (sh.state == SHEET_COLORED_STATE_STABILIZING) {
                    allSheetsStabilized = NO;
                }
            }
            
            if (allSheetsStabilized){
                self.state = GALLERY_COLORED_STATE_SHOWING_PICS;
                [self.delegate coloredGallery: self DidStabilizedToSheetNumber:sheetToStabilizeTo.number];
            } else {
//                NSLog(@"%@ : %@ not all sheets are stabilized yet", self, NSStringFromSelector(_cmd));   
            }
            
            break;
        }
            
        case GALLERY_COLORED_STATE_UNSCALING_FROM_PAINTING_AREA: {
            
            for (SheetColored *sh in self.sheets){
                if (sh.animation.state == ANIMATION_STATE_PLAYING){
                    [sh.animation updatePhysicsAtTime:currtime];
                    
                    sh.alpha = sh.animation.alpha;
                }
            }
            
            BOOL allSheetsHasAppeared = TRUE;
            for (SheetColored *sh in self.sheets){
                if (sh.animation.state != ANIMATION_STATE_STOPPED){
                    allSheetsHasAppeared = FALSE;
                }
            }
            if (allSheetsHasAppeared){
                [self changeStateTo:GALLERY_COLORED_STATE_SHOWING_PICS AtTime:CFAbsoluteTimeGetCurrent()];
                [self.delegate coloredSheetDidAnimateToGallery:self];
            }

            break;
        }
            
        case GALLERY_COLORED_STATE_HIDDEN:{
            for (SheetColored *sh in self.sheets){
                sh.state = SHEET_COLORED_STATE_HIDDEN;
            }
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected gallery state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

- (void)addEmptySheetInTheEnd
{
    
        SheetColored *shright = [[SheetColored alloc] initWithType:SHEET_COLORED_TYPE_RIGHT];
        shright.state = SHEET_COLORED_STATE_SHOWING_PICS;
        shright.number = [sheets count];
        SheetColored *leftNeighbor = [sheets lastObject];
        if (leftNeighbor){
            shright.shouldChangeEdgeSheetsZ = self.shouldChangeEdgeSheetsZ;
            shright.translationX = leftNeighbor.translationX + COLOR_HACK_CONSTANT;
        } else {
            shright.shouldChangeEdgeSheetsZ = self.shouldChangeEdgeSheetsZ;
            shright.translationX = 0.0;
        }
        shright.alpha = 1.0;
        shright.scaleX = COLORED_SHEET_SCALE_X;
        shright.scaleY = COLORED_SHEET_SCALE_Y;
        shright.scaleZ = COLORED_SHEET_SCALE_Z;
        shright.shouldLoadTextureIfUnloaded = YES;
        [sheets addObject:shright];
        [shright release];
}

- (void)dealloc{
    [self.sheets release];
    [super dealloc];
}

@end
