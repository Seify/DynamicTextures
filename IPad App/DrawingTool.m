//
//  DrwaingTool.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 02.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "DrawingTool.h"
#import "DrawingToolExtended.h"

#define rgb 1.0/255.0*

@interface DrawingTool()
@property (readwrite) drawingToolState state;
@end

@implementation DrawingTool

@synthesize number, selectedExtendedNumber;
@synthesize state, previousState, nextState;
@synthesize stateChangeBeginTime, stateChangeEndTime;
@synthesize running_light2_position, running_light2_startTime, running_light2_endTime, running_light2_alpha;
@synthesize running_light1_position, running_light1_startTime, running_light1_endTime, running_light1_alpha;
@synthesize highlight_position, highlight_startTime, highlight_endTime, highlight_alpha; 
@synthesize running_shadow_position, running_shadow_startTime, running_shadow_endTime, running_shadow_alpha;
@synthesize previousPosition;
@synthesize red, green, blue, alpha;
@synthesize reflex_red, reflex_green, reflex_blue, reflex_alpha;
@synthesize body_red, body_green, body_blue, body_alpha, previousBody_alpha;
@synthesize isSelected;	
@synthesize delegate;
@synthesize extendedColors, activeColor;
@synthesize indexOfBodyTexture;

- (CGRect)position{
    return position;
}

- (void)setPosition:(CGRect)newposition{
    
    position = newposition;

//    if (newposition.origin.x == -45.0) {
//        NSLog(@"%@ : %@ self.position.origin.x = %f", self, NSStringFromSelector(_cmd), self.position.origin.x);
//        
//    }
    
}


- (ThreeDAnimation *)animation{
    if (!animation){
        animation = [[ThreeDAnimation alloc] init];
        animation.state = ANIMATION_STATE_STOPPED;
        animation.delegate = self;
    }
    return animation;
}

- (BOOL)isAnimated{
    return (self.state == DT_STATE_SELECTED);
}


- (NSArray *)drawingToolsExtended{
    if (!drawingToolsExtended) {
        NSMutableArray *tempArray;
        DrawingToolExtended *tempTool;
        tempArray = [NSMutableArray array];
        CGRect tempRect;
        UIColor *tempColor;
        
        tempRect = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 4, 
                              103+45, 
                              37);
        tempColor = [self.extendedColors objectAtIndex:0];
        tempTool = [[DrawingToolExtended alloc] initWithPosition:tempRect Color:tempColor];
        tempTool.number = 0;
        tempTool.indexOfBodyTexture = self.indexOfBodyTexture + 0;
        tempTool.previousState = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.state = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.parentDrawingTool = self;
        tempTool.delegate = self.delegate;
        [tempArray addObject:tempTool];        
        [tempTool release];   
        
        tempRect = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 5, 
                              103+45, 
                              37);
        tempColor = [self.extendedColors objectAtIndex:1];
        tempTool = [[DrawingToolExtended alloc] initWithPosition:tempRect Color:tempColor];
        tempTool.number = 1;
        tempTool.indexOfBodyTexture = self.indexOfBodyTexture + 1;
        tempTool.previousState = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.state = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.parentDrawingTool = self;
        tempTool.delegate = self.delegate;
        [tempArray addObject:tempTool];        
        [tempTool release];   
        
        tempRect = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 6, 
                              103+45, 
                              37);
        tempColor = [self.extendedColors objectAtIndex:2];
        tempTool = [[DrawingToolExtended alloc] initWithPosition:tempRect Color:tempColor];
        tempTool.number = 2;
        tempTool.indexOfBodyTexture = self.indexOfBodyTexture + 2;
        tempTool.previousState = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.state = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.parentDrawingTool = self;
        tempTool.delegate = self.delegate;
        [tempArray addObject:tempTool];        
        [tempTool release];   
        
        tempRect = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X,
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 7, 
                              103+45, 
                              37);
        tempColor = [self.extendedColors objectAtIndex:3];
        tempTool = [[DrawingToolExtended alloc] initWithPosition:tempRect Color:tempColor];
        tempTool.number = 3;
        tempTool.indexOfBodyTexture = self.indexOfBodyTexture + 3;
        tempTool.previousState = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.state = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.parentDrawingTool = self;
        tempTool.delegate = self.delegate;
        [tempArray addObject:tempTool];        
        [tempTool release];   
        
        tempRect = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 8, 
                              103+45, 
                              37);
        tempColor = [self.extendedColors objectAtIndex:4];
        tempTool = [[DrawingToolExtended alloc] initWithPosition:tempRect Color:tempColor];
        tempTool.number = 4;
        tempTool.indexOfBodyTexture = self.indexOfBodyTexture + 4;
        tempTool.previousState = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.state = DRAWING_TOOL_EXTENDED_STATE_INACTIVE;
        tempTool.parentDrawingTool = self;
        tempTool.delegate = self.delegate;
        [tempArray addObject:tempTool];        
        [tempTool release];           
                
        drawingToolsExtended = tempArray;
        
        for (int i=0; i<5; i++) {
            DrawingToolExtended *dte = [drawingToolsExtended objectAtIndex:i];
            if(i == self.activeColor){
                dte.nextState = DRAWING_TOOL_EXTENDED_STATE_SELECTED;
            } else {
                dte.nextState = DRAWING_TOOL_EXTENDED_STATE_UNSELECTED;
            }
        }

        [drawingToolsExtended retain];
    }
    
    return drawingToolsExtended;
}


