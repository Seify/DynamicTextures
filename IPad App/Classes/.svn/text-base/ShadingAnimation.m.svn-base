//
//  ShadingAnimation.m
//  KidsPaint
//
//  Created by Roman Smirnov on 23.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "ShadingAnimation.h"

@implementation ShadingAnimation

@synthesize unopaqueEndTime;

- (void)updatePhysicsAtTime:(double)currtime{
    
    if (self.startTime <= currtime && currtime <= self.endTime) {
        
        if (currtime >= self.unopaqueEndTime) {
            double alphatimescale = (currtime - self.unopaqueEndTime)/(self.endTime - self.unopaqueEndTime);
            double deltaAlpha = self.endAlpha - self.startAlpha;
            self.alpha = self.startAlpha + alphatimescale * deltaAlpha;
        }
    }
}
@end
