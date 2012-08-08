//
//  PaintingView.m
//  DynamicTextures
//
//  Created by naceka on 03.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintingView.h"
#import "Line.h"
#import "DynamicTexturesAppDelegate.h"
#import "Constants.h"

static void RGB2HSL(float r, float g, float b, float* outH, float* outS, float* outL);



@interface PaintingView (private)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@implementation PaintingView

@synthesize  location;
@synthesize  previousLocation;
@synthesize timer;
@synthesize allLines;
@synthesize lastClickedDate;
@synthesize delegate;

void ProviderReleaseData ( void *info, const void *data, size_t size ) {
	
	free((void*)data);
}

-(UIImage*) upsideDownImageRepresenation{
	
	int imageWidth = CGRectGetWidth([self bounds]);
	int imageHeight = CGRectGetHeight([self bounds]);
	
	//image buffer for export
	NSInteger myDataLength = imageWidth* imageHeight * 4;
	
	// allocate array and read pixels into it.
	GLubyte *tempImagebuffer = (GLubyte *) malloc(myDataLength);
    
    glReadPixels(0, 0, imageWidth, imageHeight, GL_RGBA, GL_UNSIGNED_BYTE, tempImagebuffer);
	
	// make data provider with data.		
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, tempImagebuffer, myDataLength, ProviderReleaseData);
	
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * imageWidth;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
	
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
	
	// then make the uiimage from that
	UIImage *myImage =  [UIImage imageWithCGImage:imageRef] ;
	
	CGDataProviderRelease(provider);
	CGImageRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
    
    //make sure it is in the autorelease pool
	[[myImage retain] autorelease];
	
    return myImage;
}

-(UIImage*) imageRepresentation{
	
	UIImageView* upsideDownImageView=[[UIImageView alloc] initWithImage: [self upsideDownImageRepresenation]];
    
	upsideDownImageView.transform=CGAffineTransformScale(upsideDownImageView.transform, 1, -1);
	
	UIView* container=[[UIView alloc] initWithFrame:upsideDownImageView.frame];
	[container addSubview:upsideDownImageView];
	UIImage* toReturn=nil;
    
	UIGraphicsBeginImageContext(container.frame.size);
	
	[container.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	toReturn = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[upsideDownImageView release];
	[container release];
	return toReturn;
}

-(void) mergeWithImage:(UIImage*) image{
	if(image==nil){
		return;
	}
	
	glPushMatrix();
	glColor4f(256,
			  256,
			  256,
			  1.0);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glGenTextures(1, &stampTexture);
	glBindTexture(GL_TEXTURE_2D, stampTexture);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	
	GLuint imgwidth = CGImageGetWidth(image.CGImage);
	GLuint imgheight = CGImageGetHeight(image.CGImage);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	void *imageData = malloc( imgheight * imgwidth * 4 );
	CGContextRef context2 = CGBitmapContextCreate( imageData, imgwidth, imgheight, 8, 4 * imgwidth, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
	CGContextTranslateCTM (context2, 0, imgheight);
	CGContextScaleCTM (context2, 1.0, -1.0);
	CGColorSpaceRelease( colorSpace );
	CGContextClearRect( context2, CGRectMake( 0, 0, imgwidth, imgheight ) );
	CGContextTranslateCTM( context2, 0, imgheight - imgheight );
	CGContextDrawImage( context2, CGRectMake( 0, 0, imgwidth, imgheight ), image.CGImage );
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, imgwidth, imgheight, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	
	CGContextRelease(context2);
	
	free(imageData);
	
	static const GLfloat texCoords[] = {
		0.0, 1.0,
		1.0, 1.0,
		0.0, 0.0,
		1.0, 0.0
	};
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);   
	
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	//glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    /*
     
     These array would need to be changed if the size of the paintview changes. You must make sure that all image imput is 64x64, 256x256, 512x512 or 1024x1024.  In this we are using 512, but you can use 1024 as follows:
     
     use the numbers:
     {
     0.0, height, 0.0,
     1024, height, 0.0,
     0.0, height-1024, 0.0,
     1024, height-1024, 0.0
     }
     */
    
	/*
    static const GLfloat vertices[] = {
		0.0,  480, 0.0,
		512,  480, 0.0,
		0.0, -32, 0.0,
		512, -32, 0.0
	};
	*/
	
	
	static const GLfloat vertices[] = {
		0.0,  800, 0.0,
		1024,  800, 0.0,
		0.0, 800-1024, 0.0,
		1024, 800-1024, 0.0
	};
    
	
	static const GLfloat normals[] = {
		0.0, 0.0, 512,
		0.0, 0.0, 512,
		0.0, 0.0, 512,
		0.0, 0.0, 512
	};
	
	glBindTexture(GL_TEXTURE_2D, stampTexture);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glNormalPointer(GL_FLOAT, 0, normals);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glPopMatrix();
	
	glDeleteTextures( 1, &stampTexture );
	//set back the brush
	glBindTexture(GL_TEXTURE_2D, brushTexture);
	
	glColor4f(lastSetRed,
			  lastSetGreen,
			  lastSetBlue,
			  1.0);
	
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	// Т.к. нет в initDrfaults и видимо поэтому вылетает во floodCurrentArea
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_NORMAL_ARRAY);
}

-(void) setImage:(UIImage*)newImage{
    
	[EAGLContext setCurrentContext:context];
	
	// Clear the buffer - but dont display it
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self mergeWithImage:newImage];
}

// Implement this to override the default layer class (which is [CALayer class]).
// We do this so that our view will be backed by a layer that is capable of OpenGL ES rendering.
+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
	
	return [super initWithCoder:coder];
}

