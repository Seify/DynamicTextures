//
//  Pencil.m
//  KidsPaint
//
//  Created by Roman Smirnov on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Pencil.h"

@implementation Pencil

@synthesize red, green, blue, alpha;
@synthesize reflex_red, reflex_green, reflex_blue, reflex_alpha;
@synthesize isSelected;	

- (void)setColorRed:(float)newRed Green:(float)newGreen Blue:(float)newBlue Alpha:(float)newAlpha
{
    red = newRed;
    green = newGreen;
    blue = newBlue;
    alpha = newAlpha;
    [self setNeedsDisplay];
}

- (void)setReflexColorRed:(float)newRed Green:(float)newGreen Blue:(float)newBlue Alpha:(float)newAlpha
{
    reflex_red = newRed;
    reflex_green = newGreen;
    reflex_blue = newBlue;
    reflex_alpha = newAlpha;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
   
    CGFloat components[4] = {red, green, blue, alpha};  // Основной цвет карандаша

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Рисуем нераскрашенный (серый) карандаш из файла
    UIImage *graypencil; 
    if (!self.isSelected) {
        graypencil = [UIImage imageNamed:@"universal_pencil.png"];
    }
    else {
        graypencil = [UIImage imageNamed:@"universal_pencil_selected2.png"];
    } 
    if (!graypencil) NSLog(@"Pencil: Failed to load image of graypencil");
    [graypencil drawAtPoint:CGPointZero];
            
    //рисуем рефлекс
    
    int pencil_width1;
    if (!self.isSelected){pencil_width1 = 53;}
    else {pencil_width1 = 101;};
    
#define pencil_width2 5
#define pencil_width3 35
#define pencil_width4 4
    
#define pencil_height1 5  
#define pencil_height2 8
#define pencil_height3 3        
    
    CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
    CGFloat reflex_components[4] = {self.reflex_red, self.reflex_green, self.reflex_blue, self.reflex_alpha/4.0};
    CGContextSetFillColor(ctx, reflex_components);    
    CGRect reflexrect = CGRectMake(0, 27, pencil_width1-1, 3);
    CGContextFillRect(ctx, reflexrect);
    
    //рисуем clipping area для последующей заливки

    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, pencil_width1, 0);
    CGContextAddLineToPoint(ctx, pencil_width1+pencil_width2, pencil_height1);
    CGContextAddLineToPoint(ctx, pencil_width1+pencil_width2+pencil_width3, pencil_height1+pencil_height2);
    CGContextAddLineToPoint(ctx, pencil_width1+pencil_width2+pencil_width3+pencil_width4, pencil_height1+pencil_height2+pencil_height3);
    CGContextAddLineToPoint(ctx, pencil_width1+pencil_width2+pencil_width3, pencil_height1+pencil_height2+2*pencil_height3);
    CGContextAddLineToPoint(ctx, pencil_width1+pencil_width2, pencil_height1+pencil_height2+2*pencil_height3+pencil_height2);
    CGContextAddLineToPoint(ctx, pencil_width1, pencil_height1+pencil_height2+2*pencil_height3+pencil_height2+pencil_height1);
    CGContextAddLineToPoint(ctx, 0, pencil_height1+pencil_height2+2*pencil_height3+pencil_height2+pencil_height1);
    CGContextClosePath(ctx);
    CGContextClip (ctx);

    //заливаем цветом карандаша
    CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
    CGContextSetFillColor(ctx, components);    
    CGRect colorrect = CGRectMake(0, 0, graypencil.size.width, graypencil.size.height);
    CGContextFillRect(ctx, colorrect);
}


@end
