//
//  OpenGLViewController.h
//  Collections
//
//  Created by Roman Smirnov on 17.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "OpenGLView.h"
#import "ModelDataStructures.h"
#import "BookManager.h"
#import "BrushSizeSlider.h"
#import "ColorPickerViewController.h"
#import "DrawingTool.h"
#import "DrawingToolsBox.h"
#import "InterfaceManager.h"
#import "ResourceManager.h"

#define MAX_UNDO_COUNT 5

@class InterfaceManager;
@class DrawingToolsBox;
@class ColorPickerViewController;

@interface OpenGLViewController : UIViewController
{
@public
    
    OpenGLView *myOpenGLView; 
    EAGLContext *myEAGLContext;
    EAGLContext *resourceLoadingEAGLContext;
    CADisplayLink *displayLink;
    
    //буферы (FBO), в которые рисуем
    //основной (экранный) FBO
    GLuint framebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    //FBO для рисования в текстуру
    GLuint drawingToTextureFramebuffer;
    GLuint drawingToTextureDepthRenderBuffer;
    
    //счетчик fps
    double lastFPSCalculationTime;
    int frameCounter;
    
    //переменные для формирования матрицы ModelViewProjection
    vec3 rotation;
    vec3 rotationSpeed;
    vec3 scale;
    vec3 translation;
    
    // интерфейс
    InterfaceManager *interfaceManager;
        
    //текстуры (надо вынести в отдельный объект)
    GLuint drawingTexture;
    GLuint currentDrawingTexture;
    
    GLuint blackAndWhitePictureTexture; //раскрашиваемое изображение    
    GLuint drawingToolExtendedBodyTextures[12*5];
    
    // Undo Cache (надо вынести в отдельный объект)  
    int countOfUndoAvaible;
    int indexOfTextureToRewrite;
    GLuint drawingTextures[MAX_UNDO_COUNT];
    
    // для синхронизации отрисовки В текстуру и отрисовки этой текстуры на экран (не уверен, что нужно)
    BOOL isDrawingTextureUsed;
    
    // если программа в Background, нельзя делать вызовы OpenGL
    BOOL isProgramInBackground;
}

@property (retain) CADisplayLink *displayLink;
@property (retain, readonly) InterfaceManager *interfaceManager;

@property (readonly) BOOL canUndoPainting;
@property int countOfUndoAvaible;
@property int indexOfTextureToRewrite;

-(void) drawFrame:(CADisplayLink *)sender;
- (void)applicationWillResignActive;
- (void)applicationDidBecomeActive;
- (void)applicationWillEnterForeground;

- (void)processNewPageNumber:(NSNumber *)newpagenumber;

- (void)initBlackAndWhiteTexture;

- (void)loadDrawingTextureRestored:(BOOL)restored;
- (void)restoreTextureFromUndoCache;
- (void)saveCurrentDrawingTexture;
- (void)saveCurrentDrawingSampleCompletionHandler:(void (^)())completionHandler;
- (void)clearDrawingTexture;

- (void)addTextureToUndoCache;

- (void)deleteAllResources;

@end