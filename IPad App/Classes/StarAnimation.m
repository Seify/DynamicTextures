//
//  StarAnimation.m
//  KidsPaint
//
//  Created by Roman Smirnov on 17.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "StarAnimation.h"
#import "AnimationConstants.h"

@implementation StarAnimation
@synthesize angle, startAngle, endAngle;
@synthesize opaqueEndTime;

- (void)updatePhysicsAtTime:(double)currtime{
    
//    [super updatePhysicsAtTime:currtime];
    
    if (self.startTime <= currtime && currtime < self.endTime) {
        
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

        
        double deltaAngle = self.endAngle - self.startAngle;
        self.angle = self.startAngle + timescale*deltaAngle;
        
        if (currtime >= self.opaqueEndTime) {
            double alphatimescale = (currtime - self.opaqueEndTime)/(self.endTime - self.opaqueEndTime);
            double deltaAlpha = self.endAlpha - self.startAlpha;
            self.alpha = self.startAlpha + alphatimescale * deltaAlpha;
        }
        
        
    } else if (currtime >= self.endTime){
        self.state = ANIMATION_STATE_STOPPED;
        self.position = self.endPosition;
        self.alpha = self.endAlpha;
    }
}

- (void)dealloc{
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    [super dealloc];
}

@end
