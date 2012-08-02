//
//  Flooder.m
//  KidsPaint
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Flooder.h"
#import "Line.h"

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CoreAnimation.h>
#import "KidsPaintAppDelegate.h"

#import "Book.h"

@implementation Flooder

@synthesize paintImage;
@synthesize backgroundImage;

@synthesize imageAreas;
@synthesize touchedAreaKey;

- (id)init
{
	self = [super init];
	allLines = [[NSMutableArray alloc] init];
	imageAreas = [[NSMutableDictionary alloc] init];
	
	return self;
}

- (void)dealloc
{
	[imageAreas release];
	[allLines release];
	[backgroundImage release];
	
	if (paintImage != nil)
	{
		[paintImage release];
	}
		
	[super dealloc];
}

-(void) prepareForPaint: (UIImage*)bgImage
{
	/*
	minX = 0;
	minY = 0;
	maxX = bgImage.size.width;
	maxY = bgImage.size.height;
	
	if (backgroundImage != nil)
	{
		[backgroundImage release];
	}
	
    backgroundImage = bgImage;
	[backgroundImage retain];
	
	UIGraphicsBeginImageContext(self.backgroundImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
		
	UIColor* clearColor = [UIColor clearColor];
	CGContextSetFillColorWithColor(ctx, clearColor.CGColor);
	CGContextFillRect (ctx, CGRectMake(0, 0, self.backgroundImage.size.width, self.backgroundImage.size.height));
	self.paintImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	*/
	
	[self loadImageAreas];
}

#pragma mark -
#pragma mark Предварительная загрузка областей раскраски

/*
NSInteger linesSort(id line1, id line2, void *context)
{
	Line* line1Obj = (Line*)line1;
	Line* line2Obj = (Line*)line2;
	
	if (line1Obj.Y < line2Obj.Y)
	{
		return NSOrderedAscending;
	}
	else if (line1Obj.Y > line2Obj.Y)
	{
		return NSOrderedDescending;
	}
	else
	{
		return NSOrderedSame;
	}
}
*/

