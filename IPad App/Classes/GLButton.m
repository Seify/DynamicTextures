//
//  GLButton.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 05.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "GLButton.h"

@interface GLButton()
@property (readwrite) buttonState state;
@end

@implementation GLButton

//@synthesize state;
@synthesize delegate;
@synthesize identificator;
@synthesize alpha, position;
@synthesize touchArea;
@synthesize translationX, translationY, translationZ;
@synthesize rotationX, rotationY, rotationZ;
@synthesize scaleX, scaleY, scaleZ;

@synthesize shouldDisplace;

- (void)setState:(buttonState)newstate{
    state = newstate;
//    NSLog(@"%@ : %@ new state = %d", self, NSStringFromSelector(_cmd), state);
}

- (buttonState)state{
    return state;
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
        self.state = BUTTON_STATE_UNPRESSED;
    }
    return self;
}

- (BOOL)isIntersectsWithPoint:(CGPoint)point{
    return (self.touchArea.origin.x < point.x &&
            self.touchArea.origin.x + self.touchArea.size.width > point.x &&
            self.touchArea.origin.y < point.y &&
            self.touchArea.origin.y + self.touchArea.size.height > point.y);
}

- (void)changeStateTo:(buttonState)newstate{
    
    if (self.shouldDisplace){
        if (self.state == BUTTON_STATE_UNPRESSED && newstate == BUTTON_STATE_PRESSED){
            self.position = CGRectMake(self.position.origin.x + BUTTON_PRESSED_OFFSET_X, 
                                       self.position.origin.y + BUTTON_PRESSED_OFFSET_Y, 
                                       self.position.size.width, 
                                       self.position.size.height);
        } else if (self.state == BUTTON_STATE_PRESSED && newstate == BUTTON_STATE_UNPRESSED){
            self.position = CGRectMake(self.position.origin.x - BUTTON_PRESSED_OFFSET_X, 
                                       self.position.origin.y - BUTTON_PRESSED_OFFSET_Y, 
                                       self.position.size.width, 
                                       self.position.size.height);
        }
    }
    
    self.state = newstate;
}

- (void)updatePhysicsAtTime:(double)currtime{
    [self.animation updatePhysicsAtTime:currtime];
    if (self.animation.state == ANIMATION_STATE_PLAYING){
        self.alpha = self.animation.alpha;
        self.position = self.animation.position;
    }
}

#pragma mark - Gesture handlers

- (void)touchBeganAtLocation:(CGPoint)location{
    
//    NSLog(@"%@ : %@" , self, NSStringFromSelector(_cmd));
    
    if ([self isIntersectsWithPoint:location]){
        [self changeStateTo:BUTTON_STATE_PRESSED];
    }
}

- (void)touchMovedAtLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation{
//    NSLog(@"%@ : %@" , self, NSStringFromSelector(_cmd));
    if (![self isIntersectsWithPoint:location]){
        [self changeStateTo:BUTTON_STATE_UNPRESSED];
    }
}

- (void)touchEndedAtLocation:(CGPoint)location{
//    NSLog(@"%@ : %@" , self, NSStringFromSelector(_cmd));

    if (self.state == BUTTON_STATE_PRESSED && [self isIntersectsWithPoint:location]){
        [self.delegate buttonPressed:self];
    }
    [self changeStateTo:BUTTON_STATE_UNPRESSED];
}

- (void)touchesCancelledLocation:(CGPoint)location{
//    NSLog(@"%@ : %@" , self, NSStringFromSelector(_cmd));
    [self changeStateTo:BUTTON_STATE_UNPRESSED];
}

#pragma mark - ThreeDAnimation Delegate methods

- (void)animationEnded{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
//    self.position = self.animation.position;
    self.alpha = self.animation.alpha;
}

- (void)dealloc{
    if (animation) [animation release];
    [super dealloc];
}
@end