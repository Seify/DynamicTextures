//
//  ColorPickerViewController.h
//  DynamicTextures
//
//  Created by naceka on 08.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANColorPicker.h"
//#import "OpenGLViewController.h"

@protocol ColorPickerDelegate
- (void)newColorButtonPressed:(UIButton *)sender;
@end

@interface ColorPickerViewController : UIViewController<ANColorPickerDelegate> {
	
	ANColorPicker *picker;
    UIButton *colorButton;
    id <ColorPickerDelegate> delegate;
}

@property (retain, readonly) UIButton *colorButton;
@property (assign) id <ColorPickerDelegate> delegate;
-(void) initPicker;
- (IBAction)restoreColorClicked:(id)sender;

- (void) setColorPickerDelegate: (id) ctrl;
- (void) newColorButtonPressed:(id)sender;
- (void)pickColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
