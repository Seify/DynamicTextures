//
//  PaintingView.h
//  DynamicTextures
//
//  Created by naceka on 03.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define UNPAINTED_AREA_NUMBER 999999
#define BLACK_AREA_NUMBER     999998


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PaintImageController.h"

//#import "Flooder.h"

#define kBrushOpacity	    1.0 //0.65 //1.0
#define kBrushPixelStep		3
#define kBrushScale			2
#define kLuminosity			0.75
#define kSaturation			1.0

@class PaintImageController;
// UIView с поддержкой рисования (для акварели)
@interface PaintingView : UIView {
	
	// The pixel dimensions of the backbuffer
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	
	// OpenGL names for the renderbuffer and framebuffers used to render to this view
	GLuint viewRenderbuffer, viewFramebuffer;
	
	// OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist)
	GLuint depthRenderbuffer;
    GLuint depthStencil;
	
	GLuint	brushTexture;
	CGPoint	location;
	CGPoint	previousLocation;
	Boolean	firstTouch;
	Boolean needsErase;	
        
    //new texture for adding images to view
    GLuint	stampTexture;
    //we use these to set back the state after we have added images
    
@public
	float lastSetRed;
	float lastSetGreen;
	float lastSetBlue;
	
@protected
	CGFloat brushSize;
	
	NSTimer * timer;
	CGFloat oldBrushSize;
	Boolean	isBrushMoving;
	
	Boolean isEraserActive;
	NSDate* lastClickedDate;
    
    int areaForCurrentDrawing;
    
    PaintImageController *delegate;
@public    
    int areas[560][800];
}

@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, readonly) NSMutableArray * allLines;
@property (nonatomic, copy) NSDate * lastClickedDate;
@property (assign) PaintImageController *delegate;

-(void) initDefaults: (UIImage*) initialImage;
-(void) changeImage: (UIImage*) initialImage;
- (void) renderLineWithDepthBufferFromPoint:(CGPoint)start toPoint:(CGPoint)end InArea:(int)areaID;
-(void) floodWithDepthBufferArea:(int)areaID;

- (void) getAreasForPixels:(int)imageIndex;
- (void) loadAreasFromFileForBookNumber:(int)booknumber Page:(int)pagenumber;
- (void) createAreasFileFromPNGFileInPath:(NSString *)path ForBookNumber:(int)booknumber ForPageNumber:(int)pagenumber;

- (void)erase;
- (void)restartDrawing;

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (void)serEraserBrush;

-(UIImage*) imageRepresentation;
-(UIImage*) upsideDownImageRepresenation;

-(void) mergeWithImage:(UIImage*) image;
-(void) setImage:(UIImage*)newImage;
-(void) setBrushSize:(CGFloat) brushSize;

- (BOOL) isValidIndixesOfArrayAreasX:(int)x Y:(int)y;

- (void)touchesBegan:(CGPoint)loc prevLoc:(CGPoint)prevLoc;
- (void)touchesMoved:(CGPoint)loc prevLoc:(CGPoint)prevLoc;

@end
