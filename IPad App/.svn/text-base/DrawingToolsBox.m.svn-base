//
//  DrawingToolsBox.m
//  KidsPaint
//
//  Created by Roman Smirnov on 05.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//
#define rgb 1.0/255.0*

#import "DrawingToolsBox.h"
#import "DrawingTool.h"
#import "DrawingToolExtended.h"
#import "SoundManager.h"

@interface DrawingToolsBox()
@property (readwrite) drawingToolsBoxState state;
@end

@implementation DrawingToolsBox

@synthesize alpha;
@synthesize position;

@synthesize state, nextState;
@synthesize delegate;
@synthesize prevDrawingTool;


@synthesize activeToolType;
@synthesize nextToolType;

- (id)init
{
    self = [super init];
    
    if (self)
        activeToolType = DRAWING_TOOL_FLOWMASTER;
    
    return self;
}


- (RainbowTool *)rainbowTool
{
    if (!rainbowTool)
    {
        // кнопка выбора кастомного цвета
        rainbowTool = [[RainbowTool alloc] init];
        rainbowTool.position = CGRectMake(-RAINBOW_TOOL_WIDTH, 
                                          RAINBOW_TOOL_OFFSET_Y, 
                                          RAINBOW_TOOL_WIDTH, 
                                          RAINBOW_TOOL_HEIGHT);
        rainbowTool.alpha = 1.0;
        rainbowTool.delegate = self;
    }
    
    return rainbowTool;
}


- (GLButton *)customColorButton{
    if (!customColorButton){
        // кнопка выбора кастомного цвета
        customColorButton = [[GLButton alloc] init];
        customColorButton.delegate = (id <GLButtonDelegate>)self.delegate;
        customColorButton.identificator = BUTTON_CUSTOM_COLOR;
        customColorButton.position = CGRectMake(-BUTTON_CUSTOM_COLOR_WIDTH,
                                                BUTTON_CUSTOM_COLOR_OFFSET_Y, 
                                                BUTTON_CUSTOM_COLOR_WIDTH, 
                                                BUTTON_CUSTOM_COLOR_HEIGHT);
        customColorButton.touchArea = CGRectMake(BUTTON_CUSTOM_COLOR_OFFSET_X,
                                                 BUTTON_CUSTOM_COLOR_OFFSET_Y, 
                                                 BUTTON_CUSTOM_COLOR_WIDTH, 
                                                 BUTTON_CUSTOM_COLOR_HEIGHT);
        customColorButton.shouldDisplace = NO;
        customColorButton.alpha = 1.0;
    }
    return customColorButton;
}

- (ThreeDAnimation *)animation{
    if (!animation){
        animation = [[ThreeDAnimation alloc] init];
        animation.state = ANIMATION_STATE_STOPPED;
        animation.delegate = self;
    }
    return animation;
}