-(void) loadImageAreas
{
	KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
	//NSString* dataFileName = [NSString stringWithFormat:@"%@.xml", app.selectedImageName];
	[self readAreasFromFile:app.selectedImageName];
	
	if ([imageAreas count] > 0)
	{
		return;
	}
	
	/*
	if ([self loadDataForImage])
	{
		NSInteger cellSize = 10; 
		
		for (NSInteger i = cellSize; i < self.backgroundImage.size.width; i+=cellSize)
		{
			for (NSInteger j = cellSize; j < self.backgroundImage.size.height; j+=cellSize)
			{
				CGPoint point = CGPointMake(i, j);
				CGFloat redValue = 0;
				CGFloat greenValue = 0;
				CGFloat blueValue = 0;
				 
				[self getPixelColorAtLocation: point redValue:&redValue greenValue:&greenValue blueValue:&blueValue];
				
				if ([self isColorEqualToSilhuetteColor: redValue green:greenValue blue:blueValue])
				{
					continue;
				}
												
				if ([self isPointInExistingArea: point])
				{
					continue;
				}
								
				clickedRedValue = redValue;
				clickedGreenValue = greenValue;
				clickedBlueValue = blueValue;
				
				NSInteger leftX = [self findLeft: point];
				NSInteger rightX = [self findRight: point];
				
				NSMutableArray *parentLines = [[NSMutableArray alloc] init];
				Line* rootLine = [[Line alloc] initWithPoints:leftX rightX:rightX Y:point.y];
				[parentLines addObject:rootLine];
				[allLines addObject:rootLine];
				[rootLine release];
				
				while ([parentLines count] > 0)
				{
					NSMutableArray *newParentLines = [[NSMutableArray alloc] init];
					
					for (int lineIndex = 0; lineIndex < [parentLines count]; lineIndex++) 
					{
						Line* curParentLine = [parentLines objectAtIndex:lineIndex];
						
						NSInteger lxLo, rxLo, lxHi, rxHi;
						
						for (NSInteger pIndex = curParentLine.leftX; pIndex <= curParentLine.rightX; pIndex++)
						{
							if (curParentLine.Y < maxY - 1 && pIndex < maxX && [self checkUnfilledPixel: &pIndex y:(curParentLine.Y + 1)])
							{
								lxLo = [self findLeft: CGPointMake(pIndex, curParentLine.Y + 1)];
								rxLo = [self findRight: CGPointMake(pIndex, curParentLine.Y + 1)];
								
								Line* l = [[Line alloc] initWithPoints:lxLo rightX:rxLo Y:curParentLine.Y + 1]; 
								[newParentLines addObject:l];
								[allLines addObject:l];
								[l release];
							}
						}
						
						for (NSInteger pIndex = curParentLine.leftX; pIndex <= curParentLine.rightX; pIndex++)
						{
							if (curParentLine.Y > minY && pIndex < maxX && [self checkUnfilledPixel: &pIndex y:(curParentLine.Y - 1)])
							{
								lxHi = [self findLeft: CGPointMake(pIndex, curParentLine.Y - 1)];
								rxHi = [self findRight: CGPointMake(pIndex, curParentLine.Y - 1)];
								Line* l = [[Line alloc] initWithPoints:lxHi rightX:rxHi Y:curParentLine.Y - 1];
								[newParentLines addObject:l];
								[allLines addObject:l];
								[l release];
							}
						}
					}
					
					[parentLines removeAllObjects];
					[parentLines addObjectsFromArray:newParentLines];
					[newParentLines release];	
				}
				
				NSMutableArray* linesArray = [NSMutableArray arrayWithArray:allLines];
				//NSMutableArray* linesArray = [allLines sortedArrayUsingFunction:linesSort context:NULL];
				
				NSString* key = [NSString stringWithFormat:@"%i", [self.imageAreas count]];
				[self.imageAreas setObject:linesArray forKey:key];
				//[linesArray release];
				
				[parentLines release];
				[allLines removeAllObjects];
			}
		}
		
		[self releaseDataForImage];
		
		[self saveAreasToFile: dataFileName];
	}
	*/ 
}

-(void) saveAreasToFile:(NSString*) fileName
{	
	NSMutableString* areasXml = [NSMutableString stringWithString:@""];
	
	areasXml = [areasXml stringByAppendingString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?><areas>"];
	
	for(NSString *aKey in imageAreas)
	{
		areasXml = [areasXml stringByAppendingFormat:@"<area id=\"%@\">", aKey];
		
		NSMutableArray* array = [imageAreas valueForKey:aKey];
		
		//NSLog([NSString stringWithFormat:@"Count: %i", [array count]]);
		
		for (int i = 0; i < [array count]; i++) 
		{
			Line* curLine = [array objectAtIndex:i];
			areasXml = [areasXml stringByAppendingFormat:@"<line leftX=\"%i\" rightX=\"%i\" Y=\"%i\" />", 
						curLine.leftX, curLine.rightX, curLine.Y];
		}			
		
		areasXml = [areasXml stringByAppendingString:@"</area>"];
	}
	
	areasXml = [areasXml stringByAppendingString:@"</areas>"];
	//NSLog(areasXml);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString *filePath = [documents stringByAppendingPathComponent:fileName];
	
	//NSLog(filePath);
	
	[areasXml writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}


-(BOOL) isPointInExistingArea: (CGPoint) point
{
	BOOL isAreaFound = NO;

	for(NSString *aKey in imageAreas){
		
		NSMutableArray* array = [imageAreas valueForKey:aKey];
		
		NSIndexSet * index = [array indexesOfObjectsPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop){
			Line* curLine = obj;
			
			if (curLine.Y == point.y && curLine.leftX <= point.x && curLine.rightX >= point.x)
			{
				*stop = YES;
				return YES;
			}
			else 
			{
				return NO;
			}
			
		}];
		
		if ([index count] !=0){
			isAreaFound = YES;
			break;
		}
	}
		
	return isAreaFound;
}

-(NSMutableArray*) getPointArea: (CGPoint) point
{
	NSMutableArray* pointAreaArray = nil;
	
	for(NSString *aKey in imageAreas){
		
		NSMutableArray* array = [imageAreas valueForKey:aKey];
		
		NSIndexSet * index = [array indexesOfObjectsPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop){
			Line* curLine = obj;
			
			if (curLine.Y == point.y && curLine.leftX <= point.x && curLine.rightX >= point.x)
			{
				*stop = YES;
				return YES;
			}
			else 
			{
				return NO;
			}
			
		}];
		
		if ([index count] !=0){
			pointAreaArray = array;
			break;
		}
	}
    	
	return pointAreaArray;
}

