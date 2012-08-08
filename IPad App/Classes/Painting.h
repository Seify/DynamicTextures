//
//  Painting.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 13.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#define UNPAINTED_AREA_NUMBER 999999
#define BLACK_AREA_NUMBER     999998

#import <UIKit/UIKit.h>
#import "FillingAnimation.h"
#import "InterfaceManager.h"
#import "ShadingAnimation.h"

@class InterfaceManager;

@interface Painting : NSObject
{
    InterfaceManager *delegate;
    NSMutableArray *animations;
    ShadingAnimation *shadowing;
    int areas[560][800];
    float currentArea;
    
    
    GLfloat *drawingTrianglesPositions; // динамический массив для хранения координат рисуемых точек
    int countDrawingTrianglesPositions; // количество точек в массиве;
    
    GLfloat brushSize;
    GLfloat brushColor[4];
    
    CGFloat currentRed;
	CGFloat currentGreen;
	CGFloat currentBlue;
    BOOL isCustomColorActive;
    
    pictureState currentPictureState;
}

@property (assign) InterfaceManager *delegate;
@property (retain) NSMutableArray *animations;
@property (readonly) ShadingAnimation *shadowing;

@property float currentArea;
@property int countDrawingTrianglesPositions;
@property GLfloat brushSize;
@property BOOL isCustomColorActive;

@property pictureState currentPictureState;


- (GLfloat *) getBrushArray;
- (CGFloat *) getBrushColor;
- (void)loadAreasFromFileForBookNumber:(int)booknumber PageNumber:(int)pagenumber;
- (int)getAreaX:(int)i Y:(int)j;
- (BOOL)shouldPlayAnimation:(Animation *)anima;
- (BOOL)areTherePlayingAnimations;

- (void)touchBeganAtLocation:(CGPoint)location;
- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation;
- (void)touchEndedAtLocation:(CGPoint)location;
- (void)touchesCancelledLocation:(CGPoint)location;

- (void)setBrushColorRed:(GLfloat)red Green:(GLfloat)green Blue:(GLfloat)blue;
- (void)setBrushColorRed:(GLfloat)red Green:(GLfloat)green Blue:(GLfloat)blue Alpha:(GLfloat)alpha;

- (void)addPoligonVertexesForBrushWithRadius:(float)radius xpos:(float)xpos ypos:(float)ypos;

- (void)updateAnimations:(double)currtime;
- (void)removeUnusedAnimations;
- (void)freeArrays;

- (void)saveState;
- (void)restoreState;
@end