- (DrawingTool *)initWithPosition:(CGRect)pos Color:(UIColor *)color{
    if(self == [super init]) {
        self.position = pos;
        self.previousPosition = self.position;
        
        const float* colors = CGColorGetComponents(color.CGColor);
        
//        NSLog(@"%@ : %@ color = %@", self, NSStringFromSelector(_cmd), color);
                
        [self setColorRed:colors[0] 
                    Green:colors[1] 
                     Blue:colors[2] 
                    Alpha:colors[3]];
        
        [self setBodyColorRed:colors[0] 
                        Green:colors[1] 
                         Blue:colors[2] 
                        Alpha:colors[3]];
        
    }
    return self;
}

- (DrawingTool *)initWithPosition:(CGRect)pos ColorArray:(NSArray *)tempColorArray ActiveColor:(int)active{
    if(self == [super init]) {
        self.position = pos;
        self.previousPosition = self.position;
        
        self.extendedColors = tempColorArray;
//        [self.extendedColors retain];
        self.activeColor = active;
        
//        NSLog(@"%@ : %@ self.extendedColors = %@", self, NSStringFromSelector(_cmd), self.extendedColors);
        
        UIColor *myColor = [self.extendedColors objectAtIndex:self.activeColor];
        
        const float* colors = CGColorGetComponents(myColor.CGColor);
        
        [self setColorRed:colors[0] 
                    Green:colors[1] 
                     Blue:colors[2] 
                    Alpha:colors[3]];
        
        [self setBodyColorRed:colors[0] 
                        Green:colors[1] 
                         Blue:colors[2] 
                        Alpha:colors[3]];
    }
    return self;
}

- (void)setColorRed:(float)newRed Green:(float)newGreen Blue:(float)newBlue Alpha:(float)newAlpha{
    red = newRed;
    green = newGreen;
    blue = newBlue;
    alpha = newAlpha;
//    [self setNeedsDisplay];
}

- (void)setReflexColorRed:(float)newRed Green:(float)newGreen Blue:(float)newBlue Alpha:(float)newAlpha{
    reflex_red = newRed;
    reflex_green = newGreen;
    reflex_blue = newBlue;
    reflex_alpha = newAlpha;
//    [self setNeedsDisplay];
}

- (void)setBodyColorRed:(float)newRed Green:(float)newGreen Blue:(float)newBlue Alpha:(float)newAlpha{
    body_red = newRed;
    body_green = newGreen;
    body_blue = newBlue;
    body_alpha = newAlpha;
    //    [self setNeedsDisplay];
}

- (BOOL)isLocationInside:(CGPoint)location{
    return (location.x > self.position.origin.x && location.x < self.position.origin.x + self.position.size.width 
            && location.y > self.position.origin.y && location.y < self.position.origin.y + self.position.size.height);    
}

#pragma mark - State Machine