- (NSArray *)getAreasForPixelsBook:(Book *)book Page:(Page *)page;
{
//    NSMutableArray *retarray =[NSMutableArray arrayWithCapacity:<#(NSUInteger)#>];
    for(NSString *aKey in imageAreas){    
        NSLog(@"Flooder: area %@", aKey);
    }

    
//    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *filename = [NSString stringWithFormat:@"a%d", imageIndex];
//    NSString *filePathData = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSString *filePathData = [NSString stringWithFormat:@"%@/books/book%d/areas/%d", [[NSBundle mainBundle] resourcePath], book.number, page.number];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathData];
    
    if (!fileExists) {
    
    static unsigned char areasOfPixelsInt[560][800];
    
    for (int i=0; i<560; i++)
        for (int j=0; j<800; j++){
        
        BOOL areaFound = FALSE;    
            
        CGPoint curpoint = CGPointMake(i, j);
        
        for(NSString *aKey in imageAreas){
            
            NSMutableArray* array = [imageAreas valueForKey:aKey];
            
            NSIndexSet * index = [array indexesOfObjectsPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop){
                Line* curLine = obj;
                
                if (curLine.Y == curpoint.y && curLine.leftX <= curpoint.x && curLine.rightX >= curpoint.x)
                {
                    *stop = YES;
                    return YES;
                }
                else 
                {
                    return NO;
                }
                
            }];
            
            if ([index count] !=0){
//                pointAreaArray = array;
//                [retarray insertObject:aKey atIndex:i*(j+1)];
                
                areasOfPixelsInt[i][j] = (unsigned char)[aKey  intValue];

                if ((i%50 == 0) && (j%200 == 0)){
//                    NSLog(@"Flooder: added area %@ to point (%f, %f)", aKey, curpoint.x, curpoint.y);
                }
                areaFound = TRUE;    
                break;
            }
            
        }
            if (!areaFound)
                //[retarray insertObject:@"255" atIndex:(j*560+i)];
                areasOfPixelsInt[i][j] = 126;
    }
    

    NSData *mydata = [NSData dataWithBytes:&areasOfPixelsInt length:sizeof(areasOfPixelsInt)];
    
    NSLog(@"PaintingView: start file writing (NSData of int array)");
    [mydata writeToFile:filePathData atomically:YES];
    NSLog(@"PaintingView: done file writing (NSData of int array)");
/*    
    NSData *readeddata = [NSData dataWithContentsOfFile:filePathData];
    NSUInteger len = [readeddata length];
    
    static unsigned char readedArray[560][800];
    [readeddata getBytes:readedArray length:len];    
    
    for (int i=0; i<560; i++)
        for (int j=0; j<800; j++)
            if ((i%100 == 0)&&(j%200 == 0)) {
                NSLog(@"readeddata[%d][%d] == %d", i, j, (int)readedArray[i][j]);
            };
*/
    }
    return nil;
}        


