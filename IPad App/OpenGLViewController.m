//
//  OpenGLViewController.m
//  Collections
//
//  Created by Roman Smirnov on 17.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenGLViewController.h"
#import "OpenGLView.h"
#import "ShadersEnumerations.h"
#import "matrix.h"
#import "models.h"
#import "ModelDataStructures.h"
#import "BookManager.h"
#import "ResourceManager.h"
#import "Constants.h"
#import "DynamicTexturesAppDelegate.h"
#import "SoundManager.h"
#import "DrawingToolExtended.h"
#import "Mathematics.h"
#import "Pencil.h"
#import "AnimationConstants.h"

#define DEBUG 100


#define degreeToRadians M_PI/180*
#define radiansToDegree 180/M_PI*
#define ORTHO_MATRIX_SIZE 5.0

#define rgb 1.0/255.0*

//карандашница в целом

@interface OpenGLViewController ()
{
    BOOL notifyDelegateOnDraw;
    ResourceManager *resourceManager;
}
@property (retain) OpenGLView *myOpenGLView;
@property (retain) EAGLContext *myEAGLContext;
@property (retain) EAGLContext *resourceLoadingEAGLContext;
@property (readonly, assign) ResourceManager *resourceManager;

- (BOOL)validateProgram:(GLuint)prog;
- (void)waitForDrawFrame;
@end

@implementation OpenGLViewController

#pragma mark - Properties' getter & setter

@synthesize myOpenGLView;
@synthesize myEAGLContext; 
@synthesize resourceLoadingEAGLContext;
@synthesize displayLink;

- (ResourceManager *)resourceManager{
    if (!resourceManager){
        resourceManager = [ResourceManager sharedInstance];
    }
    return resourceManager;
}

- (InterfaceManager *)interfaceManager {
    if (!interfaceManager) {
        interfaceManager = [[InterfaceManager alloc] initWithState:INTERFACE_STATE_SHOWING_BOOKS];
        interfaceManager.delegate = self;
    }
    
    return interfaceManager;
}

- (int)countOfUndoAvaible {
    return countOfUndoAvaible;
}

- (int)indexOfTextureToRewrite{
    return indexOfTextureToRewrite;
}

- (void)setIndexOfTextureToRewrite:(int)newIndexOfTextureToRewrite{
    if (newIndexOfTextureToRewrite > MAX_UNDO_COUNT - 1) 
    {
        indexOfTextureToRewrite = newIndexOfTextureToRewrite % MAX_UNDO_COUNT;
    } else if (newIndexOfTextureToRewrite < 0)
    {
        indexOfTextureToRewrite = MAX_UNDO_COUNT - 1;
    } else 
    {
        indexOfTextureToRewrite = newIndexOfTextureToRewrite;
    }
}

- (void)setCountOfUndoAvaible:(int)newCountOfUndoAvaible{
    if (newCountOfUndoAvaible >= 0 && newCountOfUndoAvaible <= MAX_UNDO_COUNT) {
        countOfUndoAvaible = newCountOfUndoAvaible;
        NSString *text = [NSString stringWithFormat:@"Undo (%d)", countOfUndoAvaible];
        [self.interfaceManager->undoButton setTitle:text forState:UIControlStateNormal];
    } 
}

- (BOOL)canUndoPainting {
    return (countOfUndoAvaible > 0);
}

- (void)waitForDrawFrame{
    notifyDelegateOnDraw = YES;
}


#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
    
// Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
// Release any cached data, images, etc that aren't in use.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
    myOpenGLView = [[OpenGLView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    self.view = myOpenGLView;
}

// TO-DO: надо чтобы музыка игралась сразу при запуске программы
//- (void)setupSound{
//    SoundManager *sm = [SoundManager sharedInstance];
//    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/paint_music.mp3", [[NSBundle mainBundle] resourcePath]];  
//    
//    [sm startBackgroundMusicFilePath:soundFilePath];
//}

- (void)viewDidLoad{
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
            
    [super viewDidLoad];
    
    isProgramInBackground = NO;
                
    // Выбираем начальный карандаш
//    [self pencilClicked:[self.pencils objectAtIndex:2]];
//    isEraserSelected = NO;

    
    

    self.countOfUndoAvaible = 0;
    
//    [self setupSound];
    
//    self.interfaceManager.drawingToolsBox.state = DRAWING_TOOLS_BOX_STATE_SELECT_DRAWING_TOOL;
}

- (void)loadDrawingTextureRestored:(BOOL)restored{
    glBindTexture(GL_TEXTURE_2D, currentDrawingTexture);
    
    if (restored){
        GLubyte *restoredDrawingTexture = [self restoreCurrentDrawingTextureData];  
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1024, 1024, 0, GL_RGBA, GL_UNSIGNED_BYTE, restoredDrawingTexture);
        free(restoredDrawingTexture);
    }
    else {
        GLubyte *newDrawingTexture = (GLubyte *)malloc(1024 * 1024 * 4 * sizeof(GLubyte));
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1024, 1024, 0, GL_RGBA, GL_UNSIGNED_BYTE, newDrawingTexture);
        free(newDrawingTexture);
    }
    
    //	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 1024, 1024, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, 0);
    
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

- (void)CreateFBO{
    
	// Generate and bind a render buffer which will become a depth buffer shared between our two FBOs
	glGenRenderbuffers(1, &drawingToTextureDepthRenderBuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, drawingToTextureDepthRenderBuffer);
    
	/*
     Currently it is unknown to GL that we want our new render buffer to be a depth buffer.
     glRenderbufferStorage will fix this and in this case will allocate a depth buffer
     m_i32TexSize by m_i32TexSize.
     */
    
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, 1024, 1024);
    
	// Create a texture for rendering to
	glGenTextures(1, &currentDrawingTexture);
    
    
    glBindTexture(GL_TEXTURE_2D, currentDrawingTexture);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1024, 1024, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
//	[self loadDrawingTexture];
    
	// Create the object that will allow us to render to the aforementioned texture
	glGenFramebuffers(1, &drawingToTextureFramebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, drawingToTextureFramebuffer);
    
    
	// Attach the texture to the FBO
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, currentDrawingTexture, 0);
    
	// Attach the depth buffer we created earlier to our FBO.
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, drawingToTextureDepthRenderBuffer);
    
	// Check that our FBO creation was successful
	GLuint uStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
	if(uStatus != GL_FRAMEBUFFER_COMPLETE)
	{
		NSLog(@"ERROR: Failed to initialise FBO");
	}
    
	// Clear the colour and depth buffers for the FBO / PBuffer surface
    //	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	// Unbind the frame buffer object so rendering returns back to the backbuffer
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:self.interfaceManager.currentBook.number], @"booknumber",
                                nil];
    [[ResourceManager sharedInstance] loadResourcesForScene:SCENE_SELECT_PICTURE
                                                 Parameters:parameters
                                                  InContext:resourceLoadingEAGLContext];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );

//    isProgramInBackground = NO;
    [super viewWillAppear:animated];
    
    GLenum status;
    
    // если framebuffer уже создан (например, возвращаемся в navigation controller, пересоздавать не надо)
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);    
    status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    //    if(status != GL_FRAMEBUFFER_COMPLETE) {
    myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    resourceLoadingEAGLContext = [[EAGLContext alloc] initWithAPI:[myEAGLContext API] sharegroup: [myEAGLContext sharegroup]];
    
    NSLog(@"myEAGLContext = %@", myEAGLContext);
    NSLog(@"resourceLoadingEAGLContext = %@", resourceLoadingEAGLContext);
    
    //TODO: добавить в plist требование OpenGL ES 2.0
    [EAGLContext setCurrentContext: myEAGLContext];
    //    [self checkExtensions];
    
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    glDeleteRenderbuffers(1, &colorRenderbuffer);
    
    glGenRenderbuffers(1, &colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [self.myEAGLContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myOpenGLView.myEAGLLayer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);

    
    GLint width;
    GLint height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
//    NSLog(@"width = %d; height = %d", width, height);
    
    
    glGenRenderbuffers(1, &depthRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
    
    status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    if(status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x", status);
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame:)];
//    self.displayLink.frameInterval = 2;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];       
    
    [self CreateFBO];
    
    [self.interfaceManager setup];
    
    for (int i=0; i<[self.interfaceManager.drawingToolsBox.drawingTools count]; i++)
    {
        DrawingTool *dt = [self.interfaceManager.drawingToolsBox.drawingTools objectAtIndex:i];
//        UIColor *color = [UIColor colorWithRed:dt.red green:dt.green blue:dt.blue alpha:dt.alpha];
        
        DrawingTool *dtneibor = nil;
        if (i+1 < [self.interfaceManager.drawingToolsBox.drawingTools count]) 
        {
            dtneibor = [self.interfaceManager.drawingToolsBox.drawingTools objectAtIndex:i+1];
        } 
        UIColor *neiborcolor = nil;
        if (dtneibor) neiborcolor = [UIColor colorWithRed:dtneibor.red green:dtneibor.green blue:dtneibor.blue alpha:dtneibor.alpha/4.0];
        
//        drawingToolBodyTextures[i] = [self textureForPencilOfColor:color ReflexColor:neiborcolor];
        
        for (int j=0; j<[dt.drawingToolsExtended count]; j++) {
            DrawingToolExtended *dte = [dt.drawingToolsExtended objectAtIndex:j];
            UIColor *color = [UIColor colorWithRed:dte.red green:dte.green blue:dte.blue alpha:dte.alpha];
            
            DrawingToolExtended *dteneibor = nil;
            if (i+1 < [dt.drawingToolsExtended count]) 
            {
                dteneibor = [dt.drawingToolsExtended objectAtIndex:i+1];
            } 
            UIColor *neiborcolor = nil;
            if (dteneibor) neiborcolor = [UIColor colorWithRed:dteneibor.red green:dteneibor.green blue:dteneibor.blue alpha:dteneibor.alpha/4.0];
            
            drawingToolExtendedBodyTextures[i*5+j] = [self textureForPencilOfColor:color ReflexColor:neiborcolor];
//            NSLog(@"%@ : %@ drawingToolExtendedBodyTextures[%d] color = %@", self, NSStringFromSelector(_cmd), i*5+j, color);
        }
    }
    
    [self.interfaceManager disablePrevOrNextButtonIfNessesarily];
    
    [self checkForError];
    
    //    }
}

- (void)initBlackAndWhiteTexture {
    
    if (blackAndWhitePictureTexture){
        glDeleteTextures(1, &blackAndWhitePictureTexture);
    }
    
    BookManager *bm = [BookManager sharedInstance];
    UIImage *image = [bm imageForPage:self.interfaceManager.currentPage InBook:self.interfaceManager.currentBook];
    
//    NSLog(@"%@ : %@ self.interfaceManager.currentBook.number = %d self.interfaceManager.currentPage.number = %d ", self, NSStringFromSelector(_cmd), self.interfaceManager.currentBook.number, self.interfaceManager.currentPage.number);
    
    blackAndWhitePictureTexture = [self setupAndMixWithAreasTextureWithImage:image];
}

- (void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );

    [super viewDidAppear:animated];
    
    [self initDrawingTexturesCache];
    
//    [self initBlackAndWhiteTexture]; 
}

- (void)applicationWillResignActive{
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
    
    isProgramInBackground = YES;
	glFinish();
}

