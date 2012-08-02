#import "BookScroller.h"
#import "BookManager.h"
#import <QuartzCore/QuartzCore.h>
#import "FlowCoverRecord.h"

/************************************************************************/
/*																		*/
/*	Internal Layout Constants											*/
/*																		*/
/************************************************************************/

#define IMAGELIMIT			1024 //512 //256

#define TEXTURESIZE		    1024 //512 //256		// width and height of texture; power of 2, 256 max
#define MAXTILES			48		// maximum allocated 256x256 tiles in cache
#define VISTILES			1		// # tiles left and right of center tile visible on screen

/*
 *	Parameters to tweak layout and animation behaviors
 */

#define SPREADIMAGE			0.25		// spread between images (screen measured from -1 to 1)
#define FLANKSPREAD			1.0		// flank spread out; this is how much an image moves way from center
#define FRICTION			1.0	// friction
#define MAXSPEED			0.5	// throttle speed to this value

#define DRAGSPEED           3   // как быстро перетаскиваются тайлы

/************************************************************************/
/*																		*/
/*	Model Constants														*/
/*																		*/
/************************************************************************/

const GLfloat BookScrollerGVertices[] = {
	-1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
	-1.0f,  1.0f, 0.0f,
    1.0f,  1.0f, 0.0f,
};

const GLshort BookScrollerGTextures[] = {
	0, 0,
	1, 0,
	0, 1,
	1, 1,
};

@implementation BookScroller

@synthesize bookToScroll;
@synthesize delegate;

/************************************************************************/
/*																		*/
/*	OpenGL ES Support													*/
/*																		*/
/************************************************************************/

+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

- (BOOL)createFrameBuffer
{
	// Create an abstract frame buffer
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    
	// Create a render buffer with color, attach to view and attach to frame buffer
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
#endif
        return NO;
    }
    
    return YES;
}

- (void)destroyFrameBuffer
{
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:context];
    [self destroyFrameBuffer];
    [self createFrameBuffer];
	[self draw];
}

/************************************************************************/
/*																		*/
/*	Construction/Destruction											*/
/*																		*/
/************************************************************************/

/*	internalInit
 *
 *		Handles the common initialization tasks from the initWithFrame
 *	and initWithCoder routines
 */