- (NSArray *)drawingTools{
    if (!drawingTools) {
        NSMutableArray *tempArray;
        DrawingTool *tempTool;
        tempArray = [NSMutableArray array];
        CGRect tempRect;
//        UIColor *tempColor;
        
        UIColor *tone0, *tone1, *tone2, *tone3, *tone4; 
        NSArray *tempColorArray;

        //grey
        tone0 = [UIColor colorWithRed:rgb 84  green:rgb 84  blue:rgb 84  alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 0   green:rgb 0   blue:rgb 0   alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 135 green:rgb 135 blue:rgb 135 alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 178 green:rgb 178 blue:rgb 178 alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 230 green:rgb 230 blue:rgb 230 alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 0, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 0;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 0;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];
        
        //brown
        tone0 = [UIColor colorWithRed:rgb 106 green:rgb 64  blue:rgb 38  alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 78  green:rgb 44  blue:rgb 13  alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 91  green:rgb 75  blue:rgb 53  alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 103 green:rgb 83  blue:rgb 76  alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 145 green:rgb 116 blue:rgb 85  alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 1, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 1;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 5;
        [tempTool changeStateTo: DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];
        
        //red
        tone0 = [UIColor colorWithRed:rgb 247 green:rgb 32  blue:rgb 35  alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 135 green:rgb 0   blue:rgb 15  alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 185 green:rgb 16  blue:rgb 17  alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 255 green:rgb 91  blue:rgb 108 alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 255 green:rgb 144 blue:rgb 142 alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 2, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 2;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 10;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];
        
        //orange
        tone0 = [UIColor colorWithRed:rgb 255 green:rgb 87  blue:rgb 26  alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 153 green:rgb 84  blue:rgb 31  alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 183 green:rgb 84  blue:rgb 35  alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 255 green:rgb 118 blue:rgb 25  alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 250 green:rgb 167 blue:rgb 64  alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 3, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 3;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 15;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];
        
        //yellow
        tone0 = [UIColor colorWithRed:rgb 255 green:rgb 243 blue:rgb 63  alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 255 green:rgb 195 blue:rgb 42  alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 212 green:rgb 156 blue:rgb 31  alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 219 green:rgb 185 blue:rgb 91  alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 255 green:rgb 237 blue:rgb 146 alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 4, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 4;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 20;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];   
        
        //beuge
        tone0 = [UIColor colorWithRed:rgb 253 green:rgb 224 blue:rgb 181 alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 183 green:rgb 176 blue:rgb 138 alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 238 green:rgb 190 blue:rgb 119 alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 255 green:rgb 193 blue:rgb 165 alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 252 green:rgb 245 blue:rgb 199 alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 5, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 5;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 25;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];   
        
        //light green
        tone0 = [UIColor colorWithRed:rgb 49  green:rgb 178 blue:rgb 41  alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 95  green:rgb 152 blue:rgb 56  alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 108 green:rgb 220 blue:rgb 64  alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 107 green:rgb 210 blue:rgb 141 alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 195 green:rgb 255 blue:rgb 84  alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 6, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 6;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 30;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];   
        
        //dark green
        tone0 = [UIColor colorWithRed:rgb 0   green:rgb 82  blue:rgb 42  alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 25  green:rgb 54  blue:rgb 36  alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 0   green:rgb 116 blue:rgb 20  alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 79  green:rgb 104 blue:rgb 92  alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 130 green:rgb 146 blue:rgb 75  alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 7, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 7;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 35;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];   
        
        //light blue
        tone0 = [UIColor colorWithRed:rgb 0   green:rgb 177 blue:rgb 159 alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 0   green:rgb 141 blue:rgb 113 alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 0   green:rgb 185 blue:rgb 196 alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 73  green:rgb 214 blue:rgb 199 alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 148 green:rgb 215 blue:rgb 225 alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 8, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);       
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 8;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 40;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];           
        
        //deep blue
        tone0 = [UIColor colorWithRed:rgb 3   green:rgb 40  blue:rgb 174 alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 38  green:rgb 28  blue:rgb 121 alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 0   green:rgb 95  blue:rgb 235 alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 0   green:rgb 150 blue:rgb 235 alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 110 green:rgb 167 blue:rgb 251 alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 9, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);       
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 9;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 45;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];        
        
        //violet
        tone0 = [UIColor colorWithRed:rgb 109 green:rgb 32  blue:rgb 125 alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 74  green:rgb 25  blue:rgb 55  alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 120 green:rgb 33  blue:rgb 185 alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 222 green:rgb 0   blue:rgb 250 alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 172 green:rgb 116 blue:rgb 212 alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 10, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 10;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 50;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];           
        
        //pink
        tone0 = [UIColor colorWithRed:rgb 255 green:rgb 55  blue:rgb 145 alpha:rgb 255];
        tone1 = [UIColor colorWithRed:rgb 135 green:rgb 0   blue:rgb 70  alpha:rgb 255];
        tone2 = [UIColor colorWithRed:rgb 193 green:rgb 18  blue:rgb 110 alpha:rgb 255];
        tone3 = [UIColor colorWithRed:rgb 255 green:rgb 130 blue:rgb 179 alpha:rgb 255];
        tone4 = [UIColor colorWithRed:rgb 255 green:rgb 166 blue:rgb 201 alpha:rgb 255];
        tempColorArray = [NSArray arrayWithObjects: tone0, tone1, tone2, tone3, tone4, nil];
        tempRect = CGRectMake(DT_STATE_OUT_OF_SCREEN_ORIGIN_X, 
                              DT_STATE_OUT_OF_SCREEN_ORIGIN_Y + DT_STATE_OUT_OF_SCREEN_DELTA_Y * 11, 
                              DT_STATE_OUT_OF_SCREEN_WIDTH, 
                              DT_STATE_OUT_OF_SCREEN_HEIGHT);        
        tempTool = [[DrawingTool alloc] initWithPosition:tempRect ColorArray:tempColorArray ActiveColor:0];
        tempTool.number = 11;
        tempTool.selectedExtendedNumber = 0;
        tempTool.indexOfBodyTexture = 55;
        [tempTool changeStateTo:DT_STATE_OUT_OF_SCREEN];
        tempTool.previousState = tempTool.state;
        tempTool.delegate = self;
        [tempArray addObject:tempTool];        
        [tempTool release];           
        
        drawingTools = tempArray;
        [drawingTools retain];
    }
    
    return drawingTools;
}

- (void) putDownOldDrawingTool{
    if(prevDrawingTool) {
        prevDrawingTool.isSelected = FALSE;
        prevDrawingTool.position = CGRectMake(prevDrawingTool.position.origin.x - 45, prevDrawingTool.position.origin.y, prevDrawingTool.position.size.width, prevDrawingTool.position.size.height);
        //        [prevDrawingTool setNeedsDisplay];
    }
}

- (BOOL)shouldReceiveInput:(DrawingTool *)dt{
    return (dt.state == DT_STATE_SELECTED || dt.state == DT_STATE_UNSELECTED || dt.state == DT_STATE_HIDDEN);
}

- (BOOL)shouldReceiveInputDTE:(DrawingToolExtended *)dte{
//    NSLog(@"dte.state = %d", dte.state);
    return (dte.state == DRAWING_TOOL_EXTENDED_STATE_UNSELECTED || dte.state == DRAWING_TOOL_EXTENDED_STATE_SELECTED);
    
}

#pragma mark - Drawing Tools Delegate's methods