-(void) initDefaults: (UIImage*) initialImage
{
	CGImageRef		brushImage;
	CGContextRef	brushContext;
	GLubyte			*brushData;
	size_t			width, height;
        
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	
	eaglLayer.opaque = NO;
	// In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
	
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	
	if (!context || ![EAGLContext setCurrentContext:context]) {
		[self release];
		return;
	}
	
	// Create a texture from an image
	// First create a UIImage object from the data in a image file, and then extract the Core Graphics image
	//brushImage = [UIImage imageNamed:@"Particle.png"].CGImage;
	brushImage = [UIImage imageNamed:@"particleWithPaperTexture1.png"].CGImage;
	
	// Get the width and height of the image
	width = CGImageGetWidth(brushImage);
	height = CGImageGetHeight(brushImage);
	
	// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
	// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
	
	// Make sure the image exists
	if(brushImage) {
		// Allocate  memory needed for the bitmap context
		brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
		// Use  the bitmatp creation function provided by the Core Graphics framework. 
		brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
		// After you create the context, you can draw the  image to the context.
		CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
		// You don't need the context at this point, so you need to release it to avoid memory leaks.
		CGContextRelease(brushContext);
		// Use OpenGL ES to generate a name for the texture.
		glGenTextures(1, &brushTexture);
		// Bind the texture name. 
		glBindTexture(GL_TEXTURE_2D, brushTexture);
		
		// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		
		//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		
		// Specify a 2D texture image, providing the a pointer to the image data in memory
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
		// Release  the image data; it's no longer needed
		free(brushData);
	}
	
	// Set the view's scale factor
	self.contentScaleFactor = 1.0;
	
	// Setup OpenGL states
	glMatrixMode(GL_PROJECTION);
	CGRect frame = self.bounds;
	CGFloat scale = self.contentScaleFactor;
	// Setup the view port in Pixels
	glOrthof(0, frame.size.width * scale, 0, frame.size.height * scale, -1, 1);
	glViewport(0, 0, frame.size.width * scale, frame.size.height * scale);
	glMatrixMode(GL_MODELVIEW);
	
	glDisable(GL_DITHER);
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glEnable(GL_BLEND);
	// Set a blending function appropriate for premultiplied alpha pixel data
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
	
//	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
//	if (app.paintMode == paintModeSimple)
//	{
//		brushSize = brushInitialSizeSimple;
//	}
//	else 
//	{
//		brushSize = brushInitialSizeMedium;
//		//glPointSize(width / kBrushScale);
//	}
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    brushSize = [defaults floatForKey:@"brushSize"];
    if (brushSize == 0) {
        brushSize = brushDefaultSize;
        [defaults setFloat:brushDefaultSize forKey:@"brushSize"];        
        [defaults synchronize];
    }
	
	glPointSize(brushSize);
	
	//glEnable(GL_POINT_SMOOTH);
	
	// Make sure to start with a cleared buffer
	needsErase = YES;
	
//	flooder = [[Flooder alloc] init];
//	[flooder prepareForPaint:initialImage];
}

// Переключение на другую картинку
-(void) changeImage: (UIImage*) initialImage
{
//    [flooder prepareForPaint:initialImage];
//    [flooder performSelectorInBackground:@selector(prepareForPaint:) withObject:initialImage];
}

// If our view is resized, we'll be asked to layout subviews.
// This is the perfect opportunity to also update the framebuffer so that it is
// the same size as our display area.
-(void)layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	
	// Clear the framebuffer the first time it is allocated
	if (needsErase) {
		[self erase];
		needsErase = NO;
	}
}

- (BOOL)createFramebuffer
{
	// Generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// For this sample, we also need a  buffer, so we'll create and attach one via another renderbuffer.
	glGenRenderbuffersOES(1, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);

//    GLuint depthStencil;
//    glGenRenderbuffersOES(1, &depthStencil);
//    glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthStencil);
//    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH24_STENCIL8_OES, backingWidth, backingHeight);
//    
//    // Create the framebuffer object.
//    GLuint framebuffer;
//    glGenFramebuffersOES(1, &framebuffer);
//    glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
////    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, color);
//    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthStencil);
//    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_STENCIL_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthStencil);
////    glBindRenderbufferOES(GL_RENDERBUFFER_OES, color);

    
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}

// Clean up any buffers we have allocated.
- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

// Releases resources when they are not longer needed.
- (void) dealloc
{
//  закомментил, т.к. удалялись текстуры контроллера FlowCoverView
//    
//    if (stampTexture)
//	{
//		glDeleteTextures(1, &stampTexture);
//		brushTexture = 0;
//	}
//    
//	if (brushTexture)
//	{
//		glDeleteTextures(1, &brushTexture);
//		brushTexture = 0;
//	}
    
	
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
	if (context != nil) 
        [context release];
	
	//[allLines release];
	
//	if (flooder != nil)
//	{
//		[flooder release];
//	}
	
	[super dealloc];
}

/*
-(void) releaseData
{
	if (brushTexture)
	{
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}
	
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];
	
	if (flooder != nil)
	{
		[flooder release];
	}
}
*/



- (BOOL) isValidIndixesOfArrayAreasX:(int)x Y:(int)y
{
    if( (x>=0) && (x<560) && (y>=0) && (y<800) ) {return YES;}
    else return NO;
}

