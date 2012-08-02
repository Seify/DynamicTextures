//
//  Flooder.h
//  KidsPaint
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Flooder : NSObject {
	NSInteger minX; 
	NSInteger minY;
	NSInteger maxX; 
	NSInteger maxY;
	
	UIImage* paintImage;
	UIImage* backgroundImage;
	
	CGFloat clickedRedValue;
	CGFloat clickedGreenValue;
	CGFloat clickedBlueValue;
	
	UIColor* floodColor;
	
	NSMutableArray *allLines;
	
	unsigned char* data;
	CGContextRef cgctx;
	size_t w;
	
	NSMutableDictionary* imageAreas;
	NSString* touchedAreaKey;
}

@property (nonatomic, copy) UIImage *paintImage;
@property (nonatomic, copy) UIImage *backgroundImage;
@property (nonatomic, copy) NSString *touchedAreaKey;
@property (nonatomic, retain) NSMutableDictionary *imageAreas;

-(void) setFloodColor:(UIColor*)color;
-(void) prepareForPaint: (UIImage*)bgImage;

- (UIImage*) floodArea: (CGPoint) point;
- (UIImage*) strokeAllLines;
- (UIImage*) makeResultImage: (CGFloat) alpha;
- (UIImage*) drawConstraintedCurve: (CGPoint) startPoint endPoint:(CGPoint)endPoint;

- (UIColor*) getPixelColorAtLocation:(CGPoint)point redValue:(CGFloat*)redValue greenValue:(CGFloat*)greenValue
						   blueValue:(CGFloat*)blueValue;
/*
- (Boolean) isColorEqualToClickedPixelColor: (CGFloat) redTwo 
								   greenTwo:(CGFloat) greenTwo 
									blueTwo:(CGFloat) blueTwo;
*/ 

- (Boolean) isColorEqualToSilhuetteColor: (CGFloat) red 
								   green:(CGFloat) green 
									blue:(CGFloat) blue;

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage;
-(Boolean) loadDataForImage;
-(void) releaseDataForImage;

-(NSInteger) findLeft: (CGPoint) point;
-(NSInteger) findRight: (CGPoint) point;
- (Boolean) checkUnfilledPixel: (NSInteger*)x y:(NSInteger) y;

-(void) loadImageAreas;
-(void) saveAreasToFile:(NSString*) fileName;
//-(void) readAreasFromFile:(NSString*) fileName;

-(BOOL) isPointInExistingArea: (CGPoint) point;
-(NSMutableArray*) getPointArea: (CGPoint) point;
-(NSString*) getPointAreaKey: (CGPoint) point;
-(void) findTouchedAreaKey: (CGPoint) point;
-(CGPoint)findNearestNonSilhuettePoint: (CGPoint) point;

- (NSArray *)getAreasForPixels;

@end