- (void)changeStateTo:(drawingToolState)newstate NextState:(drawingToolState)dtNextState AtTime:(double)currtime
{
    switch (newstate) {
            
            
        case DT_STATE_APPEARS_ON_SCREEN:
        {
            
            self.animation.startTime = currtime + (DRAWING_TOOLS_BOX_UNHIDING_DURATION - DT_APPEARS_ON_SCREEN_DURATION);
            self.animation.endTime = self.animation.startTime + DT_APPEARS_ON_SCREEN_DURATION;
            
            self.animation.startPosition = self.position;
            
//            NSLog(@"%@ : %@ self.animation.startPosition.origin.x = %f", self, NSStringFromSelector(_cmd), self.animation.startPosition.origin.x);
            
            self.animation.startAlpha = self.body_alpha;
            
            float newX;
            float newAlpha;
            
            switch (dtNextState) {
                case DT_STATE_SELECTED:{
                    newX = DT_STATE_SELECTED_ORIGIN_X;
                    newAlpha = DT_STATE_SELECTED_ALPHA;
                    break;
                }
                    
                case DT_STATE_UNSELECTED:{
                    newX = DT_STATE_UNSELECTED_ORIGIN_X;
                    newAlpha = DT_STATE_UNSELECTED_ALPHA;
                    break;
                }
                    
                case DT_STATE_HIDDEN:{
                    newX = DT_STATE_HIDDEN_ORIGIN_X;
                    newAlpha = DT_STATE_HIDDEN_ALPHA;
                    break;
                }
                    
                case DT_STATE_SUPRESSED:{
                    newX = DT_STATE_SUPRESSED_ORIGIN_X;
                    newAlpha = DT_STATE_SUPRESSED_ALPHA;
                    break;
                }
                    
                case DT_STATE_OUT_OF_SCREEN:{
                    newX = DT_STATE_OUT_OF_SCREEN_ORIGIN_X;
                    newAlpha = DT_STATE_OUT_OF_SCREEN_ALPHA;   
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ Warning! Unexpected drawing tool next state: %d", self, NSStringFromSelector(_cmd), dtNextState);
                    break;
                }
            }
            
            self.animation.endAlpha = newAlpha;
            
            self.animation.endPosition = CGRectMake(newX, 
                                                  self.position.origin.y, 
                                                  self.position.size.width, 
                                                  self.position.size.height);
            
//            NSLog(@"%@ : %@ self.animation.endPosition.origin.x = %f", self, NSStringFromSelector(_cmd), self.animation.endPosition.origin.x);
            
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            break;
        }
            
        case DT_STATE_DISAPPEARS_FROM_SCREEN:
        {
            
            self.animation.startAlpha = self.alpha;
            self.animation.endAlpha = 1.0;
            
            self.animation.startPosition = self.position;
            self.animation.endPosition = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                                                  self.position.origin.y, 
                                                  self.position.size.width, 
                                                  self.position.size.height);
            
            //                NSLog(@"%@ : %@ dt.animation.startPosition = %f, dt.animation.endPosition = %f", self, NSStringFromSelector(_cmd), dt.animation.startPosition.origin.x, dt.animation.endPosition.origin.x);
            
            
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + DT_DISSAPPEARS_FROM_SCREEN_DURATION;
            
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            for (int i=0; i<[self.drawingToolsExtended count]; i++) {
                DrawingToolExtended *dte = [self.drawingToolsExtended objectAtIndex:i];
                
                [dte changeStateTo:DRAWING_TOOL_EXTENDED_STATE_DISAPPEARS_FROM_SCREEN
                         NextState: DRAWING_TOOL_EXTENDED_STATE_OUT_OF_SCREEN
                            AtTime:currtime];
            }    
            
            break;
        }
            
        case DT_STATE_HIDING:
        {
            float newX, newAlpha;
            
            switch (dtNextState) {
                case DT_STATE_HIDDEN:{
                    newX = DT_STATE_HIDDEN_ORIGIN_X;
                    newAlpha = DT_STATE_HIDDEN_ALPHA;
                    break;
                }
                 
                case DT_STATE_SUPRESSED:{
                    newX = DT_STATE_SUPRESSED_ORIGIN_X;
                    newAlpha = DT_STATE_SUPRESSED_ALPHA;
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ Warning! Unexpected Drawing Tool next state: %d", self, NSStringFromSelector(_cmd), dtNextState);
                    break;
                }
            }
            
            self.animation.startAlpha = self.alpha;
            self.animation.endAlpha = newAlpha;
            
            self.animation.startPosition = self.position;
            self.animation.endPosition = CGRectMake(newX, 
                                                    self.position.origin.y, 
                                                    self.position.size.width, 
                                                    self.position.size.height);
            
            //                NSLog(@"%@ : %@ dt.animation.startPosition = %f, dt.animation.endPosition = %f", self, NSStringFromSelector(_cmd), dt.animation.startPosition.origin.x, dt.animation.endPosition.origin.x);
            
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + DT_STATE_CHANGE_DURATION_FROM_UNSELECTER_TO_HIDDEN;
            
            self.animation.state = ANIMATION_STATE_PLAYING;

            break;
        }        
            
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected Drawing tool new state : %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
    
    self.previousState = self.state;
    self.previousPosition = self.position;
    self.previousBody_alpha = self.body_alpha;
    
    self.state = newstate;
    self.nextState = dtNextState;
};

