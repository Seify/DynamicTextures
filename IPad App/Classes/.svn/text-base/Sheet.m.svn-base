//
//  Sheet.m
//  KidsPaint
//
//  Created by Roman Smirnov on 25.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "Sheet.h"

@interface Sheet()
- (void)updateRotation;
@end

@implementation Sheet
@synthesize type, number;//, state;
@synthesize rotationY, scale, translationY, translationZ, scaleX, scaleY, scaleZ;
@synthesize previousTranslationX, previousTranslationY, previousTranslationZ, previousScaleX, previousScaleY, previousScaleZ, previousRotationY;

- (sheetState)state{
    return state;
}

- (void)setState:(sheetState)newstate{
    state = newstate;
//    NSLog(@"%@ : %@ new state = %d", self, NSStringFromSelector(_cmd), newstate);
}

- (double)translationX{
    return translationX;
}

- (void)setTranslationX:(double)newtranslation{
    translationX = newtranslation;
    switch (self.state) {
        case SHEET_STATE_SHOWING_PICS:
        case SHEET_STATE_STABILIZING:
        {
            // при изменении translationX автоматически меняется поворот и лист уезжает вглубь экрана
            [self updateRotation];
            [self updateTranslationZ];
            break;
        }
            
        case  SHEET_STATE_SCALING_TO_PAINTING_AREA:
        case  SHEET_STATE_HIDING:
        case  SHEET_STATE_HIDDEN:
        case  SHEET_STATE_UNSCALING_FROM_PAINTING_AREA:
        {
            //do nothing
            break;
        }
        default:{
            NSLog(@"%@ : %@ unexpected sheet state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

- (AcceleratedAnimation *)stabilisation{
    if (!stabilisation){
        stabilisation = [[AcceleratedAnimation alloc] init];
        stabilisation.state = ANIMATION_STATE_STOPPED;
    }
    return stabilisation;
}

- (ThreeDAnimation *)animation{
    if (!animation){
        animation = [[ThreeDAnimation alloc] init];
        animation.state = ANIMATION_STATE_STOPPED;
    }
    return animation;

}


- (id)init{
    NSLog(@"%@ : %@ initialization with default type", self, NSStringFromSelector(_cmd));
    return [self initWithType:SHEET_TYPE_LEFT];
}

- (id)initWithType:(sheetTypeID)typeid{
    if(self == [super init]){
        self.type = typeid;
    }
    return self;
}

// меняем поворот листа в зависимости от его смещения по оси X
- (void)updateRotation{
    switch (self.type) {
        case SHEET_TYPE_LEFT:{
            
            double trans;
            
            if (self.translationX > TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET && self.translationX < TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET ){
                trans = self.translationX;
            } else if (self.translationX <= TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET) {                    
                trans = TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET;
            } else if(self.translationX >= TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET){
                trans = TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET;
            }
            
            self.rotationY = LEFT_LIMIT_ROTATION
            + (trans - (TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET)) * (180 - abs(LEFT_LIMIT_ROTATION) - abs(RIGHT_LIMIT_ROTATION))/(TRANSLATION_ZONE_1_LENGHT_FOR_LEFT_SHEET);
                    
            break;
        }
        case SHEET_TYPE_RIGHT:{
            
            double trans;
            
            if (self.translationX > TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET && self.translationX < TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET ){
                
                trans = self.translationX;
                
            } else if (self.translationX <= TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET) {
                trans = TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET;
            } else if(self.translationX >= TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET){
                trans = TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET;
            }     
            
            self.rotationY = -(180 - LEFT_LIMIT_ROTATION) 
            + (trans - (TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET)) * (180 - abs(LEFT_LIMIT_ROTATION) - abs(RIGHT_LIMIT_ROTATION))/(TRANSLATION_ZONE_1_LENGHT_FOR_RIGHT_SHEET);
            
            break;
        }
        default:{
            NSLog(@"%@ : %@ WARNING!!! unexpected sheet type!", self, NSStringFromSelector(_cmd));
            break;
        }
    }
}

// меняем насколько лист смещен вглубь экрана в зависимости от смещения по оси X
//
- (void)updateTranslationZ{
     switch (self.type) {
        case SHEET_TYPE_LEFT:{
            if (self.translationX > TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET && self.translationX < TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET ){
                self.translationZ = 0.0;
            } else if (self.translationX <= TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET) {                    
                self.translationZ = - (TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET - self.translationX);
            } else if(self.translationX >= TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET){
                self.translationZ = - (self.translationX - TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET);
            }
            break;
        }
         case SHEET_TYPE_RIGHT:{
             if (self.translationX > TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET && self.translationX < TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET ){
                 self.translationZ = 0.0;
             } else if (self.translationX <= TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET) {
                 self.translationZ = - (TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET - self.translationX);
             } else if(self.translationX >= TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET){
                 self.translationZ = - (self.translationX - TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET);
             } 
             break;
         }
         default:{
             NSLog(@"%@ : %@ WARNING!!! unexpected sheet type!", self, NSStringFromSelector(_cmd));
             break;
         }
     }
}

#pragma mark - Gesture handlers

- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation{
    
    self.translationX += (location.x-previousLocation.x) * TRANSLATION_SPEED_FACTOR; 
}

#pragma mark - Physics

- (void)updatePhysicsAtTime:(double)currtime{
    
    if (self.stabilisation.state == ANIMATION_STATE_PLAYING){
        [self.stabilisation updatePhysicsAtTime:currtime];
        self.translationX = self.stabilisation.position.origin.x;
    }
    
    switch (self.state) {
        case SHEET_STATE_STABILIZING:{
            if (self.stabilisation.state == ANIMATION_STATE_STOPPED){
                self.state = SHEET_STATE_SHOWING_PICS;
            }
            break;
        }
            
        case SHEET_STATE_UNSCALING_FROM_PAINTING_AREA:{
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = SHEET_STATE_SHOWING_PICS;
            }
        }
            
        case SHEET_STATE_SHOWING_PICS:
        case SHEET_STATE_SCALING_TO_PAINTING_AREA:
        case SHEET_STATE_HIDING:
        case SHEET_STATE_HIDDEN:
        {
            //do nothing
            break;
        }
            
            
        default:{
            NSLog(@"%@ : %@ unexpected state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}


- (void)dealloc{
    [self.stabilisation release];
    [super dealloc];
}

@end
