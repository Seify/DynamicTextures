//
//  Line.m
//  KidsPaint
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Line.h"

@implementation Line

@synthesize leftX;
@synthesize rightX;
@synthesize Y;

- (id)initWithPoints:(NSInteger) leftXValue rightX:(NSInteger)rightXValue Y:(NSInteger)YValue 
{
	if(self = [super init])
	{
		self.leftX = leftXValue;
		self.rightX = rightXValue;
		self.Y = YValue;
	}
	
	return self;
}	

@end
