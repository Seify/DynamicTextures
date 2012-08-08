//
//  InterfaceConstants.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 25.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#ifndef DynamicTextures_InterfaceConstants_h
#define DynamicTextures_InterfaceConstants_h

#import "GLButtonConstants.h"
#import "DrawingToolsBoxConstants.h"
#import "GalleryForColoredPicsConstants.h"

typedef int interfaceState;

enum interfaceState{
    INTERFACE_STATE_SHOWING_BOOKS,                      // 0 - показываем юзеру книги
    INTERFACE_STATE_MORPHING_SELECTED_BOOK_TO_GALLERY,  // 1 - юзер выбрал книгу, анимируем ее в галерею
    INTERFACE_STATE_SHOWING_GALLERY,                    // 2 - показываем юзеру галереи
    INTERFACE_STATE_MORPHING_GALLERY_TO_BOOK,           // 3 - юзер возращается из галереи к странице выбора книг
    INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING,       // 4 - юзер выбрал одну из картинок в галерее, анимируем переход к экрану раскрашивания
    INTERFACE_STATE_PAINTING,                           // 5 - юзер раскрашивает
    INTERFACE_STATE_SHOWING_EXAMPLE,                    // 6 - показываем юзеру раскрашенный
    INTERFACE_STATE_CHANGING_PICTURES,                  // 7 - переходим на следующую страницу
    INTERFACE_STATE_MORPHING_PAINTING_TO_GALLERY        // 8 - возвращаемся к галереям из экрана раскрашивания
};

typedef unsigned int interfaceElementID;

enum interfaceElementID{
    INTERFACE_ELEMENT_BOOK_GALLERY_UPPER,               // 0 - верхняя галерея выбора книги
    INTERFACE_ELEMENT_BOOK_GALLERY_LOWER,               // 1 - нижняя галерея выбора книги 
    INTERFACE_ELEMENT_GALLERY,                          // 2 - галерея выбора нераскрашенной страницы в книге
    INTERFACE_ELEMENT_GALLERY_COLORED,                  // 3 - галерея выбора раскрашенной страницы в книге
    INTERFACE_ELEMENT_DRAWING_TOOLS_BOX,                // 4 - карандашница на экране раскраски
    INTERFACE_ELEMENT_PAINTING,                         // 5 - раскрашиваемое изображение на экране раскраски
    INTERFACE_ELEMENT_TOOL_SIZE_SLIDER,                 // 6 - слайдер с индикатором размера и цвета кисти
    INTERFACE_ELEMENT_UNDO_LIGHTS,                      // 7 - огоньки на UNDO, показывают сколько раз можно undo
    INTERFACE_ELEMENT_GALLERY_BOOK_COVER,               // 8 - обложка книги на экране выбора картинки 
    INTERFACE_ELEMENT_BOOK_SELECT_PAGE,                 // 9 - страница выбора книги
};

typedef int sliderState;

enum sliderState {
    SLIDER_STATE_DRAGGIN,
    SLIDER_STATE_TOUCHIN
};


#define SLIDER_FIXED_VALUE_1 (18.5)
#define SLIDER_FIXED_VALUE_2 (32.9)
#define SLIDER_FIXED_VALUE_3 (46.8)

#define DEFAULT_BRUSH_SIZE (SLIDER_FIXED_VALUE_2)

typedef unsigned int pictureState;

enum pictureState{
    PICTURE_STATE_NEW_UNMODIFIED,       //0 - загрузили новую картинку и не меняли ее
    PICTURE_STATE_NEW_MODIFIED,         //1 - загрузили новую картинку и поменяли ее
    PICTURE_STATE_EXISTING_UNMODIFIED,  //2 - загрузили раскрашенную ранее картинку и не меняли ее
    PICTURE_STATE_EXISTING_MODIFIED     //3 - загрузили раскрашенную ранее картинку и поменяли ее
};

typedef unsigned int buttonID;