- (void)applicationDidBecomeActive{
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
    
    isProgramInBackground = NO;
//    self.interfaceManager.painting.brushSize = self.interfaceManager.brushSizeSlider.value;
}

- (void)applicationWillEnterForeground{ 
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );

    isProgramInBackground = NO;
//    self.interfaceManager.painting.brushSize = self.interfaceManager.brushSizeSlider.value;
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
    
    [super viewWillDisappear:animated];    
        
    glDeleteTextures(MAX_UNDO_COUNT, &drawingTextures[0]);
	glDeleteTextures(1, &currentDrawingTexture);
    glDeleteTextures(1, &blackAndWhitePictureTexture);
    
    glDeleteRenderbuffers(1, &colorRenderbuffer);
    glDeleteRenderbuffers(1, &depthRenderbuffer);
    glDeleteFramebuffers(1, &framebuffer);
    
    glDeleteRenderbuffers(1, &drawingToTextureDepthRenderBuffer);
    glDeleteFramebuffers(1, &drawingToTextureFramebuffer);
    
    [self.displayLink invalidate];   
    
    [self.interfaceManager freeData];
    
//    free(drawingTrianglesPositions);
//    free(areasToFill);
    
    [myEAGLContext release];
    [resourceLoadingEAGLContext release];
    
    //    [self.view removeFromSuperview];
}

- (void)viewDidUnload{
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
    
    //    [self.view removeFromSuperview];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
//    [self.colorPickerPopover release];
//    self.colorPickerPopover = nil;
    
//    [colorPickerController release];
//    colorPickerController = nil;

    [self.view release];

    [self releaseViewsAndObjects];
    
//    isProgramInBackground = YES;
//	glFinish();
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
	return ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

- (void)releaseViewsAndObjects{
    [self.interfaceManager releaseViewsAndObjects];
    
// TODO: Удалить массивы с текстурами drawing tools body
    
//    [drawingToolsBox release];
    
    if (interfaceManager) [interfaceManager release];
    if (displayLink) [displayLink release];
}

- (void) dealloc{
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
    
    [self releaseViewsAndObjects];
    [super dealloc];
}

#pragma mark - Undo Cache

- (void)clearUndoCache{
    self.countOfUndoAvaible = 0;
    //    self.indexOfTextureToRewrite++;
    //    [self clearDrawingTexture];
}

- (void)addTextureToUndoCache{
    //    NSLog(@"%@ : %@ ", self, NSStringFromSelector(_cmd));
    
    [self copyTexture:currentDrawingTexture ToTexture:drawingTextures[self.indexOfTextureToRewrite]];
    self.indexOfTextureToRewrite++;
    self.countOfUndoAvaible++;
    
    //    NSLog(@"%@ : %@ end", self, NSStringFromSelector(_cmd));
    
}

- (void)restoreTextureFromUndoCache {
    if (self.canUndoPainting) {
        self.countOfUndoAvaible--;
        self.indexOfTextureToRewrite--;
        [self copyTexture:drawingTextures[self.indexOfTextureToRewrite] ToTexture:currentDrawingTexture];
    }
}

- (GLuint)getPreviousDrawingTexture {
    return drawingTextures[countOfUndoAvaible];
}

#pragma mark - Gesture recognizers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
//    NSLog(@"%@ : %@ ", self, NSStringFromSelector(_cmd));
    
    UITouch* touch = [[event touchesForView:self.view] anyObject];
	CGPoint location = [touch locationInView:self.view];

    [self.interfaceManager touchBeganAtLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [[event touchesForView:self.view] anyObject];
    CGPoint location = [touch locationInView:self.view];
    CGPoint previousLocation = [touch previousLocationInView:self.view];
    
    [self.interfaceManager touchesMovedLocation:location 
                               PreviousLocation:previousLocation];    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );

    UITouch* touch = [[event touchesForView:self.view] anyObject];
    CGPoint location = [touch locationInView:self.view];

    [self.interfaceManager touchesEndedLocation:location];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
    
    UITouch* touch = [[event touchesForView:self.view] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    [self.interfaceManager touchesCancelledLocation:location];    
}

#pragma mark - Draw cycle

- (void)MakeMatrix:(GLfloat *) matrix OriginX:(GLfloat)originX OriginY:(GLfloat)originY Width:(GLfloat)width Height:(GLfloat)height Rotation:(GLfloat)rot{
    
    GLfloat rotationMatrix[16], translationMatrix[16], scaleMatrix[16], tempMatrix[16], proj[16], modelview[16];
    
    float lowerLeftCornerOffsetX = -(SCREEN_WIDTH-width)/SCREEN_WIDTH;  
    float lowerLeftCornerOffsetY = (SCREEN_HEIGHT-height)/SCREEN_HEIGHT;
    
    mat4f_LoadXYZTranslation(lowerLeftCornerOffsetX + originX*2.0/SCREEN_WIDTH, lowerLeftCornerOffsetY - ( originY*2.0)/SCREEN_HEIGHT, -90.0f, translationMatrix);
    rotation = (vec3){rotation.x + rotationSpeed.x, rotation.y + rotationSpeed.y, rotation.z + rotationSpeed.z};
    mat4f_LoadXYZRotation(degreeToRadians(90 + rot), 0.0f, 0.0f, rotationMatrix);
    mat4f_LoadXYZScale(width/SCREEN_WIDTH, height/SCREEN_HEIGHT, 1.0f, scaleMatrix);
    mat4f_LoadOrtho(-1.0, 1.0, -1.0, 1.0, -100.0f, 100.0f, proj);
    mat4f_MultiplyMat4f(translationMatrix, scaleMatrix, tempMatrix);
    mat4f_MultiplyMat4f(tempMatrix, rotationMatrix, modelview);
    mat4f_MultiplyMat4f(proj, modelview, matrix);        
}

- (void)MakePerspectiveMatrix:(GLfloat *) matrix 
                      OriginX:(GLfloat)originX 
                      OriginY:(GLfloat)originY 
                        Width:(GLfloat)width 
                       Height:(GLfloat)height 
                     Rotation:(GLfloat)rot
                 TranslationX:(GLfloat)transX
                 TranslationY:(GLfloat)transY
                 TranslationZ:(GLfloat)transZ
                       ScaleX:(CGFloat)scaleX
                       ScaleY:(CGFloat)scaleY
{    
        
    GLfloat rotationMatrix[16], translationMatrix[16], scaleMatrix[16], proj[16];
    
    float lowerLeftCornerOffsetX = -(SCREEN_WIDTH-width)/SCREEN_WIDTH;  
    float lowerLeftCornerOffsetY = (SCREEN_HEIGHT-height)/SCREEN_HEIGHT;
        
    mat4f_LoadXYZTranslation(lowerLeftCornerOffsetX + originX*2.0/SCREEN_WIDTH + transX, lowerLeftCornerOffsetY - ( originY*2.0)/SCREEN_HEIGHT + transY, -50.0f + transZ, translationMatrix);
    mat4f_LoadXYZRotation(0.0f, degreeToRadians(rot), 0.0f, rotationMatrix);
    mat4f_LoadXYZScale(width/SCREEN_WIDTH * scaleX * 5.0, height/SCREEN_HEIGHT * scaleY * 5.0, 1.0f, scaleMatrix);
    mat4f_LoadPerspective(degreeToRadians(100), (width/height), 20.0, 80.0, proj);
    
    makePerspectiveMatrix(scaleMatrix, translationMatrix, rotationMatrix, proj, matrix);
}


- (void)drawBackground
{
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:0.0 
             OriginY:0.0 
               Width:768.0 
              Height:1024.0
            Rotation:0.0];
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    GLuint backgroundTexture = [self.resourceManager getTexture:TEXTURE_BACKGROUND
                                                     Parameters:nil
                                                      InContext:resourceLoadingEAGLContext
                                                     ShouldLoad:YES
                                                          Async:NO];

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
    glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
    
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
}

- (void)drawPicture {
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);    
    
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_FINAL_PICTURE];
    glUseProgram(currentProgram);
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:PAINTING_ORIGIN_X 
             OriginY:PAINTING_ORIGIN_Y 
               Width:PAINTING_WIDTH 
              Height:PAINTING_HEIGHT
            Rotation:0.0];
    
    glUniformMatrix4fv(final_picture_uniforms[FINAL_PICTURE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, currentDrawingTexture);
    glUniform1i(final_picture_uniforms[FINAL_PICTURE_UNIFORM_DRAWING_TEXTURE], 0);
    
    glActiveTexture(GL_TEXTURE1); 
    glBindTexture(GL_TEXTURE_2D, blackAndWhitePictureTexture);
    glUniform1i(final_picture_uniforms[FINAL_PICTURE_UNIFORM_TEXTURE], 1);
    
    GLuint paperTexture = [self.resourceManager getTexture:TEXTURE_PAPER 
                                                Parameters:nil
                                                 InContext:resourceLoadingEAGLContext
                                                ShouldLoad:YES
                                                     Async:YES];
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, paperTexture);
    glUniform1i(final_picture_uniforms[FINAL_PICTURE_UNIFORM_PAPER_TEXTURE], 2);
    
    
    glVertexAttribPointer(FINAL_PICTURE_WITH_SHADING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(FINAL_PICTURE_WITH_SHADING_ATTRIB_VERTEX);
    
    glVertexAttribPointer(FINAL_PICTURE_WITH_SHADING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(FINAL_PICTURE_WITH_SHADING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);    
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
}

- (void)drawLayers
{
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);

    for (DTLayer *layer in self.interfaceManager.layers)
    {
        if (!layer.isVisible) continue;
        
        GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_FINAL_PICTURE];
        glUseProgram(currentProgram);
        
        GLfloat modelviewProj[16];
        [self MakeMatrix:modelviewProj
                 OriginX:PAINTING_ORIGIN_X
                 OriginY:PAINTING_ORIGIN_Y
                   Width:PAINTING_WIDTH
                  Height:PAINTING_HEIGHT
                Rotation:0.0];
        
        glUniformMatrix4fv(final_picture_uniforms[FINAL_PICTURE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, layer.userDrawingTexture);
        glUniform1i(final_picture_uniforms[FINAL_PICTURE_UNIFORM_DRAWING_TEXTURE], 0);
        
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, blackAndWhitePictureTexture);
        glUniform1i(final_picture_uniforms[FINAL_PICTURE_UNIFORM_TEXTURE], 1);
        
        glVertexAttribPointer(FINAL_PICTURE_WITH_SHADING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
        glEnableVertexAttribArray(FINAL_PICTURE_WITH_SHADING_ATTRIB_VERTEX);
        
        glVertexAttribPointer(FINAL_PICTURE_WITH_SHADING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
        glEnableVertexAttribArray(FINAL_PICTURE_WITH_SHADING_ATTRIB_TEX_COORDS);
        
        glDrawArrays(GL_TRIANGLES, 0, 6);
    }
}

- (void)drawPictureWithShading{
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);    
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_FINAL_PICTURE_WITH_SHADING];
    
    glUseProgram(currentProgram);
    
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:PAINTING_ORIGIN_X 
             OriginY:PAINTING_ORIGIN_Y 
               Width:PAINTING_WIDTH 
              Height:PAINTING_HEIGHT
            Rotation:0.0];
    
    // update uniform values
    glUniformMatrix4fv(final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, currentDrawingTexture);
    glUniform1i(final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_DRAWING_TEXTURE], 0);
    
    glActiveTexture(GL_TEXTURE1); 
    glBindTexture(GL_TEXTURE_2D, blackAndWhitePictureTexture);
    glUniform1i(final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_TEXTURE], 1);
    
    GLuint paperTexture = [self.resourceManager getTexture:TEXTURE_PAPER
                                                Parameters:nil
                                                 InContext:resourceLoadingEAGLContext
                                                ShouldLoad:YES
                                                     Async:YES];
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, paperTexture);
    glUniform1i(final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_PAPER_TEXTURE], 2);

    glUniform1f(final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_CURRENT_AREA], self.interfaceManager.painting.currentArea);
    
    // чем константа выше, тем сильнее обесцвечиваются цвета неактивных областей