-(NSString*) getPointAreaKey: (CGPoint) point
{
	NSString* areaKey = nil;
	
	for(NSString *aKey in imageAreas){
		
		NSMutableArray* array = [imageAreas valueForKey:aKey];
				
		NSIndexSet * index = [array indexesOfObjectsPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop){
			Line* curLine = obj;
			
			if (curLine.Y == point.y && curLine.leftX <= point.x && curLine.rightX >= point.x)
			{
				*stop = YES;
				return YES;
			}
			else 
			{
				return NO;
			}
			
		}];
		
		if ([index count] !=0){
			areaKey = aKey;
			break;
		}
	}
	
	return areaKey;
}

#pragma mark -
#pragma mark Раскраска

-(void) setFloodColor:(UIColor*)color
{
	if (floodColor != nil)
	{
		[floodColor release];
	}
	
    floodColor = color;
	[floodColor retain];
}

- (UIImage*) floodArea: (CGPoint) point
{
	NSMutableArray* linesArea = [self getPointArea: point];
	
	// TODO: подгружать данные картинки в этом случае?
	/*
	if (linesArea == nil)
	{
		point = [self findNearestNonSilhuettePoint: point];
		linesArea = [self getPointArea: point];
	}
	*/
	
	if (linesArea != nil)
	{
		//allLines = [NSMutableArray arrayWithArray:linesArea];
		[allLines addObjectsFromArray:linesArea];
		UIImage* resultImage = [self strokeAllLines];
		[allLines removeAllObjects];
		
		return resultImage;
	}
			
	return nil;
}

-(void) findTouchedAreaKey: (CGPoint) point;
{
	self.touchedAreaKey = [self getPointAreaKey: point];
}

- (UIImage*) drawConstraintedCurve: (CGPoint) startPoint endPoint:(CGPoint)endPoint
{
	CGFloat lineWidth = 32.0;
	
	NSString* startPointKey = [self getPointAreaKey: startPoint];
	NSString* endPointKey = [self getPointAreaKey: endPoint];
	
	if (startPointKey != nil && 
		endPointKey != nil &&
		[self.touchedAreaKey compare: startPointKey] == NSOrderedSame && 
		[self.touchedAreaKey compare: endPointKey] == NSOrderedSame)
	{
		//NSLog([NSString stringWithFormat:@"X1: %f, Y1: %f | X2: %f, Y2: %f", 
		//	   startPoint.x, startPoint.y, endPoint.x, endPoint.y]);
		
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
		
		UIImage* resultImage = [self makeResultImage: 0.85];
		return resultImage;
	}
	else 
	{
		return nil;	
	}
}

- (UIImage*) strokeAllLines
{
	UIGraphicsBeginImageContext(self.paintImage.size);
    [self.paintImage drawInRect:CGRectMake(0, 0, self.paintImage.size.width, self.paintImage.size.height)];
	
    //sets the style for the endpoints of lines drawn in a graphics context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
   	
	//CGContextSetStrokeColorWithColor(ctx, floodColor.CGColor);
	//CGContextSetLineCap(ctx, kCGLineCapButt); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
	CGContextSetLineWidth(ctx, 1.0);
		
	CGContextSetAllowsAntialiasing(ctx, NO); 
	CGContextSetShouldAntialias(ctx, NO); 
	CGContextSetShadowWithColor(ctx, CGSizeMake( 0.0, 0.0 ), 0, NULL); 
	
	/*
	// kCGBlendModeDarken, kCGBlendModeMultiply
	if (![floodColor isEqual:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]])
	{
		CGContextSetBlendMode(ctx, kCGBlendModeMultiply); 
	}
	*/
	
	//CGContextSetLineJoin(ctx, kCGLineJoinMiter);
		
	//NSMutableArray* pointsArray = [[NSMutableArray alloc] initWithCapacity:[allLines count]*2];
	CGPoint points[[allLines count]*2];
	
	for (int i = 0; i < [allLines count]; i++) 
	{
		Line* curLine = [allLines objectAtIndex:i];
		int index = i*2;
		
		// + 0.5f нужен, чтобы линия была нарисована точно без размытия
		points[index] = CGPointMake(curLine.leftX, curLine.Y + 0.5f);
		points[index + 1] = CGPointMake(curLine.rightX, curLine.Y + 0.5f);
	}
	
	// Сначала нужно очистить закрашиваемую область от прошлых цветов
	CGContextSetStrokeColorWithColor(ctx, [[UIColor clearColor] CGColor]);
	CGContextSetBlendMode(ctx, kCGBlendModeClear);
	CGContextStrokeLineSegments(ctx, points, [allLines count]*2);
	
	// Закрашиваем
	CGContextSetStrokeColorWithColor(ctx, floodColor.CGColor);
	CGContextSetBlendMode(ctx, kCGBlendModeNormal);
	CGContextStrokeLineSegments(ctx, points, [allLines count]*2);
		
	// рисуем поверх еще одну картинку
	/*
	CGContextSetAlpha(ctx, 0.5);
	CGContextTranslateCTM(ctx, 0, self.image.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	CGContextDrawImage(ctx, CGRectMake(0, 0, self.image.size.width, self.image.size.height), self.image.CGImage);
	//[self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
	*/

	/*
    UIImage* strokedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	// TODO: release points ?
	return strokedImage;
	*/
	
	self.paintImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	UIImage* resultImage = [self makeResultImage:0.85];
	return resultImage;
}