- (id)internalInit
{
	CAEAGLLayer *eaglLayer;
	
	eaglLayer = (CAEAGLLayer *)self.layer;
	eaglLayer.opaque = YES;
	
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	if (!context || ![EAGLContext setCurrentContext:context] || ![self createFrameBuffer]) {
		[self release];
		return nil;
	}
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	
	cache = [[DataCache alloc] initWithCapacity:MAXTILES];
	offset = 0;
    
//    UISwipeGestureRecognizer *swypeGR = [[UISwipeGestureRecognizer alloc]
//                                                initWithTarget:self action:@selector(swype:)];
//    [self addGestureRecognizer:swypeGR];
//    [swypeGR release];
    
	
	return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) {
		self = [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder 
{
    if (self = [super initWithCoder:coder]) {
		self = [self internalInit];
    }
    return self;
}

- (void)dealloc 
{
    [EAGLContext setCurrentContext:context];
    
	[self destroyFrameBuffer];
    
    if (cache != nil) {
        [cache release];
    }
    
	[EAGLContext setCurrentContext:nil];
    
    if (context != nil) {
        [context release];
        context = nil;
    }
	[super dealloc];
}

/************************************************************************/
/*																		*/
/*	Delegate Calls														*/
/*																		*/
/************************************************************************/

- (int)numTiles
{
	if (self.delegate) {
//        NSLog(@"I have delegate");
		return [delegate howManyPagesInBook:bookToScroll];
	} else {
		return 0;		// test
	}
}

- (UIImage *)tileImage:(int)image
{
	if (self.delegate) {
        Page *page = [self.delegate pageNumber:image InBook:self.bookToScroll];
		return [self.delegate imageForPage:page InBook:bookToScroll];
	} else {
		return nil;		// should never happen
	}
}

/************************************************************************/
/*																		*/
/*	Tile Management														*/
/*																		*/
/************************************************************************/

static void *GData = NULL;

- (GLuint)imageToTexture:(UIImage *)image
{
	/*
	 *	Set up off screen drawing
	 */
	
	if (GData == NULL) GData = malloc(4 * TEXTURESIZE * TEXTURESIZE);
    //	void *data = malloc(TEXTURESIZE * TEXTURESIZE * 4);
	CGColorSpaceRef cref = CGColorSpaceCreateDeviceRGB();
	CGContextRef gc = CGBitmapContextCreate(GData,
                                            TEXTURESIZE,TEXTURESIZE,
                                            8,TEXTURESIZE*4,
                                            cref,kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(cref);
	UIGraphicsPushContext(gc);
	
	/*
	 *	Set to transparent
	 */
	
    
    //    [[UIColor colorWithRed:0 green:0 blue:0.5 alpha:1.0] setFill];
	[[UIColor colorWithWhite:0 alpha:0] setFill];
    CGRect r = CGRectMake(0, 0, TEXTURESIZE, TEXTURESIZE);
	UIRectFill(r);
	
	/*
	 *	Draw the image scaled to fit in the texture.
	 */
	
	CGSize size = image.size;
	
	if (size.width > size.height) {
		size.height = IMAGELIMIT * (size.height / size.width);
		size.width = IMAGELIMIT;
	} else {
		size.width = IMAGELIMIT * (size.width / size.height);
		size.height = IMAGELIMIT;
	}
	
	r.origin.x = (IMAGELIMIT - size.width)/2;
	r.origin.y = (IMAGELIMIT - size.height)/2;
	r.size = size;
    
	[image drawInRect:r];
	
	/*
	 *	Create the texture
	 */
	
	UIGraphicsPopContext();
	CGContextRelease(gc);
	
	GLuint texture = 0;
	glGenTextures(1,&texture);
	[EAGLContext setCurrentContext:context];
	glBindTexture(GL_TEXTURE_2D,texture);
    
//    NSLog(@"bind texture %x", texture);
    
	glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,TEXTURESIZE,TEXTURESIZE,0,GL_RGBA,GL_UNSIGNED_BYTE,GData);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);

    NSLog(@"texture %x filled with image %@", texture, image);

	free(GData);
	GData = NULL;
	
	/*
	 *	Done.
	 */
	    
	return texture;
}

- (FlowCoverRecord *)getTileAtIndex:(int)index
{
	NSNumber *num = [NSNumber numberWithInt:index];
	FlowCoverRecord *fcr = [cache objectForKey:num];
    
    
	if (fcr == nil) {
		/*
		 *	Object at index doesn't exist. Create a new texture
		 */
        
        //            NSLog(@"FlowCoverView: Object at index doesn't exist. Create a new texture");
        
        GLuint texture = [self imageToTexture:[self tileImage:index]];
        fcr = [[[FlowCoverRecord alloc] initWithTexture:texture] autorelease];
        if (!fcr) {NSLog(@"BookScroller: failed to create fcr");}
        [cache setObject:fcr forKey:num];        
	}
	
    if (fcr == nil) {
        NSLog(@"BookScroller: empty texture");
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    
	return fcr;
}


/************************************************************************/
/*																		*/
/*	Drawing																*/
/*																		*/
/************************************************************************/

- (void)drawTile:(int)index atOffset:(double)off
{
    
	FlowCoverRecord *fcr = [self getTileAtIndex:index];

    double trans = off + 0.75*index;
    
	glPushMatrix();
	glBindTexture(GL_TEXTURE_2D, fcr.texture);
    
    glTranslatef(trans * 2, 0, 0);
    
    glScalef(2.4, 2.4, 1.0);
    
	glDrawArrays(GL_TRIANGLE_STRIP,0,4);
	
	// reflect
    
//	glTranslatef(0,-2,0);
//	glScalef(1,-1,1);
//	glColor4f(0.5,0.5,0.5,0.5);
//	glDrawArrays(GL_TRIANGLE_STRIP,0,4);
//	glColor4f(1,1,1,1);
    
	glPopMatrix();
    
}

- (void) perspectiveFovy: (double) fovy
                  Aspect: (double) aspect
                   Znear: (double) zNear
                    Zfar:(double) zFar
{
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
    
    double xmin, xmax, ymin, ymax;
    
    ymax = zNear * tan(fovy * M_PI / 360.0);
    ymin = -ymax;
    xmin = ymin * aspect;
    xmax = ymax * aspect;
    
    
    glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar);
    
    
    
	glMatrixMode(GL_MODELVIEW);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);	
    
	glDepthMask(GL_TRUE);
}