#define DISCOLORING_CONSTANT 0.9
    glUniform1f(final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_DISCOLORING_CONSTANT],
                self.interfaceManager.painting.shadowing.alpha / SHADING_END_ALPHA * DISCOLORING_CONSTANT);
    
//    NSLog(@"%@ : %@ self.interfaceManager.painting.shadowing.alpha = %f", self, NSStringFromSelector(_cmd), self.interfaceManager.painting.shadowing.alpha);
    
    
    // чем константа выше, тем ярче подсветка (меньше затенение) неактивных областей
#define HIGHLIGHT_CONSTANT 0.4 
    glUniform1f(final_picture_with_shading_uniforms[FINAL_PICTURE_WITH_SHADING_UNIFORM_HIGHLIGHT_CONSTANT], 
                self.interfaceManager.painting.shadowing.alpha / SHADING_END_ALPHA * HIGHLIGHT_CONSTANT);
    
    glVertexAttribPointer(FINAL_PICTURE_WITH_SHADING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(FINAL_PICTURE_WITH_SHADING_ATTRIB_VERTEX);
    
    glVertexAttribPointer(FINAL_PICTURE_WITH_SHADING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(FINAL_PICTURE_WITH_SHADING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);    
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
}
//test
- (void)drawStar:(StarAnimation *)star{
    
//    NSLog(@"%@ : %@ ", self, NSStringFromSelector(_cmd));
    
//    glDisable(GL_DEPTH_TEST);
//    glDisable(GL_BLEND);
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    if([self.interfaceManager.painting shouldPlayAnimation:star]){
        
//        if(star.alpha == 1.0) {
//            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//        } else {
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//        }
        
        GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_TEXTURING_PLUS_ALPHA];
        glUseProgram(currentProgram);
        
        // handle viewing matrices
        GLfloat modelviewProj[16];
        [self MakeMatrix:modelviewProj 
                 OriginX:star.position.origin.x 
                 OriginY:star.position.origin.y 
                   Width:star.position.size.width 
                  Height:star.position.size.height
                Rotation:star.angle];
        
        // update uniform values
        glUniformMatrix4fv(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
        
        
        GLuint starTexture = [self.resourceManager getTexture:STAR_TEXTURE
                                                   Parameters:nil
                                                    InContext:resourceLoadingEAGLContext
                                                   ShouldLoad:YES
                                                        Async:YES];
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, starTexture);
        glUniform1i(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE], 0);
        
        glUniform1f(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA], star.alpha);
        
        glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
        glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX);
        
        glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
        glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS);
        
        glDrawArrays(GL_TRIANGLES, 0, 6);        
        
//        if (![self validateProgram:currentProgram]) {
//            
//            NSLog(@"Failed to validate program: (%d)", currentProgram);
//        }
    }
}

- (void) drawToTexture {
    
    //    NSLog(@"%@ : %@ ", self, NSStringFromSelector(_cmd));
    
    if (isDrawingTextureUsed) {NSLog(@"WARNING!! isDrawingTextureUsed");}
    
    isDrawingTextureUsed = YES;
    
    glBindFramebuffer(GL_FRAMEBUFFER, drawingToTextureFramebuffer);
    
    DTLayer *activeLayer = [self.interfaceManager.layers objectAtIndex:self.interfaceManager.activeLayerNumber];
    GLuint textureToDrawTo = activeLayer.userDrawingTexture;
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureToDrawTo, 0);
    
    glViewport(0, 0, 1024, 1024);
        
    glDisable(GL_DEPTH_TEST);
    
//    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
//    if (app.paintMode != paintModeSimple) {
        
        {        //рисуем линии кисти
 
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glEnable(GL_BLEND); 
            
            GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_DRAW_BRUSH_LINE];
            glUseProgram(currentProgram);
            
            GLfloat modelviewProj[16];
            [self MakeMatrix:modelviewProj OriginX:0.0 OriginY:0.0 Width:768.0 Height:1024.0 Rotation:0.0];
            
            
            // update uniform values
            glUniformMatrix4fv(draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            
            GLuint currentTexture = [self.resourceManager getTexture:BRUSH_TEXTURE
                                                          Parameters:nil
                                                           InContext:resourceLoadingEAGLContext 
                                                          ShouldLoad:YES
                                                               Async:YES]; 
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, currentTexture);
            glUniform1i(draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_BRUSH_TEXTURE], 0);
            
            glActiveTexture(GL_TEXTURE2); 
            glBindTexture(GL_TEXTURE_2D, blackAndWhitePictureTexture);
            glUniform1i(draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_TEXTURE], 2);
            
            glUniform1f(draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_CURRENT_AREA], self.interfaceManager.painting.currentArea);
            
            GLfloat *brushColor = [self.interfaceManager.painting getBrushColor];
            
            glUniform4f(draw_brush_line_uniforms[DRAW_BRUSH_LINE_UNIFORM_COLOR], 1.0-brushColor[0], 1.0-brushColor[1], 1.0-brushColor[2], brushColor[3]);
            
//            glVertexAttribPointer(DRAW_BRUSH_LINE_ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), &drawingTrianglesPositions[0]);
            
            GLfloat *arrayptr = [self.interfaceManager.painting getBrushArray];
            
            glVertexAttribPointer(DRAW_BRUSH_LINE_ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), &arrayptr[0]);
            glEnableVertexAttribArray(DRAW_BRUSH_LINE_ATTRIB_VERTEX);
            
            glVertexAttribPointer(DRAW_BRUSH_LINE_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), &arrayptr[2]);
            glEnableVertexAttribArray(DRAW_BRUSH_LINE_ATTRIB_TEX_COORDS);
            
            glDrawArrays(GL_TRIANGLES, 0, self.interfaceManager.painting.countDrawingTrianglesPositions);
            
            //        if (countDrawingTrianglesPositions != 0) {
            //            NSLog(@"%@ : %@ : drawing %d triangles", self, NSStringFromSelector(_cmd), countDrawingTrianglesPositions);
            //        }
            
            self.interfaceManager.painting.countDrawingTrianglesPositions = 0;
            
//            if (![self validateProgram:currentProgram]) {
//                NSLog(@"Failed to validate program: (%d)", currentProgram);
//            }
        }
        

// рисуем заливку областей
        for (FillingAnimation *fa in self.interfaceManager.painting.animations){
                
//                glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

                glEnable(GL_BLEND); 
                
                GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_FILLING];            
                glUseProgram(currentProgram);
                
                GLfloat modelviewProj[16];
                [self MakeMatrix:modelviewProj OriginX:0.0 OriginY:0.0 Width:768.0 Height:1024.0 Rotation:0.0];
                
                // update uniform values
                glUniformMatrix4fv(filling_uniforms[FILLING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
                
                glActiveTexture(GL_TEXTURE1); 
                glBindTexture(GL_TEXTURE_2D, blackAndWhitePictureTexture);
                glUniform1i(filling_uniforms[FILLING_UNIFORM_AREAS_TEXTURE], 1);
            
                GLuint circleTexture = [self.resourceManager getTexture:CIRCLE_TEXTURE
                                                             Parameters:nil
                                                              InContext:resourceLoadingEAGLContext
                                                             ShouldLoad:YES 
                                                                  Async:YES];
                glActiveTexture(GL_TEXTURE0); 
                glBindTexture(GL_TEXTURE_2D, circleTexture);
                glUniform1i(filling_uniforms[FILLING_UNIFORM_CIRCLE_TEXTURE], 0);

            
//                glUniform1f(filling_uniforms[FILLING_UNIFORM_CURRENT_AREA], areasToFill[i]);
                glUniform1f(filling_uniforms[FILLING_UNIFORM_CURRENT_AREA], fa.area);
                
                glUniform4f(filling_uniforms[FILLING_UNIFORM_BRUSH_COLOR], 
                            1.0-fa.red, 
                            1.0-fa.green, 
                            1.0-fa.blue, 
                            fa.alpha);
            
//                NSLog(@"%@ : %@ Color = (%f, %f, %f, %f)", self, NSStringFromSelector(_cmd) ,fa.red, fa.green, fa.blue, fa.alpha);

                
                float radius = 2.0 * (fa.position.size.width - fa.startPosition.size.width)/(fa.endPosition.size.width - fa.startPosition.size.width);
                
                float *vertexes;
                vertexes = malloc(42*sizeof(float));
                       
                CGPoint locationOnPaintingView = convertLocationToPaintingViewLocation(fa.position.origin);
                CGPoint center = convertPaintingViewPixelsToGLCoords(locationOnPaintingView);

                
                for (int i=0; i<6; i++) {
                    vertexes[i*7+0] = (plain[i].vertex.x ) *radius + center.y;// - 0.21875;
                    vertexes[i*7+1] = (plain[i].vertex.y ) *radius - center.x;// + 0.453125;
                    vertexes[i*7+2] = plain[i].vertex.z;
                    vertexes[i*7+3] = (1.0-vertexes[i*7+1])/2.0;
                    vertexes[i*7+4] = (1.0-vertexes[i*7+0])/2.0;
                    vertexes[i*7+5] = plain[i].texCoord.u;
                    vertexes[i*7+6] = plain[i].texCoord.v;     
                }
            

                glVertexAttribPointer(FILLING_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(float), &vertexes[0]);
                glEnableVertexAttribArray(FILLING_ATTRIB_VERTEX);

                glVertexAttribPointer(FILLING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, 7 * sizeof(float), &vertexes[3]);
                glEnableVertexAttribArray(FILLING_ATTRIB_TEX_COORDS);

                glVertexAttribPointer(FILLING_ATTRIB_CIRCLE_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, 7 * sizeof(float), &vertexes[5]);
                glEnableVertexAttribArray(FILLING_ATTRIB_CIRCLE_TEX_COORDS);      
                
                glDrawArrays(GL_TRIANGLES, 0, 6);
            
                free(vertexes);
                
//                if (![self validateProgram:currentProgram]) {
//                    NSLog(@"Failed to validate fillingProgram: (%d)", currentProgram);
//                }
            }
//            countAreasToFill = 0;       
//        }
//    }
    
    isDrawingTextureUsed = NO;
    
    
    //        NSLog(@"%@ : %@ end", self, NSStringFromSelector(_cmd));
}