- (BOOL)shouldBeSupressedAfterHiding:(DrawingTool *)dt{
    int dtnumber = [self.drawingTools indexOfObject:dt];
    return (dtnumber > 3 && dtnumber < 9);
}

- (void)newColorSelectedWithRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alphaValue
{
    if(delegate != nil && [(NSObject*)delegate respondsToSelector:@selector(newColorSelectedWithRed:green:blue:alpha:)])
        [delegate newColorSelectedWithRed:red green:green blue:blue alpha:alphaValue];
}

#pragma mark - Tools' states queries

- (BOOL)areTherePlayingAnimations
{
    for (DrawingTool *dt in self.drawingTools) {
        switch (dt.state)
        {
            case DT_STATE_HIDDEN:
            case DT_STATE_SELECTED:
            case DT_STATE_SUPRESSED:
            case DT_STATE_UNSELECTED:
            case DT_STATE_OUT_OF_SCREEN:
            {
                break;
            }
            case DT_STATE_HIDING:
            case DT_STATE_UNHIDING:
            case DT_STATE_APPEARS_ON_SCREEN:
            case DT_STATE_DISAPPEARS_FROM_SCREEN:
            {
                return YES;
                break;
            }

            default:
            {
                NSLog(@"%@ : %@ Warning! Unexpected dt state: %d", self, NSStringFromSelector(_cmd), dt.state);
                break;
            }
        }
        
        for (DrawingToolExtended *dte in dt.drawingToolsExtended)
        {
            switch (dte.state) {
                    
                case DRAWING_TOOL_EXTENDED_STATE_SELECTED:
                case DRAWING_TOOL_EXTENDED_STATE_UNSELECTED:
                case DRAWING_TOOL_EXTENDED_STATE_INACTIVE:
                case DRAWING_TOOL_EXTENDED_STATE_OUT_OF_SCREEN:
                {
                    break;
                }

                case DRAWING_TOOL_EXTENDED_STATE_PUSHING:
                case DRAWING_TOOL_EXTENDED_STATE_POPING:
                case DRAWING_TOOL_EXTENDED_STATE_DISAPPEARS_FROM_SCREEN:
                case DRAWING_TOOL_EXTENDED_STATE_APPEARS_ON_SCREEN:
                {   
                    return YES;
                    break;
                }
                    
                default:
                {
                    break;
                    NSLog(@"%@ : %@ Warning! Unexpected dte state: %d", self, NSStringFromSelector(_cmd), dte.state);
                }
            }
        }
    }
    
    return NO;
}

- (BOOL)allDrawingToolsHiddenOrSupressed{
    
    BOOL retValue = YES;
    for (int i=0; i<[self.drawingTools count]; i++) {
        DrawingTool *dt = [self.drawingTools objectAtIndex:i];
        if (dt.state != DT_STATE_HIDDEN &&
            dt.state != DT_STATE_SUPRESSED){
                retValue = NO;
                break;
            }
    }
    return retValue;
}

- (BOOL)allDrawingToolsExtendedAreSelectedOrUndelected{
    BOOL retValue = YES;
    for (int i=0; i<[self.drawingTools count]; i++) {
        DrawingTool *dt = [self.drawingTools objectAtIndex:i];
        if (dt.state != DT_STATE_SELECTED &&
            dt.state != DT_STATE_UNSELECTED){
            retValue = NO;
            break;
        }
    }
    return retValue;
}

- (BOOL)allDrawingToolsExtendedAreVisible{
    BOOL retValue = YES;
    for (int i=0; i<[drawingToolToExtend.drawingToolsExtended count]; i++) {
        DrawingToolExtended *dte = [drawingToolToExtend.drawingToolsExtended objectAtIndex:i];
        if (dte.state != DRAWING_TOOL_EXTENDED_STATE_SELECTED &&
            dte.state != DRAWING_TOOL_EXTENDED_STATE_UNSELECTED)
        {
            retValue = NO;
            break;
        }
    }
    return retValue;
    
}

- (BOOL)allDrawingToolsExtendedAreInactive{
    BOOL retValue = YES;
    for (int i=0; i<[drawingToolToExtend.drawingToolsExtended count]; i++) {
        DrawingToolExtended *dte = [drawingToolToExtend.drawingToolsExtended objectAtIndex:i];
        
//        NSLog(@"%@ : %@ dte.state = %d", self, NSStringFromSelector(_cmd), dte.state);
        
        if (dte.state != DRAWING_TOOL_EXTENDED_STATE_INACTIVE) {
            retValue = NO;
            break;
        }
    }
    return retValue;
}