- (void)draw
{
	/*
	 *	Get the current aspect ratio and initialize the viewport
	 */
	   
	double aspect = ((double)backingWidth)/backingHeight;
	
	glViewport(0,0,backingWidth,backingHeight);
	glDisable(GL_DEPTH_TEST);				// using painters algorithm
	
	glClearColor(0,0,0,0);
    
	glVertexPointer(3,GL_FLOAT,0,BookScrollerGVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_SHORT, 0, BookScrollerGTextures);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glEnable(GL_TEXTURE_2D);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
	/*
	 *	Setup for clear
	 */
	
	[EAGLContext setCurrentContext:context];
	
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glClear(GL_COLOR_BUFFER_BIT);
	
	/*
	 *	Set up the basic coordinate system
	 */
    
    /*	
     glMatrixMode(GL_PROJECTION);
     glLoadIdentity();
     glScalef(1,aspect,1);
     */
    //    [self perspectiveFovy:40.0 Aspect:aspect Znear:0.1 Zfar:10.0];
    [self perspectiveFovy:100.0 Aspect:aspect Znear:0.1 Zfar:10.0];
    
    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
    glTranslatef(0.0, 0.0, -2.0);
	
	/*
	 *	Change from Alesandro Tagliati <alessandro.tagliati@gmail.com>:
	 *	We don't need to draw all the tiles, just the visible ones. We guess
	 *	there are 6 tiles visible; that can be adjusted by altering the 
	 *	constant
	 */
	
	int i, len = [self numTiles];
        
//	int mid = (int)floor(offset + 0.5);
//	int iStartPos = mid - VISTILES;
//	if (iStartPos<0) {
//		iStartPos=0;
//	}
//	for (i = iStartPos; i < mid; ++i) {
//		[self drawTile:i atOffset:i-offset];
//	}
//	
//	int iEndPos=mid + VISTILES;
//	if (iEndPos >= len) {
//		iEndPos = len-1;
//	}
//	for (i = iEndPos; i >= mid; --i) {
//		[self drawTile:i atOffset:i-offset];
//	}

    //рисуем только видимые тайлы
    for (i=len-1; i>=0; i--) {
        if (i <= offset * 4/7 + 2)
            if (i >= offset * 4/7 - 2) 
                [self drawTile:i atOffset: i-offset];
    }
        
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

/************************************************************************/
/*																		*/
/*	Animation															*/
/*																		*/
/************************************************************************/

- (void)updateAnimationAtTime:(double)elapsed
{
//	int max = [self numTiles] - 1;
    int max = ([self numTiles] - 1) * 1.75;
    
	if (elapsed > runDelta) elapsed = runDelta;
//	double delta = fabs(startSpeed) * elapsed - FRICTION * elapsed * elapsed / 2;
	double delta = fabs(startSpeed) * elapsed - FRICTION * elapsed * elapsed / 2;
    
//    delta *= 1.75; //test
    
	if (startSpeed < 0) delta = -delta;
	offset = startOff + delta;
	
	if (offset > max) offset = max;
	if (offset < 0) offset = 0;
	
	[self draw];
}

- (void)endAnimation
{
	if (timer) {
//		int max = [self numTiles] - 1;
        int max = ([self numTiles] - 1) * 1.75;
        
		offset = floor(offset + 0.5);
		if (offset > max) offset = max;
		if (offset < 0) offset = 0;
		[self draw];
		
		[timer invalidate];
		timer = nil;
	}
}

- (void)driveAnimation
{
	double elapsed = CACurrentMediaTime() - startTime;
	if (elapsed >= runDelta) {
		[self endAnimation];
	} else {
		[self updateAnimationAtTime:elapsed];
	}
}

- (void)startAnimation:(double)speed
{
	if (timer) [self endAnimation];
	
	/*
	 *	Adjust speed to make this land on an even location
	 */
	
	//NSLog(@"speed: %lf",speed);
	double delta = speed * speed / (FRICTION * 2);
    
//    delta *= 1.75;//test
    
	if (speed < 0) delta = -delta;
	double nearest = startOff + delta;
	nearest = floor(nearest + 0.5);
    
//    nearest *= 1.75;//test
    
	startSpeed = sqrt(fabs(nearest - startOff) * FRICTION * 2);
	if (nearest < startOff) startSpeed = -startSpeed;
	
	runDelta = fabs(startSpeed / FRICTION);
	startTime = CACurrentMediaTime();
	
	//NSLog(@"startSpeed: %lf",startSpeed);
	//NSLog(@"runDelta: %lf",runDelta);
	timer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                             target:self
                                           selector:@selector(driveAnimation)
                                           userInfo:nil
                                            repeats:YES];
}


