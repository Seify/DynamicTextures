//
//  BrushSizeSlider.h
//  
//
//  Created by Roman Smirnov on 12.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceConstants.h"

// Слайдер с расширенной областью, в которой он реагирует на касания
// http://mpatric.blogspot.com/2009/04/more-responsive-sliders-on-iphone.html

@interface BrushSizeSlider : UISlider
{
    UIEdgeInsets responseInsets;
    sliderState state;
}

@property (nonatomic, assign) UIEdgeInsets responseInsets;
@property sliderState state;

- (void)saveState;
- (void)restoreState;

@end