- (BOOL)allToolsAppeared 
{
    
    for (DrawingTool *dt in self.drawingTools)
    {
        if(dt.state == DT_STATE_APPEARS_ON_SCREEN) {
            return NO;
        }
        for (DrawingToolExtended *dte in dt.drawingToolsExtended) {
            if (dte.state == DRAWING_TOOL_EXTENDED_STATE_APPEARS_ON_SCREEN){
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - State Machine

- (void)startAnimatingDrawingTool:(BOOL)toolIsAppearing atTime:(double)currtime
{
    if(toolIsAppearing)
        [self restoreStateAndShowTool:activeToolType];
    else
    {
        [self saveStateForTool];
        
        switch (activeToolType) 
        {
            case DRAWING_TOOL_FLOWMASTER:
            {
                for (DrawingTool *dt in self.drawingTools)
                {
                    [dt changeStateTo:DT_STATE_DISAPPEARS_FROM_SCREEN 
                            NextState:DT_STATE_OUT_OF_SCREEN 
                               AtTime:currtime];
                    
                }
                
                break;
            }
                
            case DRAWING_TOOL_RAINBOW:
            {
                [rainbowTool changeStateTo:RAINBOW_TOOL_STATE_DISAPPEARS_FROM_SCREEN AtTime:currtime];
                break;
            }
                
            default:
            {
                NSLog(@"%@ : %@ unexpected tool type: %d !", self, NSStringFromSelector(_cmd), activeToolType);
                break;
            }
        }
    }
}

- (void)changeStateTo:(drawingToolsBoxState)newstate AtTime:(double)currtime
{
    switch (newstate) {
            
        case DRAWING_TOOLS_BOX_STATE_OUT_OF_SCREEN:{
            
            for (DrawingTool *dt in self.drawingTools) {
                [dt changeStateTo:DT_STATE_OUT_OF_SCREEN];
            }            
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_APPEARS_ON_SCREEN:{
            
            // анимируем выезд карандашницы на экран
            self.animation.startAlpha = self.alpha;
            self.animation.endAlpha = 1.0;
            
            self.animation.startPosition = self.position;
            self.animation.endPosition = CGRectMake(DRAWING_TOOLS_BOX_OFFSET_X, 
                                                                    DRAWING_TOOLS_BOX_OFFSET_Y, 
                                                                    DRAWING_TOOLS_BOX_WIDTH, 
                                                                    DRAWING_TOOLS_BOX_HEIGHT);
            
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + DRAWING_TOOLS_BOX_UNHIDING_DURATION;
            
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            // анимируем выезд кнопки выбора кастомного цвета на экран
            self.customColorButton.animation.startAlpha = self.customColorButton.alpha;
            self.customColorButton.animation.endAlpha = 1.0;
            
            self.customColorButton.animation.startPosition = self.customColorButton.position;
            self.customColorButton.animation.endPosition = CGRectMake(BUTTON_CUSTOM_COLOR_OFFSET_X,
                                                                      BUTTON_CUSTOM_COLOR_OFFSET_Y, 
                                                                      BUTTON_CUSTOM_COLOR_WIDTH, 
                                                                      BUTTON_CUSTOM_COLOR_HEIGHT);
            
            self.customColorButton.animation.startTime = self.animation.startTime;
            self.customColorButton.animation.endTime = self.animation.endTime;
            
            self.customColorButton.animation.state = ANIMATION_STATE_PLAYING;

            [self startAnimatingDrawingTool:YES atTime:currtime];

            
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_SELECT_DRAWING_TOOL:{
            
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_HIDING_DRAWING_TOOLS:{
            
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_4.mp3", [[NSBundle mainBundle] resourcePath]];  
            SoundManager *sm = [SoundManager sharedInstance];        
            [sm playEffectFilePath:soundFilePath];
            
            
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_PUSHING_EXTENDED_DRAWING_TOOLS:{
            
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_SELECT_EXTENDED_DRAWING_TOOLS:{
            
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_POPING_EXTENDED_DRAWING_TOOLS:{
            
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_4.mp3", [[NSBundle mainBundle] resourcePath]];  
            SoundManager *sm = [SoundManager sharedInstance];        
            [sm playEffectFilePath:soundFilePath];

            
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_UNHIDING_DRAWING_TOOLS:{
            
            break;
        }       
            
        case DRAWING_TOOLS_BOX_STATE_DISAPPEARS_FROM_SCREEN:{
            
            self.animation.startAlpha = self.alpha;
            self.animation.endAlpha = 1.0;
            
            self.animation.startPosition = self.position;
            self.animation.endPosition = CGRectMake(-DRAWING_TOOLS_BOX_WIDTH, 
                                                    DRAWING_TOOLS_BOX_OFFSET_Y, 
                                                    DRAWING_TOOLS_BOX_WIDTH, 
                                                    DRAWING_TOOLS_BOX_HEIGHT);
            
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + DRAWING_TOOLS_BOX_UNHIDING_DURATION;
            
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            
            
            self.customColorButton.animation.startAlpha = self.customColorButton.alpha;
            self.customColorButton.animation.endAlpha = 1.0;
            
            self.customColorButton.animation.startPosition = self.customColorButton.position;
            self.customColorButton.animation.endPosition = CGRectMake(BUTTON_CUSTOM_COLOR_OFFSET_X - DRAWING_TOOLS_BOX_WIDTH,
                                                                      BUTTON_CUSTOM_COLOR_OFFSET_Y, 
                                                                      BUTTON_CUSTOM_COLOR_WIDTH, 
                                                                      BUTTON_CUSTOM_COLOR_HEIGHT);
            
            self.customColorButton.animation.startTime = self.animation.startTime;
            self.customColorButton.animation.endTime = self.animation.endTime;
            
            self.customColorButton.animation.state = ANIMATION_STATE_PLAYING;
            
            [self startAnimatingDrawingTool:NO atTime:currtime];
            
            break;
        }          
            

        default:{
            NSLog(@"%@ : %@ unexpected new state: %d !", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
    
    self.state = newstate;

}

#pragma mark - Physics

- (void)updatePhysicsAtTime:(double)currtime{
    
    [self.animation updatePhysicsAtTime:currtime];
    if (self.animation.state == ANIMATION_STATE_PLAYING){
        self.alpha = self.animation.alpha;
        self.position = self.animation.position;
    }
    
    // вызов обработчика физики для всех инструментов
    for (int i=0; i<[self.drawingTools count]; i++)
    {
        DrawingTool *dt = [self.drawingTools objectAtIndex:i];
        [dt updatePhysicsAtTime:currtime];
        for (int j=0; j<[dt.drawingToolsExtended count]; j++){
            DrawingToolExtended *dte = [dt.drawingToolsExtended objectAtIndex:j];
            [dte updatePhysicsAtTime:currtime];
        }
    }
    
    //вызов обработчика физики для кнопки выбора кастомного цвета
    [self.customColorButton updatePhysicsAtTime:currtime];
    [rainbowTool updatePhysicsAtTime:currtime];
    
    switch (self.state) {
            
        case DRAWING_TOOLS_BOX_STATE_OUT_OF_SCREEN:{
        // do nothing
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_APPEARS_ON_SCREEN:{
            // если палитра выдвинулась, переходим в следующее состояние (например, режим выбора карандаша);
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                if ([self allToolsAppeared]){
                    self.state = self.nextState;
                }
            }
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_SELECT_DRAWING_TOOL:{
            // do nothing
            break;
        }
                        
        case DRAWING_TOOLS_BOX_STATE_HIDING_DRAWING_TOOLS:{
        // задвигаем базовую палитру
            if ([self allDrawingToolsHiddenOrSupressed]) {
                self.state = DRAWING_TOOLS_BOX_STATE_PUSHING_EXTENDED_DRAWING_TOOLS;
                [drawingToolToExtend extendTones:currtime];
            }
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_PUSHING_EXTENDED_DRAWING_TOOLS:{
        // выдвигаем расширенную палитру
            if ([self allDrawingToolsExtendedAreVisible]){
                self.state = DRAWING_TOOLS_BOX_STATE_SELECT_EXTENDED_DRAWING_TOOLS;
            }
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_SELECT_EXTENDED_DRAWING_TOOLS:{
            // do nothing
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_POPING_EXTENDED_DRAWING_TOOLS:{
        // задвигаем расширенную палитру
            if ([self allDrawingToolsExtendedAreInactive]){
                self.state = DRAWING_TOOLS_BOX_STATE_UNHIDING_DRAWING_TOOLS;
                for (int i=0; i<[self.drawingTools count]; i++){
                    DrawingTool *dt = [self.drawingTools objectAtIndex:i];
                    
                    //                dt.previousState = dt.state;
                    //                dt.state = DT_STATE_UNHIDING;
                    [dt changeStateTo:DT_STATE_UNHIDING];
                    if (dt == drawingToolToExtend) {
                        dt.nextState = DT_STATE_SELECTED;
                    } else {
                        dt.nextState = DT_STATE_UNSELECTED;                    
                    }
                    dt.stateChangeBeginTime = currtime;
                    dt.StateChangeEndTime = currtime + DT_STATE_CHANGE_DURATION_FROM_HIDDEN_TO_UNSELECTED;
                    
                }
            }
            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_UNHIDING_DRAWING_TOOLS:{
        // выдвигаем базовую палитру
            if ([self allDrawingToolsExtendedAreSelectedOrUndelected]){
                self.state = DRAWING_TOOLS_BOX_STATE_SELECT_DRAWING_TOOL;
            }

            break;
        }
            
        case DRAWING_TOOLS_BOX_STATE_DISAPPEARS_FROM_SCREEN:
        {
            if(activeToolType != nextToolType && animation.state == ANIMATION_STATE_STOPPED)
            {
                activeToolType = nextToolType;
                [self changeStateTo:DRAWING_TOOLS_BOX_STATE_APPEARS_ON_SCREEN AtTime:CFAbsoluteTimeGetCurrent()];
            }
            else
            {
                if ([self allDrawingToolsExtendedAreInactive])
                    [self changeStateTo:DRAWING_TOOLS_BOX_STATE_OUT_OF_SCREEN AtTime:CFAbsoluteTimeGetCurrent()]; 
            }
            
            break;
        }

            
        default:{
            
            NSLog(@"%@ : %@ WARNING!!! unexpected DrawingToolsBox state : %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }

    
}

#pragma mark - events handlers

- (void)drawingToolClicked:(DrawingTool *)dt{
        
    if (self.state == DRAWING_TOOLS_BOX_STATE_SELECT_DRAWING_TOOL) {
    
        // если нажали на невыбранный карандаш
        if (!dt.state == DT_STATE_SELECTED)
        {
            dt.isSelected = TRUE;
            [dt changeStateTo:DT_STATE_SELECTED];
            dt.position = CGRectMake(DT_STATE_SELECTED_ORIGIN_X, dt.position.origin.y, dt.position.size.width, dt.position.size.height);
            dt.previousPosition = dt.position;
            dt.previousBody_alpha = dt.body_alpha;

            // делаем невыбранным предыдущий карандаш
            for (int i=0; i<[self.drawingTools count]; i++) {
                DrawingTool *prevseldt = [self.drawingTools objectAtIndex:i];
                if (prevseldt != dt)
                    if (prevseldt.state == DT_STATE_SELECTED) {
                        prevseldt.isSelected = NO;
                        [prevseldt changeStateTo:DT_STATE_UNSELECTED];
                    }
            }
            
            // уведомляем менеджера интерфейса о событии
            [self.delegate newDrawingToolSelected:dt];
        }
        // если нажали на выбранный ранее карандаш
        else {

            double currtime = CFAbsoluteTimeGetCurrent();
            
//            self.state = DRAWING_TOOLS_BOX_STATE_HIDING_DRAWING_TOOLS;
            [self changeStateTo:DRAWING_TOOLS_BOX_STATE_HIDING_DRAWING_TOOLS AtTime:currtime];
            drawingToolToExtend = dt;
            
            
            for (int i=0; i<[self.drawingTools count]; i++) 
            {
                DrawingTool *dt = [self.drawingTools objectAtIndex:i];
                {
                    drawingToolState newState;
                    if ([self shouldBeSupressedAfterHiding:dt]){
                        newState = DT_STATE_SUPRESSED;
                    } else {
                        newState = DT_STATE_HIDDEN;
                    }
                    [dt changeStateTo:DT_STATE_HIDING
                            NextState:newState 
                               AtTime:currtime];
                }
            }
        }
    }
    else if (self.state == DRAWING_TOOLS_BOX_STATE_SELECT_EXTENDED_DRAWING_TOOLS) {
        // если нажали на полупрозрачный основной карандаш
        if (dt.state == DT_STATE_HIDDEN) {
            double currtime = CFAbsoluteTimeGetCurrent();
//            self.state = DRAWING_TOOLS_BOX_STATE_POPING_EXTENDED_DRAWING_TOOLS;
            [self changeStateTo:DRAWING_TOOLS_BOX_STATE_POPING_EXTENDED_DRAWING_TOOLS AtTime:currtime];
            
            for (int i=0; i<[drawingToolToExtend.drawingToolsExtended count]; i++) {
                DrawingToolExtended *dte = [drawingToolToExtend.drawingToolsExtended objectAtIndex:i];
                
                [dte changeStateTo:DRAWING_TOOL_EXTENDED_STATE_POPING 
                         NextState:DRAWING_TOOL_EXTENDED_STATE_INACTIVE 
                            AtTime:currtime];
                
            }      
            
            [self.delegate newDrawingToolSelected:drawingToolToExtend];
        }
    }
}

- (void)changeParentColorToExtended:(DrawingToolExtended *)dte {
    //меняем цвет основного карандаша
    dte.parentDrawingTool.red = dte.red;
    dte.parentDrawingTool.green = dte.green;
    dte.parentDrawingTool.blue = dte.blue;
    dte.parentDrawingTool.alpha = dte.alpha;
    
    dte.parentDrawingTool.body_red = dte.body_red;
    dte.parentDrawingTool.body_green = dte.body_green;
    dte.parentDrawingTool.body_blue = dte.body_blue;
    //            dte.parentDrawingTool.body_alpha = dte.body_alpha;
    
    dte.parentDrawingTool.indexOfBodyTexture = dte.indexOfBodyTexture;
    
    dte.parentDrawingTool.activeColor = [dte.parentDrawingTool.drawingToolsExtended indexOfObject:dte];
    
    dte.parentDrawingTool.selectedExtendedNumber = dte.number;
}

- (void)drawingToolExtendedClicked:(DrawingToolExtended *)dte{
    if (self.state == DRAWING_TOOLS_BOX_STATE_SELECT_EXTENDED_DRAWING_TOOLS){
        
        // если нажали на невыбранный карандаш
        if (dte.state == DRAWING_TOOL_EXTENDED_STATE_UNSELECTED){
            dte.isSelected = TRUE;
            [dte changeStateTo:DRAWING_TOOL_EXTENDED_STATE_SELECTED];
            
            // делаем невыбранным предыдущий карандаш
            
            for (int i=0; i<[drawingToolToExtend.drawingToolsExtended count]; i++) {
                DrawingToolExtended *prevseldte = [drawingToolToExtend.drawingToolsExtended objectAtIndex:i];
                if (prevseldte != dte) {
                    
//                    NSLog(@"%@ : %@ prevseldte.state = %d", self, NSStringFromSelector(_cmd), prevseldte.state);
                    
                    if (prevseldte.state == DRAWING_TOOL_EXTENDED_STATE_SELECTED) {
                        prevseldte.isSelected = NO;
                        [prevseldte changeStateTo:DRAWING_TOOL_EXTENDED_STATE_UNSELECTED];
                    }
                }
            }
            
            [self.delegate newDrawingToolSelected:dte];
        }
        // если нажали на выбранный карандаш
        else if (dte.state == DRAWING_TOOL_EXTENDED_STATE_SELECTED){
            
            [self changeParentColorToExtended:dte];
            
            double currtime = CFAbsoluteTimeGetCurrent();
            [self changeStateTo:DRAWING_TOOLS_BOX_STATE_POPING_EXTENDED_DRAWING_TOOLS AtTime:currtime];
//            self.state = DRAWING_TOOLS_BOX_STATE_POPING_EXTENDED_DRAWING_TOOLS;
            
            for (int i=0; i<[drawingToolToExtend.drawingToolsExtended count]; i++) {
                DrawingToolExtended *dte = [drawingToolToExtend.drawingToolsExtended objectAtIndex:i];

                [dte changeStateTo:DRAWING_TOOL_EXTENDED_STATE_POPING 
                         NextState:DRAWING_TOOL_EXTENDED_STATE_INACTIVE 
                            AtTime:currtime];

            
            }        
        }
        
    }
}

- (BOOL)processTouchAtLocation:(CGPoint)location
{
    
    // обрабатываем нажатия на основные карандаши
    for (int i=0; i<[self.drawingTools count]; i++) {
        DrawingTool *dt = [self.drawingTools objectAtIndex:i];
        if ([self shouldReceiveInput:dt])
            if ([dt isLocationInside:location]) {
                [self drawingToolClicked:dt];
                return YES;
            }
    } 

    // обрабатываем нажатия на оттеночные карандаши
    for (int i=0; i<[self.drawingTools count]; i++) {
        DrawingTool *dt = [self.drawingTools objectAtIndex:i];
        for (int j=0; j<[dt.drawingToolsExtended count]; j++) {
            DrawingToolExtended *dte = [dt.drawingToolsExtended objectAtIndex:j];
            if ([self shouldReceiveInputDTE:dte]){
                if ([dte isLocationInside:location]) {
                    [self drawingToolExtendedClicked:dte];
                    return YES;
                }                
            }
        } 
    }
    return NO;
}

- (void)unselectTools{
    switch (self.state) {
        case DRAWING_TOOLS_BOX_STATE_SELECT_DRAWING_TOOL:
        {
            for (int i=0; i<[self.drawingTools count]; i++) {
                DrawingTool *dt = [self.drawingTools objectAtIndex:i];
                [dt changeStateTo:DT_STATE_UNSELECTED];
            }
            break;
        }
            
            case DRAWING_TOOLS_BOX_STATE_SELECT_EXTENDED_DRAWING_TOOLS:
        {
            for (int i=0; i<[drawingToolToExtend.drawingToolsExtended count]; i++) {
                DrawingToolExtended *dte = [drawingToolToExtend.drawingToolsExtended objectAtIndex:i];
                [dte changeStateTo:DRAWING_TOOL_EXTENDED_STATE_UNSELECTED];
            }
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected DTBOX state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

- (void)touchBeganAtLocation:(CGPoint)location
{
    if ([self processTouchAtLocation:location]) 
    {
        //NSLog(@"drawingToolsBox touch processed");
    }
    
    [customColorButton touchBeganAtLocation:location];
    [rainbowTool touchBeganAtLocation:location];
}

- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation
{
    [customColorButton touchMovedAtLocation:location PreviousLocation:previousLocation];
    [rainbowTool touchMovedAtLocation:location PreviousLocation:previousLocation];
}

- (void)touchEndedAtLocation:(CGPoint)location
{
    [customColorButton touchEndedAtLocation:location];
    [rainbowTool touchEndedAtLocation:location];
}

- (void)touchesCancelledLocation:(CGPoint)location
{
    [customColorButton touchesCancelledLocation:location];
    [rainbowTool touchEndedAtLocation:location];
}


#pragma mark - Save & Restore state

- (void)saveStateForTool
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithUnsignedInt:state] forKey:@"lastBoxState"];
    
    switch (activeToolType) 
    {
        case DRAWING_TOOL_FLOWMASTER:
        {
            [defaults setInteger:drawingToolToExtend.number forKey:@"drawingToolToExtendNumber"];
            
            NSMutableArray* drawingToolsStates = [NSMutableArray array];
            NSMutableArray* drawingToolsSelectedExtendedIndexes = [NSMutableArray array];
            NSMutableArray* drawingToolsExtendedStates = [NSMutableArray array];
            
            for (DrawingTool* dt in drawingTools) 
            {
                [drawingToolsStates addObject:[NSNumber numberWithUnsignedInt:dt.state]];
                [drawingToolsSelectedExtendedIndexes addObject:[NSNumber numberWithInt:dt.selectedExtendedNumber]];
                [drawingToolsExtendedStates addObject:[NSMutableArray array]];
                
                for (DrawingToolExtended* dte in dt.drawingToolsExtended)
                    [[drawingToolsExtendedStates lastObject] addObject:[NSNumber numberWithUnsignedInt:dte.state]];
            }
            
            if(drawingTools.count > 0)
            {
                [defaults setObject:drawingToolsStates forKey:@"drawingToolsStates"];
                [defaults setObject:drawingToolsSelectedExtendedIndexes forKey:@"drawingToolsSelectedExtendedIndexes"];
                [defaults setObject:drawingToolsExtendedStates forKey:@"drawingToolsExtendedStates"];
            }
            
            break;
        }
        case DRAWING_TOOL_RAINBOW:
        {
            [rainbowTool saveState];
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ WARNING!!! unexpected DrawingToolsBox activeToolType : %d", self, NSStringFromSelector(_cmd), activeToolType);
            break;
        }
    }
    
    [defaults synchronize];
}

- (void)saveState
{
    //NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:activeToolType forKey:@"activeToolType"];
    [defaults setInteger:nextToolType forKey:@"nextToolType"];
    
    [defaults synchronize];
    
    [self saveStateForTool];
}

- (void)restoreStateAndShowTool:(drawingToolType)tooltype
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    double currtime = CFAbsoluteTimeGetCurrent();
    
    NSNumber* dtboxStateNumber = [defaults objectForKey:@"lastBoxState"];
    if (dtboxStateNumber)
        nextState = [dtboxStateNumber unsignedIntValue];
    else
        nextState = DRAWING_TOOLS_BOX_STATE_SELECT_DRAWING_TOOL; //дефолтное значение
    
    switch (tooltype) 
    {
        case DRAWING_TOOL_FLOWMASTER:
        {
            //calling property just to be sure that drawing tools are created
            if(self.drawingTools.count > 0)
            {
                drawingToolToExtend = [drawingTools objectAtIndex:[defaults integerForKey:@"drawingToolToExtendNumber"]];
                
                NSMutableArray* drawingToolsStates = [defaults objectForKey:@"drawingToolsStates"];
                NSMutableArray* drawingToolsSelectedExtendedIndexes = [defaults objectForKey:@"drawingToolsSelectedExtendedIndexes"];
                NSMutableArray* drawingToolsExtendedStates = [defaults objectForKey:@"drawingToolsExtendedStates"];
                DrawingTool* dt = nil;
                DrawingToolExtended* dte = nil;
                NSNumber* dtStateNumber = nil;
                NSNumber* dteStateNumber = nil;
                BOOL foundSelectedTool = NO;
                
                for (NSUInteger i = 0;i < drawingTools.count;i++)
                {
                    dt = [drawingTools objectAtIndex:i];
                    
                    dtStateNumber = [drawingToolsStates objectAtIndex:i];
                    drawingToolState dtstate;
                    if (dtStateNumber != nil)
                        dtstate = [dtStateNumber unsignedIntValue];
                    else
                        dtstate = DT_STATE_UNSELECTED; // дефолтное значение
                    
                    [self changeParentColorToExtended:[dt.drawingToolsExtended objectAtIndex:[[drawingToolsSelectedExtendedIndexes objectAtIndex:i] integerValue]]];
                    
                    [dt changeStateTo:DT_STATE_APPEARS_ON_SCREEN 
                            NextState:dtstate
                               AtTime:currtime];
                    
                    for (NSUInteger j = 0;j < dt.drawingToolsExtended.count;j++)
                    {
                        dte = [dt.drawingToolsExtended objectAtIndex:j];
                        dteStateNumber = [[drawingToolsExtendedStates objectAtIndex:i] objectAtIndex:j];
                        drawingToolExtendedState dteState;
                        if (dteStateNumber != nil)
                            dteState = [dteStateNumber unsignedIntValue];
                        else
                            dteState = DRAWING_TOOL_EXTENDED_STATE_INACTIVE; // дефолтное значение
                        
                        if(dteState == DT_STATE_SELECTED)
                        {
                            foundSelectedTool = YES;
                            [delegate newDrawingToolSelected:dte];
                        }
                        
                        [dte changeStateTo:DRAWING_TOOL_EXTENDED_STATE_APPEARS_ON_SCREEN 
                                 NextState:dteState
                                    AtTime:currtime];
                        
                    }
                }
                
                if(!foundSelectedTool)
                    [delegate newDrawingToolSelected:drawingToolToExtend];
            }
            
            break;
        }
        case DRAWING_TOOL_RAINBOW:
        {
            [rainbowTool restoreState];
            [rainbowTool changeStateTo:RAINBOW_TOOL_STATE_APPEARS_ON_SCREEN AtTime:currtime];
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ WARNING!!! unexpected DrawingToolsBox activeToolType : %d", self, NSStringFromSelector(_cmd), activeToolType);
            break;
        }
    }
    
    [defaults synchronize];
}

- (void)restoreState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double currtime = CFAbsoluteTimeGetCurrent();
    
    activeToolType = [defaults integerForKey:@"activeToolType"];
    nextToolType = [defaults integerForKey:@"nextToolType"];
    
    [self restoreStateAndShowTool:activeToolType];
    [self changeStateTo:DRAWING_TOOLS_BOX_STATE_APPEARS_ON_SCREEN AtTime:currtime];
}



#pragma mark - ThreeDAnimation Delegate methods

- (void)animationEnded{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    self.position = self.animation.position;
    self.alpha = self.animation.alpha;
}

#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    [drawingTools release];
    [self.customColorButton release];
    [rainbowTool release]; rainbowTool = nil;
    
    [super dealloc];
}


@end