enum buttonID{
    BUTTON_CLEAR_PAINTING,          //0
    BUTTON_PREVIOUS,                //1
    BUTTON_NEXT,                    //2
    BUTTON_CHANGE_PAINTING_MODE,    //3
    BUTTON_EXIT,                    //4
    BUTTON_CUSTOM_COLOR,            //5
    BUTTON_ERASER_PLUS_UNDO,        //6
    BUTTON_BACK_TO_GALLERY,         //7
    BUTTON_SHOW_SAMPLE,             //8
    NUM_BUTTONS
};

#define BUTTON_CLEAR_PAINTING_OFFSET_X 405
#define BUTTON_CLEAR_PAINTING_OFFSET_Y 102
#define BUTTON_CLEAR_PAINTING_WIDTH 111
#define BUTTON_CLEAR_PAINTING_HEIGHT 127


#define UNDO_OFFSET_X 0
#define UNDO_OFFSET_Y 900
#define UNDO_WIDTH 144
#define UNDO_HEIGHT 115

#define BUTTON_PREVIOUS_OFFSET_X 322
#define BUTTON_PREVIOUS_OFFSET_Y 35
#define BUTTON_PREVIOUS_WIDTH 115
#define BUTTON_PREVIOUS_HEIGHT 76

#define BUTTON_NEXT_OFFSET_X 464
#define BUTTON_NEXT_OFFSET_Y 35
#define BUTTON_NEXT_WIDTH 115
#define BUTTON_NEXT_HEIGHT 75

#define BUTTON_CHANGE_PAINTING_MODE_OFFSET_X 620
#define BUTTON_CHANGE_PAINTING_MODE_OFFSET_Y 940
#define BUTTON_CHANGE_PAINTING_MODE_WIDTH 139
#define BUTTON_CHANGE_PAINTING_MODE_HEIGHT 91

#define BUTTON_BACK_TO_GALLERY_OFFSET_X 165
#define BUTTON_BACK_TO_GALLERY_OFFSET_Y 20
#define BUTTON_BACK_TO_GALLERY_WIDTH 115
#define BUTTON_BACK_TO_GALLERY_HEIGHT 91

#define BUTTON_SHOW_SAMPLE_OFFSET_X (5)
#define BUTTON_SHOW_SAMPLE_OFFSET_Y (20)
#define BUTTON_SHOW_SAMPLE_WIDTH (133)
#define BUTTON_SHOW_SAMPLE_HEIGHT (175)

#define ERASER_UNSELECTED_OFFSET_X 0
#define ERASER_UNSELECTED_OFFSET_Y 880
#define ERASER_UNSELECTED_WIDTH 108
#define ERASER_UNSELECTED_HEIGHT 131

#define ERASER_SELECTED_OFFSET_X 0
#define ERASER_SELECTED_OFFSET_Y 900
#define ERASER_SELECTED_WIDTH 141
#define ERASER_SELECTED_HEIGHT 104

// размеры галереи выбора чб картинки
#define GALLERY_OFFSET_X 0
#define GALLERY_OFFSET_Y 120

#define GALLERY_ORIGIN_X 0
#define GALLERY_ORIGIN_Y 158
#define GALLERY_WIDTH 768
#define GALLERY_HEIGHT 499

// размеры галереи выбора раскрашенной картинки
#define GALLERY_COLORED_OFFSET_X 0
#define GALLERY_COLORED_OFFSET_Y 290

#define GALLERY_COLORED_ORIGIN_X 0
#define GALLERY_COLORED_ORIGIN_Y 656
#define GALLERY_COLORED_WIDTH 768
#define GALLERY_COLORED_HEIGHT 368

// размеры верхней галереи выбора книг
#define GALLERY_SELECT_BOOK_UPPER_OFFSET_X 0
#define GALLERY_SELECT_BOOK_UPPER_OFFSET_Y (-200)

#define GALLERY_SELECT_BOOK_UPPER_ORIGIN_X 0
#define GALLERY_SELECT_BOOK_UPPER_ORIGIN_Y 150
#define GALLERY_SELECT_BOOK_UPPER_WIDTH 768
#define GALLERY_SELECT_BOOK_UPPER_HEIGHT 368