/************************************************************************/
/*																		*/
/*	Touch																*/
/*																		*/
/************************************************************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect r = self.bounds;
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
//	startPos = (where.x / r.size.width) * 10 - 5;
    startPos = (where.x / r.size.width) * DRAGSPEED;

//	startOff = offset;
	startOff = offset;
	
	touchFlag = YES;
	startTouch = where;
	
	startTime = CACurrentMediaTime();
	lastPos = startPos;
	
	[self endAnimation];
    [self draw];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect r = self.bounds;
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
//	double pos = (where.x / r.size.width) * 10 - 5;
	double pos = (where.x / r.size.width) * DRAGSPEED;
	
//	if (touchFlag == YES) {
//		// Touched location; only accept on touching inner 256x256 area
//		r.origin.x += (r.size.width - IMAGELIMIT)/2;
//		r.origin.y += (r.size.height - IMAGELIMIT)/2;
//		r.size.width = IMAGELIMIT;
//		r.size.height = IMAGELIMIT;
//		
//		if (CGRectContainsPoint(r, where)) {
//			[self touchAtIndex:(int)floor(offset + 0.01)];	// make sure .99 is 1
//		}
//	} else {
    
		// Start animation to nearest
		startOff += (startPos - pos);
        offset = startOff;
      
		double time = CACurrentMediaTime();
//		double speed = (lastPos - pos)/(time - startTime);
        double speed = (lastPos - pos)/(time - startTime);
		if (speed > MAXSPEED) speed = MAXSPEED;
		if (speed < -MAXSPEED) speed = -MAXSPEED;
		
//		[self startAnimation:speed];
//	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect r = self.bounds;
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
//	double pos = (where.x / r.size.width) * 10 - 5;
	double pos = (where.x / r.size.width) * DRAGSPEED;
    
//	if (touchFlag) {
//		// determine if the user is dragging or not
//		int dx = fabs(where.x - startTouch.x);
//		int dy = fabs(where.y - startTouch.y);
//		if ((dx < 3) && (dy < 3)) return;
//		touchFlag = NO;
//	}
	
//	int max = [self numTiles]-1;
    int max = ([self numTiles] - 1) * 1.75;
	
	offset = startOff + (startPos - pos);
	if (offset > max) offset = max;
	if (offset < 0) offset = 0;
	[self draw];
	
	double time = CACurrentMediaTime();
	if (time - startTime > 0.2) {
		startTime = time;
		lastPos = pos;
	}
}

//- (IBAction) swype:(UIGestureRecognizer *)sender
//{
//    NSLog(@"swype gesture happened");
//}

@end