- (void) renderLineWithDepthBufferFromPoint:(CGPoint)start toPoint:(CGPoint)end InArea:(int)areaID
{
    // буфер для хранения точек, в которых будет рисоваться текстура кисти
	static GLfloat*		vertexBuffer = NULL;
	static NSUInteger	vertexMax = 64;
	NSUInteger			vertexCount = 0,
	count,
	i;
    
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	// Convert locations from Points to Pixels
	CGFloat scale = self.contentScaleFactor;
	start.x *= scale;
	start.y *= scale;
	end.x *= scale;
	end.y *= scale;
	
	// Allocate vertex array buffer
	if(vertexBuffer == NULL)
	{
		vertexBuffer = malloc(vertexMax * 3 * sizeof(GLfloat));
	}

    
	// Add points to the buffer so there are drawing points every X pixels
	count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
     
	for(i = 0; i < count; ++i) 
	{
		if(vertexCount == vertexMax) 
		{
			vertexMax = 2 * vertexMax;
			vertexBuffer = realloc(vertexBuffer, vertexMax * 3 * sizeof(GLfloat));
		}
        
        
		CGFloat pointX = (int)(start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count));
		CGFloat pointY = (int)(backingHeight - (start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count)));
        
        if(![self isValidIndixesOfArrayAreasX:pointX Y:pointY]) {
            
//            NSLog(@"PaintingView: points out of Diapason");
//            NSLog(@"PaintingView: PointX = %d", (int)pointX);
//            NSLog(@"PaintingView: PointY = %d", (int)pointY);
            break;
        }
        
        if ([self isValidIndixesOfArrayAreasX:(int)pointX Y:(int)pointY])
            if (areas[(int)pointX][(int)pointY] == areaForCurrentDrawing )
            {
                vertexBuffer[3 * vertexCount + 0] = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
                vertexBuffer[3 * vertexCount + 1] = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
                vertexBuffer[3 * vertexCount + 2] = 1.0;
                vertexCount += 1;
            }
      
	}
    
    // используем depth buffer вместо stencil buffer, т.к. у iPhone нет stencil buffer.
    // для этого создаем массив точек clippingVertexBuffer, в него записываем все точки рисуемой зоны, 
    // устанавливаем им z = 1 и отрисовываем невидимым цветом, кисть = 1.0. 
    // Затем отрисовываем точки из vertexBuffer текстурой.
    // Т.к. включен DEPTH_TEST с функцией GL_EQUAL, отрисовываются только те точки текстуры,
    // для которых ранее были отрисованы соответствующие им точки из clippingVertexBuffer.
    // Метод отсюда:
    // http://stackoverflow.com/questions/5809585/using-the-depth-buffer-instead-of-stencil-buffer-for-clipping    
     
     glEnable(GL_DEPTH_TEST); // to enable writing to the depth buffer
     glDepthFunc(GL_ALWAYS);  // to ensure everything you draw passes
     glDepthMask(GL_TRUE);    // to allow writes to the depth buffer
     glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
     //    // so that whatever we draw isn't actually visible
     //    
     glClear(GL_DEPTH_BUFFER_BIT); // for a fresh start
     
     {
     //     here: draw geometry to clip to the inside of, e.g. at z = -2 
     static GLfloat*		clippingVertexBuffer = NULL;
     static NSUInteger	clippingVertexMax = 64;
         NSUInteger			clippingVertexCount = 0;
//     , clippingCount,
//     clippingI
        ;
     
     if(clippingVertexBuffer == NULL)
     {
     clippingVertexBuffer = malloc(clippingVertexMax * 3 * sizeof(GLfloat));
     }
     
    int Xmin = MIN(start.x, end.x);
    int Xmax = MAX(start.x, end.x);
    int Ymin = MIN(799 - start.y, 799 - end.y);
    int Ymax = MAX(799 - start.y, 799 - end.y);
         
    // заносим в clippingVertexBuffer все точки зоны, в которых рисуем.
    // Если буфер слишком мал, увеличиваем его.
     for (int i = MAX(0, Xmin - (int)brushSize); i < MIN(560, Xmax + (int)brushSize); i++)
         for (int j = MAX(0, Ymin - (int)brushSize); j < MIN(800, Ymax + (int)brushSize); j++){
             if (areas[i]  [j]   == areaForCurrentDrawing) {
                 if(clippingVertexCount == clippingVertexMax) {
                     clippingVertexMax = 2 * clippingVertexMax;
                     clippingVertexBuffer = realloc(clippingVertexBuffer, clippingVertexMax * 3 * sizeof(GLfloat));
                 }
                 clippingVertexBuffer[3 * clippingVertexCount + 0] = (GLfloat)(i+1);
                 clippingVertexBuffer[3 * clippingVertexCount + 1] = (GLfloat)(799-j);
                 clippingVertexBuffer[3 * clippingVertexCount + 2] = 1;
                 clippingVertexCount += 1;
             }
     }
         
         glPointSize(1.0);
         
     glVertexPointer(3, GL_FLOAT, 0, clippingVertexBuffer);
     glDrawArrays(GL_POINTS, 0, clippingVertexCount);
     
     
     }
     
     glDepthFunc(GL_EQUAL); // so that the z test will actually be applied
     //    glDepthFunc(GL_ALWAYS); // so that the z test will actually be applied
     glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
     // so that pixels are painted again...
     glDepthMask(GL_FALSE);  // ... but don't change the clip area
     
     //    here: draw the geometry to clip inside the old shape at a z further than -2 
   
    
	// Render the vertex array
    glPointSize(brushSize);
    
	glVertexPointer(3, GL_FLOAT, 0, vertexBuffer);
	glDrawArrays(GL_POINTS, 0, vertexCount);
    

	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];   
    
    glDisable(GL_DEPTH_TEST); // to enable writing to the depth buffer

}

