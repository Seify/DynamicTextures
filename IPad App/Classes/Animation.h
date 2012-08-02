//
//  Animation.h
//  KidsPaint
//
//  Created by Roman Smirnov on 13.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationConstants.h"


@interface Animation : NSObject
{
    double startTime;
    double endTime;
    
    CGRect startPosition;
    CGRect position;
    CGRect endPosition;
    
    double alpha;
    double startAlpha;
    double endAlpha;
    
//    UIColor *startColor;
//    UIColor *color;
//    UIColor *endColor;
    
    int state;
}

@property double startTime;
@property double endTime;

@property CGRect startPosition;
@property CGRect position;
@property CGRect endPosition;

@property double alpha;
@property double startAlpha;
@property double endAlpha;

//@property (retain) UIColor *startColor;
//@property (retain) UIColor *color;
//@property (retain) UIColor *endColor;

@property int state;

- (void)updatePhysicsAtTime:(double)currtime;

@end
