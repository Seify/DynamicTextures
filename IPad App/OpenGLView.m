//
//  OpenGLView.m
//  Collections
//
//  Created by Roman Smirnov on 17.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenGLView.h"
#import <QuartzCore/QuartzCore.h>
@implementation OpenGLView

@synthesize myEAGLLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.myEAGLLayer = (CAEAGLLayer *)self.layer;
        self.layer.opaque = YES;
        
        //TODO (Optionally): configure the surface properties of the rendering surface by assigning a new dictionary of values to the drawableProperties property of the CAEAGLLayer object. EAGL allows you to specify the pixel format for the renderbuffer and whether it retains its contents after they are presented to the Core Animation. For a list of the keys you can set, see EAGLDrawable Protocol Reference.
        self.myEAGLLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                               kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                               nil];
        

    }
    return self;
}


+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