-(void) floodWithDepthBufferArea:(int)areaID
{
    // буфер для хранения точек, в которых будет рисоваться текстура кисти
	static GLfloat*		vertexBuffer = NULL;
	static NSUInteger	vertexMax = 50000;
	NSUInteger			vertexCount = 0,
//	count,
	i;
    
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	// Convert locations from Points to Pixels
	
	// Allocate vertex array buffer
	if(vertexBuffer == NULL)
	{
		vertexBuffer = malloc(vertexMax * 3 * sizeof(GLfloat));
//        NSLog(@"PV: flood.. created vertexBuffer with size = %lu", vertexMax * 3 * sizeof(GLfloat));
	}
    
	for (i = 0; i < 560; i++)
        for (int j=0; j<800; j++)
        {
            if(vertexCount == vertexMax) 
            {
                vertexMax += 50000;
                vertexBuffer = realloc(vertexBuffer, vertexMax * 3 * sizeof(GLfloat));
//                NSLog(@"PV: flood.. vertexBuffer reallocated with size = %lu", vertexMax * 3 * sizeof(GLfloat));
                
            }
            if (areas[i][j] == areaID)
            {
                vertexBuffer[3 * vertexCount + 0] = i+1;
                vertexBuffer[3 * vertexCount + 1] = 799-j;
                vertexBuffer[3 * vertexCount + 2] = 1.0;
                vertexCount += 1;
            }
        
        }
    
    // используем depth buffer вместо stencil buffer, т.к. у iPhone нет stencil buffer.
    // для этого создаем массив точек clippingVertexBuffer, в него записываем все точки рисуемой зоны, 
    // устанавливаем им z = 1 и отрисовываем невидимым цветом, кисть = 1.0. 
    // Затем отрисовываем точки из vertexBuffer текстурой.
    // Т.к. включен DEPTH_TEST с функцией GL_EQUAL, отрисовываются только те точки текстуры,
    // для которых ранее были отрисованы соответствующие им точки из clippingVertexBuffer.
    // Метод отсюда:
    // http://stackoverflow.com/questions/5809585/using-the-depth-buffer-instead-of-stencil-buffer-for-clipping    
    
    glEnable(GL_DEPTH_TEST); // to enable writing to the depth buffer
    glDepthFunc(GL_ALWAYS);  // to ensure everything you draw passes
    glDepthMask(GL_TRUE);    // to allow writes to the depth buffer
    glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
    //    // so that whatever we draw isn't actually visible
    //    
    glClear(GL_DEPTH_BUFFER_BIT); // for a fresh start
    
    {
        
        glPointSize(1.0);
        
        glVertexPointer(3, GL_FLOAT, 0, vertexBuffer);
        glDrawArrays(GL_POINTS, 0, vertexCount);
        
        
    }
    
    glDepthFunc(GL_EQUAL); // so that the z test will actually be applied
    //    glDepthFunc(GL_ALWAYS); // so that the z test will actually be applied
    glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
    // so that pixels are painted again...
    glDepthMask(GL_FALSE);  // ... but don't change the clip area
    
    //    here: draw the geometry to clip inside the old shape at a z further than -2 
    
    
	// Render the vertex array
    glPointSize(brushSize);
    
	glVertexPointer(3, GL_FLOAT, 0, vertexBuffer);
	glDrawArrays(GL_POINTS, 0, vertexCount);
    
    
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];   
    
    glDisable(GL_DEPTH_TEST); // to enable writing to the depth buffer
    

}


/*
- (void) showImageToUser: (CGFloat) alpha
{
	UIGraphicsBeginImageContext(userView.image.size);
    [userView.image drawInRect:CGRectMake(0, 0, userView.image.size.width, userView.image.size.height)];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	UIImage* currentImage = [self imageRepresentation];
	
	CGContextSetAlpha(ctx, alpha);
	CGContextTranslateCTM(ctx, 0, currentImage.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	CGContextDrawImage(ctx, CGRectMake(0, 0, currentImage.size.width, currentImage.size.height), currentImage.CGImage);
	
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	if (resultImage != nil)
	{
		userView.image = resultImage;
	}
}
*/

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(CGPoint)loc prevLoc:(CGPoint)prevLoc
{
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
//	UIImage* viewImage = [self imageRepresentation];
//	[app savePreviousImage:viewImage BookNumber:self.delegate.currentBook.number PageNumber:self.delegate.currentPage.number];
		
	CGRect				bounds = [self bounds];
	firstTouch = YES;
	
	location = loc;
	location.y = bounds.size.height - location.y;
	
//	CGPoint convertedPoint = CGPointMake(location.x, backingHeight - location.y);

	
// Если 2 клика подряд с временным интервалом меньше 0.3, закрашиваем область    
//    allLines = [flooder getPointArea: convertedPoint];
/*	
	if (self.lastClickedDate == nil)
	{
		self.lastClickedDate = [NSDate date];
	}
	else 
	{
		NSDate* curDate = [NSDate date];
		NSTimeInterval ti = [curDate timeIntervalSinceDate:self.lastClickedDate];
		self.lastClickedDate = [NSDate date];
		
		if (ti < 0.3)
		{
//			[self floodCurrentArea];
            int x = loc.x;
            int y = loc.y;
            int area = areas[x][y];
            if (areas[x][y]!=255)
                [self floodCurrentAreaWithNewAlgorithm: area];
			return;
		}
	}
*/	
	if (app.paintMode == paintModeSimple)
	{
//		[self floodCurrentArea];
        int x = loc.x;
        int y = loc.y;
        if ( (loc.x > 0) && (loc.x < 559) && (loc.y > 0) && (loc.y < 799) )
            
//        NSLog(@"areas[x][y] = %d", areas[x][y]);
        
        if ((areas[x][y]!=UNPAINTED_AREA_NUMBER) 
            &&(areas[x][y]!=BLACK_AREA_NUMBER)
            )
        {
//            [self floodCurrentAreaWithNewAlgorithm:(areas[x][y])];
            [self floodWithDepthBufferArea:(areas[x][y])];
        }
//        else NSLog(@"PaintingView: clicked area UNPAINTED_AREA_NUMBER or BLACK_AREA_NUMBER");
	}
	else {
		// Convert touch point from UIView referential to OpenGL one (upside-down flip)
		if (firstTouch) {
			firstTouch = NO;
			previousLocation = prevLoc;
			previousLocation.y = bounds.size.height - previousLocation.y;
		} else {
			location = loc;
			location.y = bounds.size.height - location.y;
			previousLocation = prevLoc;
			previousLocation.y = bounds.size.height - previousLocation.y;
		}

        // Render the stroke
        //		[self renderLineFromPoint:previousLocation toPoint:location];

        
        if ( (loc.x > 0) && (loc.x < 560) && (loc.y > 0) && (loc.y < 800) )
        if ((areas[(int)loc.x][(int)loc.y]!=UNPAINTED_AREA_NUMBER) &&
            (areas[(int)loc.x][(int)loc.y]!=BLACK_AREA_NUMBER)
            ) {        
            areaForCurrentDrawing = areas[(int)loc.x][(int)loc.y];
//            [self renderLineFromPoint:previousLocation 
//                              toPoint:location 
//                               InArea:areaForCurrentDrawing];
            [self renderLineWithDepthBufferFromPoint:previousLocation 
                              toPoint:location 
                               InArea:areaForCurrentDrawing];
        }
	
		isBrushMoving = NO;
		oldBrushSize = brushSize;
		
		if (!isEraserActive)
		{
			self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.1
														  target:self selector:@selector(paintLeak:) userInfo:nil repeats: YES];
		}
	}
}

