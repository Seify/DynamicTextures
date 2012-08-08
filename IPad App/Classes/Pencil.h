//
//  Pencil.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Pencil : UIButton
{
@private
    float red;
    float green;
    float blue;
    float alpha;
    
    float reflex_red;
    float reflex_green;
    float reflex_blue;
    float reflex_alpha;
    
    BOOL isSelected;
}
@property float red;
@property float green;
@property float blue;
@property float alpha;
@property float reflex_red;
@property float reflex_green;
@property float reflex_blue;
@property float reflex_alpha;
@property BOOL isSelected;
- (void) setColorRed:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha;
- (void) setReflexColorRed:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha;

@end
