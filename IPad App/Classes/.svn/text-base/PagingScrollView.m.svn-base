//
//  PagingScrollView.m
//  
//
//  Created by Mac on 29.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PagingScrollView.h"

@implementation PagingScrollView

@synthesize responseInsets;

// Пояснения: http://stackoverflow.com/a/3018776

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint parentLocation = //CGPointMake(point.x - self.bounds.origin.x, point.y - self.bounds.origin.y);
    [self convertPoint:point toView:self.superview];
    CGRect responseRect = self.frame;
    
    //расстояние от левого края scrollView до границы экрана
    responseInsets.left = (768-self.frame.size.width)/2; 
    //расстояние от правого края scrollView до границы экрана
    responseInsets.right = (768-self.frame.size.width)/2;
    
    responseRect.origin.x -= responseInsets.left;
    responseRect.origin.y -= responseInsets.top;
    responseRect.size.width += (responseInsets.left + responseInsets.right);
    responseRect.size.height += (responseInsets.top + responseInsets.bottom);    
    return CGRectContainsPoint(responseRect, parentLocation);
}

@end