// Handles the continuation of a touch.
- (void)touchesMoved:(CGPoint)loc prevLoc:(CGPoint)prevLoc
{  
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	if (app.paintMode != paintModeSimple)
	{
		isBrushMoving = YES;
		[self setBrushSize:oldBrushSize];
		
		CGRect				bounds = [self bounds];
		//UITouch*			touch = [[event touchesForView:self] anyObject];
				
		location = loc;
		location.y = bounds.size.height - location.y;
		previousLocation = prevLoc;
		previousLocation.y = bounds.size.height - previousLocation.y;
		
		// Render the stroke
//		[self renderLineFromPoint:previousLocation toPoint:location];
        if ((loc.x > 0) && (loc.x < 559) && (loc.y > 0) && (loc.y < 799))
        if ((areas[(int)loc.x][(int)loc.y]!=UNPAINTED_AREA_NUMBER) 
            &&(areas[(int)loc.x][(int)loc.y]!=BLACK_AREA_NUMBER)
//            &&(areas[(int)loc.x][(int)loc.y] == areas[(int)prevLoc.x][(int)prevLoc.y])
            )
        {    
//            [self renderLineFromPoint:previousLocation 
//                              toPoint:location
//                               InArea:(areas[(int)loc.x][(int)loc.y])];
            [self renderLineWithDepthBufferFromPoint:previousLocation 
                              toPoint:location
                               InArea:(areas[(int)loc.x][(int)loc.y])];

        }
	}
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	if (app.paintMode != paintModeSimple)
	{
		isBrushMoving = NO;
		[self setBrushSize:oldBrushSize];
		
		if (!isEraserActive)
		{
			[self.timer invalidate];
		}
	}
		
//	UIImage* viewImage = [self imageRepresentation];
//	[app saveCurrentImage:viewImage BookNumber:self.delegate.currentBook.number PageNumber:self.delegate.currentPage.number];
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
}

// Растекание краски при удерживании кисти на бумаге
-(void) paintLeak: (NSTimer*) theTimer 
{
    
//    NSLog(@"PaintingView: paintleak");
	if (!isBrushMoving)
	{
//        NSLog(@"PaintingView: paintleak && !isBrushMoving");

		CGFloat newBrushSize = brushSize + 1;
		
		if (newBrushSize < oldBrushSize * 10)
		{
            
//            NSLog(@"PaintingView: paintleak && !isBrushMoving && (newBrushSize < oldBrushSize * 10)");
            
			[self setBrushSize:newBrushSize];
//			[self renderLineFromPoint:location toPoint:location];
            if ([self isValidIndixesOfArrayAreasX:(int)location.x Y:(int)location.y])
//                [self renderLineFromPoint:location toPoint:location InArea:areas[(int)location.x][(int)location.y] ];
                [self renderLineWithDepthBufferFromPoint:location 
                                                 toPoint:location 
                                                  InArea:areas[(int)location.x][(int)location.y] ];
		}
	}
	
	isBrushMoving = NO;
}

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    lastSetRed=red;
	lastSetBlue=blue;
	lastSetGreen=green;
    
//    NSLog(@"lastSetRed = %f", lastSetRed);
//    NSLog(@"lastSetGreen = %f", lastSetGreen);
//    NSLog(@"lastSetBlue = %f", lastSetBlue);
		
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	
	// Set the brush color using premultiplied alpha values
	glColor4f(red	* kBrushOpacity,
			  green * kBrushOpacity,
			  blue	* kBrushOpacity,
			  kBrushOpacity);
	
	isEraserActive = NO;
}

#pragma mark -
#pragma mark Eraser

// Erases the screen
- (void) erase
{
	[EAGLContext setCurrentContext:context];
	
	// Clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)serEraserBrush
{
	glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);
	glColor4f(1.0, 1.0, 1.0, 1.0);
	
	isEraserActive = YES;
}

-(void) setBrushSize:(CGFloat) brushSizeValue
{
	brushSize = brushSizeValue;
	glPointSize(brushSize);
//    NSLog(@"PaintingView: new Brushsize is: %f", brushSize);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:brushSizeValue forKey:@"brushSize"];        
    [defaults synchronize];
}





- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ( event.subtype == UIEventSubtypeMotionShake ) 
	{
		[self restartDrawing];
    }
}

- (void)restartDrawing
{
	[self erase];
	
//	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
//	[app saveCurrentImage:[self imageRepresentation] BookNumber:self.delegate.currentBook.number PageNumber:self.delegate.currentPage.number];
}

