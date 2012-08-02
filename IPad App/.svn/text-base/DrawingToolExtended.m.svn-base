//
//  DrawingToolExtended.m
//  KidsPaint
//
//  Created by Roman Smirnov on 05.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "DrawingToolExtended.h"

@interface DrawingToolExtended()
@property (readwrite) drawingToolExtendedState state;
@end

@implementation DrawingToolExtended

//@synthesize state;
@synthesize parentDrawingTool;

- (void)setState:(drawingToolExtendedState)newstate{
    state = newstate;
}
- (BOOL)isAnimated{
    return (self.state == DRAWING_TOOL_EXTENDED_STATE_SELECTED);
}

#pragma mark - State Machine

- (void)changeStateTo:(drawingToolExtendedState)newstate 
            NextState:(drawingToolExtendedState)dteNextState 
               AtTime:(double)currtime
{
    switch (newstate) {
        case DRAWING_TOOL_EXTENDED_STATE_APPEARS_ON_SCREEN:
        {
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + DTE_APPEARS_ON_SCREEN_DURATION;
            
            self.animation.startPosition = self.position;
            
            float newX;
            
            switch (dteNextState) {
                case DRAWING_TOOL_EXTENDED_STATE_SELECTED:{
                    newX = DRAWING_TOOL_EXTENDED_STATE_SELECTED_ORIGIN_X;
                    break;
                }
                    
                case DRAWING_TOOL_EXTENDED_STATE_UNSELECTED:{                    
                    newX = DRAWING_TOOL_EXTENDED_STATE_UNSELECTED_ORIGIN_X;
                    break;
                }
                    
                case DRAWING_TOOL_EXTENDED_STATE_INACTIVE:{
                    newX = DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X;
                    break;
                }
                    
                    
                default:{
                    NSLog(@"%@ : %@ Warning! Unexpected Drawing Tool Extended next state: %d", self, NSStringFromSelector(_cmd), dteNextState);
                    break;
                }
            }
            
            self.animation.endPosition = CGRectMake(newX, 
                                                    self.position.origin.y, 
                                                    self.position.size.width, 
                                                    self.position.size.height);
                        
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            break;
        }
            
        case DRAWING_TOOL_EXTENDED_STATE_PUSHING:
        {
    
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + DRAWING_TOOL_EXTENDED_STATE_CHANGE_DURATION_FROM_INACTIVE_TO_UNSELECTED;
            
            self.animation.startPosition = self.position;
            
            float newX;
            
            switch (dteNextState) {
                case DRAWING_TOOL_EXTENDED_STATE_SELECTED:{
                    newX = DRAWING_TOOL_EXTENDED_STATE_SELECTED_ORIGIN_X;
                    break;
                }
                    
                case DRAWING_TOOL_EXTENDED_STATE_UNSELECTED:{                    
                    newX = DRAWING_TOOL_EXTENDED_STATE_UNSELECTED_ORIGIN_X;
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ Warning! Unexpected Drawing Tool Extended next state: %d", self, NSStringFromSelector(_cmd), dteNextState);
                    break;
                }
            }
            
            self.animation.endPosition = CGRectMake(newX, 
                                                    self.position.origin.y, 
                                                    self.position.size.width, 
                                                    self.position.size.height);
            
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            break;
        }
            
        case DRAWING_TOOL_EXTENDED_STATE_POPING:
        {
            
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + DRAWING_TOOL_EXTENDED_STATE_CHANGE_DURATION_FROM_UNSELECTED_TO_INACTIVE;
            
            self.animation.startPosition = self.position;
                        
            self.animation.endPosition = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X, 
                                                    self.position.origin.y, 
                                                    self.position.size.width, 
                                                    self.position.size.height);
            
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            break;
        } 
            
        case DRAWING_TOOL_EXTENDED_STATE_DISAPPEARS_FROM_SCREEN:{
            
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + DRAWING_TOOL_EXTENDED_STATE_CHANGE_DURATION_TO_OUT_OF_SCREEN;
            
            self.animation.startPosition = self.position;
            
            self.animation.endPosition = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                                                    self.position.origin.y, 
                                                    self.position.size.width, 
                                                    self.position.size.height);
            
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
    self.nextState = dteNextState;
};

- (void)changeStateTo:(drawingToolExtendedState)newstate{
    self.previousState = self.state;
    self.previousPosition = self.position;
    self.previousBody_alpha = self.body_alpha;
    self.state = newstate;
    
    switch (newstate) {
        case DRAWING_TOOL_EXTENDED_STATE_UNSELECTED:{
            self.position = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_UNSELECTED_ORIGIN_X, self.position.origin.y, self.position.size.width, self.position.size.height);            
            break;
        }        
        
        case DRAWING_TOOL_EXTENDED_STATE_SELECTED:{
            self.position = CGRectMake(DT_STATE_SELECTED_ORIGIN_X, self.position.origin.y, self.position.size.width, self.position.size.height);
            
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

        case DRAWING_TOOL_EXTENDED_STATE_INACTIVE:{
            // do nothing
            break;
        }           
            
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected new Extended Drawing Tool's state: %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
}

- (void)updatePhysicsAtTime:(double)currtime{
    
//    NSLog(@"%@ : %@ self.state = %d", self, NSStringFromSelector(_cmd),  self.state);

    [self.animation updatePhysicsAtTime:currtime];
    
    switch (self.state) {

            
        case DRAWING_TOOL_EXTENDED_STATE_APPEARS_ON_SCREEN:{
            
            if (self.animation.state == ANIMATION_STATE_PLAYING){
                self.position = self.animation.position;
//                NSLog(@"%@ : %@ self.position.originX = %f", self, NSStringFromSelector(_cmd), self.position.origin.x);
            }
            
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = self.nextState;
            }
            
            break;
        }
            
            
        case DRAWING_TOOL_EXTENDED_STATE_PUSHING:
        {
            if (self.animation.state == ANIMATION_STATE_PLAYING){
                self.position = self.animation.position;
//                NSLog(@"%@ : %@ self.position.originX = %f", self, NSStringFromSelector(_cmd), self.position.origin.x);
            }
            
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = self.nextState;
            }
            
            break;
        }
            
        case DRAWING_TOOL_EXTENDED_STATE_POPING:
        {
            if (self.animation.state == ANIMATION_STATE_PLAYING){
                self.position = self.animation.position;
            }
            
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = self.nextState;
            }
            
            break;
        }
            
        case DRAWING_TOOL_EXTENDED_STATE_DISAPPEARS_FROM_SCREEN:{
            if (self.animation.state == ANIMATION_STATE_PLAYING){
                self.position = self.animation.position;
            }
            
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = self.nextState;
            }
            
            break;
        }
            
        case DRAWING_TOOL_EXTENDED_STATE_OUT_OF_SCREEN:{
            //do nothing
            break;
        }
            
        case DRAWING_TOOL_EXTENDED_STATE_SELECTED:
        {
            float deltaX, deltaY, newX, newY, newAlpha, newWidth, newHeight; //для running light 2
            float deltaX1, deltaY1, newX1, newY1, newAlpha1; //для running light 1
            
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
        case DRAWING_TOOL_EXTENDED_STATE_UNSELECTED:
        {
            
            break;
        }
            
        case DRAWING_TOOL_EXTENDED_STATE_INACTIVE:
        {
//            self.position = CGRectMake(DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X, 
//                                       self.position.origin.y, 
//                                       self.position.size.width, 
//                                       self.position.size.height);

            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected Extended DrawingTool's state : %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

@end
