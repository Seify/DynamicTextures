//
//  OpenGLView.h
//  Collections
//
//  Created by Roman Smirnov on 17.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OpenGLView : UIView
{
@private
    CAEAGLLayer *myEAGLLayer;
}
+ (Class) layerClass;

@property (retain) CAEAGLLayer *myEAGLLayer;
@end