//- (void) loadAreasFromFileForPictureIndex:(int)imageIndex
- (void) loadAreasFromFileForBookNumber:(int)booknumber Page:(int)pagenumber
{
//    NSLog(@"PaintingView: loadAreasFromFileForBookNumber:%d Page:%d", booknumber, pagenumber);
    
//    NSString *areaspath = [NSString stringWithFormat:@"%@/library/book0/areas/AREAS0.png", [[NSBundle mainBundle] resourcePath]];
    
//    NSString *areaspath = [NSString stringWithFormat:@"%@/books/book%d/areas/%d", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];

#define IPAD_GENERATES_AREAS_ITSELF_IN_DOCUMENTS NO
    
    NSString *areaspath;
    
    if (IPAD_GENERATES_AREAS_ITSELF_IN_DOCUMENTS) {
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filename = [NSString stringWithFormat:@"/areasofbook%dpagepage%d", booknumber, pagenumber];
        areaspath = [documentsDirectory stringByAppendingPathComponent:filename];
    } else {
        areaspath = [NSString stringWithFormat:@"%@/books/book%d/areas/%d", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];  
    }

    
    BOOL areasFileExists = [[NSFileManager defaultManager] fileExistsAtPath:areaspath];
    
    if (!areasFileExists) {
        NSLog(@"PaintingView: file with areas data does not exist. Gonna create one.");
        NSString *areaspathpng = [NSString stringWithFormat:@"%@/books/book%d/areas/AREAS%d.png", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
        [self createAreasFileFromPNGFileInPath:areaspathpng ForBookNumber:booknumber ForPageNumber:pagenumber];
    }
    NSData *readeddata = [NSData dataWithContentsOfFile:areaspath];
    NSUInteger len = [readeddata length];    
    [readeddata getBytes:areas length:len];   
}

//- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
//{
//
//}




#pragma mark -
#pragma mark Areas

- (void) createAreasFileFromPNGFileInPath:(NSString *)path ForBookNumber:(int)booknumber ForPageNumber:(int)pagenumber
{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!fileExists) 
    {
            NSLog(@"PaintingView: createAreas...  File with areas data do not exist at path: %@", path);
    } 
    else
    {
        
        UIImage *areaspicture = [UIImage imageWithContentsOfFile:path];
        NSMutableArray *myareas = [NSMutableArray array];
        
        
        
        // First get the image into your data buffer
        CGImageRef imageRef = [areaspicture CGImage];
        NSUInteger width = CGImageGetWidth(imageRef);
        NSUInteger height = CGImageGetHeight(imageRef);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        unsigned char *rawData = malloc(height * width * 4);
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
                
        CGContextRef currentContext = CGBitmapContextCreate(rawData, width, height,
                                                     bitsPerComponent, bytesPerRow, colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        
        CGContextDrawImage(currentContext, CGRectMake(0, 0, width, height), imageRef);
        CGContextRelease(currentContext);
        
        // Now your rawData contains the image data in the RGBA8888 pixel format.
        //        int byteIndex = (bytesPerRow * 1) + 1 * bytesPerPixel;
        
        int counter = 1;
        
        static int areasOfPixelsInt[560][800];
        
        for (int j = 0; j < 800; j++)
            for (int i = 0 ; i < 560; i++)
                
            {
                CGFloat red   = (rawData[bytesPerPixel * (j * 560 + i)]     * 1.0) / 255.0;
                CGFloat green = (rawData[bytesPerPixel * (j * 560 + i) + 1] * 1.0) / 255.0;
                CGFloat blue  = (rawData[bytesPerPixel * (j * 560 + i) + 2] * 1.0) / 255.0;
                CGFloat alpha = (rawData[bytesPerPixel * (j * 560 + i) + 3] * 1.0) / 255.0;

                CGFloat hue;
                CGFloat saturation;                
                CGFloat brightness;      
                
                RGB2HSL(red*255.0, green*255.0, blue*255.0, &hue, &saturation, &brightness);
                                
                UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
                
                BOOL colorfound = NO;
        
                
                for (UIColor *c in myareas){
                    CGFloat r=0; CGFloat g=0; CGFloat b=0; CGFloat a=0;
                    [c getRed:&r green:&g blue:&b alpha:&a]; 
//                    UIColor getRed green blue alpha will work in iOS5+ only!!!
//                    Better use:
//                    
//                    const float* colors = CGColorGetComponents(c.CGColor );
//                    r = colors[0];
//                    g = colors[1];
//                    b = colors[2];
//                    a = colors[3];
                    
                    CGFloat h;
                    CGFloat s;                
                    CGFloat br;
                    
                    RGB2HSL(r*255.0, g*255.0, b*255.0, &h, &s, &br);
                    
                    if (red < 0.1 && green < 0.1 && blue < 0.1) {
                        colorfound = YES;
                        areasOfPixelsInt[i][j] = BLACK_AREA_NUMBER;
                        break;
                    }
                    else if (fabs(hue - h) < 0.01){
                        colorfound = YES;
                        areasOfPixelsInt[i][j] = [myareas indexOfObject:c];
                        break;
                    }
                }
                
                if (!colorfound) {
                    [myareas addObject:acolor];
                    areasOfPixelsInt[i][j] = [myareas indexOfObject:acolor];
                }
                
                
                if ((j*560+i)%100000 == 0) {
                    NSLog(@"iteraciya %d", counter);
                }
                
                counter ++;
            }
               
        free(rawData);
        
        int colors = [myareas count];
        
        
        
        NSMutableArray *myareas2 = [NSMutableArray array];
        //удаляем области с малым количеством пискелей
        for (int k=[myareas count]; k>=0; k--) {
            int pixelsinarea = 0;
            for (int i=0; i<560; i++)
                for (int j=0; j<800; j++) {
                    if (areasOfPixelsInt[i][j] == k) pixelsinarea++;
                }
//            NSLog(@"PaintingView: there is %d pixels of color %d", pixelsinarea, k);
            if (pixelsinarea < 450) // было 500 - поменяли из-за того, что ухо у лошади не пролезало
                for (int i=0; i<560; i++)
                    for (int j=0; j<800; j++) {
                        if (areasOfPixelsInt[i][j] == k) {
                            areasOfPixelsInt[i][j] = UNPAINTED_AREA_NUMBER;
                        }
                    }
            else [myareas2 addObject:[myareas objectAtIndex:k]];
        }
        
        myareas = myareas2;
        
        NSLog(@"PaintingView: Found %d areas", [myareas count]);
        
        for (int k=colors-1; k>=0; k--) {
            int pixelsinarea = 0;
            for (int i=0; i<560; i++)
                for (int j=0; j<800; j++) {
                    if (areasOfPixelsInt[i][j] == k) pixelsinarea++;
                }
//            if (pixelsinarea > 0) NSLog(@"PaintingView: there is %d pixels of color %d", pixelsinarea, k);
        }
        
/*        
        //отфильтровываем единичные пиксели
        for (int i=1; i<559; i++)
            for (int j=1; j<799; j++) {
                int zone = areasOfPixelsInt[i][j];
                    if(//(areasOfPixelsInt[i+1][j] != BLACK_AREA_NUMBER)&&
                       (areasOfPixelsInt[i+1][j] != zone)&&
                       (areasOfPixelsInt[i][j+1] != zone)&&
                       (areasOfPixelsInt[i+1][j+1] != zone)&&
                       (areasOfPixelsInt[i][j-1] != zone)&&
                       (areasOfPixelsInt[i-1][j] != zone)&&
                       (areasOfPixelsInt[i-1][j-1] != zone)&&
                       (areasOfPixelsInt[i+1][j-1] != zone)&&
                       (areasOfPixelsInt[i-1][j+1] != zone)
                       ){
                        areasOfPixelsInt[i][j] = UNPAINTED_AREA_NUMBER;
                        }
                
            }
        
        
        static int areasOfPixelsInt2[560][800];
    
        for (int i=0; i<560; i++)
            for (int j=0; j<800; j++)
                areasOfPixelsInt2[i][j] = areasOfPixelsInt[i][j];
        
        for (int k=0; k<10; k++) {
            for (int i=1; i<559; i++)
                for (int j=1; j<799; j++) 
                    if (areasOfPixelsInt[i][j] == UNPAINTED_AREA_NUMBER)
                    {
                        for (int deltaX = -1; deltaX < 2; deltaX++)
                            for (int deltaY = -1; deltaY <2; deltaY++ )
                                if (areasOfPixelsInt[i+deltaX][j+deltaY] != UNPAINTED_AREA_NUMBER) {
                                    areasOfPixelsInt2[i][j] = areasOfPixelsInt[i+deltaX][j+deltaY];
                                    break;
                                }
                    }
            for (int q = 0; q<560; q++)
                for (int w = 0; w < 800; w++)
                    areasOfPixelsInt[q][w] = areasOfPixelsInt2[q][w];
        }

*/
        
        
        
        ////////////////////////////////////////
        //загружаем черные контуры из картинки//
        ////////////////////////////////////////

        
        
        NSString *picturepathBW = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
        
        
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:picturepathBW];
        
        if (fileExists) {
            
            UIImage *areaspictureBW = [UIImage imageWithContentsOfFile:picturepathBW];

            // First get the image into your data buffer
            CGImageRef imageRefBW = [areaspictureBW CGImage];
            NSUInteger widthBW = CGImageGetWidth(imageRefBW);
            NSUInteger heightBW = CGImageGetHeight(imageRefBW);
            
            CGColorSpaceRef colorSpaceBW = CGColorSpaceCreateDeviceRGB();
            unsigned char *rawDataBW = malloc(heightBW * widthBW * 4);
            NSUInteger bytesPerPixelBW = 4;
            NSUInteger bytesPerRowBW = bytesPerPixelBW * widthBW;
            NSUInteger bitsPerComponentBW = 8;
            
            CGContextRef contextBW = CGBitmapContextCreate(rawDataBW, widthBW, heightBW,
                                                         bitsPerComponentBW, bytesPerRowBW, colorSpaceBW,
                                                         kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
            CGColorSpaceRelease(colorSpaceBW);
            
            CGContextDrawImage(contextBW, CGRectMake(0, 0, widthBW, heightBW), imageRefBW);
            CGContextRelease(contextBW);
            
            // Now your rawData contains the image data in the RGBA8888 pixel format.
            //        int byteIndex = (bytesPerRow * 1) + 1 * bytesPerPixel;
            
                                 
            for (int j = 0; j < 800; j++)
                for (int i = 0 ; i < 560; i++)
                    
                {                    
                    CGFloat red   = (rawDataBW[bytesPerPixelBW * (j * 560 + i)]     * 1.0) / 255.0;
                    CGFloat green = (rawDataBW[bytesPerPixelBW * (j * 560 + i) + 1] * 1.0) / 255.0;
                    CGFloat blue  = (rawDataBW[bytesPerPixelBW * (j * 560 + i) + 2] * 1.0) / 255.0;
//                    CGFloat alpha = (rawDataBW[bytesPerPixelBW * (j * 560 + i) + 3] * 1.0) / 255.0;
                        if ((red < 0.1) && (green < 0.1) && (blue < 0.1)){
                            areasOfPixelsInt[i][j] = BLACK_AREA_NUMBER;
                        }                                          
                    }
                    
            free(rawDataBW);
        }

        
        NSString *filePathData;
        
        if (IPAD_GENERATES_AREAS_ITSELF_IN_DOCUMENTS) {
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *filename = [NSString stringWithFormat:@"/areasofbook%dpagepage%d", booknumber, pagenumber];
            filePathData = [documentsDirectory stringByAppendingPathComponent:filename];
        }
        else {
            filePathData = [NSString stringWithFormat:@"%@/books/book%d/areas/%d", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];            
        }
        
//        NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:
        
//        NSString *filePathData = [NSString stringWithFormat:@"%@/books/book%d/areas/%d", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
        NSData *mydata = [NSData dataWithBytes:&areasOfPixelsInt length:sizeof(areasOfPixelsInt)];
        
        NSLog(@"PaintingView: start file writing (NSData of int array)");
        
        
//        if (![mydata writeToFile:filePathData atomically:YES])
//        {
//            NSLog(@"PaintingView: Failed to create file with areas %@", filePathData);
//        }

        NSError *error = nil;
        [mydata writeToFile:filePathData options:NSDataWritingAtomic error:&error];
//        NSLog(@"PaintingView: Failed to create file with areas %@", filePathData);
        NSLog(@"Write returned error: %@", [error localizedDescription]);
        
        //        NSLog(@"%@", myareas);
        
        
        
        //        NSLog(@"PaintingView: created Array with colors, count = %d", [colordata count]);
        //        NSData *readeddata = [NSData dataWithContentsOfFile:filePath];
        //        NSUInteger len = [readeddata length];    
        //        [readeddata getBytes:areas length:len];   
    }
    
}


- (void) getAreasForPixels:(int)imageIndex
{
    
//    [flooder getAreasForPixels:imageIndex];
    //    [flooder getAreasForPixels];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filename = [NSString stringWithFormat:@"a%d", imageIndex];
    NSString *filePathData = [documentsDirectory stringByAppendingPathComponent:filename];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathData];
    
    if (fileExists) {
        //        NSLog(@"PaintingView: start loading area information");        
        NSData *readeddata = [NSData dataWithContentsOfFile:filePathData];
        NSUInteger len = [readeddata length];    
        [readeddata getBytes:areas length:len];   
        //        NSLog(@"PaintingView: done loading area information (file at path %@)", filePathData);
    }
    
    else {
        NSLog(@"PaintingView: File with areas data do not exist");
    }
    
    //    for (int i=0; i<560; i++)
    //        for (int j=0; j<800; j++)
    //            if ((i%100 == 0)&&(j%200 == 0)) {
    //                NSLog(@"readeddata[%d][%d] == %d", i, j, (int)readedArray[i][j]);
    //            };
    
    /*
     areasOfPixels = [flooder getAreasForPixels];
     [areasOfPixels retain];
     
     static int areasOfPixelsInt[560][800];
     for (int i=0; i<560; i++)
     for (int j=0; j<800; j++) {
     areasOfPixelsInt [i][j] = [[areasOfPixels objectAtIndex:(j*560+i)] intValue] ;
     if ((i%100 == 0)&&(j%200 == 0)) {
     NSLog(@"PaintImageController: writeddata[%d][%d] == %d", i, j, areasOfPixelsInt[i][j]);
     NSLog(@"PaintImageController: writeddata[%d][%d] SHOULD BE == %@", i, j, [areasOfPixels objectAtIndex:(j*560+i)]);
     };
     }
     */
    
    
    
    
    
    /*    
     NSData *mydata = [NSData dataWithBytes:&areasOfPixelsInt length:sizeof(areasOfPixelsInt)];
     
     
     //    NSError *error;
     //    NSFileManager *fileMgr = [NSFileManager defaultManager];
     
     NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
     
     NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"areasofpixels"];
     
     NSLog(@"PaintingView: start file writing (string)");
     [areasOfPixels writeToFile:filePath atomically:YES];
     NSLog(@"PaintingView: done file writing (string)");
     
     NSString *filePathData = [documentsDirectory stringByAppendingPathComponent:@"areasofpixelsdata"];
     
     NSLog(@"PaintingView: start file writing (NSData of int array)");
     [mydata writeToFile:filePathData atomically:YES];
     NSLog(@"PaintingView: done file writing (NSData of int array)");
     
     NSData *readeddata = [NSData dataWithContentsOfFile:filePathData];
     NSUInteger len = [readeddata length];
     
     static int readedArray[560][800];
     [readeddata getBytes:readedArray length:len];    
     
     for (int i=0; i<560; i++)
     for (int j=0; j<800; j++)
     if ((i%100 == 0)&&(j%200 == 0)) {
     NSLog(@"readeddata[%d][%d] == %d", i, j, readedArray[i][j]);
     };
     
     */
}

