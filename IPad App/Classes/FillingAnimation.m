//
//  FillingAnimation.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 17.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "AnimationConstants.h"
#import "FillingAnimation.h"

@implementation FillingAnimation
@synthesize fillingColor;
@synthesize area;
@synthesize radius;

- (NSArray *)stars{
    if (!stars){
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i=0; i<STARS_COUNT; i++) {
            StarAnimation *star = [[StarAnimation alloc] init];
            star.state = ANIMATION_STATE_STOPPED;
            [tempArray addObject:star];
            [star release];
        }
        stars = tempArray;
        [stars retain];
    }
    return stars;
}

- (float)red{
    const float* colors = CGColorGetComponents(self.fillingColor.CGColor);
    return colors[0];
}

- (float)green{
    const float* colors = CGColorGetComponents(self.fillingColor.CGColor);
    return colors[1];
}

- (float)blue{
    const float* colors = CGColorGetComponents(self.fillingColor.CGColor);
    return colors[2];
}
//
//- (float)alpha{
//    const float* colors = CGColorGetComponents(self.fillingColor.CGColor);
//    return colors[3];
//}

- (void)addStarsAnimations:(double)currtime{
    // большая звезда
    StarAnimation *star = [self.stars objectAtIndex:0];
    star.startTime = currtime;
    star.endTime = self.startTime + STAR_BIG_DURATION;            
    star.opaqueEndTime = star.startTime + STAR_BIG_OPAQUE_DURATION;
    star.startPosition = CGRectMake(self.position.origin.x, 
                                    self.position.origin.y, 
                                    STAR_BIG_WIDTH, 
                                    STAR_BIG_HEIGHT);
    star.position = star.startPosition;
    star.endPosition = CGRectMake(self.position.origin.x, 
                                  self.position.origin.y + STAR_BIG_DISTANCE_Y, 
                                  STAR_BIG_WIDTH, 
                                  STAR_BIG_HEIGHT);
    star.startAngle = STAR_BIG_START_ANGLE;
    star.angle = star.startAngle;
    star.endAngle = STAR_BIG_END_ANGLE * (float) random()/RAND_MAX;
    star.startAlpha = STAR_BIG_START_ALPHA;
    star.alpha = star.startAlpha;
    star.endAlpha = STAR_BIG_END_ALPHA;
    
    // малая звезда слева
    star = [self.stars objectAtIndex:1];
    star.startTime = currtime;
    star.endTime = self.startTime + STAR_SMALL_DURATION;
    star.opaqueEndTime = star.startTime + STAR_SMALL_OPAQUE_DURATION;
    star.startPosition = CGRectMake(self.position.origin.x - STAR_SMALL_OFFSET_X, 
                                    self.position.origin.y + STAR_SMALL_OFFSET_Y, 
                                    STAR_SMALL_WIDTH, 
                                    STAR_SMALL_HEIGHT);
    star.position = star.startPosition;
    star.endPosition = CGRectMake(star.startPosition.origin.x, 
                                  star.startPosition.origin.y + STAR_SMALL_DISTANCE_Y, 
                                  STAR_SMALL_WIDTH, 
                                  STAR_SMALL_HEIGHT);
    star.startAngle = STAR_SMALL_START_ANGLE;
    star.angle = star.startAngle;
    star.endAngle = STAR_SMALL_END_ANGLE * (float) random()/RAND_MAX;
    star.startAlpha = STAR_SMALL_START_ALPHA;
    star.alpha = star.startAlpha;
    star.endAlpha = STAR_SMALL_END_ALPHA;
    
    
    // малая звезда справа
    star = [self.stars objectAtIndex:2];
    star.startTime = currtime;
    star.endTime = self.startTime + STAR_SMALL_DURATION;
    star.opaqueEndTime = star.startTime + STAR_SMALL_OPAQUE_DURATION;
    star.startPosition = CGRectMake(self.position.origin.x + STAR_SMALL_OFFSET_X, 
                                    self.position.origin.y + STAR_SMALL_OFFSET_Y, 
                                    STAR_SMALL_WIDTH, 
                                    STAR_SMALL_HEIGHT);
    star.position = star.startPosition;
    star.endPosition = CGRectMake(star.startPosition.origin.x, 
                                  star.startPosition.origin.y + STAR_SMALL_DISTANCE_Y, 
                                  STAR_SMALL_WIDTH, 
                                  STAR_SMALL_HEIGHT);
    star.startAngle = STAR_SMALL_START_ANGLE;
    star.angle = star.startAngle;
    star.endAngle = STAR_SMALL_END_ANGLE * (float) random()/RAND_MAX;
    star.startAlpha = STAR_SMALL_START_ALPHA;
    star.alpha = star.startAlpha;
    star.endAlpha = STAR_SMALL_END_ALPHA;

};

- (void)updatePhysicsAtTime:(double)currtime{
    [super updatePhysicsAtTime:currtime];
    for (int i=0; i<[self.stars count]; i++){
        StarAnimation *sa = [self.stars objectAtIndex:i];
        [sa updatePhysicsAtTime:currtime];
    }
}

- (void)dealloc{
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
//    for(StarAnimation *star in self.stars){
//        [star release];
//    }
    [self.stars release];
    [super dealloc];
}

@end
