//
//  Sheet.h
//  KidsPaint
//
//  Created by Roman Smirnov on 25.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceleratedAnimation.h"
#import "ThreeDAnimation.h"
#import "GalleryConstants.h"

@interface Sheet : NSObject
{
    sheetTypeID type;
    
    int number;             // номер листа. У левого и правого листов номера кажется одинаковые
    
    sheetState state;
    
    double translationX;    // смещение листа по оси X
    double translationY;    // смещение листа по оси Y
    double translationZ;    // смещение листа по оси Z
    double scaleX;          // масштаб листа по оси X
    double scaleY;          // масштаб листа по оси Y
    double scaleZ;          // масштаб листа по оси Z
    double rotationY;       // вращение листа по оси X
    
    
    // то же для сохранения предыдущего состояния при анимации галерея <-> экран рисования
    double previousTranslationX;
    double previousTranslationY;
    double previousTranslationZ;
    double previousScaleX;
    double previousScaleY;
    double previousScaleZ;
    double previousRotationY;
    
    double scale;    
    
    AcceleratedAnimation *stabilisation;    // анимация стабилизации (надо либо доделать Accelerated, либо использовать обычную ThreeDAnimation *animation)
    ThreeDAnimation *animation;             // generic анимация (например, для анимации галерея <-> экран рисования)
}
@property sheetTypeID type;
@property sheetState state;
@property int number;
@property double translationX;
@property double translationY;
@property double translationZ;
@property double scaleX;
@property double scaleY;
@property double scaleZ;
@property double rotationY;

@property double previousTranslationX;
@property double previousTranslationY;
@property double previousTranslationZ;
@property double previousScaleX;
@property double previousScaleY;
@property double previousScaleZ;
@property double previousRotationY;

@property double scale;
@property (readonly) AcceleratedAnimation *stabilisation;   // Анимация стабилизации. Надо либо досделать акселерированную, либо перевести на обычную ThreeDAnimation *animation;
@property (readonly) ThreeDAnimation *animation;

- (id)initWithType:(sheetTypeID)typeid;

- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation;

//- (void)updatePosition:(double)currtime;

- (void)updatePhysicsAtTime:(double)currtime;

@end
