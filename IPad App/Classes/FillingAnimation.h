//
//  FillingAnimation.h
//  KidsPaint
//
//  Created by Roman Smirnov on 17.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "Animation.h"
#import "StarAnimation.h"

@interface FillingAnimation : Animation
{
    UIColor *fillingColor;
    float area;
    NSArray *stars;
    double radius;
}
@property (retain) UIColor *fillingColor;
@property (readonly) float red;
@property (readonly) float green;
@property (readonly) float blue;
//@property float alpha;
@property float area;
@property (readonly) NSArray *stars;
@property double radius;

- (void)addStarsAnimations:(double)currtime;
@end