- (void)drawRainbowTool
{
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);    
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:self.interfaceManager.drawingToolsBox.rainbowTool.position.origin.x 
             OriginY:self.interfaceManager.drawingToolsBox.rainbowTool.position.origin.y 
               Width:self.interfaceManager.drawingToolsBox.rainbowTool.position.size.width
              Height:self.interfaceManager.drawingToolsBox.rainbowTool.position.size.height 
            Rotation:0.0];
    
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    GLuint rainbowToolTexture = [self.resourceManager getTexture:RAINBOW_TOOL_TEXTURE
                                                      Parameters:nil
                                                       InContext:resourceLoadingEAGLContext
                                                      ShouldLoad:YES
                                                           Async:YES];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, rainbowToolTexture);
    glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
    
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
    
    //    glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_TRUE, sizeof(vertexDataTextured), &plain[0].normal);
    //    glEnableVertexAttribArray(ATTRIB_NORMAL);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    
    //    if (![self validateProgram:currentProgram]) {
    //        NSLog(@"Failed to validate program: (%d)", currentProgram);
    //    }
}

- (void)drawRainbowToolIndicator
{
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);    
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:self.interfaceManager.drawingToolsBox.rainbowTool.indicatorPosition.x - RAINBOW_TOOL_INDICATOR_WIDTH / 2 + RAINBOW_TOOL_INDICATOR_OFFSET_X
             OriginY:self.interfaceManager.drawingToolsBox.rainbowTool.indicatorPosition.y - RAINBOW_TOOL_INDICATOR_HEIGHT / 2 + RAINBOW_TOOL_INDICATOR_OFFSET_Y
               Width:RAINBOW_TOOL_INDICATOR_HEIGHT
              Height:RAINBOW_TOOL_INDICATOR_WIDTH 
            Rotation:0.0];
    
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    GLuint rainbowToolTexture = [self.resourceManager getTexture:RAINBOW_TOOL_INDICATOR_TEXTURE
                                                      Parameters:nil
                                                       InContext:resourceLoadingEAGLContext
                                                      ShouldLoad:YES
                                                           Async:YES];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, rainbowToolTexture);
    glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
    
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
    
    //    glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_TRUE, sizeof(vertexDataTextured), &plain[0].normal);
    //    glEnableVertexAttribArray(ATTRIB_NORMAL);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    
    //    if (![self validateProgram:currentProgram]) {
    //        NSLog(@"Failed to validate program: (%d)", currentProgram);
    //    }
}



- (void)drawDrawingToolsBox{
       
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);    
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);
        
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:self.interfaceManager.drawingToolsBox.position.origin.x 
             OriginY:self.interfaceManager.drawingToolsBox.position.origin.y 
               Width:self.interfaceManager.drawingToolsBox.position.size.width
              Height:self.interfaceManager.drawingToolsBox.position.size.height 
            Rotation:0.0];
    
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    GLuint drawingToolsBoxTexture = [self.resourceManager getTexture:TEXTURE_DRAWING_TOOLS_BOX
                                                          Parameters:nil
                                                           InContext:resourceLoadingEAGLContext
                                                          ShouldLoad:YES
                                                               Async:YES];
                                     
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, drawingToolsBoxTexture);
    glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
    
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
    
    //    glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_TRUE, sizeof(vertexDataTextured), &plain[0].normal);
    //    glEnableVertexAttribArray(ATTRIB_NORMAL);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
}

- (void)drawPencil:(DrawingTool *)dt {
        
    if(dt.body_alpha == 1.0) {
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    } else {
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_TEXTURING_PLUS_ALPHA];
    glUseProgram(currentProgram);
    
    // handle viewing matrices
    GLfloat modelviewProj[16];
    //        [self MakeMatrix:modelviewProj OriginX:0 OriginY:150 Width:103 Height:37 Rotation:0.0];
    [self MakeMatrix:modelviewProj 
             OriginX:dt.position.origin.x 
             OriginY:dt.position.origin.y 
               Width:dt.position.size.width 
              Height:dt.position.size.height
            Rotation:0.0];
    
    // update uniform values
    glUniformMatrix4fv(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    glActiveTexture(GL_TEXTURE0);
    //        glBindTexture(GL_TEXTURE_2D, drawingToolBodyTextures[i]);
    glBindTexture(GL_TEXTURE_2D, drawingToolExtendedBodyTextures[dt.indexOfBodyTexture]);
    glUniform1i(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE], 0);
    
    glUniform1f(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA], dt.body_alpha);
    
    glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX);
    
    glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
    
    if (dt.isAnimated){
        //анимация
        if (dt.running_light2_alpha > 0.0){

            //        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
            //        glEnable(GL_BLEND);   
            //        glDisable(GL_BLEND);   

            glUseProgram(currentProgram);
            
            // handle viewing matrices
            GLfloat modelviewProj[16];
            //        [self MakeMatrix:modelviewProj OriginX:0 OriginY:150 Width:103 Height:37];
            [self MakeMatrix:modelviewProj 
                     OriginX:dt.running_light2_position.origin.x 
                     OriginY:dt.running_light2_position.origin.y 
                       Width:dt.running_light2_position.size.width 
                      Height:dt.running_light2_position.size.height 
                    Rotation:0.0];
            
            // update uniform values
            glUniformMatrix4fv(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            GLuint currentTexture = [self.resourceManager getTexture:CRAYON_RUNNING_LIGHT_2_TEXTURE
                                                          Parameters:nil
                                                           InContext:resourceLoadingEAGLContext
                                                          ShouldLoad:YES
                                                               Async:YES];

            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, currentTexture);
            glUniform1i(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE], 0);        
            glUniform1f(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA], dt.running_light2_alpha);
            glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
            glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX);
            
            glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
            glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS);
            
            glDrawArrays(GL_TRIANGLES, 0, 6);
            
//            if (![self validateProgram:currentProgram]) {
//                NSLog(@"Failed to validate program: (%d)", currentProgram);
//            }
        }
        if (dt.running_light1_alpha > 0.0){
            
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//            glBlendFunc(GL_ONE, GL_ZERO);
            
            glUseProgram(currentProgram);
            
            // handle viewing matrices
            GLfloat modelviewProj[16];
            [self MakeMatrix:modelviewProj 
                     OriginX:dt.running_light1_position.origin.x 
                     OriginY:dt.running_light1_position.origin.y 
                       Width:dt.running_light1_position.size.width 
                      Height:dt.running_light1_position.size.height 
                    Rotation:0.0];            
            // update uniform values
            glUniformMatrix4fv(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            GLuint currentTexture = [self.resourceManager getTexture:CRAYON_RUNNING_LIGHT_1_TEXTURE 
                                                          Parameters:nil
                                                           InContext:resourceLoadingEAGLContext
                                                          ShouldLoad:YES 
                                                               Async:YES];
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, currentTexture);
            glUniform1i(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE], 0);        
            glUniform1f(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA], dt.running_light1_alpha);
            //            NSLog(@"%@ : %@ dt.running_light2_alpha = %f", self, NSStringFromSelector(_cmd), dt.running_light2_alpha);
            glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
            glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX);
            
            glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
            glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS);
            
            glDrawArrays(GL_TRIANGLES, 0, 6);
            
            
//            if (![self validateProgram:currentProgram]) {
//                NSLog(@"Failed to validate program: (%d)", currentProgram);
//            }
        }
        if (dt.highlight_alpha > 0.0){
            
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//            glBlendFunc(GL_ONE, GL_ZERO);
            
            glUseProgram(currentProgram);
            
            // handle viewing matrices
            GLfloat modelviewProj[16];
            [self MakeMatrix:modelviewProj 
                     OriginX:dt.highlight_position.origin.x 
                     OriginY:dt.highlight_position.origin.y 
                       Width:dt.highlight_position.size.width 
                      Height:dt.highlight_position.size.height 
                    Rotation:0.0];
            
            // update uniform values
            glUniformMatrix4fv(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            GLuint currentTexture = [self.resourceManager getTexture:CRAYON_HIGHLIGHT_TEXTURE 
                                                          Parameters:nil
                                                           InContext:resourceLoadingEAGLContext
                                                          ShouldLoad:YES 
                                                               Async:YES];
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, currentTexture);
            glUniform1i(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE], 0);        
            glUniform1f(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA], dt.highlight_alpha);
            //            NSLog(@"%@ : %@ dt.running_light2_alpha = %f", self, NSStringFromSelector(_cmd), dt.running_light2_alpha);
            glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
            glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX);
            
            glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
            glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS);
            
            glDrawArrays(GL_TRIANGLES, 0, 6);
            
//            if (![self validateProgram:currentProgram]) {
//                NSLog(@"Failed to validate program: (%d)", currentProgram);
//            }
        }
        
        if (dt.running_shadow_alpha > 0.0){
            
//            glBlendFunc(GL_ONE, GL_ZERO);
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
            
            glUseProgram(currentProgram);
            
            // handle viewing matrices
            GLfloat modelviewProj[16];
            //        [self MakeMatrix:modelviewProj OriginX:0 OriginY:150 Width:103 Height:37];
            [self MakeMatrix:modelviewProj 
                     OriginX:dt.running_shadow_position.origin.x 
                     OriginY:dt.running_shadow_position.origin.y 
                       Width:dt.running_shadow_position.size.width 
                      Height:dt.running_shadow_position.size.height
                    Rotation:0.0];
            
            // update uniform values
            glUniformMatrix4fv(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            
            GLuint currentTexture = [self.resourceManager getTexture:CRAYON_RUNNING_SHADOW_TEXTURE
                                                          Parameters:nil
                                                           InContext:resourceLoadingEAGLContext
                                                          ShouldLoad:YES 
                                                               Async:YES];
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, currentTexture);
            glUniform1i(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE], 0);        
            glUniform1f(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA], dt.running_shadow_alpha);
            //            NSLog(@"%@ : %@ dt.running_light2_alpha = %f", self, NSStringFromSelector(_cmd), dt.running_light2_alpha);
            glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
            glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX);
            
            glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
            glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS);
            
            glDrawArrays(GL_TRIANGLES, 0, 6);
            
//            if (![self validateProgram:currentProgram]) {
//                NSLog(@"Failed to validate program: (%d)", currentProgram);
//            }
        }
    }
}

- (void)drawDrawingTools{
    glDisable(GL_DEPTH_TEST);
    
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    glEnable(GL_BLEND);    
       
    for (int i=0; i<[self.interfaceManager.drawingToolsBox.drawingTools count]; i++)
    {
        
        DrawingTool *dt = [self.interfaceManager.drawingToolsBox.drawingTools objectAtIndex:i];
        
        [self drawPencil:dt];
        
        for (int j=0; j<[dt.drawingToolsExtended count]; j++){
            DrawingToolExtended *dte = [dt.drawingToolsExtended objectAtIndex:j];
            
            if (dte.state != DRAWING_TOOL_EXTENDED_STATE_INACTIVE) {
                [self drawPencil:dte];
            }
        }
    }
}

- (void)drawGLButton:(GLButton *)button {
    glEnable(GL_BLEND);
    
    if(button.alpha == 1.0) {
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    } else {
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_TEXTURING_PLUS_ALPHA];
    glUseProgram(currentProgram);
    
    // handle viewing matrices
    GLfloat modelviewProj[16];
    //        [self MakeMatrix:modelviewProj OriginX:0 OriginY:150 Width:103 Height:37 Rotation:0.0];
    [self MakeMatrix:modelviewProj 
             OriginX:button.position.origin.x 
             OriginY:button.position.origin.y 
               Width:button.position.size.width 
              Height:button.position.size.height
            Rotation:0.0];
    
    // update uniform values
    glUniformMatrix4fv(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);

    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
    glActiveTexture(GL_TEXTURE0);
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:button.identificator], @"buttontype", 
                                [NSNumber numberWithInt:app.paintMode], @"paintingmode", 
                                [NSNumber numberWithInt:self.interfaceManager.currentBook.number], @"booknumber", 
                                [NSNumber numberWithInt:self.interfaceManager.currentPage.number], @"pagenumber",
                                
                                nil];
    glBindTexture(GL_TEXTURE_2D, [self.resourceManager getTexture:BUTTON_TEXTURE
                                                       Parameters:parameters
                                                        InContext:resourceLoadingEAGLContext    
                                                       ShouldLoad:YES 
                                                            Async:YES]);


    glUniform1i(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE], 0);
    
    glUniform1f(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA], button.alpha);
    
    glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX);
    
    glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
}

