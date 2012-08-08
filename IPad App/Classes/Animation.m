//
//  Animation.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 13.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "Animation.h"
#import "FillingAnimation.h"

@implementation Animation

@synthesize startTime, endTime;
@synthesize startPosition, position, endPosition;
//@synthesize startColor, color, endColor;
@synthesize alpha, startAlpha, endAlpha;
@synthesize state;

- (void)updatePhysicsAtTime:(double)currtime{
    if (self.startTime <= currtime && currtime <= self.endTime) {
        
        self.state = ANIMATION_STATE_PLAYING;
        
        double timescale = (currtime - self.startTime)/(self.endTime - self.startTime);
        
        double deltaX = self.endPosition.origin.x - self.startPosition.origin.x;
        double deltaY = self.endPosition.origin.y - self.startPosition.origin.y;
        double deltaWidth = self.endPosition.size.width - self.startPosition.size.width;
        double deltaHeight = self.endPosition.size.height - self.startPosition.size.height;
        self.position = CGRectMake(
            self.startPosition.origin.x + timescale * deltaX,
            self.startPosition.origin.y + timescale * deltaY,
            self.startPosition.size.width + timescale * deltaWidth,
            self.startPosition.size.height + timescale * deltaHeight);
        
        self.alpha = self.startAlpha + timescale * (self.endAlpha - self.startAlpha);
        
    } else {
        self.state = ANIMATION_STATE_STOPPED;
        self.position = self.endPosition;
        self.alpha = self.endAlpha;
//        NSLog(@"%@ : %@ originX = %f", self, NSStringFromSelector(_cmd), self.position.origin.x);
    }
}

@end
