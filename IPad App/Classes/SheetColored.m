//
//  SheetColored.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 14.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "SheetColored.h"

@interface SheetColored()
- (void)updateRotation;
@end

@implementation SheetColored
@synthesize type, number, state;
@synthesize alpha, rotationY, scale, translationY, translationZ, scaleX, scaleY, scaleZ;
@synthesize previousTranslationX, previousTranslationY, previousTranslationZ, previousScaleX, previousScaleY, previousScaleZ, previousRotationY;
@synthesize shouldLoadTextureIfUnloaded;
@synthesize shouldChangeEdgeSheetsZ;

- (double)translationX{
    return translationX;
}

- (double) centerTranslationX{
    return (translationX - COLOR_HACK_CONSTANT/2.0);
}

- (void)setTranslationX:(double)newtranslation{
    translationX = newtranslation;
    
    switch (self.state) {
        case SHEET_COLORED_STATE_SHOWING_PICS:
        case SHEET_COLORED_STATE_STABILIZING:
        {
            if (shouldChangeEdgeSheetsZ){
                [self updateTranslationZ];
            }
            break;
        }
            
        case  SHEET_COLORED_STATE_SCALING_TO_PAINTING_AREA:
        case  SHEET_COLORED_STATE_HIDING:
        case  SHEET_COLORED_STATE_HIDDEN:
        case  SHEET_COLORED_STATE_UNSCALING_FROM_PAINTING_AREA:
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
    return [self initWithType:SHEET_COLORED_TYPE_LEFT];
}

- (id)initWithType:(sheetColoredTypeID)typeid{
    if(self == [super init]){
        self.type = typeid;
    }
    return self;
}


- (void)updateRotation{
    switch (self.type) {
        case SHEET_COLORED_TYPE_LEFT:{
            
            double trans;
            
            if (self.translationX > COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET && self.translationX < COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET ){
                trans = self.translationX;
            } else if (self.translationX <= COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET) {                    
                trans = COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET;
            } else if(self.translationX >= COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET){
                trans = COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET;
            }
            
            self.rotationY = COLORED_LEFT_LIMIT_ROTATION
            + (trans - (COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET)) * (180 - abs(COLORED_LEFT_LIMIT_ROTATION) - abs(COLORED_RIGHT_LIMIT_ROTATION))/(COLORED_TRANSLATION_ZONE_1_LENGHT_FOR_LEFT_SHEET);
            
            break;
        }
        case SHEET_COLORED_TYPE_RIGHT:{
            
            double trans;
            
            if (self.translationX > COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET && self.translationX < COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET ){
                
                trans = self.translationX;
                
            } else if (self.translationX <= COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET) {
                trans = COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET;
            } else if(self.translationX >= COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET){
                trans = COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET;
            }     
            
            self.rotationY = -(180 - COLORED_LEFT_LIMIT_ROTATION) 
            + (trans - (COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET)) * (180 - abs(COLORED_LEFT_LIMIT_ROTATION) - abs(COLORED_RIGHT_LIMIT_ROTATION))/(COLORED_TRANSLATION_ZONE_1_LENGHT_FOR_RIGHT_SHEET);
            
            break;
        }
        default:{
            NSLog(@"%@ : %@ WARNING!!! unexpected sheet type!", self, NSStringFromSelector(_cmd));
            break;
        }
    }
}

- (void)updateTranslationZ{
    switch (self.type) {
        case SHEET_COLORED_TYPE_LEFT:{
            if (self.translationX > COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET && self.translationX < COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET ){
                self.translationZ = 0.0;
            } else if (self.translationX <= COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET) {                    
                self.translationZ = - (COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET - self.translationX);
            } else if(self.translationX >= COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET){
                self.translationZ = - (self.translationX - COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET);
            }
            break;
        }
        case SHEET_COLORED_TYPE_RIGHT:{
            if (self.translationX > COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET && self.translationX < COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET ){
                self.translationZ = 0.0;
            } else if (self.translationX <= COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET) {
                self.translationZ = - (COLORED_TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET - self.translationX);
            } else if(self.translationX >= COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET){
                self.translationZ = - (self.translationX - COLORED_TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET);
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
    
    self.translationX -= (previousLocation.x-location.x) * COLORED_TRANSLATION_SPEED_FACTOR; 
}

#pragma mark - Physics

- (void)updatePhysicsAtTime:(double)currtime{
    
    if (self.stabilisation.state == ANIMATION_STATE_PLAYING){
        [self.stabilisation updatePhysicsAtTime:currtime];
        self.translationX = self.stabilisation.position.origin.x;
    }
    
    switch (self.state) {
        case SHEET_COLORED_STATE_STABILIZING:{
            if (self.stabilisation.state == ANIMATION_STATE_STOPPED){
                self.state = SHEET_COLORED_STATE_SHOWING_PICS;
            }
            break;
        }
            
        case SHEET_COLORED_STATE_SHOWING_PICS:
        case SHEET_COLORED_STATE_SCALING_TO_PAINTING_AREA:
        case SHEET_COLORED_STATE_HIDING:
        case SHEET_COLORED_STATE_HIDDEN:
        case SHEET_COLORED_STATE_UNSCALING_FROM_PAINTING_AREA:
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



- (void)updatePosition:(double)currtime
{
    
}

- (void)dealloc{
    [self.stabilisation release];
    [super dealloc];
}

@end
