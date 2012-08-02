//
//  PaintImageView.m
//  KidsPaint
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintImageView.h"
#import "KidsPaintAppDelegate.h"

@implementation PaintImageView

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
	
    return self;
}

-(void) initDefaults: (UIImage*) bgimage
{
//	if (flooder == nil)
//	{
//		flooder = [[Flooder alloc] init];
//	}
	
	UIColor* color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	[self setPaintColor: color];
		
//	[flooder prepareForPaint:self.image];
}

-(void) releaseData
{
//	[flooder release];
}

-(void) setPaintColor:(UIColor*)color
{
	if (paintColor != nil)
	{
		[paintColor release];
	}
	
    paintColor = color;
	[paintColor retain];
	
//	[flooder setFloodColor:color];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
	
	UITouch *touch = [touches anyObject];
	currentPoint = [touch locationInView:self];

	if (app.paintMode == paintModeSimple)
	{
		[self fillArea];
	}
	else if (app.paintMode == paintModeMedium)
	{
		lastPoint = currentPoint;
//		[flooder findTouchedAreaKey:currentPoint];
		//lastPoint.y -= 20;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
	
	if (app.paintMode == paintModeMedium)
	{
		mouseSwiped = YES;
		
		UITouch *touch = [touches anyObject];	
		CGPoint currentPointNew = [touch locationInView:self];
		//currentPointNew.y -= 20;
		
//		UIImage* paintedImage = [flooder drawConstraintedCurve:lastPoint endPoint:currentPointNew];
//		
//		if (paintedImage != nil)
//		{
//			self.image = paintedImage;
//		}
		
		lastPoint = currentPointNew;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
	
	if (app.paintMode == paintModeMedium)
	{
		if(!mouseSwiped) {
//			UIImage* paintedImage = [flooder drawConstraintedCurve:lastPoint endPoint:lastPoint];
//			
//			if (paintedImage != nil)
//			{
//				self.image = paintedImage;
//			}
		}
	}
}

-(void) fillArea
{
//	UIImage* paintedImage = [flooder floodArea:currentPoint];
//	
//	if (paintedImage != nil)
//	{
//		self.image = paintedImage;
//	}
}

- (void)dealloc {
    [super dealloc];
}

@end
