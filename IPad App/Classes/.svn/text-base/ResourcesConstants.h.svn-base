//
//  TexturesConstants.h
//  KidsPaint
//
//  Created by Roman Smirnov on 24.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#ifndef KidsPaint_TexturesConstants_h
#define KidsPaint_TexturesConstants_h

#define MAX_SIMULTANEOUSLY_LOADING_TEXTURES (10)


typedef unsigned int modelID;
typedef unsigned int programID;
typedef unsigned int textureID;
typedef unsigned int sceneID;
typedef unsigned int textureState;

enum textureState{
    TEXTURE_STATE_UNLOADED,
    TEXTURE_STATE_LOADING,
    TEXTURE_STATE_USED,
    TEXTURE_STATE_UNUSED,
    TEXTURE_STATE_UNLOADING
};

// айдишники текстур, которые мы передаем в ResourceManager
enum textureID{
    TEXTURE_BACKGROUND,                         //0 - деревянный задник
    STAR_TEXTURE,                               //1 - звезда, используется при анимации заливки на экране раскрашивания
    CIRCLE_TEXTURE,                             //2 - окружность, используется для анимации заливки на экране раскрашивания
    TEXTURE_PAPER,                              //3 - текстура бумаги
    BRUSH_TEXTURE,                              //4 - текстура кисти (она отрисовывается на экране при рисовании)
    TEXTURE_BLACK_AND_WHITE_PICTURE,            //5 - черно-белая картинка, которую раскрашиваем
    TEXTURE_COLORING_PICTURE,                   //6 
    TEXTURE_DRAWING_TOOLS_BOX,                  //7 - карандашница
    BUTTON_TEXTURE,                             //8 - текстуры кнопок
    ERASER_TEXTURE,                             //9 - не используется, надо удалить
    SLIDER_BACKGROUND_TEXTURE,                  //10 - задник слайдера
    TOOL_COLOR_AND_SIZE_INDICATOR_TEXTURE,      //11 - индикатор цвета и размера кисти
    CRAYON_HIGHLIGHT_TEXTURE,                   //12 - текстура анимации мелка 1
    CRAYON_RUNNING_LIGHT_1_TEXTURE,             //13 - текстура анимации мелка 2
    CRAYON_RUNNING_LIGHT_2_TEXTURE,             //14 - текстура анимации мелка 3
    CRAYON_RUNNING_SHADOW_TEXTURE,              //15 - текстура анимации мелка 4
    UNDO_TEXTURE,                               //16 - текстура анды
    ERASER_UNSELECTED_TEXTURE,                  //17 - текстура выбранного ластика
    ERASER_SELECTED_TEXTURE,                    //18 - текстура невыбранного ластика
    UNDO_LIGHT_ON_TEXTURE,                      //19 - огонек на анде горит
    UNDO_LIGHT_OFF_TEXTURE,                     //20 - огонек на анде не горит
    GALLERY_BOOK_COVER_TEXTURE,                 //21 - обложка галереи-книги
    BOOK_COVER_TEXTURE,                         //22 - текстура обложки книги для галереи выбора книг
    POLKA_TEXTURE,                              //23 - текстура полки
    RAINBOW_TOOL_TEXTURE,                       //24
    RAINBOW_TOOL_INDICATOR_TEXTURE              //25
};

enum modelID{
    MODEL_SHEET_LEFT,
    MODEL_SHEET_RIGHT,
    MODEL_SHEET_COLORED
};

enum programID{
    PROGRAM_FINAL_PICTURE,
    PROGRAM_DRAW_BRUSH_LINE,
    PROGRAM_BASIC_LIGHTNING,
    PROGRAM_FILLING,
    PROGRAM_FINAL_PICTURE_WITH_SHADING, // шейдер, рисующий финальную картинку + затенение областей
    PROGRAM_TEXTURING_PLUS_COLOR_CHANGE,
    PROGRAM_TEXTURING_PLUS_ALPHA,
    PROGRAM_SIMPLE_TEXTURING
};

enum sceneID{
    SCENE_SELECT_PICTURE,
    SCENE_PAINTING
};


// шейдер освещения (для галереи)
enum {
    BASIC_LIGHTING_ATTRIB_VERTEX,
    BASIC_LIGHTING_ATTRIB_NORMAL,
    BASIC_LIGHTING_ATTRIB_TEX_COORDS,
    BASIC_LIGHTING_NUM_ATTRIBUTES
};

enum {
    BASIC_LIGHTING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX,
    BASIC_LIGHTING_UNIFORM_ROTATION,    
    BASIC_LIGHTING_UNIFORM_TEXTURE,
    BASIC_LIGHTING_UNIFORM_PAPER_TEXTURE,
    BASIC_LIGHTING_UNIFORM_LIGHT_DIRECTION,    
    BASIC_LIGHTING_UNIFORM_AMBIENT_COLOR,    
    BASIC_LIGHTING_UNIFORM_DIFFUSE_COLOR,    
    BASIC_LIGHTING_UNIFORM_SPECULAR_COLOR,    
    BASIC_LIGHTING_NUM_UNIFORMS
};
GLint basic_lighting_uniforms [BASIC_LIGHTING_NUM_UNIFORMS];