- (UIImage*) makeResultImage: (CGFloat) alpha
{
	UIGraphicsBeginImageContext(self.backgroundImage.size);
    [self.backgroundImage drawInRect:CGRectMake(0, 0, self.backgroundImage.size.width, self.backgroundImage.size.height)];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSetAlpha(ctx, alpha);
	CGContextTranslateCTM(ctx, 0, self.paintImage.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	CGContextDrawImage(ctx, CGRectMake(0, 0, self.paintImage.size.width, self.paintImage.size.height), self.paintImage.CGImage);
	
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return resultImage;
}

-(NSInteger) findLeft: (CGPoint) point
{
	NSInteger curX = point.x;
	
	while (curX > minX)
	{
		CGFloat redValue = 0;
		CGFloat greenValue = 0;
		CGFloat blueValue = 0;
		
		//UIColor* curColor = 
		[self getPixelColorAtLocation: CGPointMake(curX, point.y) redValue:&redValue greenValue:&greenValue blueValue:&blueValue];
		
		if ([self isColorEqualToSilhuetteColor:redValue green:greenValue blue:blueValue])
		{
			curX++;
			break;
		}
		
		curX--;
	}
	
	return curX;
}

-(NSInteger) findRight: (CGPoint) point
{
	NSInteger curX = point.x;
	
	while (curX < maxX)
	{
		CGFloat redValue = 0;
		CGFloat greenValue = 0;
		CGFloat blueValue = 0;
		
		//UIColor* curColor = 
		[self getPixelColorAtLocation: CGPointMake(curX, point.y) redValue:&redValue greenValue:&greenValue blueValue:&blueValue];
		
		if ([self isColorEqualToSilhuetteColor: redValue green:greenValue blue:blueValue])
		{
			break;
		}
		
		curX++;
	}
	
	//return --curX;
	return curX;
}

- (Boolean) checkUnfilledPixel: (NSInteger*)x y:(NSInteger) y
{
	NSInteger curX = *x;
	
	CGFloat redValue = 0;
	CGFloat greenValue = 0;
	CGFloat blueValue = 0;
	
	//UIColor* curColor = 
	[self getPixelColorAtLocation: CGPointMake(*x, y) redValue:&redValue greenValue:&greenValue blueValue:&blueValue];
	
	if ([self isColorEqualToSilhuetteColor:redValue green:greenValue blue:blueValue])
	{
		return NO;
	}
	
	Line* existingLine = nil;
		
	NSIndexSet * index = [allLines indexesOfObjectsPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop){
		Line* curLine = obj;
		
        if (curLine.Y == y && curLine.leftX <= curX && curLine.rightX >= curX)
		{
			*stop = YES;
			return YES;
		}
		else 
		{
			return NO;
		}

    }];
	
    if ([index count] !=0){
		existingLine = [[allLines objectsAtIndexes:index] objectAtIndex:0];
		*x = existingLine.rightX;
		return NO;
	}		
	
	return YES;
}

