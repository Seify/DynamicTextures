//
//  GalleryConstants.h
//  KidsPaint
//
//  Created by Roman Smirnov on 26.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#ifndef KidsPaint_GalleryConstants_h
#define KidsPaint_GalleryConstants_h

typedef int sheetTypeID;

enum sheetTypeID{
    SHEET_TYPE_LEFT,    // левый лист
    SHEET_TYPE_RIGHT    // правый лист
};

typedef int sheetState;

enum sheetState{
    SHEET_STATE_SHOWING_PICS,                   // 0 - лист просто показывает картинку
    SHEET_STATE_STABILIZING,                    // 1 - лист стабилизируется
    SHEET_STATE_SCALING_TO_PAINTING_AREA,       // 2 - лист выбран и анимируется в картинку на экране рисования
    SHEET_STATE_HIDING,                         // 3 - лист скрывается в то время как другой лист анимируется на экран рисования
    SHEET_STATE_HIDDEN,                         // 4 - лист скрыт
    SHEET_STATE_UNSCALING_FROM_PAINTING_AREA    // 5 - лист анимируется из картинки на экране рисования обратно в книгу
};

typedef int galleryState;

enum galleryState{
    GALLERY_STATE_SHOWING_PICS,                 // 0 - галерея показывает картинки
    GALLERY_STATE_STABILIZING,                  // 1 - галерея стабилизируется
    GALLERY_STATE_SCALING_TO_PAINTING_AREA,     // 2 - выбранный лист анимируется на экран раскрашивания, остальные скрываются
    GALLERY_STATE_HIDDEN,                       // 3 - галерея скрыта
    GALLERY_STATE_UNSCALING_FROM_PAINTING_AREA  // 4 - анимация в галерею из экрана раскрашивания
};


#define HACK_CONSTANT (2.885) //расстояние между двумя соседними парами листов

#define TRANSLATION_SPEED_FACTOR (0.02) //с какой скоростью двигаем пальцем листы


#define SHEET_SCALE_X (1.45)    // масштаб листа по оси X (шире - уже)
#define SHEET_SCALE_Y (1.4)     // масштаб листа по оси Y (выше - ниже)
#define SHEET_SCALE_Z (1.0)     // масштаб листа по оси Z (1.0)

#define RIGHT_LIMIT_ROTATION (-20)                      // предельный угол, на который поворачивается лист справа
#define LEFT_LIMIT_ROTATION (-RIGHT_LIMIT_ROTATION)     // предельный угол, на который поворачивается лист слева


// параметры анимации "докрутки" страниц после убирания пальца с экрана
#define STABILIZATION_TIME (0.5) // время, за которое после отпускания пальца анимация останавливается
#define STABILIZATION_ACCELERATION (1.0) // ускорение стабилизации - НЕ ИСПОЛЬЗУЕТСЯ


// параметры анимации превращения выбранной страницы в раскрашиваемую
// значения подогнаны
//
#define SCALING_TO_PAINTING_PAGE_DURATION (0.8)                // время анимации из галереи в страницу раскрашивания
#define SCALING_TO_GALLERY_PAGE_DURATION (0.8)                 // время анимации из страницы раскрашивания в галерею

#define SCALING_TO_PAINTING_PAGE_END_TRANSLATION_X (-24.1)     // перемещение по оси X
#define SCALING_TO_PAINTING_PAGE_END_TRANSLATION_Y (-10.0)     // перемещение по оси Y
#define SCALING_TO_PAINTING_PAGE_END_TRANSLATION_Z (4.0)       // перемещение по оси Z

#define SCALING_TO_PAINTING_PAGE_END_ROTATION_X (0.0)          // поворот вдоль оси X
#define SCALING_TO_PAINTING_PAGE_END_ROTATION_Y (180.0)        // поворот вдоль оси Y
#define SCALING_TO_PAINTING_PAGE_END_ROTATION_Z (0.0)          // поворот вдоль оси Z

#define SCALING_TO_PAINTING_PAGE_END_SCALE_X (2.145)           // масштабирование по оси X
#define SCALING_TO_PAINTING_PAGE_END_SCALE_Y (2.145)           // масштабирование по оси Y
#define SCALING_TO_PAINTING_PAGE_END_SCALE_Z (1.0)             // масштабирование по оси Z (= 1.0)


// листы на экране видны только пока они находятся в определенной зоне (zone_1)
// То есть пока zone_1_left_border < translationX < zone_1_right_border
// zone_1 различается для левого и правого листа.

#define TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET (-0.55)
#define TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET (3.45)
#define TRANSLATION_ZONE_1_LENGHT_FOR_LEFT_SHEET (TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_LEFT_SHEET - TRANSLATION_ZONE_1_LEFT_BORDER_FOR_LEFT_SHEET)

#define TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET (-3.55)
#define TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET (0.45)
#define TRANSLATION_ZONE_1_LENGHT_FOR_RIGHT_SHEET (TRANSLATION_ZONE_1_RIGHT_BORDER_FOR_RIGHT_SHEET - TRANSLATION_ZONE_1_LEFT_BORDER_FOR_RIGHT_SHEET)

#endif
