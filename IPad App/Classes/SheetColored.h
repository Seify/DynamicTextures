//
//  SheetColored.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 14.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceleratedAnimation.h"
#import "ThreeDAnimation.h"
#import "GalleryForColoredPicsConstants.h"

@interface SheetColored : NSObject
{
    sheetColoredTypeID type;
    
    int number;
    
    sheetColoredState state;
    
    double alpha;
    double translationX;
    double translationY;
    double translationZ;
    double scaleX;
    double scaleY;
    double scaleZ;
    double rotationY;
    double scale;    
    
    double previousTranslationX;
    double previousTranslationY;
    double previousTranslationZ;
    double previousScaleX;
    double previousScaleY;
    double previousScaleZ;
    double previousRotationY;
    
    BOOL shouldLoadTextureIfUnloaded;
    
    AcceleratedAnimation *stabilisation;
    ThreeDAnimation *animation;
}
@property sheetColoredTypeID type;
@property sheetColoredState state;
@property int number;

@property double alpha;
@property double translationX;
@property double translationY;
@property double translationZ;
@property double scaleX;
@property double scaleY;
@property double scaleZ;
@property double rotationY;
@property double scale;

@property double previousTranslationX;
@property double previousTranslationY;
@property double previousTranslationZ;
@property double previousScaleX;
@property double previousScaleY;
@property double previousScaleZ;
@property double previousRotationY;

@property (readonly) AcceleratedAnimation *stabilisation;
@property (readonly) ThreeDAnimation *animation;
@property (readonly) double centerTranslationX;

@property BOOL shouldLoadTextureIfUnloaded;
@property BOOL shouldChangeEdgeSheetsZ;


- (id)initWithType:(sheetColoredTypeID)typeid;
- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation;
//- (void)touchEndedAtLocation:(CGPoint)location;
- (void)updatePhysicsAtTime:(double)currtime;

- (void)updatePosition:(double)currtime;

@end