- (void)drawButtons{

    for (GLButton *button in self.interfaceManager.buttons) {
        //TO-DO: проверка ifShouldDraw...
        [self drawGLButton:button];
    }
}

- (void)drawUndoLights
{

    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);
    
    for (int i=0; i<MAX_UNDO_COUNT; i++)
    {

        GLfloat modelviewProj[16];
        GLuint drawingToolsBoxTexture;
        
        if (self.countOfUndoAvaible > i)
        {
        
        [self MakeMatrix:modelviewProj 
                 OriginX: (self.interfaceManager.eraserPlusUndo.position.origin.x + i * 22)
                 OriginY: (self.interfaceManager.eraserPlusUndo.position.origin.y + 43 - i * 6.3)
                   Width:23
                  Height:26
                Rotation:0.0];    
            
            drawingToolsBoxTexture = [self.resourceManager getTexture:UNDO_LIGHT_ON_TEXTURE
                                                           Parameters:nil
                                                            InContext:resourceLoadingEAGLContext
                                                           ShouldLoad:YES
                                                                Async:YES];
        }
        
        else {
            [self MakeMatrix:modelviewProj 
                     OriginX: (self.interfaceManager.eraserPlusUndo.position.origin.x + 2 + i * 22)
                     OriginY: (self.interfaceManager.eraserPlusUndo.position.origin.y + 48 - i * 6.3)
                       Width:17
                      Height:18
                    Rotation:0.0];    
            
            drawingToolsBoxTexture = [self.resourceManager getTexture:UNDO_LIGHT_OFF_TEXTURE
                                                           Parameters:nil
                                                            InContext:resourceLoadingEAGLContext
                                                           ShouldLoad:YES
                                                                Async:YES];            
        }
        
        // update uniform values
        glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);

    
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, drawingToolsBoxTexture);
        glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
        
        
        glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
        glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
            
        glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
        glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
        
        glDrawArrays(GL_TRIANGLES, 0, 6);
        
    }
}

- (void)drawEraser{
    glEnable(GL_BLEND);

    if(self.interfaceManager.eraserPlusUndo.alpha == 1.0) {
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    } else {
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_TEXTURING_PLUS_ALPHA];
    glUseProgram(currentProgram);
    
    // handle viewing matrices
    GLfloat modelviewProj[16];
    //        [self MakeMatrix:modelviewProj OriginX:0 OriginY:150 Width:103 Height:37 Rotation:0.0];
    [self MakeMatrix:modelviewProj 
             OriginX:self.interfaceManager.eraserPlusUndo.position.origin.x 
             OriginY:self.interfaceManager.eraserPlusUndo.position.origin.y 
               Width:self.interfaceManager.eraserPlusUndo.position.size.width 
              Height:self.interfaceManager.eraserPlusUndo.position.size.height
            Rotation:0.0];
    
    // update uniform values
    glUniformMatrix4fv(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    glActiveTexture(GL_TEXTURE0);
    
    textureID currentTextureID = [self.interfaceManager getTextureIDForEraserPlusUndo];
    
    glBindTexture(GL_TEXTURE_2D, [self.resourceManager getTexture:currentTextureID
                                                       Parameters:nil
                                                        InContext:resourceLoadingEAGLContext 
                                                       ShouldLoad:YES 
                                                            Async:YES]);
    
    glUniform1i(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_TEXTURE], 0);
    
    glUniform1f(texture_plus_alpha_uniforms[TEXTURE_PLUS_ALPHA_UNIFORM_ALPHA], self.interfaceManager.eraserPlusUndo.alpha);
    
    glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_VERTEX);
    
    glVertexAttribPointer(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(TEXTURE_PLUS_ALPHA_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_UNDO_LIGHTS])
    {
        [self drawUndoLights];
    }
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
}

- (void)drawSliderBg{
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:SLIDER_IMAGE_ORIGIN_X 
             OriginY:SLIDER_IMAGE_ORIGIN_Y 
               Width:SLIDER_IMAGE_WIDTH 
              Height:SLIDER_IMAGE_HEIGHT
            Rotation:0.0];
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    GLuint texture = [self.resourceManager getTexture:SLIDER_BACKGROUND_TEXTURE 
                                           Parameters:nil
                                            InContext:resourceLoadingEAGLContext
                                           ShouldLoad:YES 
                                                Async:YES];    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
    
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
}

- (void)drawToolSizeAndColorIndicator{
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_TEXTURING_PLUS_COLOR_CHANGE];
    
    // Use shader program.
    glUseProgram(currentProgram);

    CGRect coords = [self.interfaceManager getToolSizeAndColorIndicatorRect];
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:coords.origin.x
             OriginY:coords.origin.y
               Width:coords.size.width
              Height:coords.size.height
            Rotation:0.0];
    
    // update uniform values
    glUniformMatrix4fv(texturing_plus_color_change_uniforms[PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    GLuint texture = [self.resourceManager getTexture:TOOL_COLOR_AND_SIZE_INDICATOR_TEXTURE
                                           Parameters:nil
                                            InContext:resourceLoadingEAGLContext
                                           ShouldLoad:YES 
                                                Async:YES];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(texturing_plus_color_change_uniforms[PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_TEXTURE], 0);
    
    glUniform4fv(texturing_plus_color_change_uniforms[PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_UNIFORM_NEW_COLOR], 1, [self.interfaceManager getToolSizeAndColorIndicatorColor]);
    
    glVertexAttribPointer(PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_ATTRIB_VERTEX);
    
    glVertexAttribPointer(PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(PROGRAM_TEXTURING_PLUS_COLOR_CHANGE_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
//    if (![self validateProgram:currentProgram]) {
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
}


- (void)drawUI 
{
    if  ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_DRAWING_TOOLS_BOX])
    {
        [self drawDrawingToolsBox];
        [self drawDrawingTools];
        [self drawRainbowTool];
        [self drawRainbowToolIndicator];
        [self drawGLButton:self.interfaceManager.drawingToolsBox.customColorButton];

    }
    [self drawButtons];
    [self drawEraser];
    if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_TOOL_SIZE_SLIDER]){
        [self drawSliderBg];
        [self drawToolSizeAndColorIndicator];
    }
}

- (void)drawGalleryBookCover
{
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);    
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX:0 
             OriginY:133 
               Width:768
              Height:532
            Rotation:0.0];
    
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    GLuint drawingToolsBoxTexture = [self.resourceManager getTexture:GALLERY_BOOK_COVER_TEXTURE
                                                          Parameters:nil
                                                           InContext:resourceLoadingEAGLContext
                                                          ShouldLoad:YES
                                                               Async:NO];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, drawingToolsBoxTexture);
    glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
    
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)drawUpperBookGallery{
    
//    glDepthFunc(GL_LESS);
//    glEnable(GL_DEPTH_TEST);
    
    GLuint currProgram = [self.resourceManager getProgram:PROGRAM_BASIC_LIGHTNING];
    
    glUseProgram(currProgram);
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glViewport(0, -2 * GALLERY_SELECT_BOOK_UPPER_OFFSET_Y, 768, 1024 + 2 * GALLERY_SELECT_BOOK_UPPER_OFFSET_Y);
    
    GLfloat modelviewProj[16];
    
    //    
    
    for (SheetColored *sh in self.interfaceManager.gallerySelectBookUpper.sheets){
        
        if ([self.interfaceManager.gallerySelectBookUpper shouldDrawSheet:sh]){
            
            [self MakePerspectiveMatrix:modelviewProj 
                                OriginX:0.0 
                                OriginY:0.0 
                                  Width:SCREEN_WIDTH 
                                 Height:SCREEN_HEIGHT
                               Rotation:sh.rotationY
                           TranslationX:sh.translationX
                           TranslationY:sh.translationY 
                           TranslationZ:sh.translationZ
                                 ScaleX:sh.scaleX
                                 ScaleY:SCREEN_HEIGHT/(SCREEN_HEIGHT+ 2 * GALLERY_SELECT_BOOK_UPPER_OFFSET_Y) * sh.scaleY];
            
            
            vertexDataTextured *model = (vertexDataTextured *)[self.resourceManager getModel:MODEL_SHEET_COLORED];
            
            // update uniform values
            
            glUniformMatrix4fv(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            glUniform1f(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_ROTATION], degreeToRadians(-sh.rotationY));
            
            glActiveTexture(GL_TEXTURE0);
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:sh.number], @"booknumber", 
                                        nil];
            
            GLuint texture = [self.resourceManager getTexture:BOOK_COVER_TEXTURE
                                                   Parameters:parameters
                                                    InContext:resourceLoadingEAGLContext 
                                                   ShouldLoad:sh.shouldLoadTextureIfUnloaded 
                                                        Async:NO];
            
            GLuint paperTexture = [self.resourceManager getTexture:TEXTURE_PAPER 
                                                        Parameters:nil
                                                         InContext:resourceLoadingEAGLContext
                                                        ShouldLoad:YES 
                                                             Async:YES];
            if (texture){

            
                if (texture){
                    glBindTexture(GL_TEXTURE_2D, texture);
                } else {
                    glBindTexture(GL_TEXTURE_2D, paperTexture);
                }
                
                glActiveTexture(GL_TEXTURE1);
                glBindTexture(GL_TEXTURE_2D, paperTexture);
                glUniform1i(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_PAPER_TEXTURE], 1);
                
                
                glUniform1i(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_TEXTURE], 0);
                
                glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].vertex);
                glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_VERTEX);
                
                //            glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_NORMAL, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].normal);
                //            glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_NORMAL);
                
                glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].texCoord);
                glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_TEX_COORDS);
                
                glDrawArrays(GL_TRIANGLES, 0, 6);  
                
                //            if (![self validateProgram:currProgram]) {
                //                NSLog(@"Failed to validate program: (%d)", currProgram);
                //            }
                
            }
        }
    }
}
- (void)drawLowerBookGallery{
    
    GLuint currProgram = [self.resourceManager getProgram:PROGRAM_BASIC_LIGHTNING];
    
    glUseProgram(currProgram);
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glViewport(0, -2 * GALLERY_SELECT_BOOK_LOWER_OFFSET_Y, 768, 1024 + 2 * GALLERY_SELECT_BOOK_LOWER_OFFSET_Y);
    
    GLfloat modelviewProj[16];
    
    for (SheetColored *sh in self.interfaceManager.gallerySelectBookLower.sheets){
        
        if ([self.interfaceManager.gallerySelectBookLower shouldDrawSheet:sh]){
            
            [self MakePerspectiveMatrix:modelviewProj 
                                OriginX:0.0 
                                OriginY:0.0 
                                  Width:SCREEN_WIDTH 
                                 Height:SCREEN_HEIGHT
                               Rotation:sh.rotationY
                           TranslationX:sh.translationX
                           TranslationY:sh.translationY 
                           TranslationZ:sh.translationZ
                                 ScaleX:sh.scaleX
                                 ScaleY:SCREEN_HEIGHT/(SCREEN_HEIGHT+ 2 * GALLERY_SELECT_BOOK_LOWER_OFFSET_Y) * sh.scaleY];
            
            
            vertexDataTextured *model = (vertexDataTextured *)[self.resourceManager getModel:MODEL_SHEET_COLORED];
            
            // update uniform values
            
            glUniformMatrix4fv(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            glUniform1f(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_ROTATION], degreeToRadians(-sh.rotationY));
            
            glActiveTexture(GL_TEXTURE0);
            
            int booknumber = sh.number + [self.interfaceManager.gallerySelectBookUpper.sheets count];
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:booknumber], @"booknumber", 
                                        nil];
            
            GLuint texture = [self.resourceManager getTexture:BOOK_COVER_TEXTURE
                                                   Parameters:parameters
                                                    InContext:resourceLoadingEAGLContext 
                                                   ShouldLoad:sh.shouldLoadTextureIfUnloaded 
                                                        Async:NO];
            
            GLuint paperTexture = [self.resourceManager getTexture:TEXTURE_PAPER 
                                                        Parameters:nil
                                                         InContext:resourceLoadingEAGLContext
                                                        ShouldLoad:YES 
                                                             Async:YES];
            
            if (texture)
            {
            
                if (texture){
                    glBindTexture(GL_TEXTURE_2D, texture);
                } else {
                    glBindTexture(GL_TEXTURE_2D, paperTexture);
                }
                
                glActiveTexture(GL_TEXTURE1);
                glBindTexture(GL_TEXTURE_2D, paperTexture);
                glUniform1i(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_PAPER_TEXTURE], 1);
                
                glUniform1i(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_TEXTURE], 0);
                
                glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].vertex);
                glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_VERTEX);
                            
                glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].texCoord);
                glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_TEX_COORDS);
                
                glDrawArrays(GL_TRIANGLES, 0, 6);  
                
            }
                
        }
    }
}