@end


static void HSL2RGB(float h, float s, float l, float* outR, float* outG, float* outB)
{
	float			temp1,
    temp2;
	float			temp[3];
	int				i;
    
	// Check for saturation. If there isn't any just return the luminance value for each, which results in gray.
	if(s == 0.0) {
		if(outR)
			*outR = l;
		if(outG)
			*outG = l;
		if(outB)
			*outB = l;
		return;
	}
    
	// Test for luminance and compute temporary values based on luminance and saturation 
	if(l < 0.5)
		temp2 = l * (1.0 + s);
	else
		temp2 = l + s - l * s;
    temp1 = 2.0 * l - temp2;
    
	// Compute intermediate values based on hue
	temp[0] = h + 1.0 / 3.0;
	temp[1] = h;
	temp[2] = h - 1.0 / 3.0;
    
	for(i = 0; i < 3; ++i) {
        
		// Adjust the range
		if(temp[i] < 0.0)
			temp[i] += 1.0;
		if(temp[i] > 1.0)
			temp[i] -= 1.0;
        
        
		if(6.0 * temp[i] < 1.0)
			temp[i] = temp1 + (temp2 - temp1) * 6.0 * temp[i];
		else {
			if(2.0 * temp[i] < 1.0)
				temp[i] = temp2;
			else {
				if(3.0 * temp[i] < 2.0)
					temp[i] = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - temp[i]) * 6.0;
				else
					temp[i] = temp1;
			}
		}
	}
    
	// Assign temporary values to R, G, B
	if(outR)
		*outR = temp[0];
	if(outG)
		*outG = temp[1];
	if(outB)
		*outB = temp[2];
}

