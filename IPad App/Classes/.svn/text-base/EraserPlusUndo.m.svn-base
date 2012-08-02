//
//  Eraser.m
//  KidsPaint
//
//  Created by Roman Smirnov on 11.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "EraserPlusUndo.h"

@interface EraserPlusUndo()
@property (readwrite) eraserPlusUndoState state;
@property (readwrite) eraserPlusUndoState nextState;
@property (readwrite) eraserPlusUndoState prevState;
@end

@implementation EraserPlusUndo

@synthesize delegate;
@synthesize alpha, position;
@synthesize translationX, translationY, translationZ;
@synthesize rotationX, rotationY, rotationZ;
@synthesize scaleX, scaleY, scaleZ;

- (void)setState:(eraserPlusUndoState)newstate{
    switch (newstate) {
        case ERASER_STATE_OUT_OF_SCREEN:
        case ERASER_STATE_APPEARS_ON_SCREEN:
        case ERASER_STATE_SELECTED:
        case ERASER_STATE_UNSELECTED:
        case ERASER_STATE_DISAPPERS_FROM_SCREEN:
        case UNDO_STATE_OUT_OF_SCREEN:
        case UNDO_STATE_APPEARS_ON_SCREEN:
        case UNDO_STATE_SELECTED:
        case UNDO_STATE_UNSELECTED:
        case UNDO_STATE_DISSAPPEARS_FROM_SCREEN:
        {
            //Good state, do nothing
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected eraserPlusUndo new state: %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
    state = newstate;
    //    NSLog(@"%@ : %@ new state = %d", self, NSStringFromSelector(_cmd), state);
}

- (eraserPlusUndoState)state{
    return state;
}

- (void)setNextState:(eraserPlusUndoState)newstate{
    nextState = newstate;
    
    switch (newstate) {
        case ERASER_STATE_OUT_OF_SCREEN:
        case ERASER_STATE_APPEARS_ON_SCREEN:
        case ERASER_STATE_SELECTED:
        case ERASER_STATE_UNSELECTED:
        case ERASER_STATE_DISAPPERS_FROM_SCREEN:
        case UNDO_STATE_OUT_OF_SCREEN:
        case UNDO_STATE_APPEARS_ON_SCREEN:
        case UNDO_STATE_SELECTED:
        case UNDO_STATE_UNSELECTED:
        case UNDO_STATE_DISSAPPEARS_FROM_SCREEN:
        {
            //Good state, do nothing
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected eraserPlusUndo new state: %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
    
    //    NSLog(@"%@ : %@ new nextState = %d", self, NSStringFromSelector(_cmd), nextState);
}

- (eraserPlusUndoState)nextState{
    return nextState;
}

- (void)setPrevState:(eraserPlusUndoState)newstate{
    prevState = newstate;
    
    switch (newstate) {
        case ERASER_STATE_OUT_OF_SCREEN:
        case ERASER_STATE_APPEARS_ON_SCREEN:
        case ERASER_STATE_SELECTED:
        case ERASER_STATE_UNSELECTED:
        case ERASER_STATE_DISAPPERS_FROM_SCREEN:
        case UNDO_STATE_OUT_OF_SCREEN:
        case UNDO_STATE_APPEARS_ON_SCREEN:
        case UNDO_STATE_SELECTED:
        case UNDO_STATE_UNSELECTED:
        case UNDO_STATE_DISSAPPEARS_FROM_SCREEN:
        {
            //Good state, do nothing
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected eraserPlusUndo new prev state: %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
    
    //    NSLog(@"%@ : %@ new nextState = %d", self, NSStringFromSelector(_cmd), nextState);
}

- (eraserPlusUndoState)prevState{
    return prevState;
}

- (ThreeDAnimation *)animation{
    if (!animation){
        animation = [[ThreeDAnimation alloc] init];
        animation.state = ANIMATION_STATE_STOPPED;
        animation.delegate = self;
    }
    return animation;
}

- (id)init{
    if (self = [super init]){
        self.state = ERASER_STATE_OUT_OF_SCREEN;
    }
    return self;
}

- (BOOL)isIntersectsWithPoint:(CGPoint)point{
    return (self.position.origin.x < point.x &&
            self.position.origin.x + self.position.size.width > point.x &&
            self.position.origin.y < point.y &&
            self.position.origin.y + self.position.size.height > point.y);
}

- (void) changeStateTo:(eraserPlusUndoState)newState 
             NextState:(eraserPlusUndoState)euNextState
                AtTime:(double)currtime
{
    switch (newState) {
            
        case ERASER_STATE_APPEARS_ON_SCREEN:
        {
            self.animation.startAlpha = self.alpha;
            self.animation.endAlpha = 1.0;
            self.animation.startPosition = self.position;
            
            switch (euNextState) {
                case ERASER_STATE_SELECTED:
                {
                    self.animation.endPosition = CGRectMake(ERASER_SELECTED_OFFSET_X,
                                                            ERASER_SELECTED_OFFSET_Y, 
                                                            ERASER_SELECTED_WIDTH, 
                                                            ERASER_SELECTED_HEIGHT);

                    break;
                }
                    
                case ERASER_STATE_UNSELECTED:
                {
                    self.animation.endPosition = CGRectMake(ERASER_UNSELECTED_OFFSET_X,
                                                            ERASER_UNSELECTED_OFFSET_Y, 
                                                            ERASER_UNSELECTED_WIDTH, 
                                                            ERASER_UNSELECTED_HEIGHT);
                    break;
                }
                    
                default:
                {
                    NSLog(@"%@ : %@ Warning! Unexpected Eraser next state: %d", self, NSStringFromSelector(_cmd), euNextState);
                    break;
                }
            }

            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + ERASER_UNHINDING_DURATION;
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            break;
        }   
            
        case UNDO_STATE_APPEARS_ON_SCREEN:
        {
            self.animation.startAlpha = self.alpha;
            self.animation.endAlpha = 1.0;
            self.animation.startPosition = self.position;
            self.animation.endPosition = CGRectMake(UNDO_OFFSET_X,
                                                    UNDO_OFFSET_Y, 
                                                    UNDO_WIDTH, 
                                                    UNDO_HEIGHT);
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + ERASER_UNHINDING_DURATION;
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            break;
        }  
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected eraser / undo new state : %d", self, NSStringFromSelector(_cmd), newState);
            break;
        }
    }
    
    self.prevState = self.state;
    self.state = newState;
    self.nextState = euNextState;
    
}

- (void)changeStateTo:(eraserPlusUndoState)newstate AtTime:(double)currtime{

    switch (newstate) {

            
        case ERASER_STATE_DISAPPERS_FROM_SCREEN:{
            
            self.animation.startAlpha = self.alpha;
            self.animation.endAlpha = 1.0;
            self.animation.startPosition = self.position;
            self.animation.endPosition = CGRectMake(ERASER_UNSELECTED_OFFSET_X - DRAWING_TOOLS_BOX_WIDTH,
                                                    ERASER_UNSELECTED_OFFSET_Y, 
                                                    ERASER_UNSELECTED_WIDTH, 
                                                    ERASER_UNSELECTED_HEIGHT);
            self.animation.startTime = currtime;
            self.animation.endTime = self.animation.startTime + ERASER_HINDING_DURATION;
            self.animation.state = ANIMATION_STATE_PLAYING;
            
            break;
        }

        case ERASER_STATE_SELECTED:{
            self.position = CGRectMake(ERASER_SELECTED_OFFSET_X,
                                       ERASER_SELECTED_OFFSET_Y,
                                       ERASER_SELECTED_WIDTH,
                                       ERASER_SELECTED_HEIGHT);

            
            break;
        }
            
        case ERASER_STATE_UNSELECTED:{
            self.position = CGRectMake(ERASER_UNSELECTED_OFFSET_X,
                                       ERASER_UNSELECTED_OFFSET_Y,
                                       ERASER_UNSELECTED_WIDTH,
                                       ERASER_UNSELECTED_HEIGHT);

            break;
        }
            
        case UNDO_STATE_OUT_OF_SCREEN:
        case UNDO_STATE_DISSAPPEARS_FROM_SCREEN:
        {
            //do nothing
            break;
        }

        case UNDO_STATE_SELECTED:
        case UNDO_STATE_UNSELECTED:
        {
            self.position = CGRectMake(UNDO_OFFSET_X,
                                       UNDO_OFFSET_Y,
                                       UNDO_WIDTH,
                                       UNDO_HEIGHT);

            break;
        }
            
        default: {
            NSLog(@"%@ : %@ Warning! Unexpected eraser's new state: %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }

    
    if (self.state == ERASER_STATE_UNSELECTED && newstate == ERASER_STATE_SELECTED){
        self.position = CGRectMake(self.position.origin.x, 
                                   self.position.origin.y, 
                                   ERASER_SELECTED_WIDTH, 
                                   ERASER_SELECTED_WIDTH);
    }
    else if (self.state == ERASER_STATE_SELECTED && newstate == ERASER_STATE_UNSELECTED){
        self.position = CGRectMake(self.position.origin.x, 
                                   self.position.origin.y, 
                                   ERASER_UNSELECTED_WIDTH, 
                                   ERASER_UNSELECTED_HEIGHT);
        [self.delegate eraserUnselected];

    }
    
    self.prevState = self.state;
    self.state = newstate;
}

- (void)updatePhysicsAtTime:(double)currtime{
    [self.animation updatePhysicsAtTime:currtime];
    if (self.animation.state == ANIMATION_STATE_PLAYING){
        self.alpha = self.animation.alpha;
        self.position = self.animation.position;
    }
    
    switch (self.state) {
        case ERASER_STATE_APPEARS_ON_SCREEN:
        case UNDO_STATE_APPEARS_ON_SCREEN:
        {
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = self.nextState;
            }
            break;
        }
            
        case ERASER_STATE_DISAPPERS_FROM_SCREEN:{
            if (self.animation.state == ANIMATION_STATE_STOPPED){
                self.state = ERASER_STATE_OUT_OF_SCREEN;
            }
            break;
        }
          
        case ERASER_STATE_OUT_OF_SCREEN:
        case ERASER_STATE_UNSELECTED:
        case ERASER_STATE_SELECTED:{
            //do nothing
            break;
        }
            
        case UNDO_STATE_OUT_OF_SCREEN:
        case UNDO_STATE_SELECTED:
        case UNDO_STATE_UNSELECTED:
        case UNDO_STATE_DISSAPPEARS_FROM_SCREEN:
        {
            //do nothing
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected eraser state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

#pragma mark - Gesture handlers

- (void)touchBeganAtLocation:(CGPoint)location{
    
    //    NSLog(@"%@ : %@" , self, NSStringFromSelector(_cmd));
    
    if ([self isIntersectsWithPoint:location]){
        
        switch (self.state) {
            case ERASER_STATE_UNSELECTED:
            {
                [self changeStateTo:ERASER_STATE_SELECTED AtTime:CFAbsoluteTimeGetCurrent()];
                [self.delegate eraserSelected];
                
                break;
            }
                
            case ERASER_STATE_SELECTED:
            {
                [self changeStateTo:ERASER_STATE_UNSELECTED AtTime:CFAbsoluteTimeGetCurrent()];            
                [self.delegate eraserUnselected];
                
                break;
            }
                
            case UNDO_STATE_SELECTED:
            {
                [self changeStateTo:UNDO_STATE_UNSELECTED AtTime:CFAbsoluteTimeGetCurrent()];            
//                [self.delegate undoButtonPressed];  
                
                isUndoPressed = YES;
                self.position = CGRectMake(UNDO_OFFSET_X + BUTTON_PRESSED_OFFSET_X, 
                                           UNDO_OFFSET_Y + BUTTON_PRESSED_OFFSET_Y, 
                                           UNDO_WIDTH, 
                                           UNDO_HEIGHT);
                
                break;
            }
                
            case UNDO_STATE_UNSELECTED:
            {
                [self changeStateTo:UNDO_STATE_SELECTED AtTime:CFAbsoluteTimeGetCurrent()];            
                
                isUndoPressed = YES;
                self.position = CGRectMake(UNDO_OFFSET_X + BUTTON_PRESSED_OFFSET_X, 
                                           UNDO_OFFSET_Y + BUTTON_PRESSED_OFFSET_Y, 
                                           UNDO_WIDTH, 
                                           UNDO_HEIGHT);

                
                break;
            }
                
            default:
            {
                NSLog(@"%@ : %@ Warning! Unexpected eraser / undo state: %d", self, NSStringFromSelector(_cmd), self.state);
                break;
            }
        }
        
    }
}

- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation{
    //    NSLog(@"%@ : %@" , self, NSStringFromSelector(_cmd));
    if (![self isIntersectsWithPoint:location]){
        switch (self.state) {
            case UNDO_STATE_SELECTED:
            case UNDO_STATE_UNSELECTED:
            {
                isUndoPressed = NO;
                self.position = CGRectMake(UNDO_OFFSET_X, 
                                           UNDO_OFFSET_Y, 
                                           UNDO_WIDTH, 
                                           UNDO_HEIGHT);
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)touchEndedAtLocation:(CGPoint)location{
    //    NSLog(@"%@ : %@" , self, NSStringFromSelector(_cmd));    
    switch (self.state) {
        case UNDO_STATE_SELECTED:
        case UNDO_STATE_UNSELECTED:
        {
            isUndoPressed = NO;
            self.position = CGRectMake(UNDO_OFFSET_X, 
                                       UNDO_OFFSET_Y, 
                                       UNDO_WIDTH, 
                                       UNDO_HEIGHT);
            
            if ([self isIntersectsWithPoint:location]){
                [self.delegate undoButtonPressed]; 
            }

            break;
        }
            
        default:
            break;
    }
}

- (void)touchesCancelledLocation:(CGPoint)location{
    //    NSLog(@"%@ : %@" , self, NSStringFromSelector(_cmd));
}

#pragma mark - Switching between Eraser and Undo

- (BOOL)areYouEraserNow
{
    switch (self.state)
    {
        case ERASER_STATE_OUT_OF_SCREEN:
        case ERASER_STATE_APPEARS_ON_SCREEN:
        case ERASER_STATE_SELECTED:
        case ERASER_STATE_UNSELECTED:
        case ERASER_STATE_DISAPPERS_FROM_SCREEN:
        {
            return YES;
            break;
        }
         
        case UNDO_STATE_OUT_OF_SCREEN:          
        case UNDO_STATE_APPEARS_ON_SCREEN:
        case UNDO_STATE_SELECTED:
        case UNDO_STATE_UNSELECTED:
        case UNDO_STATE_DISSAPPEARS_FROM_SCREEN:
        {
            return NO;
            break;
        }
        
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected eraser / undo state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
    
    return NO;
}

- (void)switchToEraser
{
    double currtime = CFAbsoluteTimeGetCurrent();
    
    switch (self.state) {
            
        case UNDO_STATE_SELECTED:
        {
            [self changeStateTo:ERASER_STATE_SELECTED AtTime:currtime];

            break;
        }        
            
        case UNDO_STATE_UNSELECTED:
        {
            [self changeStateTo:ERASER_STATE_UNSELECTED AtTime:currtime];
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected eraser / undo state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

- (void)switchToUndo
{
    double currtime = CFAbsoluteTimeGetCurrent();
    
    switch (self.state) {
            
        case ERASER_STATE_SELECTED:
        {
            [self changeStateTo:UNDO_STATE_SELECTED AtTime:currtime];
            break;
        }        
        
        case ERASER_STATE_UNSELECTED:
        {
            [self changeStateTo:UNDO_STATE_UNSELECTED AtTime:currtime];
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected eraser / undo state: %d", self, NSStringFromSelector(_cmd) ,self.state);
            break;
        }
    }
}

- (void)unselectSelf
{
    double currtime = CFAbsoluteTimeGetCurrent();
    
    switch (self.state) {
        case ERASER_STATE_SELECTED:
        {
            [self changeStateTo:ERASER_STATE_UNSELECTED AtTime:currtime];
            break;
        }
            
        case UNDO_STATE_SELECTED:
        {
            [self changeStateTo:UNDO_STATE_UNSELECTED AtTime:currtime];            
            break;
        }
            
        default:
        {
            //do nothing
            break;
        }
    }

}

#pragma Save & Restore state

- (void)saveState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *eustate = [NSNumber numberWithInt:self.state];
    [defaults setObject:eustate forKey:@"lastEraserPlusUndoState"];
    [defaults synchronize];
}

- (void)appearsOnScreenWithRestoredState
{
    double currtime = CFAbsoluteTimeGetCurrent();
    
    eraserPlusUndoState euNewState;
    eraserPlusUndoState euNextState;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *eraserPlusUndoStateNumber = [defaults objectForKey:@"lastEraserPlusUndoState"];
    
    if (eraserPlusUndoStateNumber)
    {
        euNextState = [eraserPlusUndoStateNumber intValue];
        
        switch (euNextState) {
            case ERASER_STATE_SELECTED:
            {
                euNewState = ERASER_STATE_APPEARS_ON_SCREEN;
                self.position = CGRectMake(-ERASER_SELECTED_WIDTH,
                                           ERASER_SELECTED_OFFSET_Y,
                                           ERASER_SELECTED_WIDTH,
                                           ERASER_SELECTED_HEIGHT);
                break;
            }
                
                
            case ERASER_STATE_UNSELECTED:
            {
                euNewState = ERASER_STATE_APPEARS_ON_SCREEN;
                self.position = CGRectMake(-ERASER_UNSELECTED_WIDTH,
                                           ERASER_UNSELECTED_OFFSET_Y,
                                           ERASER_UNSELECTED_WIDTH,
                                           ERASER_UNSELECTED_HEIGHT);
                break;
            }
                
            case UNDO_STATE_SELECTED:
            case UNDO_STATE_UNSELECTED:
            {
                euNewState = UNDO_STATE_APPEARS_ON_SCREEN;
                self.position = CGRectMake(-UNDO_WIDTH,
                                           UNDO_OFFSET_Y,
                                           UNDO_WIDTH,
                                           UNDO_HEIGHT);
                break;
            }
                
            default:
            {
                NSLog(@"%@ : %@ Warning! Unexpected eraser / undo next state : %d", self, NSStringFromSelector(_cmd), euNextState);
                break;
            }
        }
    }
    else 
    {
        // default values
        euNewState = UNDO_STATE_APPEARS_ON_SCREEN;
        euNextState = UNDO_STATE_UNSELECTED;
    }
    
    [self changeStateTo:euNewState 
              NextState:euNextState
                 AtTime:currtime];
    
}

//- (void)restoreState
//{
//    double currtime = CFAbsoluteTimeGetCurrent();
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSNumber *eraserPlusUndoStateNumber = [defaults objectForKey:@"lastEraserPlusUndoState"];
//    if (eraserPlusUndoStateNumber)
//    {
//        eraserPlusUndoState newstate = [eraserPlusUndoStateNumber intValue];
//        [self changeStateTo:newstate AtTime:currtime];
//    }
//    else 
//    {
//        [self changeStateTo:ERASER_STATE_UNSELECTED AtTime:currtime];
//    }
//}

#pragma mark - ThreeDAnimation Delegate methods

- (void)animationEnded{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    self.position = self.animation.position;
    self.alpha = self.animation.alpha;
}


#pragma mark - dealloc

- (void)dealloc{
    if (animation) [animation release];
    [super dealloc];
}

@end