- (void)drawGallery{
    
    if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_GALLERY_BOOK_COVER])
    {
        [self drawGalleryBookCover];
    }
    
    glDepthFunc(GL_LESS);
    glEnable(GL_DEPTH_TEST);
    
    GLuint currProgram = [self.resourceManager getProgram:PROGRAM_BASIC_LIGHTNING];
    
    glUseProgram(currProgram);
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glViewport(0, 0, 768, 1024 + 2 * GALLERY_OFFSET_Y);
    
    GLfloat modelviewProj[16];
    
    for (Sheet *sh in self.interfaceManager.gallery.sheets){
        
        if ([self.interfaceManager.gallery shouldDrawSheet:sh]){
            
            [self MakePerspectiveMatrix:modelviewProj 
                                OriginX:0.0 
                                OriginY:0.0 
                                  Width:SCREEN_WIDTH 
                                 Height:SCREEN_HEIGHT
                               Rotation:sh.rotationY
                           TranslationX:sh.translationX 
                           TranslationY:sh.translationY 
                           TranslationZ:sh.translationZ
                                 ScaleX:sh.scaleX
                                 ScaleY:SCREEN_HEIGHT/(SCREEN_HEIGHT + 2 * GALLERY_OFFSET_Y) * sh.scaleY];
            
            
            vertexDataTextured *model;
            if (sh.type == SHEET_TYPE_LEFT){
                model = (vertexDataTextured *)[self.resourceManager getModel:MODEL_SHEET_LEFT];
            } else {
                model = (vertexDataTextured *)[self.resourceManager getModel:MODEL_SHEET_RIGHT];
            }
            
            
            // update uniform values
            
            glUniformMatrix4fv(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            glUniform1f(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_ROTATION], degreeToRadians(-sh.rotationY));
            

            glActiveTexture(GL_TEXTURE0);

            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.interfaceManager.currentBook.number], @"booknumber", [NSNumber numberWithInt:sh.number], @"pagenumber", nil];
            
            GLuint texture = [self.resourceManager getTexture:TEXTURE_BLACK_AND_WHITE_PICTURE
                                                   Parameters:parameters
                                                    InContext:resourceLoadingEAGLContext
                                                   ShouldLoad:YES 
                                                        Async:NO];
            
            GLuint paperTexture = [self.resourceManager getTexture:TEXTURE_PAPER 
                                                        Parameters:nil
                                                         InContext:resourceLoadingEAGLContext
                                                        ShouldLoad:YES 
                                                             Async:YES];
            
            
            if (texture)
            {
            
                if (texture){
                    glBindTexture(GL_TEXTURE_2D, texture);
                } else {
                    glBindTexture(GL_TEXTURE_2D, paperTexture);
                }
                
                glActiveTexture(GL_TEXTURE1);
                glBindTexture(GL_TEXTURE_2D, paperTexture);
                glUniform1i(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_PAPER_TEXTURE], 1);
                
                glUniform1i(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_TEXTURE], 0);
                
                glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].vertex);
                glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_VERTEX);
                
                glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].texCoord);
                glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_TEX_COORDS);
                
                glDrawArrays(GL_TRIANGLES, 0, 6);  
                
            }
        }
    }
}

- (void)drawGalleryColored{
    
    glDepthFunc(GL_LESS);
    glEnable(GL_DEPTH_TEST);
    
    GLuint currProgram = [self.resourceManager getProgram:PROGRAM_BASIC_LIGHTNING];
    
    glUseProgram(currProgram);
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glViewport(0, -2 * GALLERY_COLORED_OFFSET_Y, 768, 1024 + 2 * GALLERY_COLORED_OFFSET_Y);
    
    GLfloat modelviewProj[16];
    
//    

      for (SheetColored *sh in self.interfaceManager.galleryColored.sheets){
          
        if ([self.interfaceManager.galleryColored shouldDrawSheet:sh]){
            
            [self MakePerspectiveMatrix:modelviewProj 
                                OriginX:0.0 
                                OriginY:0.0 
                                  Width:SCREEN_WIDTH 
                                 Height:SCREEN_HEIGHT
                               Rotation:sh.rotationY
                           TranslationX:sh.translationX
                           TranslationY:sh.translationY 
                           TranslationZ:sh.translationZ
                                 ScaleX:sh.scaleX
                                 ScaleY:SCREEN_HEIGHT/(SCREEN_HEIGHT+ 2 * GALLERY_COLORED_OFFSET_Y) * sh.scaleY];
            
            
            vertexDataTextured *model = (vertexDataTextured *)[self.resourceManager getModel:MODEL_SHEET_COLORED];

            // update uniform values
            
            glUniformMatrix4fv(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
            
            glUniform1f(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_ROTATION], degreeToRadians(-sh.rotationY));
            
            glActiveTexture(GL_TEXTURE0);
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:self.interfaceManager.currentBook.number], @"booknumber", 
                                        [NSNumber numberWithInt:sh.number], @"versionnumber",
                                        nil];
            
            GLuint texture = [self.resourceManager getTexture:TEXTURE_COLORING_PICTURE
                                                   Parameters:parameters
                                                    InContext:resourceLoadingEAGLContext 
                                                   ShouldLoad:sh.shouldLoadTextureIfUnloaded 
                                                        Async:NO];
            
            GLuint paperTexture = [self.resourceManager getTexture:TEXTURE_PAPER 
                                                        Parameters:nil
                                                         InContext:resourceLoadingEAGLContext
                                                        ShouldLoad:YES 
                                                             Async:YES];
            
            if (texture)
            {
            
                if (texture){
                    glBindTexture(GL_TEXTURE_2D, texture);
                } else {
                    glBindTexture(GL_TEXTURE_2D, paperTexture);
                }
                
                glActiveTexture(GL_TEXTURE1);
                glBindTexture(GL_TEXTURE_2D, paperTexture);
                glUniform1i(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_PAPER_TEXTURE], 1);
                
                
                glUniform1i(basic_lighting_uniforms[BASIC_LIGHTING_UNIFORM_TEXTURE], 0);
                
                glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].vertex);
                glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_VERTEX);
                
                //            glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_NORMAL, 3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].normal);
                //            glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_NORMAL);
                
                glVertexAttribPointer(BASIC_LIGHTING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &model[0].texCoord);
                glEnableVertexAttribArray(BASIC_LIGHTING_ATTRIB_TEX_COORDS);
                
                glDrawArrays(GL_TRIANGLES, 0, 6);  
                
    //            if (![self validateProgram:currProgram]) {
    //                NSLog(@"Failed to validate program: (%d)", currProgram);
    //            }
                
            }
        }
    }
}

// рисуем полки
- (void)drawPolkas
{
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);    
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);
    
// рисуем верхнюю полку    
    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj 
             OriginX: POLKA_UPPER_ORIGIN_X
             OriginY: POLKA_UPPER_ORIGIN_Y
               Width: POLKA_UPPER_WIDTH
              Height: POLKA_UPPER_HEIGHT
            Rotation: 0.0];
    
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    GLuint drawingToolsBoxTexture = [self.resourceManager getTexture:POLKA_TEXTURE
                                                          Parameters:nil
                                                           InContext:resourceLoadingEAGLContext
                                                          ShouldLoad:YES
                                                               Async:NO];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, drawingToolsBoxTexture);
    glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
    
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
// рисуем нижнюю полку

    GLfloat modelviewProj2[16];
    [self MakeMatrix:modelviewProj2 
             OriginX: POLKA_LOWER_ORIGIN_X
             OriginY: POLKA_LOWER_ORIGIN_Y
               Width: POLKA_LOWER_WIDTH
              Height: POLKA_LOWER_HEIGHT
            Rotation:0.0];
    
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj2);
            
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

// рисуем страницу выбора книг
- (void)drawBookSelectPage
{
    [self drawPolkas];
    
    if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_UPPER]) {
        [self drawUpperBookGallery];
    }
    
    if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_LOWER]) {
        [self drawLowerBookGallery];
    }
}


- (void) drawFrame:(CADisplayLink *)sender{   

    double currtime = CFAbsoluteTimeGetCurrent();
    
//#define FPS_COUNT_INTERVAL 50
//
//
//    frameCounter++;
//    if (frameCounter == FPS_COUNT_INTERVAL) {
////        NSLog(@"fps = %f",  frameCounter/(currtime - lastFPSCalculationTime) );
//        lastFPSCalculationTime = currtime;
//        frameCounter = 0;
//    }
    
    
    // Update physics
    [self.interfaceManager updatePhysics:currtime];

    if (!isProgramInBackground && !isDrawingTextureUsed) {
        
        //        NSLog(@"%@ : %@ , isDrawingTextureUsed = NO", self, NSStringFromSelector(_cmd));
        
        [self drawToTexture];
        
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        GLint framebufferWidth = 768;
        GLint framebufferHeight = 1024;                   
        glViewport(0, 0, framebufferWidth, framebufferHeight);
        
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_DEPTH_BUFFER_BIT);

        
        [self drawBackground];
        
        if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_UPPER]) {
            [self drawBookSelectPage];
        }

        if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_PAINTING]) {
////            if ([self.interfaceManager.painting shouldPlayAnimation:self.interfaceManager.painting.shadowing] &&
////                self.interfaceManager.painting.shadowing.alpha > 0.0){
////                [self drawPictureWithShading];
////            } else {
//                [self drawPicture];
////            }
            
            [self drawLayers];
        }
        
        if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_GALLERY])
            [self drawGallery];

        if ([self.interfaceManager shouldDrawInterfaceElement:INTERFACE_ELEMENT_GALLERY_COLORED])
            [self drawGalleryColored];
        
        glViewport(0, 0, 768, 1024);

        [self drawUI];
        
        for (FillingAnimation *an in self.interfaceManager.painting.animations) {
            for (StarAnimation *star in an.stars) {
                [self drawStar:star];
            }
        }                
  
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        [myEAGLContext presentRenderbuffer:GL_RENDERBUFFER];   
        
        if (notifyDelegateOnDraw){
            [self.interfaceManager OpenGLViewDidFinishProcessingNewImage];
            notifyDelegateOnDraw = NO;
        }
    }
}

