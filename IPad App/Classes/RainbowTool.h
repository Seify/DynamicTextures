//
//  RainbowTool.h
//  KidsPaint
//
//  Created by Иван Ерасов on 27.06.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceConstants.h"
#import "ThreeDAnimation.h"
#import "ANImageBitmapRep.h"

#define RAINBOW_TOOL_OFFSET_X 0
#define RAINBOW_TOOL_OFFSET_Y 236
#define RAINBOW_TOOL_WIDTH 100
#define RAINBOW_TOOL_HEIGHT 522

#define RAINBOW_TOOL_INDICATOR_OFFSET_X 2 //drawing offset from real position
#define RAINBOW_TOOL_INDICATOR_OFFSET_Y -2 //drawing offset from real position
#define RAINBOW_TOOL_INDICATOR_WIDTH 33
#define RAINBOW_TOOL_INDICATOR_HEIGHT 34

#define RAINBOW_TOOL_UNHIDING_DURATION 0.224
#define RAINBOW_TOOL_HIDING_DURATION 0.224

@protocol RainbowToolDelegate

- (void)newColorSelectedWithRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha;

@end;

typedef unsigned int rainbowToolState;

enum rainbowToolState
{
    RAINBOW_TOOL_STATE_OUT_OF_SCREEN,                      //0 - за пределами экрана
    RAINBOW_TOOL_STATE_APPEARS_ON_SCREEN,                  //1 - появляется на экране
    RAINBOW_TOOL_STATE_DISAPPEARS_FROM_SCREEN,             //2 - скрываем радугу (убираем за пределы экрана)
    RAINBOW_TOOL_STATE_ON_SCREEN                           //3 - на экране
};

@interface RainbowTool : NSObject <ThreeDAnimationDelegate>
{
    GLfloat alpha;
    CGRect position;
    
    ANImageBitmapRep* colorMap;
    CGRect colorMapScreenRect; //a rect to restrict indicator on screen
    
    BOOL movingIndicator;
    CGPoint indicatorPosition; //actual position for engine to draw
    CGPoint indicatorPositionInTool; //position in tool screen rect
    
    ThreeDAnimation *animation;
    
    rainbowToolState state;
    
    id<RainbowToolDelegate> delegate;
}

@property (readonly) rainbowToolState state;
@property GLfloat alpha;
@property CGRect position;
@property (readonly) CGPoint indicatorPosition;
@property (readonly) ThreeDAnimation *animation;
@property (assign) id<RainbowToolDelegate> delegate;

- (void)touchBeganAtLocation:(CGPoint)location;
- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation;
- (void)touchEndedAtLocation:(CGPoint)location;
- (void)touchesCancelledLocation:(CGPoint)location;

- (void)changeStateTo:(rainbowToolState)newstate AtTime:(double)currtime;
- (void)updatePhysicsAtTime:(double)currtime;

- (void)saveState;
- (void)restoreState;

@end