- (void)changeStateTo:(drawingToolState)newstate{
    
    switch (newstate) {
            
        case DT_STATE_OUT_OF_SCREEN:{
            //do nothing;
            break;
        }

//  перенесено в changeStateTo:(drawingToolState)newstate NextState:(drawingToolState)dtNextState AtTime:(double)currtime
//        case DT_STATE_APPEARS_ON_SCREEN:{
//            //do nothing;
//            
//            self.body_alpha = 1.0;
//            
//            break;
//        }
            
        case DT_STATE_UNHIDING:{
            //do nothing;
            break;
        }
            
        case DT_STATE_UNSELECTED:{
            self.position = CGRectMake(DT_STATE_UNSELECTED_ORIGIN_X, self.position.origin.y, self.position.size.width, self.position.size.height);       
//            NSLog(@"%@ : %@ self.position = (%f, %f, %f, %f)", self, NSStringFromSelector(_cmd), self.position.origin.x, self.position.origin.y, self.position.size.width, self.position.size.height);
            break;
        }
            
        case DT_STATE_SELECTED:{
            self.position = CGRectMake(DT_STATE_SELECTED_ORIGIN_X, self.position.origin.y, self.position.size.width, self.position.size.height);
//            NSLog(@"%@ : %@ self.position = (%f, %f, %f, %f)", self, NSStringFromSelector(_cmd), self.position.origin.x, self.position.origin.y, self.position.size.width, self.position.size.height);
        
            self.running_light2_position = CGRectMake(self.position.origin.x, self.position.origin.y + DT_RUNNING_LIGHT_2_START_ORIGIN_Y_OFFSET, 50, 50);
            self.running_light2_startTime = CFAbsoluteTimeGetCurrent();
            self.running_light2_endTime = self.running_light2_startTime + DT_RUNNING_LIGHT_2_TOTAL_DURATION;
            self.running_light2_alpha = 1.0;
            
            self.running_light1_position = CGRectMake(DT_RUNNING_LIGHT_1_START_ORIGIN_X, self.position.origin.y + DT_RUNNING_LIGHT_1_START_ORIGIN_Y_OFFSET, 50, 50);
            self.running_light1_startTime = CFAbsoluteTimeGetCurrent();
            self.running_light1_endTime = self.running_light1_startTime + DT_RUNNING_LIGHT_1_TOTAL_DURATION;
            self.running_light1_alpha = 1.0;
            
            self.highlight_position = CGRectMake(DT_HIGHLIGHT_ORIGIN_X, self.position.origin.y + DT_HIGHLIGHT_ORIGIN_Y_OFFSET, DT_HIGHLIGHT_START_WIDTH, DT_HIGHLIGHT_START_HEIGHT);
            self.highlight_startTime = CFAbsoluteTimeGetCurrent();
            self.highlight_endTime = self.running_light1_startTime + DT_RUNNING_LIGHT_1_TOTAL_DURATION;
            self.highlight_alpha = 1.0;
            
            self.running_shadow_position = CGRectMake(DT_RUNNING_LIGHT_1_START_ORIGIN_X, self.position.origin.y + DT_RUNNING_LIGHT_1_START_ORIGIN_Y_OFFSET, 50, 50);
            self.running_shadow_startTime = CFAbsoluteTimeGetCurrent();
            self.running_shadow_endTime = self.running_light1_startTime + DT_RUNNING_LIGHT_1_TOTAL_DURATION;
            self.running_shadow_alpha = 1.0;

            break;
        }
            
        case DT_STATE_HIDING:{
            //do nothing
            break;
        }
            
        case DT_STATE_HIDDEN:{
            //do nothing
            break;
        }
            
        case DT_STATE_SUPRESSED:{
            //do nothing
            break;
        }

            
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected DT state: %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
    
    self.previousState = self.state;
    self.previousPosition = self.position;
    self.previousBody_alpha = self.body_alpha;
    self.state = newstate;
}

#pragma mark - Physics

- (void)updatePhysicsAtTime:(double)currtime{
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));

    [self.animation updatePhysicsAtTime:currtime];
    if (self.animation.state == ANIMATION_STATE_PLAYING){
        self.body_alpha = self.animation.alpha;
        self.position = self.animation.position;
//        NSLog(@"%@ : %@ self.alpha = %f", self, NSStringFromSelector(_cmd), self.alpha);
    }
    
    switch (self.state) {
        case DT_STATE_OUT_OF_SCREEN:{
            break;
        }

        case DT_STATE_APPEARS_ON_SCREEN:{
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = self.nextState;
            }
            break;
        }
            
        case DT_STATE_HIDING:
        {
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = self.nextState;
            }
            break;
        }            
            
        case DT_STATE_SUPRESSED:
        {
            self.body_alpha = 0.0;
            self.previousBody_alpha = self.body_alpha;
            break;
        }
            
        case DT_STATE_UNHIDING:
        {
            double timescale = (currtime - self.stateChangeBeginTime)/(self.stateChangeEndTime - self.stateChangeBeginTime);
            double deltaX;
            if (self.nextState == DT_STATE_UNSELECTED) {
                deltaX = DT_STATE_UNSELECTED_ORIGIN_X - DT_STATE_HIDDEN_ORIGIN_X;

                self.position = CGRectMake(self.previousPosition.origin.x + timescale * deltaX, 
                                           self.position.origin.y, 
                                           self.position.size.width, 
                                           self.position.size.height);
                
                if (self.position.origin.x > DT_STATE_UNSELECTED_ORIGIN_X) {
                    self.position = CGRectMake(DT_STATE_UNSELECTED_ORIGIN_X, 
                                               self.position.origin.y, 
                                               self.position.size.width, 
                                               self.position.size.height);
                }
                
                float deltaAlpha = 1.0 - self.previousBody_alpha;
                self.body_alpha = self.previousBody_alpha + timescale*deltaAlpha;
                
                if (self.body_alpha > 1.0) {
                    self.body_alpha = 1.0;
                }
            }
                else if (self.nextState == DT_STATE_SELECTED) {
                    
                deltaX = DT_STATE_SELECTED_ORIGIN_X - DT_STATE_HIDDEN_ORIGIN_X;
                    
                self.position = CGRectMake(self.previousPosition.origin.x + timescale * deltaX, 
                                           self.position.origin.y, 
                                           self.position.size.width, 
                                           self.position.size.height);
                
                if (self.position.origin.x > DT_STATE_SELECTED_ORIGIN_X) {
                    self.position = CGRectMake(DT_STATE_SELECTED_ORIGIN_X, 
                                               self.position.origin.y, 
                                               self.position.size.width, 
                                               self.position.size.height);
                }
                
                float deltaAlpha = 1.0 - self.previousBody_alpha;
                self.body_alpha = self.previousBody_alpha + timescale*deltaAlpha;
                
                if (self.body_alpha > 1.0) {
                    self.body_alpha = 1.0;
                }

            } else {
                NSLog(@"%@ : %@ Unknown Drawing Tool previousState: %d", self, NSStringFromSelector(_cmd), self.previousState);
            }
            
            if (currtime >= self.stateChangeEndTime) 
            {
                self.previousState = self.state;
                self.previousPosition = self.position;
                
//                self.state = self.nextState;
                [self changeStateTo:self.nextState];
            }

        
            break;
        }
            
        case DT_STATE_SELECTED:{
            
            float deltaX, deltaY, newX = 0, newY = 0, newAlpha = 0, newWidth, newHeight; //для running light 2
            float deltaX1, deltaY1, newX1 = 0, newY1 = 0, newAlpha1 = 0; //для running light 1
            
            if (currtime < self.running_light2_startTime + DT_RUNNING_LIGHT_2_START_DELAY) {
                newX = DT_RUNNING_LIGHT_2_START_ORIGIN_X;
                newY = self.running_light2_position.origin.y;
                newAlpha = 1.0;                
            } 
            else if (currtime >= self.running_light2_startTime + DT_RUNNING_LIGHT_2_START_DELAY
                       && currtime <= self.running_light2_endTime - DT_RUNNING_LIGHT_2_END_DELAY){
                
                double timescaleX = (currtime - (self.running_light2_startTime + DT_RUNNING_LIGHT_2_START_DELAY) )/(DT_RUNNING_LIGHT_2_START_TO_END_DURATION);
                
                deltaX = DT_RUNNING_LIGHT_2_END_ORIGIN_X - DT_RUNNING_LIGHT_2_START_ORIGIN_X;
                newX = DT_RUNNING_LIGHT_2_START_ORIGIN_X + timescaleX * deltaX;    
                
                if (self.running_light2_position.origin.x > DT_RUNNING_LIGHT_2_END_ORIGIN_X) {
                    newX = DT_RUNNING_LIGHT_2_END_ORIGIN_X;
                }
                
                double timescaleY = 0;
                deltaY = DT_RUNNING_LIGHT_2_END_ORIGIN_Y_OFFSET - DT_RUNNING_LIGHT_2_START_ORIGIN_Y_OFFSET;
                if (timescaleX > 0.85) timescaleY = (timescaleX - 0.85) / 0.15 * 1.0;
                newY = self.position.origin.y + DT_RUNNING_LIGHT_2_START_ORIGIN_Y_OFFSET + timescaleY * deltaY;
                
                newAlpha = 1.0;
                
            }
            else if (currtime < self.running_light2_endTime) {
                newX = DT_RUNNING_LIGHT_2_END_ORIGIN_X;
                newY = self.running_light2_position.origin.y;
                newAlpha = 0.0;
            } 
            else if (currtime >= self.running_light2_endTime){
                newX = DT_RUNNING_LIGHT_2_START_ORIGIN_X; 
                newY = self.position.origin.y + DT_RUNNING_LIGHT_2_START_ORIGIN_Y_OFFSET;
//                newAlpha = 1.0;
//                
//                self.running_light2_startTime = currtime;
//                self.running_light2_endTime = currtime + DT_RUNNING_LIGHT_2_TOTAL_DURATION;

//                NSLog(@"currtime = %f , running_light2_endTime = %f", currtime, self.running_light2_endTime);
                
            } 
            else {
                NSLog(@"%@ : %@ unexpected time!", self, NSStringFromSelector(_cmd));
            }
            
            self.running_light2_position = CGRectMake(newX, 
                                                     newY, 
                                                     DT_RUNNING_LIGHT_2_WIDTH, 
                                                     DT_RUNNING_LIGHT_2_HEIGHT);
            self.running_light2_alpha = newAlpha;



            
            
            // running light 1
            
            if (currtime < self.running_light1_startTime + DT_RUNNING_LIGHT_1_START_DELAY){
                newX1 = DT_RUNNING_LIGHT_1_START_ORIGIN_X;
                newY1 = self.running_light1_position.origin.y;
                newAlpha1 = 0.0;
            } 
            else if (currtime >= self.running_light1_startTime + DT_RUNNING_LIGHT_1_START_DELAY
                       && currtime <= self.running_light1_endTime - DT_RUNNING_LIGHT_1_END_DELAY){

                double timescaleX1 = (currtime - (self.running_light1_startTime + DT_RUNNING_LIGHT_1_START_DELAY) )/(DT_RUNNING_LIGHT_1_START_TO_END_DURATION);
                
                deltaX1 = DT_RUNNING_LIGHT_1_END_ORIGIN_X - DT_RUNNING_LIGHT_1_START_ORIGIN_X;
                newX1 = DT_RUNNING_LIGHT_1_START_ORIGIN_X + timescaleX1 * deltaX1;    
                
                if (self.running_light1_position.origin.x > DT_RUNNING_LIGHT_1_END_ORIGIN_X) {
                    newX1 = DT_RUNNING_LIGHT_1_END_ORIGIN_X;
                }
                
                double timescaleY1 = 0;
                deltaY1 = DT_RUNNING_LIGHT_1_END_ORIGIN_Y_OFFSET - DT_RUNNING_LIGHT_1_START_ORIGIN_Y_OFFSET;
                if (timescaleX1 > 0.85) timescaleY1 = (timescaleX1 - 0.85) / 0.15 * 1.0;
                newY1 = self.position.origin.y + DT_RUNNING_LIGHT_1_START_ORIGIN_Y_OFFSET + timescaleY1 * deltaY1;
                
                newAlpha1 = 1.0;
                
                
            } else if (currtime < self.running_light1_endTime) {
                newX1 = DT_RUNNING_LIGHT_1_END_ORIGIN_X;
                newY1 = self.running_light1_position.origin.y;
                newAlpha1 = 0.0;
            } 
            else if (currtime >= self.running_light1_endTime) {
                newX1 = DT_RUNNING_LIGHT_1_START_ORIGIN_X; 
                newY1 = self.position.origin.y + DT_RUNNING_LIGHT_1_START_ORIGIN_Y_OFFSET;
                newAlpha1 = 0.0;
                
//                self.running_light1_startTime = currtime;
//                self.running_light1_endTime = currtime + DT_RUNNING_LIGHT_1_TOTAL_DURATION;
            }
            else {
                NSLog(@"%@ : %@ unexpected time!", self, NSStringFromSelector(_cmd));
            }
            
            self.running_light1_position = CGRectMake(newX1, 
                                                      newY1, 
                                                      DT_RUNNING_LIGHT_1_WIDTH, 
                                                      DT_RUNNING_LIGHT_1_HEIGHT);
            self.running_light1_alpha = newAlpha1;
            
            
            //highlight
            
            if (currtime < self.highlight_startTime + DT_HIGHLIGHT_START_DELAY) {
                newX = DT_HIGHLIGHT_ORIGIN_X;
                newY = self.position.origin.y + DT_HIGHLIGHT_ORIGIN_Y_OFFSET;
                newWidth = DT_HIGHLIGHT_START_WIDTH;
                newHeight = DT_HIGHLIGHT_START_HEIGHT;
            } 
            else if (currtime >= self.highlight_startTime + DT_HIGHLIGHT_START_DELAY
                                   && currtime <= self.highlight_endTime - DT_HIGHLIGHT_END_DELAY){
                
                double timeScale = (currtime - (self.highlight_startTime + DT_HIGHLIGHT_START_DELAY) )/(DT_HIGHLIGHT_START_TO_END_DURATION);
                deltaX = DT_HIGHLIGHT_MAX_WIDTH - DT_HIGHLIGHT_START_WIDTH;
                deltaY = DT_HIGHLIGHT_MAX_HEIGHT - DT_HIGHLIGHT_START_HEIGHT;
                
                newX = self.highlight_position.origin.x - timeScale*deltaX/2.0;
                newWidth = self.highlight_position.size.width + timeScale*deltaX;
                if (newWidth > DT_HIGHLIGHT_MAX_WIDTH) {
                    newWidth = DT_HIGHLIGHT_MAX_WIDTH;
                    newX = self.position.origin.x + DT_HIGHLIGHT_ORIGIN_X - DT_HIGHLIGHT_MAX_WIDTH/2.0;;
                }
                
                newY = self.highlight_position.origin.y - timeScale*deltaY/2.0;
                newHeight = self.highlight_position.size.height + timeScale*deltaY;
                
                if (newHeight > DT_HIGHLIGHT_MAX_HEIGHT) {
                    newHeight = DT_HIGHLIGHT_MAX_HEIGHT;
                    newY = self.position.origin.y + DT_HIGHLIGHT_ORIGIN_Y_OFFSET - DT_HIGHLIGHT_MAX_HEIGHT/2.0;
                }
            }
            else if (currtime < self.highlight_endTime) {
                
            }

        else if (currtime >= self.highlight_endTime) {
            newX = DT_HIGHLIGHT_ORIGIN_X; 
            newY = self.position.origin.y + DT_HIGHLIGHT_ORIGIN_Y_OFFSET;
            
            newWidth = DT_HIGHLIGHT_START_WIDTH;
            newHeight = DT_HIGHLIGHT_START_WIDTH;
            
//            newAlpha1 = 0.0;
            
//            self.highlight_startTime = currtime;
//            self.highlight_endTime = currtime + DT_HIGHLIGHT_TOTAL_DURATION;
        }

            
//            NSLog(@"DT_RUNNING_LIGHT_1_TOTAL_DURATION = %f, DT_RUNNING_LIGHT_2_TOTAL_DURATION = %f",
//                  DT_RUNNING_LIGHT_1_TOTAL_DURATION,DT_RUNNING_LIGHT_2_TOTAL_DURATION);

            
            self.highlight_position = CGRectMake(newX, 
                                                 newY,  
                                                 newWidth, 
                                                 newHeight
                                                 );
            
            // running shadow
            if (currtime < self.running_shadow_startTime + DT_RUNNING_SHADOW_START_DELAY){
                newX1 = DT_RUNNING_SHADOW_START_ORIGIN_X;
                newY1 = self.running_shadow_position.origin.y;
                newAlpha1 = 0.0;
            } 
            else if (currtime >= self.running_shadow_startTime + DT_RUNNING_SHADOW_START_DELAY
                     && currtime <= self.running_shadow_endTime - DT_RUNNING_SHADOW_END_DELAY){
                
                double timescaleX1 = (currtime - (self.running_shadow_startTime + DT_RUNNING_SHADOW_START_DELAY) )/(DT_RUNNING_SHADOW_START_TO_END_DURATION);
                
                deltaX1 = DT_RUNNING_SHADOW_END_ORIGIN_X - DT_RUNNING_SHADOW_START_ORIGIN_X;
                newX1 = DT_RUNNING_SHADOW_START_ORIGIN_X + timescaleX1 * deltaX1;    
                
                if (self.running_shadow_position.origin.x > DT_RUNNING_SHADOW_END_ORIGIN_X) {
                    newX1 = DT_RUNNING_SHADOW_END_ORIGIN_X;
                }
                
                double timescaleY1 = 0;
                deltaY1 = DT_RUNNING_SHADOW_END_ORIGIN_Y_OFFSET - DT_RUNNING_SHADOW_START_ORIGIN_Y_OFFSET;
                if (timescaleX1 > 0.85) timescaleY1 = (timescaleX1 - 0.85) / 0.15 * 1.0;
                newY1 = self.position.origin.y + DT_RUNNING_SHADOW_START_ORIGIN_Y_OFFSET + timescaleY1 * deltaY1;
                
                newAlpha1 = 1.0;
                
                
            } else if (currtime < self.running_shadow_endTime) {
                newX1 = DT_RUNNING_SHADOW_END_ORIGIN_X;
                newY1 = self.running_shadow_position.origin.y;
                newAlpha1 = 0.0;
            } 
            else if (currtime >= self.running_shadow_endTime) {
                newX1 = DT_RUNNING_SHADOW_START_ORIGIN_X; 
                newY1 = self.position.origin.y + DT_RUNNING_SHADOW_START_ORIGIN_Y_OFFSET;
                newAlpha1 = 0.0;
                
//                self.running_shadow_startTime = currtime;
//                self.running_shadow_endTime = currtime + DT_RUNNING_SHADOW_TOTAL_DURATION;
            }
            else {
                NSLog(@"%@ : %@ unexpected time!", self, NSStringFromSelector(_cmd));
            }
            
            self.running_shadow_position = CGRectMake(newX1, 
                                                      newY1, 
                                                      DT_RUNNING_SHADOW_WIDTH, 
                                                      DT_RUNNING_SHADOW_HEIGHT);
            self.running_shadow_alpha = newAlpha1;

            
            
            
            break;
        }
            
        case DT_STATE_UNSELECTED:{
            // do nothing
            break;
        }
            
        case DT_STATE_HIDDEN:{
            // do nothing
            break;
        }
            
        case DT_STATE_DISAPPEARS_FROM_SCREEN:{
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = self.nextState;
            }
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected drawing tool's state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

- (void)extendTones:(double)currtime{
    for (int i=0; i<[self.drawingToolsExtended count]; i++) {
        DrawingToolExtended *dte = [self.drawingToolsExtended objectAtIndex:i];
        
        drawingToolExtendedState dteNextState;
        if(i == self.activeColor){
            dteNextState = DRAWING_TOOL_EXTENDED_STATE_SELECTED;
        } else {
            dteNextState = DRAWING_TOOL_EXTENDED_STATE_UNSELECTED;
        }
        
        [dte changeStateTo:DRAWING_TOOL_EXTENDED_STATE_PUSHING 
                 NextState:dteNextState 
                    AtTime:currtime];
    }
}

#pragma mark - ThreeDAnimation Delegate methods

- (void)animationEnded{
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    self.position = self.animation.position;
    self.alpha = self.animation.alpha;
    
    
}

- (void)dealloc{
    
    [extendedColors release];
    [drawingToolsExtended release];
    
    [super dealloc];
}

@end
