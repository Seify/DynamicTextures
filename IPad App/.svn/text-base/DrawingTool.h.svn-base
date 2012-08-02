//
//  DrwaingTool.h
//  KidsPaint
//
//  Created by Roman Smirnov on 02.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceConstants.h"
#import "ThreeDAnimation.h"

#define DT_STATE_HIDDEN_ORIGIN_X (-90)
#define DT_STATE_HIDDEN_ALPHA (0.4)

#define DT_STATE_SUPRESSED_ORIGIN_X (-90)
#define DT_STATE_SUPRESSED_ALPHA (0.0)

#define DT_STATE_SELECTED_ORIGIN_X (0.0)
#define DT_STATE_SELECTED_ALPHA (1.0)

#define DT_STATE_UNSELECTED_ORIGIN_X (-45)
#define DT_STATE_UNSELECTED_ALPHA (1.0)

#define DT_STATE_OUT_OF_SCREEN_ORIGIN_X (-148)
#define DT_STATE_OUT_OF_SCREEN_ALPHA (1.0)
#define DT_STATE_OUT_OF_SCREEN_ORIGIN_Y (244)
#define DT_STATE_OUT_OF_SCREEN_DELTA_Y (43.0)
#define DT_STATE_OUT_OF_SCREEN_WIDTH (148)
#define DT_STATE_OUT_OF_SCREEN_HEIGHT (37)

#define DT_APPEARS_ON_SCREEN_DURATION 0.22
#define DT_DISSAPPEARS_FROM_SCREEN_DURATION 0.22

#define DT_STATE_CHANGE_DURATION_FROM_UNSELECTER_TO_HIDDEN 0.1
#define DT_STATE_CHANGE_DURATION_FROM_HIDDEN_TO_UNSELECTED 0.1

// selected pencil animation

//running light 2
#define DT_RUNNING_LIGHT_2_START_ORIGIN_X (-DT_RUNNING_LIGHT_2_WIDTH)
#define DT_RUNNING_LIGHT_2_END_ORIGIN_X 50
#define DT_RUNNING_LIGHT_2_START_ORIGIN_Y_OFFSET -7
#define DT_RUNNING_LIGHT_2_END_ORIGIN_Y_OFFSET -3
#define DT_RUNNING_LIGHT_2_WIDTH 37
#define DT_RUNNING_LIGHT_2_HEIGHT 37
#define DT_RUNNING_LIGHT_2_START_DELAY 0.1
#define DT_RUNNING_LIGHT_2_START_TO_END_DURATION 0.4
#define DT_RUNNING_LIGHT_2_END_DELAY 1.0
#define DT_RUNNING_LIGHT_2_TOTAL_DURATION DT_RUNNING_LIGHT_2_START_DELAY+DT_RUNNING_LIGHT_2_START_TO_END_DURATION+DT_RUNNING_LIGHT_2_END_DELAY

#define DT_RUNNING_LIGHT_1_START_ORIGIN_X 45
#define DT_RUNNING_LIGHT_1_END_ORIGIN_X 75
#define DT_RUNNING_LIGHT_1_START_ORIGIN_Y_OFFSET -18
#define DT_RUNNING_LIGHT_1_END_ORIGIN_Y_OFFSET DT_RUNNING_LIGHT_1_START_ORIGIN_Y_OFFSET+4
#define DT_RUNNING_LIGHT_1_WIDTH 37
#define DT_RUNNING_LIGHT_1_HEIGHT 37
#define DT_RUNNING_LIGHT_1_START_DELAY DT_RUNNING_LIGHT_2_START_DELAY+DT_RUNNING_LIGHT_2_START_TO_END_DURATION + 0.3
#define DT_RUNNING_LIGHT_1_START_TO_END_DURATION 0.3
#define DT_RUNNING_LIGHT_1_END_DELAY 0.4
#define DT_RUNNING_LIGHT_1_TOTAL_DURATION DT_RUNNING_LIGHT_1_START_DELAY+DT_RUNNING_LIGHT_1_START_TO_END_DURATION+DT_RUNNING_LIGHT_1_END_DELAY

#define DT_HIGHLIGHT_ORIGIN_X DT_RUNNING_LIGHT_1_END_ORIGIN_X + DT_HIGHLIGHT_MAX_WIDTH/2
#define DT_HIGHLIGHT_ORIGIN_Y_OFFSET DT_RUNNING_LIGHT_1_START_ORIGIN_Y_OFFSET + DT_HIGHLIGHT_MAX_HEIGHT/2
#define DT_HIGHLIGHT_START_WIDTH 0
#define DT_HIGHLIGHT_START_HEIGHT 0
#define DT_HIGHLIGHT_MAX_HEIGHT 50
#define DT_HIGHLIGHT_MAX_WIDTH 50
#define DT_HIGHLIGHT_START_DELAY DT_RUNNING_LIGHT_1_START_DELAY+DT_RUNNING_LIGHT_1_START_TO_END_DURATION
#define DT_HIGHLIGHT_START_TO_END_DURATION 0.2
#define DT_HIGHLIGHT_END_DELAY 0.2
#define DT_HIGHLIGHT_TOTAL_DURATION DT_HIGHLIGHT_START_DELAY+DT_HIGHLIGHT_START_TO_END_DURATION+DT_HIGHLIGHT_END_DELAY

