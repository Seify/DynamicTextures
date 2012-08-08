//
//  ColorShower.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 23.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ColorShower.h"

@implementation ColorShower

//@synthesize red, green, blue, alpha;


- (float) red
{
    return red;
}

- (void)setRed:(float)newred
{
    if ((red!=newred) && (newred >= 0) && (newred <= 1.0)){
        red = newred;
        [self setNeedsDisplay];
    }
    
}

- (float) green
{
    return green;
}

- (void)setGreen:(float)newgreen
{
    if ((green!=newgreen) && (newgreen >= 0) && (newgreen <= 1.0)){
        green = newgreen;
        [self setNeedsDisplay];
    }
    
}

- (float) blue
{
    return blue;
}

- (void)setBlue:(float)newblue
{
    if ((blue!=newblue) && (newblue >= 0) && (newblue <= 1.0)){
        blue = newblue;
        [self setNeedsDisplay];
    }
    
}


- (float) alpha
{
    return alpha;
}

- (void)setAlpha:(float)newalpha
{
    if ((alpha!=newalpha) && (newalpha >= 0) && (newalpha <= 1.0)){
        alpha = newalpha;
        [self setNeedsDisplay];
    }
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        red = 0.0;
        green = 0.0;
        blue = 0.0;
        alpha = 1.0;
    }
    return self;
}


- (void)setColorRed:(float)newRed Green:(float)newGreen Blue:(float)newBlue Alpha:(float)newAlpha
{
    red = newRed;
    green = newGreen;
    blue = newBlue;
    alpha = newAlpha;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

//    float red = 0.711;
//    float green = 0.066;
//    float blue = 0.066;

    
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    
   
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;

//    CGFloat locations[2] = { 0.3, 1.0 };
    CGFloat components[8] = {red, green, blue, alpha,  // Start color
        red, green, blue, 0.0 }; // End color
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
//    myGradient = CGGradientCreateWithColorComponents (myColorspace, components ,locations, num_locations);;
    
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components, NULL, num_locations);
    
    CGPoint myStartPoint, myEndPoint;
    CGFloat myStartRadius, myEndRadius;

    myStartPoint.x = self.frame.size.width/2 + 5;
    myStartPoint.y = self.frame.size.height/2 - 3;
    myEndPoint.x = self.frame.size.width/2;
    myEndPoint.y = self.frame.size.height/2;
    myStartRadius = 0;
    myEndRadius = self.frame.size.width/2;
    
//    CGContextDrawRadialGradient (ctx, myGradient, myStartPoint, myStartRadius, myEndPoint, myEndRadius, NULL);
    CGContextDrawRadialGradient (ctx, myGradient, myStartPoint, myStartRadius, myEndPoint, myEndRadius, kCGGradientDrawsBeforeStartLocation);
    

    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
    

}


@end