#pragma mark - Drawing textures operations

- (void)clearDrawingTexture {
    
    
    if (isDrawingTextureUsed) {NSLog(@"WARNING!! isDrawingTextureUsed");}
    
    isDrawingTextureUsed = YES;
    
    glBindFramebuffer(GL_FRAMEBUFFER, drawingToTextureFramebuffer);
    
    glViewport(0, 0, 1024, 1024);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    isDrawingTextureUsed = NO;
}

- (void)copyTexture:(GLuint)textureToCopyFrom ToTexture:(GLuint)textureToCopyTo{
    
    isDrawingTextureUsed = YES;
    
    
    glBindFramebuffer(GL_FRAMEBUFFER, drawingToTextureFramebuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureToCopyTo, 0);
    
    glDisable(GL_DEPTH_TEST);
    
    glViewport(0, 0, 1024, 1024);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);    
    glDisable(GL_BLEND);  
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT); 
    
    GLuint currentProgram = [self.resourceManager getProgram:PROGRAM_SIMPLE_TEXTURING];
    glUseProgram(currentProgram);

    
    GLfloat modelviewProj[16];
    [self MakeMatrix:modelviewProj OriginX:0.0 OriginY:0.0 Width:768.0 Height:1024.0 Rotation:0.0];
    
    // update uniform values
    glUniformMatrix4fv(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_MODEL_VIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureToCopyFrom);
    glUniform1i(simple_texturing_uniforms[SIMPLE_TEXTURING_UNIFORM_TEXTURE], 0);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_VERTEX,3, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].vertex);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_VERTEX);
    
    glVertexAttribPointer(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS, 2, GL_FLOAT, GL_FALSE, sizeof(vertexDataTextured), &plain[0].texCoord);
    glEnableVertexAttribArray(SIMPLE_TEXTURING_ATTRIB_TEX_COORDS);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
//    if (![self validateProgram:currentProgram]) {
//        
//        NSLog(@"Failed to validate program: (%d)", currentProgram);
//    }
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, currentDrawingTexture, 0);
    
    isDrawingTextureUsed = NO;
}

- (GLubyte *)restoreCurrentDrawingTextureData{
//    NSLog(@"%@ : %@ begin", self, NSStringFromSelector(_cmd) );
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/SavedData/drawings/book%d/page%d/version%d.png", documents, self.interfaceManager.currentBook.number, self.interfaceManager.currentPage.number, self.interfaceManager.curentVersionNumber];
    
    NSLog(@"%@ : %@ restore filePath = %@", self, NSStringFromSelector(_cmd), filePath);
    
    
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (imagePathExists)
	{
        
//        GLubyte *readedTexture = (GLubyte *)malloc(560 * 800 * 4 * sizeof(GLubyte));
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//        NSUInteger len = [readeddata length];    
//        [readeddata getBytes:readedTexture length:len];   
        
        GLubyte *returnTexArray = (GLubyte *)malloc(1024 * 1024 * 4 * sizeof(GLubyte));
        
        int width = 1024;
        
        
//        for (int i=0; i<560; i++)
//            for (int j=0; j<800; j++) {
//                returnTexArray[4*(i + j * width) + 0] = readedTexture[4*(i + j * 560) + 0];
//                returnTexArray[4*(i + j * width) + 1] = readedTexture[4*(i + j * 560) + 1];
//                returnTexArray[4*(i + j * width) + 2] = readedTexture[4*(i + j * 560) + 2];
//                returnTexArray[4*(i + j * width) + 3] = readedTexture[4*(i + j * 560) + 3];
//            }
//        
//        free (readedTexture);
//        
        
        GLubyte *ptr = (GLubyte *)imageData.bytes;
        
        for (int i=0; i<560; i++)
            for (int j=0; j<800; j++) {
                returnTexArray[4*(i + j * width) + 0] = *(ptr + 4*(i + j * 560) + 0);
                returnTexArray[4*(i + j * width) + 1] = *(ptr + 4*(i + j * 560) + 1);
                returnTexArray[4*(i + j * width) + 2] = *(ptr + 4*(i + j * 560) + 2);
                returnTexArray[4*(i + j * width) + 3] = *(ptr + 4*(i + j * 560) + 3);
            }
        
        
//        NSLog(@"%@ : %@ end", self, NSStringFromSelector(_cmd) );
        
        return returnTexArray;
        //        return readedTexture;
	} 
    else {
        NSLog(@"%@ : %@ failed to restore image. Path %@ does not exist.", self, NSStringFromSelector(_cmd), filePath);
        
//        NSLog(@"%@ : %@ end", self, NSStringFromSelector(_cmd) );
        
        return NULL;
    }
}

- (void)saveCurrentDrawingTexture{
    NSLog(@"%@ : %@ begin", self, NSStringFromSelector(_cmd) );
    
    glBindFramebuffer(GL_FRAMEBUFFER, drawingToTextureFramebuffer);
    
	// allocate array and read pixels into it.
	GLubyte *tempImagebuffer = (GLubyte *) malloc(560 * 800 * 4);
        
    if (isDrawingTextureUsed) {NSLog(@"WARNING!! isDrawingTextureUsed");}
    isDrawingTextureUsed = YES;
    
    NSLog(@"%@ : %@ start glRead", self, NSStringFromSelector(_cmd));
    
    glReadPixels(0, 0, 560, 800, GL_RGBA, GL_UNSIGNED_BYTE, tempImagebuffer);
    isDrawingTextureUsed = NO;

    NSLog(@"%@ : %@ end glRead", self, NSStringFromSelector(_cmd));

    
    NSString* filePath = [self.interfaceManager pathForCurrentDrawingTextureSaveFile];
    NSLog(@"%@ : %@ save filePath = %@", self, NSStringFromSelector(_cmd), filePath);
    
    if (filePath)
    {
        NSData *mydata = [NSData dataWithBytes:tempImagebuffer length:560 * 800 * 4];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSError *error = nil;
            [mydata writeToFile:filePath options:NSDataWritingAtomic error:&error];
            if (error) {
                NSLog(@"%@ : %@ Write returned error: %@", self, NSStringFromSelector(_cmd), [error localizedDescription]);
            } 
            
            free(tempImagebuffer);

        });
        
    }
    

//    NSLog(@"%@ : %@ end", self, NSStringFromSelector(_cmd) );
}

// считывает raw массив из framebuffer и сохраняет в UIImage
// взято отсюда: http://www.bit-101.com/blog/?p=1861


- (void)saveCurrentDrawingSampleCompletionHandler:(void (^)())completionHandler
{
    
    
    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd) );
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_DEPTH_BUFFER_BIT);
    
    [self drawPicture];
    
    
	// allocate array and read pixels into it.
    int tempImagebufferLenght = 560 * 800 * 4;
	GLubyte *tempImagebuffer = (GLubyte *) malloc(tempImagebufferLenght);
    
    if (isDrawingTextureUsed) {NSLog(@"WARNING!! isDrawingTextureUsed");}
    
    isDrawingTextureUsed = YES;
    
    glReadPixels(PAINTING_ORIGIN_X,
                 SCREEN_HEIGHT-PAINTING_HEIGHT-PAINTING_ORIGIN_Y, 
                 PAINTING_WIDTH, 
                 PAINTING_HEIGHT, 
                 GL_RGBA, GL_UNSIGNED_BYTE, tempImagebuffer);
    
    //    NSLog(@"%@ : %@ glReadPixels ended", self, NSStringFromSelector(_cmd) );
    
    isDrawingTextureUsed = NO;
    
    NSString* filePath = [self.interfaceManager pathForCurrentColoredSampleSaveFile];
    NSLog(@"%@ : %@ save filePath = %@", self, NSStringFromSelector(_cmd), filePath);
    
    if (filePath)
    {
        
        // make data provider with data.
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, tempImagebuffer, tempImagebufferLenght, NULL);
        
        // prep the ingredients
        int bitsPerComponent = 8;
        int bitsPerPixel = 32;
        int bytesPerRow = 4 * 560;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
        CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
        
        // make the cgimage
        CGImageRef imageRef = CGImageCreate(560, 800, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
        
        CGDataProviderRelease(provider);
        
        // then make the uiimage from that
        UIImage *myImage = [UIImage imageWithCGImage:imageRef];
        
        
        //TO-DO: resize myImage
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSError *error = nil;
            [UIImagePNGRepresentation(myImage) writeToFile:filePath atomically:YES];        
            
            if (error) {
                NSLog(@"%@ : %@ Write returned error: %@", self, NSStringFromSelector(_cmd), [error localizedDescription]);
            }
            
            free(tempImagebuffer);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), completionHandler);
                        
        });
        
    } else {
        free(tempImagebuffer);
        
        NSLog(@"%@ : %@ Saving dir doesn't exists", self, NSStringFromSelector(_cmd));        
    }
}

#pragma mark - OpenGL setup functions

- (void)deleteAllResources
{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    glDeleteTextures(1, &drawingTexture);
    glDeleteTextures(1, &currentDrawingTexture);
    glDeleteTextures(1, &blackAndWhitePictureTexture);
    glDeleteTextures(12*5, (GLuint *)&drawingToolExtendedBodyTextures);
    glDeleteTextures(MAX_UNDO_COUNT, (GLuint *)&drawingTextures);
}