// Шейдер заливки обласи при рисовании

enum {
    FILLING_ATTRIB_VERTEX,
    FILLING_ATTRIB_TEX_COORDS,
    FILLING_ATTRIB_CIRCLE_TEX_COORDS,
    FILLING_NUM_ATTRIBUTES    
};

enum {
    FILLING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX,
    FILLING_UNIFORM_AREAS_TEXTURE,
    FILLING_UNIFORM_CIRCLE_TEXTURE,
    FILLING_UNIFORM_CURRENT_AREA,
    FILLING_UNIFORM_BRUSH_COLOR,
    FILLING_NUM_UNIFORMS
};
GLint filling_uniforms [FILLING_NUM_UNIFORMS];

// шейдер, рисующий финальную картинку
enum {
    FINAL_PICTURE_ATTRIB_VERTEX,
    FINAL_PICTURE_ATTRIB_TEX_COORDS,
    FINAL_PICTURE_NUM_ATTRIBUTES
};

enum {
    FINAL_PICTURE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX,
    FINAL_PICTURE_UNIFORM_TEXTURE,
    FINAL_PICTURE_UNIFORM_DRAWING_TEXTURE,
    FINAL_PICTURE_UNIFORM_PAPER_TEXTURE,
    FINAL_PICTURE_NUM_UNIFORMS
};
GLint final_picture_uniforms[FINAL_PICTURE_NUM_UNIFORMS];

// шейдер, рисующий финальную картинку + затенение областей
enum {
    FINAL_PICTURE_WITH_SHADING_ATTRIB_VERTEX,
    FINAL_PICTURE_WITH_SHADING_ATTRIB_TEX_COORDS,
    FINAL_PICTURE_WITH_SHADING_ATTRIB_COLOR,
    FINAL_PICTURE_WITH_SHADING_NUM_ATTRIBUTES
};

enum {
    FINAL_PICTURE_WITH_SHADING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX,
    FINAL_PICTURE_WITH_SHADING_UNIFORM_TEXTURE,
    FINAL_PICTURE_WITH_SHADING_UNIFORM_DRAWING_TEXTURE,
    FINAL_PICTURE_WITH_SHADING_UNIFORM_CURRENT_AREA,
    FINAL_PICTURE_WITH_SHADING_UNIFORM_PAPER_TEXTURE,
    FINAL_PICTURE_WITH_SHADING_UNIFORM_DISCOLORING_CONSTANT,
    FINAL_PICTURE_WITH_SHADING_UNIFORM_HIGHLIGHT_CONSTANT,
    FINAL_PICTURE_WITH_SHADING_NUM_UNIFORMS
};
GLint final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_NUM_UNIFORMS];


// шейдер, рисующий текстуру и меняющий ее цвет
enum {
    
    PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_ATTRIB_VERTEX,
    PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_ATTRIB_TEX_COORDS,
    PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_NUM_ATTRIBUTES
};

enum {
    PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX,
    PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_TEXTURE,
    PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_NEW_COLOR,
    PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_NUM_UNIFORMS
};
GLint texturing_plus_color_change_uniforms[PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_NUM_UNIFORMS];

enum {
    DRAW_BRUSH_LINE_ATTRIB_VERTEX,
    DRAW_BRUSH_LINE_ATTRIB_TEX_COORDS,
    DRAW_BRUSH_LINE_NUM_ATTRIBUTES
};

enum {
    DRAW_BRUSH_LINE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX,
    DRAW_BRUSH_LINE_UNIFORM_BRUSH_TEXTURE,
    DRAW_BRUSH_LINE_UNIFORM_COLOR,
    DRAW_BRUSH_LINE_UNIFORM_TEXTURE,
    DRAW_BRUSH_LINE_UNIFORM_CURRENT_AREA,
    DRAW_BRUSH_LINE_NUM_UNIFORMS
};
GLint draw_brush_line_uniforms [DRAW_BRUSH_LINE_NUM_UNIFORMS];

// шейдеры текстурирования
enum {
    SIMPLE_TEXTURING_ATTRIB_VERTEX,
    SIMPLE_TEXTURING_ATTRIB_TEX_COORDS,
    SIMPLE_TEXTURING_NUM_ATTRIBUTES
};
enum {
    SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX,
    SIMPLE_TEXTURING_UNIFORM_TEXTURE,
    SIMPLE_TEXTURING_NUM_UNIFORMS
};
GLint simple_texturing_uniforms [SIMPLE_TEXTURING_NUM_UNIFORMS];

// шейдеры полупрозрачного текстурирования
enum {
    TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX,
    TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS,
    TEXTURE_PLUS_ALPHA_NUM_ATTRIBUTES
};

enum {
    TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX,
    TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE,
    TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA,
    TEXTURE_PLUS_ALPHA_NUM_UNIFORMS
};
GLint texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_NUM_UNIFORMS];

#endif