// размеры нижней галереи выбора книги
#define GALLERY_SELECT_BOOK_LOWER_OFFSET_X 0
#define GALLERY_SELECT_BOOK_LOWER_OFFSET_Y 150

#define GALLERY_SELECT_BOOK_LOWER_ORIGIN_X 0
#define GALLERY_SELECT_BOOK_LOWER_ORIGIN_Y 556
#define GALLERY_SELECT_BOOK_LOWER_WIDTH 768
#define GALLERY_SELECT_BOOK_LOWER_HEIGHT 368

// размеры верхней полки, на которой стоят книги на странице выбора книги

#define POLKA_UPPER_ORIGIN_X 0
#define POLKA_UPPER_ORIGIN_Y 400
#define POLKA_UPPER_WIDTH 768
#define POLKA_UPPER_HEIGHT 107

// размеры нижней полки, на которой стоят книги на странице выбора книги

#define POLKA_LOWER_ORIGIN_X 0
#define POLKA_LOWER_ORIGIN_Y 750
#define POLKA_LOWER_WIDTH 768
#define POLKA_LOWER_HEIGHT 107

// размеры карандашницы
#define DRAWING_TOOLS_BOX_OFFSET_X 0
#define DRAWING_TOOLS_BOX_OFFSET_Y 203
#define DRAWING_TOOLS_BOX_WIDTH 134
#define DRAWING_TOOLS_BOX_HEIGHT 746

#define BUTTON_CUSTOM_COLOR_OFFSET_X 18
#define BUTTON_CUSTOM_COLOR_OFFSET_Y 761
#define BUTTON_CUSTOM_COLOR_WIDTH 75
#define BUTTON_CUSTOM_COLOR_HEIGHT 73

#define BUTTONS_UNHIDING_DURATION 0.5
#define BUTTONS_HIDING_DURATION 0.5
#define DRAWING_TOOLS_BOX_UNHIDING_DURATION 0.3
#define DRAWING_TOOLS_BOX_HIDING_DURATION 0.3
#define ERASER_UNHINDING_DURATION 0.3
#define ERASER_HINDING_DURATION 0.3

#define PAINTING_ORIGIN_X (159)
#define PAINTING_ORIGIN_Y (115)
#define PAINTING_WIDTH (560)
#define PAINTING_HEIGHT (800)

#define SLIDER_THUMB_ORIGIN_X (320)
#define SLIDER_THUMB_ORIGIN_Y (961)
#define SLIDER_THUMB_WIDTH (165)
#define SLIDER_THUMB_HEIGHT (23)

#define SLIDER_IMAGE_ORIGIN_X (290)
#define SLIDER_IMAGE_ORIGIN_Y (934)
#define SLIDER_IMAGE_WIDTH (248)
#define SLIDER_IMAGE_HEIGHT (78)

#define TOOL_COLOR_AND_SIZE_INDICATOR_ORIGIN_X (SLIDER_IMAGE_ORIGIN_X + (180))
#define TOOL_COLOR_AND_SIZE_INDICATOR_ORIGIN_Y (SLIDER_IMAGE_ORIGIN_Y + (3))
#define TOOL_COLOR_AND_SIZE_INDICATOR_WIDTH (60)
#define TOOL_COLOR_AND_SIZE_INDICATOR_HEIGHT (60)

#define TOOL_COLOR_AND_SIZE_INDICATOR_CENTER_X (SLIDER_IMAGE_ORIGIN_X + (206.5))
#define TOOL_COLOR_AND_SIZE_INDICATOR_CENTER_Y (SLIDER_IMAGE_ORIGIN_Y + (37.0))

#define TOOL_SIZE_AND_COLOR_INDICATOR_MIN_RADIUS (4.0)
#define TOOL_SIZE_AND_COLOR_INDICATOR_SCALE_FACTOR (0.6)

#endif