- (GLuint)textureForPencilOfColor:(UIColor *)color ReflexColor:(UIColor *)reflexcolor{
    
static void *GData = NULL;
//#define TEXTURESIZE			256
//#define TEXTURESIZE			64
    
#define TEXTURE_WIDTH 128
#define TEXTURE_HEIGHT 32
    
#define IMAGELIMIT			256
    
	if (GData == NULL) GData = malloc(4 * TEXTURE_WIDTH * TEXTURE_HEIGHT);
	CGColorSpaceRef cref = CGColorSpaceCreateDeviceRGB();
	CGContextRef gc = CGBitmapContextCreate(GData,
                                            TEXTURE_WIDTH,TEXTURE_HEIGHT,
                                            8,TEXTURE_WIDTH*4,
                                            cref,kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(cref);
	UIGraphicsPushContext(gc);
	
	[[UIColor colorWithWhite:0 alpha:0] setFill];
    CGRect r = CGRectMake(0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT);
	UIRectFill(r);
	
    CGContextRef ctx = gc;
    
    DrawingTool *dt = [self.interfaceManager.drawingToolsBox.drawingTools objectAtIndex:1];
    
    //Рисуем нераскрашенный (серый) карандаш из файла
    UIImage *graypencil; 
    graypencil = [UIImage imageNamed:@"universal_pencil_selected2.png"];
    if (!graypencil) NSLog(@"%@ : %@ Pencil: Failed to load image of graypencil", self, NSStringFromSelector(_cmd));
    
    [graypencil  drawInRect:CGRectMake(0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT)];

    int pencil_width1;
    {pencil_width1 = 101;};
    
    
#define pencil_width2 5
#define pencil_width3 35
#define pencil_width4 4
    
#define pencil_height1 5  
#define pencil_height2 8
#define pencil_height3 3    
    
//#define offsetY 33
#define offsetY TEXTURE_HEIGHT*0.129
    

    // рисуем clipping area для последующей заливки
    
    float scaleX = TEXTURE_WIDTH / dt.position.size.width;
    float scaleY = TEXTURE_HEIGHT / dt.position.size.height;
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0 * scaleX, 0 * scaleY + offsetY);
    CGContextAddLineToPoint(ctx, pencil_width1 * scaleX, 0 * scaleY + offsetY);
    CGContextAddLineToPoint(ctx, (pencil_width1+pencil_width2) * scaleX, pencil_height1 * scaleY + offsetY);
    CGContextAddLineToPoint(ctx, (pencil_width1+pencil_width2+pencil_width3) * scaleX, (pencil_height1+pencil_height2) * scaleY + offsetY);
    CGContextAddLineToPoint(ctx, (pencil_width1+pencil_width2+pencil_width3+pencil_width4)  * scaleX, (pencil_height1+pencil_height2+pencil_height3) * scaleY + offsetY);
    CGContextAddLineToPoint(ctx, (pencil_width1+pencil_width2+pencil_width3) * scaleX, (pencil_height1+pencil_height2+2*pencil_height3) * scaleY + offsetY);
    CGContextAddLineToPoint(ctx, (pencil_width1+pencil_width2) * scaleX, (pencil_height1+pencil_height2+2*pencil_height3+pencil_height2) * scaleY + offsetY);
    CGContextAddLineToPoint(ctx, (pencil_width1) * scaleX, (pencil_height1+pencil_height2+2*pencil_height3+pencil_height2+pencil_height1) * scaleY + offsetY);
    CGContextAddLineToPoint(ctx, 0  * scaleX, (pencil_height1+pencil_height2+2*pencil_height3+pencil_height2+pencil_height1) * scaleY + offsetY);
    CGContextClosePath(ctx);
    CGContextClip (ctx);
    
    // заливаем цветом карандаша
    
    CGContextSetLineWidth(ctx, 3);
    
    [color setFill];
    CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
    CGRect colorrect = CGRectMake(0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT);
    CGContextFillRect(ctx, colorrect);

    
    // рисуем рефлекс (блик от соседнего карандаша)
//    if (reflexcolor) {
//        [reflexcolor setFill];
//        CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
//        CGRect reflexrect = CGRectMake(0, 70, (pencil_width1-1) * scaleX, 15);
//        CGContextFillRect(ctx, reflexrect);
//    }

    
	
	UIGraphicsPopContext();
	CGContextRelease(gc);
    
	GLuint texture = 0;
	glGenTextures(1,&texture);
	[EAGLContext setCurrentContext:myEAGLContext];
	glBindTexture(GL_TEXTURE_2D,texture);
	glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA, TEXTURE_WIDTH, TEXTURE_HEIGHT, 0,GL_RGBA,GL_UNSIGNED_BYTE,GData);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	free(GData);
	GData = NULL;
	
	/*
	 *	Done.
	 */
	
    //    NSLog(@"FlowCoverView: imageToTexture returns texture = %d", texture);
    
	return texture;
}

- (BOOL)CheckForExtension: (NSString *)searchName{
    NSString *extensionString = [NSString stringWithCString:(const char *)glGetString(GL_EXTENSIONS) encoding:NSASCIIStringEncoding];
    NSArray *extensionsNames = [extensionString componentsSeparatedByString:@" "];
    return [extensionsNames containsObject: searchName];
}

- (void) checkForError{
    GLenum error = glGetError();
    if (error == GL_NO_ERROR) NSLog(@"OpenGL error status: No error has been recorded.");
    else if (error == GL_INVALID_ENUM) NSLog(@"OpenGL error status: An unacceptable value is specified for an enumerated argument." 
                                             @"The offending command is ignored and has no other side effect than to set the error flag.");
    else if (error == GL_INVALID_VALUE) NSLog(@"OpenGL error status: A numeric argument is out of range."
                                              @"The offending command is ignored and has no other side effect than to set the error flag.");
    else if (error == GL_INVALID_OPERATION) NSLog(@"OpenGL error status: The specified operation is not allowed in the current state."
                                                  @"The offending command is ignored and has no other side effect than to set the error flag.");
    else if (error == GL_INVALID_FRAMEBUFFER_OPERATION) NSLog(@"OpenGL error status: The command is trying to render to or read from the framebuffer "
                                                              @"while the currently bound framebuffer is not framebuffer complete"
                                                              @"(i.e. the return value from glCheckFramebufferStatus is not GL_FRAMEBUFFER_COMPLETE). "
                                                              @"The offending command is ignored and has no other side effect than to set the error flag.");
    else if (error == GL_OUT_OF_MEMORY) NSLog(@"OpenGL error status: There is not enough memory left to execute the command."
                                              @"The state of the GL is undefined, except for the state of the error flags, after this error is recorded.");
}

- (void) checkExtensions{
    int param; 
    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &param);
    NSLog(@"Maximum size of the texture == %d", param);
    glGetIntegerv(GL_DEPTH_BITS, &param);
    NSLog(@"Number of depth buffer planes == %d", param);
    glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, &param);
    NSLog(@"Number of stencil buffer planes == %d", param);
    glGetIntegerv(GL_STENCIL_BITS, &param);
    NSLog(@"Maximum number of vertex attributes == %d", param);
    glGetIntegerv(GL_MAX_VERTEX_UNIFORM_VECTORS, &param);
    NSLog(@"Maximum number of uniform vertex vectors == %d", param);
    glGetIntegerv(GL_MAX_FRAGMENT_UNIFORM_VECTORS, &param);
    NSLog(@"Maximum number of uniform fragment vectors == %d", param);   
    glGetIntegerv(GL_MAX_VARYING_VECTORS, &param);
    NSLog(@"Maximum number of varying vectors == %d", param);
    glGetIntegerv(GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS, &param);
    NSLog(@"Maximum number of texture units usable in a vertex shader == %d", param);
    glGetIntegerv(GL_MAX_TEXTURE_IMAGE_UNITS, &param);
    NSLog(@"Maximum number of texture units usable in a fragment shader == %d", param);
}

- (void)initDrawingTexturesCache{    
    glGenTextures(MAX_UNDO_COUNT, &drawingTextures[0]);
    for (int i=0; i<MAX_UNDO_COUNT; i++) {
        glBindTexture(GL_TEXTURE_2D, drawingTextures[i]);           
        
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        //        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        //        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1024, 1024, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    }
}


- (GLuint)setupAndMixWithAreasTextureWithImage:(UIImage *)image {   
    
//    NSLog(@"%@ : %@ begin", self, NSStringFromSelector(_cmd) );
    
    CGImageRef spriteImage = image.CGImage;
    if (!spriteImage) {
        NSLog(@"%@ : %@ Failed to load image %@", self, NSStringFromSelector(_cmd), image);
        exit(1);
    }
    
    //    size_t width = CGImageGetWidth(spriteImage);
    //    size_t height = CGImageGetHeight(spriteImage);
    size_t width = 1024;
    size_t height = 1024;
    
    GLubyte * spriteData = (GLubyte *) malloc(width*height*4 * sizeof(GLubyte));
    
    //    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, 
    //                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);  
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
    
//    if (!spriteContext) {
//        NSLog(@"%@ : %@ CGBitmapContextCreate failed for ColorSpace %d Image: %@", self, NSStringFromSelector(_cmd), CGImageGetColorSpace(spriteImage), image);
//    }
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 1024-800, 560, 800), spriteImage);
    CGContextRelease(spriteContext);
    
    // добавляем в текстуру в альфа-канал номер зоны
    
    
    for (int i=0; i<width; i++)
        for (int j=0; j<height; j++) {
            if (i < 560 && j < 800) {
                int area = [self.interfaceManager.painting getAreaX:i Y:j];
                if (area == UNPAINTED_AREA_NUMBER || area == BLACK_AREA_NUMBER) {
                    spriteData[4*(i + j * width) + 3] = (GLubyte)255;
                }
                else {
                    spriteData[4*(i + j * width) + 3] = (GLubyte)area;    
                }
            } else {
                spriteData[4*(i + j * width) + 3] = (GLubyte)255;                
            }
        }
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST); 
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    
//    NSLog(@"%@ : %@ end", self, NSStringFromSelector(_cmd) );
    
    return texName;    
}

- (void)setupAndMixWithAreasTexture:(GLuint)texture WithImage:(UIImage *)image {   
    
//    NSLog(@"%@ : %@ begin", self, NSStringFromSelector(_cmd) );
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGImageRef spriteImage = image.CGImage;
        if (!spriteImage) {
            NSLog(@"%@ : %@ Failed to load image %@", self, NSStringFromSelector(_cmd), image);
            exit(1);
        }
        
        //    size_t width = CGImageGetWidth(spriteImage);
        //    size_t height = CGImageGetHeight(spriteImage);
        size_t width = 1024;
        size_t height = 1024;
        
        GLubyte * spriteData = (GLubyte *) malloc(width*height*4 * sizeof(GLubyte));
        
        //    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, 
        //                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);  
        
        CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
        
        if (!spriteContext) {
            NSLog(@"%@ : %@ CGBitmapContextCreate failed for Image: %@", self, NSStringFromSelector(_cmd), image);
        }
        
        CGContextDrawImage(spriteContext, CGRectMake(0, 1024-800, 560, 800), spriteImage);
        CGContextRelease(spriteContext);
        
        // добавляем в текстуру в альфа-канал номер зоны
        
        
        for (int i=0; i<560; i++)
            for (int j=0; j<800; j++) 
            {
                int area = [self.interfaceManager.painting getAreaX:i Y:j];

                if (area == UNPAINTED_AREA_NUMBER || area == BLACK_AREA_NUMBER) {
                    spriteData[4*(i + j * width) + 3] = (GLubyte)255;
                } else {
                    spriteData[4*(i + j * width) + 3] = (GLubyte)area;    
                }
            }

        
//        dispatch_sync(dispatch_get_main_queue(), ^{
            
            glBindTexture(GL_TEXTURE_2D, texture);
            
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST); 
            
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
            
            free(spriteData);        
            
//        });//end block
//    });

//    NSLog(@"%@ : %@ end", self, NSStringFromSelector(_cmd) );
}

- (GLuint)setupTexture:(NSString *)fileName {    
    // 1
    
    UIImage *resizedImage = [UIImage imageNamed:fileName];
    UIGraphicsBeginImageContext(CGSizeMake(512, 512));
    [resizedImage drawInRect:CGRectMake(0, 0, 512, 512)];
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    
    CGImageRef spriteImage = resizedImage.CGImage;
    if (!spriteImage) {
        NSLog(@"%@ : %@ Failed to load image %@", self, NSStringFromSelector(_cmd), fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, 
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);    
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);     
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;    
}

- (BOOL)validateProgram:(GLuint)prog{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

@end
