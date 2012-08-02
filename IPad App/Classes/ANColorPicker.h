//
//  ANColorPicker.h
//  ANColorPicker
//
//  Created by Alex Nichol on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANImageBitmapRep.h"

@protocol ANColorPickerDelegate
- (void)colorChangedWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
@end


@interface ANColorPicker : UIView {
	UIImage * wheel;
	UIImage * brightness;
	UIColor * lastColor;
	ANImageBitmapRep * wheelAdjusted;
	CGRect colorFrame;
	CGRect circleFrame;
	float brightnessPCT;
	CGPoint selectedPoint;
	id <ANColorPickerDelegate> delegate;
	BOOL drawsSquareIndicator;
	BOOL drawsBrightnessChanger;
}

@property (nonatomic, assign) id <ANColorPickerDelegate> delegate;
@property (readwrite) BOOL drawsSquareIndicator;
@property (readwrite) BOOL drawsBrightnessChanger;

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (UIColor *)color;
- (void)setBrightness:(float)_brightness;
- (float)brightness;

-(void) changeCirclePicker: (CGPoint) p;
-(void) setCirclePicker: (CGPoint) newPoint;

@end
