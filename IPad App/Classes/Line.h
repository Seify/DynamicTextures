//
//  Line.h
//  KidsPaint
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Line : NSObject {
	NSInteger leftX; 
	NSInteger rightX;
	NSInteger Y;
}

@property (nonatomic) NSInteger leftX;
@property (nonatomic) NSInteger rightX;
@property (nonatomic) NSInteger Y;

- (id)initWithPoints:(NSInteger) leftX rightX:(NSInteger)rightX Y:(NSInteger)Y;

@end
