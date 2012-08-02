//
//  DrawingToolExtended.h
//  KidsPaint
//
//  Created by Roman Smirnov on 05.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "DrawingTool.h"

#define DRAWING_TOOL_EXTENDED_STATE_OUT_OF_SCREEN_ORIGIN_X (-148)
#define DRAWING_TOOL_EXTENDED_STATE_INACTIVE_ORIGIN_X (-148)
#define DRAWING_TOOL_EXTENDED_STATE_UNSELECTED_ORIGIN_X (-45)
#define DRAWING_TOOL_EXTENDED_STATE_UNSELECTED_ORIGIN_Y (-45)
#define DRAWING_TOOL_EXTENDED_STATE_SELECTED_ORIGIN_X (0.0)


#define DTE_APPEARS_ON_SCREEN_DURATION (0.3)

#define DRAWING_TOOL_EXTENDED_STATE_CHANGE_DURATION_FROM_INACTIVE_TO_UNSELECTED (0.1)
#define DRAWING_TOOL_EXTENDED_STATE_CHANGE_DURATION_FROM_UNSELECTED_TO_INACTIVE (0.1)
#define DRAWING_TOOL_EXTENDED_STATE_CHANGE_DURATION_TO_OUT_OF_SCREEN (0.22)

typedef unsigned int drawingToolExtendedState;

enum drawingToolExtendedState{
    DRAWING_TOOL_EXTENDED_STATE_SELECTED,               // 0 - расширенная палитра на экране, данный инструмент выбран
    DRAWING_TOOL_EXTENDED_STATE_UNSELECTED,             // 1 - расширенная палитра на экране, данный инструмент НЕ выбран
    DRAWING_TOOL_EXTENDED_STATE_PUSHING,                // 2 - расширенная палитра и данный инструмент выезжают
    DRAWING_TOOL_EXTENDED_STATE_POPING,                 // 3 - расширенная палитра и данный инструмент заезжают
    DRAWING_TOOL_EXTENDED_STATE_INACTIVE,               // 4 - расширенная палитра и данный инструмент скрыты
    DRAWING_TOOL_EXTENDED_STATE_DISAPPEARS_FROM_SCREEN, // 5 - расширенная палитра и данный инструмент уезжают за экран
    DRAWING_TOOL_EXTENDED_STATE_APPEARS_ON_SCREEN,      // 6 - расширенная палитра и данный инструмент выезжают за экран
    DRAWING_TOOL_EXTENDED_STATE_OUT_OF_SCREEN           // 7 - расширенная палитра и за пределами экрана
};

@class DrawingTool;

@interface DrawingToolExtended : DrawingTool
{
    DrawingTool *parentDrawingTool;
}
//@property (readonly) int state;
@property (assign) DrawingTool *parentDrawingTool;
@end
