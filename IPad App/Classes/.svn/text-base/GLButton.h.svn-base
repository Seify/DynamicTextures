//
//  GLButton.h
//  KidsPaint
//
//  Created by Roman Smirnov on 05.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLButtonConstants.h"
#import "ThreeDAnimation.h"
#import "InterfaceConstants.h"

@protocol GLButtonDelegate
- (void) buttonPressed:(id)button;
@end

@interface GLButton : NSObject <ThreeDAnimationDelegate>
{
    GLfloat alpha;
    CGRect position;

    CGRect touchArea;
    
    GLfloat translationX;
    GLfloat translationY;
    GLfloat translationZ;

    GLfloat rotationX;
    GLfloat rotationY;
    GLfloat rotationZ;

    GLfloat scaleX;
    GLfloat scaleY;
    GLfloat scaleZ;
    
    id <GLButtonDelegate> delegate;
    
    buttonID identificator;
    
    buttonState state;
    
    ThreeDAnimation *animation;

    BOOL shouldDisplace;
}
@property GLfloat alpha;
@property CGRect position;
@property CGRect touchArea;

@property GLfloat translationX;
@property GLfloat translationY;
@property GLfloat translationZ;
@property GLfloat rotationX;
@property GLfloat rotationY;
@property GLfloat rotationZ;
@property GLfloat scaleX;
@property GLfloat scaleY;
@property GLfloat scaleZ;

@property BOOL shouldDisplace;

@property (assign) id <GLButtonDelegate> delegate;


@property (readonly) buttonState state;
@property buttonID identificator;

@property (readonly) ThreeDAnimation *animation;

- (BOOL)isIntersectsWithPoint:(CGPoint)point;

- (void)changeStateTo:(buttonState)newstate;
- (void)updatePhysicsAtTime:(double)currtime;

- (void)touchBeganAtLocation:(CGPoint)location;
- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation;
- (void)touchEndedAtLocation:(CGPoint)location;
- (void)touchesCancelledLocation:(CGPoint)location;

@end