#define DT_RUNNING_SHADOW_START_ORIGIN_X 45
#define DT_RUNNING_SHADOW_END_ORIGIN_X 75
#define DT_RUNNING_SHADOW_START_ORIGIN_Y_OFFSET 8
#define DT_RUNNING_SHADOW_END_ORIGIN_Y_OFFSET DT_RUNNING_SHADOW_START_ORIGIN_Y_OFFSET+4
#define DT_RUNNING_SHADOW_WIDTH 37
#define DT_RUNNING_SHADOW_HEIGHT 37
#define DT_RUNNING_SHADOW_START_DELAY DT_RUNNING_LIGHT_2_START_DELAY+DT_RUNNING_LIGHT_2_START_TO_END_DURATION + 0.7
#define DT_RUNNING_SHADOW_START_TO_END_DURATION 0.3
#define DT_RUNNING_SHADOW_END_DELAY 0.0
#define DT_RUNNING_SHADOW_TOTAL_DURATION DT_RUNNING_SHADOW_START_DELAY+DT_RUNNING_SHADOW_START_TO_END_DURATION+DT_RUNNING_SHADOW_END_DELAY


@class DrawingToolExtended;

@protocol DrawingToolDelegate;

typedef unsigned int drawingToolState;

enum drawingToolState{
    DT_STATE_SELECTED,  //0 - выбран     
    DT_STATE_HIDING,    //1 - скрывается для показа доп/ оттенков
    DT_STATE_HIDDEN,    //2 - скрыт для показа доп.оттенков
    DT_STATE_SUPRESSED, //3 - скрыт для показа доп.оттенков, невидим и не отвечает на нажатия (поверх него выводится другой инструмент с доп.оттенками)
    DT_STATE_UNSELECTED,//4 - невыбран  
    DT_STATE_UNHIDING,   //5 - восстанавливается из скрытого состояния
    DT_STATE_OUT_OF_SCREEN, // 6 - находится за пределами экрана
    DT_STATE_APPEARS_ON_SCREEN, // 7 - выезжает на экран
    DT_STATE_DISAPPEARS_FROM_SCREEN // 8 - уезжает за экран
};

@interface DrawingTool : NSObject <ThreeDAnimationDelegate>
{
    int number;
    int selectedExtendedNumber;
    
    CGRect position;
    CGRect previousPosition; //для расчета анимации переходов между состояниями
    
    ThreeDAnimation *animation;
    
    float red;
    float green;
    float blue;
    float alpha;
       
    float reflex_red;
    float reflex_green;
    float reflex_blue;
    float reflex_alpha;
    
    float body_red;
    float body_green;
    float body_blue;
    float body_alpha;
    
    float previousBody_alpha; //для расчета анимации переходов между состояниями
    
    BOOL isSelected;
    
    drawingToolState state;
    drawingToolState previousState;
    drawingToolState nextState;
    
    double stateChangeBeginTime;
    double stateChangeEndTime;
    
    CGRect running_light2_position;
    double running_light2_startTime;
    double running_light2_endTime;
    double running_light2_alpha;

    CGRect running_light1_position;
    double running_light1_startTime;
    double running_light1_endTime;
    double running_light1_alpha;
    
    CGRect highlight_position;
    double highlight_startTime;
    double highlight_endTime;
    double highlight_alpha;
    
    CGRect running_shadow_position;
    double running_shadow_startTime;
    double running_shadow_endTime;
    double running_shadow_alpha;
    
    NSArray *extendedColors;
    int activeColor;
    
    NSArray *drawingToolsExtended;
    
    int indexOfBodyTexture;
}

@property (assign) id <DrawingToolDelegate> delegate;

@property int number;
@property int selectedExtendedNumber;

@property float red;
@property float green;
@property float blue;
@property float alpha;

@property float reflex_red;
@property float reflex_green;
@property float reflex_blue;
@property float reflex_alpha;

@property float body_red;
@property float body_green;
@property float body_blue;
@property float body_alpha;

@property float previousBody_alpha;

@property BOOL isSelected;
@property CGRect position;
@property CGRect previousPosition;

@property (readonly) drawingToolState state;
@property drawingToolState previousState;
@property drawingToolState nextState;


@property double stateChangeBeginTime;
@property double stateChangeEndTime;

@property CGRect running_light2_position;
@property double running_light2_startTime;
@property double running_light2_endTime;
@property double running_light2_alpha;

@property CGRect running_light1_position;
@property double running_light1_startTime;
@property double running_light1_endTime;
@property double running_light1_alpha;

@property CGRect highlight_position;
@property double highlight_startTime;
@property double highlight_endTime;
@property double highlight_alpha;

@property CGRect running_shadow_position;
@property double running_shadow_startTime;
@property double running_shadow_endTime;
@property double running_shadow_alpha;

@property (retain, readonly) NSArray *drawingToolsExtended;
@property (retain) NSArray *extendedColors;
@property int activeColor;

@property int indexOfBodyTexture;

@property (readonly) ThreeDAnimation *animation;
@property (readonly) BOOL isAnimated;

- (DrawingTool *)initWithPosition:(CGRect)pos Color:(UIColor *)color;
- (DrawingTool *)initWithPosition:(CGRect)pos ColorArray:(NSArray *)tempColorArray ActiveColor:(int)active;
- (void) setColorRed:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha;
- (void) setReflexColorRed:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha;
- (BOOL) isLocationInside:(CGPoint)location;

- (void)changeStateTo:(drawingToolState)newstate;

- (void)changeStateTo:(drawingToolState)newstate 
            NextState:(drawingToolState)dtNextState 
               AtTime:(double)currtime;

- (void)updatePhysicsAtTime:(double)currtime;
- (void)extendTones:(double)currtime;
@end

@protocol DrawingToolDelegate
- (BOOL)shouldBeSupressedAfterHiding:(DrawingTool *)dt;
@end;


