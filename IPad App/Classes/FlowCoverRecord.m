//
//  FlowCoverRecord.m
//  KidsPaint
//
//  Created by naceka on 04.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlowCoverRecord.h"


@implementation FlowCoverRecord
@synthesize texture;

- (id)initWithTexture:(GLuint)t
{
	if (nil != (self = [super init])) {
//        NSLog(@"FlowCoverRecord: object %@ init with texture %d", self, t);
		texture = t;
	}
	
	return self;
}

- (void)dealloc
{
	if (texture) {
//        NSLog(@"FlowCoverRecord: object %@ deletes texture", self);
		glDeleteTextures(1,&texture);
	}
	
	[super dealloc];
}

@end