static void RGB2HSL(float r, float g, float b, float* outH, float* outS, float* outL)
{
    r = r/255.0f;
    g = g/255.0f;
    b = b/255.0f;
    
    
    float h,s, l, v, m, vm, r2, g2, b2;
    
    h = 0;
    s = 0;
    l = 0;
    
    v = MAX(r, g);
    v = MAX(v, b);
    m = MIN(r, g);
    m = MIN(m, b);
    
    l = (m+v)/2.0f;
    
    if (l <= 0.0){
        if(outH)
			*outH = h;
		if(outS)
			*outS = s;
		if(outL)
			*outL = l;
        return;
    }
    
    vm = v - m;
    s = vm;
    
    if (s > 0.0f){
        s/= (l <= 0.5f) ? (v + m) : (2.0 - v - m); 
    }else{
        if(outH)
			*outH = h;
		if(outS)
			*outS = s;
		if(outL)
			*outL = l;
        return;
    }
    
    r2 = (v - r)/vm;
    g2 = (v - g)/vm;
    b2 = (v - b)/vm;
    
    if (r == v){
        h = (g == m ? 5.0f + b2 : 1.0f - g2);
    }else if (g == v){
        h = (b == m ? 1.0f + r2 : 3.0 - b2);
    }else{
        h = (r == m ? 3.0f + g2 : 5.0f - r2);
    }
    
    h/=6.0f;
    
    if(outH)
        *outH = h;
    if(outS)
        *outS = s;
    if(outL)
        *outL = l;
    
}