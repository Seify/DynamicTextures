//
//  GalleryAsInPaper.h
//  KidsPaint
//
//  Created by Roman Smirnov on 25.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//
//  Галерея представляет собой массив листов (Sheets). Лист может быть двух типов: левый и правый.
//  На одном листе показывается цветной образец, на другом - черно-белая исходная картинка.
//  У каждого листа есть сдвиг по оси X (translationX). У тех листов, на которых сейчас открыта галерея книга,
//  translationX = 0. Такие листы (их два - левый и правый) называются активными.
//  Угол поворота листа rotationY однозначно определяется типом листа (левый-правый) и его translationX.
//  Галерея отлавливает события касания экрана и изменяет translationX для всех своих листов.
//  После отпускания пальца происходит стабилизация (stabilization) галереи - прокрутка к ближайшему листу.
//  Галерея имеет делегата, у которого спрашивает сколько у нее листов и сообщает ему о событиях.
//  Галерея может находиться в одном из нескольких состояний.


#import <UIKit/UIKit.h>
#import "Sheet.h"
#import "AcceleratedAnimation.h"
#import "GalleryConstants.h"

@protocol GalleryDelegate
- (int)howManySheets;                                       // сколько листов

- (void)newActiveSheetNumber:(int)sheetNumber;              // новый лист стал активным
- (void)sheetWillAnimateToPaintingPage:(int)sheetNumber;    // активный лист выбран и будет анимирован для перехода к экрану рисования
- (void)sheetDidAnimateToPaintingPage:(int)sheetNumber;     // анимация перехода к экрану рисования завершена
- (void)galleryWillStabilizeToSheetNumber:(int)sheetNumber  // галерея будет стабилизирована
                                StartTime:(double)startTime 
                                  EndTime:(double)endTime;
- (void)galleryDidStabilized;                               // анимация стабилизации завершена
- (void)sheetDidAnimateToGallery;                           // анимация возврата в галерею с экрана рисования завершена
@end

@interface GalleryAsInPaper : NSObject
{
    id <GalleryDelegate> delegate;
    NSArray *sheets;
    galleryState state;
}

@property (assign) id <GalleryDelegate> delegate;
@property (readonly) NSArray *sheets;
@property galleryState state;

- (void)changeStateTo:(galleryState)newstate AtTime:(double)currtime;

- (void)touchBeganAtLocation:(CGPoint)location;
- (void)touchMovedAtLocation:(CGPoint)location 
            PreviousLocation:(CGPoint)previousLocation
               InsideGallery:(BOOL)inside;
- (void)touchEndedAtLocation:(CGPoint)location
               InsideGallery:(BOOL)inside;
- (void)touchesCancelledLocation:(CGPoint)location;

- (void)updateSheets:(double)currtime;                  // update физики

- (BOOL)shouldDrawSheet: (Sheet *)sh;                   // нужно ли отрисовывать лист на экране
@end
