//
//  DrawingToolsBoxConstants.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 08.06.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#ifndef DynamicTextures_DrawingToolsBoxConstants_h
#define DynamicTextures_DrawingToolsBoxConstants_h

typedef unsigned int drawingToolsBoxState;

enum drawingToolsBoxState{
    DRAWING_TOOLS_BOX_STATE_OUT_OF_SCREEN,                      //0 - за пределами экрана
    DRAWING_TOOLS_BOX_STATE_APPEARS_ON_SCREEN,                  //1 - появляется на экране
    DRAWING_TOOLS_BOX_STATE_SELECT_DRAWING_TOOL,                //2 - выбор основного инструмента
    DRAWING_TOOLS_BOX_STATE_HIDING_DRAWING_TOOLS,               //3 - скрываем основные инструменты для показа расширенных
    DRAWING_TOOLS_BOX_STATE_PUSHING_EXTENDED_DRAWING_TOOLS,     //4 - основные инструменты скрыты, выдвигаем расширенные
    DRAWING_TOOLS_BOX_STATE_SELECT_EXTENDED_DRAWING_TOOLS,      //5 - выбор расширенного инструмента
    DRAWING_TOOLS_BOX_STATE_POPING_EXTENDED_DRAWING_TOOLS,      //6 - скрываем расширенные инструменты для показа основных
    DRAWING_TOOLS_BOX_STATE_UNHIDING_DRAWING_TOOLS,             //7 - расширенные инструменты скрыты, выдвигаем основные
    DRAWING_TOOLS_BOX_STATE_DISAPPEARS_FROM_SCREEN,             //8 - скрываем карандашницу (убираем за пределы экрана)
    DRAWING_TOOLS_BOX_STATE_RAINBOW_TOOL_SELECTED               //9 - показана радуга
};

typedef unsigned int drawingToolType;

enum drawingToolType {
    DRAWING_TOOL_FLOWMASTER,
    DRAWING_TOOL_RAINBOW,
    DRAWING_TOOL_CRAYONS
};

typedef unsigned int flowmasterType;

enum flowmasterType {
    FLOWMASTER_NORMAL,
    FLOWMASTER_EXTENDED
};

#endif
