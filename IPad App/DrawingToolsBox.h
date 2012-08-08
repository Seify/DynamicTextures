//
//  DrawingToolsBox.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 05.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//



#import "ThreeDAnimation.h"
#import "DrawingTool.h"
#import <Foundation/Foundation.h>
#import "GLButton.h"
#import "DrawingToolsBoxConstants.h"
#import "RainbowTool.h"


@protocol DrawingToolsBoxDelegate

@optional

- (void)newDrawingToolSelected:(DrawingTool*)dt;
- (void)newColorSelectedWithRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha;

@end

@interface DrawingToolsBox : NSObject <DrawingToolDelegate, RainbowToolDelegate, ThreeDAnimationDelegate>
{
    GLfloat alpha;
    CGRect position;
    
//    GLfloat translationX;
//    GLfloat translationY;
//    GLfloat translationZ;
//    
//    GLfloat rotationX;
//    GLfloat rotationY;
//    GLfloat rotationZ;
//    
//    GLfloat scaleX;
//    GLfloat scaleY;
//    GLfloat scaleZ;
    
    ThreeDAnimation *animation;
    
    NSArray *drawingTools;    
    drawingToolsBoxState state;
    drawingToolsBoxState nextState;
    id <DrawingToolsBoxDelegate> delegate;
    
    DrawingTool *prevDrawingTool;
    DrawingTool *drawingToolToExtend; 
    
    RainbowTool* rainbowTool;
    
    GLButton *customColorButton;
    
    drawingToolType activeToolType;
    drawingToolType nextToolType;
}

@property (readonly) NSArray *drawingTools;
@property (readonly) drawingToolsBoxState state;
@property (readonly) drawingToolsBoxState nextState;
@property (assign) id <DrawingToolsBoxDelegate> delegate;
@property (readonly) RainbowTool *rainbowTool;
@property (assign) DrawingTool *prevDrawingTool;
@property GLfloat alpha;
@property CGRect position;
@property (readonly) ThreeDAnimation *animation;
@property (readonly) GLButton *customColorButton;

@property (readonly) drawingToolType activeToolType;
@property drawingToolType nextToolType;


- (void)changeStateTo:(drawingToolsBoxState)newstate AtTime:(double)currtime;
- (void)updatePhysicsAtTime:(double)currtime;
- (BOOL)processTouchAtLocation:(CGPoint)location;
- (void)unselectTools;
- (void) putDownOldDrawingTool;

- (void)touchBeganAtLocation:(CGPoint)location;
- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation;
- (void)touchEndedAtLocation:(CGPoint)location;
- (void)touchesCancelledLocation:(CGPoint)location;

- (BOOL)areTherePlayingAnimations;

- (void)saveState;
- (void)saveStateForTool;
- (void)restoreState;

@end
