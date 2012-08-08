    //
//  SilhuetteView.m
//  DynamicTextures
//
//  Created by naceka on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SilhuetteView.h"
#import "PaintingView.h"
#import "DynamicTexturesAppDelegate.h"
#import "Line.h"
#import "PaintingView.h"

@implementation SilhuetteView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		
		drawImage = [[UIImageView alloc] initWithImage:nil];
		drawImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		[self addSubview:drawImage];
		[drawImage release];
    }
    return self;
}

- (void) dealloc
{
	[drawImage removeFromSuperview];
	
	[super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    
//    NSLog(@"SilhuetteView: touchesBegan");
    
//
//	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	NSArray *s = [self.superview subviews];
	PaintingView* pv = (PaintingView*)[s objectAtIndex:1];
	
	UITouch*	touch = [[event touchesForView:self] anyObject];
	CGPoint location = [touch locationInView:self];
	CGPoint previousLocation = [touch previousLocationInView:self];

	[pv touchesBegan:location prevLoc:previousLocation];
	
	// Показываем ограниченную область
//	if (app.paintMode == paintModeMedium) 
//    if ([pv isValidIndixesOfArrayAreasX:(int)location.x Y:(int)location.y])
//    if(pv->areas[(int)location.x][(int)location.y] != UNPAINTED_AREA_NUMBER)
//    if(pv->areas[(int)location.x][(int)location.y] != BLACK_AREA_NUMBER)
//	{
//        UIGraphicsBeginImageContext(self.frame.size);
//        [drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        CGContextSetLineCap(ctx, kCGLineCapRound);
//        CGContextSetLineJoin(ctx, kCGLineJoinRound);
//        
//        CGContextSetLineWidth(ctx, 1.0);
//        
////        UIColor* silhuetteColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
////        UIColor* silhuetteColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
//        UIColor* silhuetteColor = [UIColor colorWithRed:252.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
//        
//        CGContextSetStrokeColorWithColor(ctx, silhuetteColor.CGColor);
//
//        static CGPoint points[560*800*2];
//        int pointscount = 0;
//        
//        int areaID;
//        if ([pv isValidIndixesOfArrayAreasX:(int)location.x Y:(int)location.y])
//            areaID = pv->areas[(int)location.x][(int)location.y];
//        
//        for (int i=0; i<560; i++)
//            for (int j=0; j<800; j++)
////                if ([pv isValidIndixesOfArrayAreasX:(int)location.x Y:(int)location.y])
////                    if (pv->areas[i][j] != pv->areas[(int)location.x][(int)location.y])
////                    {
////                        points[pointscount] = CGPointMake(i, j);
////                        points[pointscount + 1] = CGPointMake(i+1, j);
////                        pointscount += 2;
////                    }
//                if (pv->areas[i][j] == BLACK_AREA_NUMBER) {
//                    BOOL need2draw = NO;
//                for (int X = MAX(0, i - 2); X <= MIN(559, i + 2); X++) 
//                    for (int Y = MAX(0, j - 2); Y <= MIN(799, j + 2); Y++)
//                        if(pv->areas[X][Y] == areaID){
//                            need2draw = YES;
//                            break;
//                        }
//
//                    
//                if (need2draw)
//                {
//                    points[pointscount] = CGPointMake(i, j);
//                    points[pointscount + 1] = CGPointMake(i+1, j);
//                    pointscount += 2;
//                }
//            }
//        
////        CGContextStrokeLineSegments(ctx, points, 560*800*2);
//        CGContextStrokeLineSegments(ctx, points, pointscount);
//        
//        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
///*        
//        NSMutableArray* allLines = pv.allLines;
//		
//		UIGraphicsBeginImageContext(self.frame.size);
//		[drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//		CGContextRef ctx = UIGraphicsGetCurrentContext();
//		CGContextSetLineCap(ctx, kCGLineCapRound);
//		CGContextSetLineJoin(ctx, kCGLineJoinRound);
//		
//		CGContextSetLineWidth(ctx, 1.0);
//		
//		UIColor* silhuetteColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
//		
//		CGContextSetStrokeColorWithColor(ctx, silhuetteColor.CGColor);
//				
//		CGPoint points[[allLines count]*2];
//		
//		for (int i = 0; i < [allLines count]; i++) 
//		{
//			Line* curLine = [allLines objectAtIndex:i];
//			int index = i*2;
//			
//			// + 0.5f нужен, чтобы линия была нарисована точно без размытия
//			points[index] = CGPointMake(curLine.leftX, curLine.Y + 0.5f);
//			points[index + 1] = CGPointMake(curLine.rightX, curLine.Y + 0.5f);
//		}
//				
//		CGContextStrokeLineSegments(ctx, points, [allLines count]*2);
//							
//		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//*/ 
// 
//	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	NSArray *s = [self.superview subviews];
	PaintingView* pv = (PaintingView*)[s objectAtIndex:1];
	
	UITouch*	touch = [[event touchesForView:self] anyObject];
	CGPoint location = [touch locationInView:self];
	CGPoint previousLocation = [touch previousLocationInView:self];
	
	[pv touchesMoved:location prevLoc:previousLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	drawImage.image = nil;
	
	NSArray *s = [self.superview subviews];
	PaintingView* pv = (PaintingView*)[s objectAtIndex:1];
	[pv touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
	/*
	UIGraphicsBeginImageContext(self.paintImage.size);
	[self.paintImage drawInRect:CGRectMake(0, 0, self.paintImage.size.width, self.paintImage.size.height)];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	NSMutableArray* linesArea = [self getPointArea: endPoint];
	NSInteger rectsCount = [linesArea count];
	CGRect clipRects[rectsCount];
	
	for (int i = 0; i < [linesArea count]; i++) 
	{
		Line* curLine = [linesArea objectAtIndex:i];
		
		CGRect rect = CGRectMake(curLine.leftX, curLine.Y, curLine.rightX - curLine.leftX, 1);
		clipRects[i] = rect;
	}
	
	CGContextClipToRects (ctx, clipRects, rectsCount);
	
	CGContextSetLineCap(ctx, kCGLineCapRound);
	//CGContextSetLineCap(ctx, kCGLineCapButt);
	CGContextSetLineJoin(ctx, kCGLineJoinRound);
	
	CGContextSetLineWidth(ctx, lineWidth);
	CGContextSetStrokeColorWithColor(ctx, floodColor.CGColor);
	
	CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
	CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
	
	CGContextStrokePath(ctx);
	self.paintImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	*/ 
}

@end