-(CGPoint)findNearestNonSilhuettePoint: (CGPoint) point
{
	NSInteger curX = point.x;
	NSInteger curY = point.y;
	
	CGFloat redValue = 0;
	CGFloat greenValue = 0;
	CGFloat blueValue = 0;
	UIColor* curColor;
	
	// Нужно найти точку на некотором удалении от границы (не вплотную)
	NSInteger i = 5;
	
	while(curX - i > minX && curX + i < maxX && curY - i > minY && curY + i < maxY)
	{
		for (NSInteger d = 0; d < 4; d++) 
		{
			CGPoint curPoint;
			
			if (d == 0)
			{
				curPoint = CGPointMake(curX, curY + i);
			}
			else if (d == 1)
			{
				curPoint = CGPointMake(curX, curY - i);
			}
			else if (d == 2)
			{
				curPoint = CGPointMake(curX - i, curY);
			}
			else if (d == 3)
			{
				curPoint = CGPointMake(curX + i, curY);
			}
			
			curColor = 
				[self getPixelColorAtLocation: curPoint redValue:&redValue greenValue:&greenValue blueValue:&blueValue];
			
			if (![self isColorEqualToSilhuetteColor: redValue green:greenValue blue:blueValue])
			{
				return curPoint;
			}
		}
		
		i+=5;
	}
	
	return CGPointMake(0, 0);
}

- (Boolean) isColorEqualToSilhuetteColor: (CGFloat) red 
								   green:(CGFloat) green 
									blue:(CGFloat) blue
{
	CGFloat bgMinRed = 0.0;
	CGFloat bgMaxRed = 0.2; //0.6;
	CGFloat bgMinGreen = 0.0;
	CGFloat bgMaxGreen = 0.2;
	CGFloat bgMinBlue = 0.0;
	CGFloat bgMaxBlue = 0.2;
	
	if (red>=bgMinRed && red<=bgMaxRed && 
		green>=bgMinGreen && green<=bgMaxGreen &&
		blue>=bgMinBlue && blue<=bgMaxBlue)
	{
		return YES;	
	}
	else 
	{
		return NO;	
	}
}

#pragma mark -
#pragma mark Внутренние данные картинки

-(Boolean) loadDataForImage
{
	CGImageRef inImage = self.backgroundImage.CGImage;
	
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	cgctx = [self createARGBBitmapContextFromImage:inImage];
	
	if (cgctx == NULL) 
	{ 
		return NO; 
		/* error */ 
	}
	
    w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}}; 
	
	// Draw the image to the bitmap context. Once we draw, the memory 
	// allocated for the context for rendering will then contain the 
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage); 
	
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	data = CGBitmapContextGetData (cgctx);
	
	return YES;
}

-(void) releaseDataForImage
{
	// When finished, release the context
	CGContextRelease(cgctx); 
	// Free image data memory for the context
	if (data) { free(data); }
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point redValue:(CGFloat*)redValue greenValue:(CGFloat*)greenValue
							blueValue:(CGFloat*)blueValue
{
	UIColor* color = nil;
		
	//offset locates the pixel in the data from x,y. 
	//4 for 4 bytes of data per pixel, w is width of one row of data.
	int offset = 4*((w*round(point.y))+round(point.x));
	int alpha =  data[offset]; 
	int red = data[offset+1]; 
	int green = data[offset+2]; 
	int blue = data[offset+3]; 
	
	*redValue = red/255.0f;
	*greenValue = green/255.0f;
	*blueValue = blue/255.0f;
	
	//NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
	color = [UIColor colorWithRed:(*redValue) green:(*greenValue) blue:(*blueValue) alpha:(alpha/255.0f)];
	
	return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
	
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL) 
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
	// per component. Regardless of what the source image format is 
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease( colorSpace );
	
	return context;
}

@end
