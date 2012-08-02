//
//  BrushSizeSlider.m
//  
//
//  Created by Roman Smirnov on 12.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrushSizeSlider.h"

@implementation BrushSizeSlider

@synthesize state;

#define THUMB_SIZE 75
#define EFFECTIVE_THUMB_SIZE 150

@synthesize responseInsets;

// Расширяем область, в которой слайдер реагирует на касания
// http://mpatric.blogspot.com/2009/04/more-responsive-sliders-on-iphone.html

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -150, -35);
    return CGRectContainsPoint(bounds, point);
}

- (BOOL) beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    float thumbPercent = (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);
    float thumbPos = THUMB_SIZE + (thumbPercent * (bounds.size.width - (2 * THUMB_SIZE)));
    CGPoint touchPoint = [touch locationInView:self];
    return (touchPoint.x >= (thumbPos - EFFECTIVE_THUMB_SIZE) && touchPoint.x <= (thumbPos + EFFECTIVE_THUMB_SIZE));
}

- (void)saveState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithFloat:self.value] forKey:@"lastSliderValue"];
}

- (void)restoreState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *restoredValueNumber = [defaults objectForKey:@"lastSliderValue"];
    if (restoredValueNumber){
        self.value = [restoredValueNumber floatValue];
    } else {
        self.value = DEFAULT_BRUSH_SIZE;
    }
}

@end
