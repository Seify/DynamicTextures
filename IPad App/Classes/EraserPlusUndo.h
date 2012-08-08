//
//  Eraser.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 11.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "InterfaceConstants.h"
#import "EraserPlusUndoConstants.h"
#import "ThreeDAnimation.h"

@protocol EraserPlusUndoDelegate
- (void)eraserSelected;
- (void)eraserUnselected;
@end

@interface EraserPlusUndo : NSObject <ThreeDAnimationDelegate>
{
    BOOL isUndoPressed;
    
    
    eraserPlusUndoState state;
    eraserPlusUndoState nextState;
    eraserPlusUndoState prevState;
    
    GLfloat alpha;
    CGRect position;
    
    GLfloat translationX;
    GLfloat translationY;
    GLfloat translationZ;
    
    GLfloat rotationX;
    GLfloat rotationY;
    GLfloat rotationZ;
    
    GLfloat scaleX;
    GLfloat scaleY;
    GLfloat scaleZ;
    
    id <EraserPlusUndoDelegate> delegate;
    
    ThreeDAnimation *animation;
}
@property GLfloat alpha;
@property CGRect position;

@property GLfloat translationX;
@property GLfloat translationY;
@property GLfloat translationZ;
@property GLfloat rotationX;
@property GLfloat rotationY;
@property GLfloat rotationZ;
@property GLfloat scaleX;
@property GLfloat scaleY;
@property GLfloat scaleZ;

@property (assign) id <EraserPlusUndoDelegate> delegate;

@property (readonly) eraserPlusUndoState state;
@property (readonly) eraserPlusUndoState nextState;
@property (readonly) eraserPlusUndoState prevState;

@property (readonly) ThreeDAnimation *animation;

- (BOOL)isIntersectsWithPoint:(CGPoint)point;

- (void)changeStateTo:(eraserPlusUndoState)newstate AtTime:(double)currtime;

- (void) changeStateTo:(eraserPlusUndoState)newState 
          NextState:(eraserPlusUndoState)nextState
             AtTime:(double)currtime;


- (void)updatePhysicsAtTime:(double)currtime;

- (void)touchBeganAtLocation:(CGPoint)location;
- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation;
- (void)touchEndedAtLocation:(CGPoint)location;
- (void)touchesCancelledLocation:(CGPoint)location;

- (void)switchToEraser;
- (void)switchToUndo;
- (void)unselectSelf;

- (void)saveState;
- (void)restoreState;
- (void)appearsOnScreenWithRestoredState;

- (BOOL)areYouEraserNow;

@end
