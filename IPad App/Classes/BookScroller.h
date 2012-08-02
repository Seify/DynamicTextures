//
//  BookScroller.h
//  
//
//  Created by Mac on 26.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "DataCache.h"
#import "BookManager.h"

@protocol BookScrollerDelegate;

@interface BookScroller : UIView 
{
    Book *bookToScroll;
    
	// Current state support
	double offset;
	
	NSTimer *timer;
	double startTime;
	double startOff;
	double startPos;
	double startSpeed;
	double runDelta;
	BOOL touchFlag;
	CGPoint startTouch;
	
	double lastPos;
	
	// Delegate
    id<BookManagerDelegate> delegate;
	
	DataCache *cache;
	
	// OpenGL ES support
    GLint backingWidth;
    GLint backingHeight;
    EAGLContext *context;
    GLuint viewRenderbuffer, viewFramebuffer;
    GLuint depthRenderbuffer;
}

@property (retain) Book *bookToScroll;
@property (assign) id <BookManagerDelegate> delegate;

- (void)draw;					// Draw the FlowCover view with current state

@end