//
//  InterfaceManager.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 05.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceConstants.h"
#import "OpenGLViewController.h"
#import "Painting.h"
#import "DrawingToolsBox.h"
#import "ColorPickerViewController.h"
#import "GalleryAsInPaper.h"
#import "GalleryForColoredPics.h"
#import "GLButton.h"
#import "EraserPlusUndo.h"
#import "ResourcesConstants.h"
#import "DTLayer.h"

@class OpenGLViewController;
@class Painting;
@class DrawingToolsBox;
@class ColorPickerViewController;

@interface InterfaceManager : NSObject <GalleryDelegate, GalleryForColoredPicsDelegate, GLButtonDelegate, EraserPlusUndoDelegate, DrawingToolsBoxDelegate, ColorPickerDelegate>
{
    OpenGLViewController *delegate;
    
    interfaceState state;
    
    // книга и страница, которые раскрашиваем
    Book *currentBook;
    Page *currentPage;
    int curentVersionNumber;
    
    //режим выбора книги
    
    GalleryForColoredPics *gallerySelectBookUpper;
    GalleryForColoredPics *gallerySelectBookLower;
    
    //режим выбора страницы
    
    GalleryAsInPaper *gallery;
    GalleryForColoredPics *galleryColored;
    
    //режим раскраски
    
    
    
//    GLButton *clearPainting;
    
    NSArray *buttons;
    EraserPlusUndo *eraserPlusUndo;
    
//    UIButton *restartButton;
    UIButton *exitButton;
    UIButton *prevButton;
	UIButton *nextButton;
    UIButton *paintModeButton;
    UIButton *colorPickerButton;
    UIPopoverController* colorPickerPopover;
    ColorPickerViewController* colorPickerController;
    BrushSizeSlider* brushSizeSlider; 
    UIImageView *sliderImage;
    UIButton *eraserPlusUndoButton;
    
    UIImageView* paperShadow;
    UIImageView* examplePanel;
    UIImageView* exampleImage;
    UIImageView* cross;
    UIImageView* exampleImageOnButton;
    
@public
    UIButton *undoButton;
@protected    
    
       
    Painting *painting;
    DrawingToolsBox *drawingToolsBox;
    
}
@property interfaceState state;

@property (retain) Book *currentBook;
@property (retain) Page *currentPage;
@property int curentVersionNumber;

@property (assign) OpenGLViewController *delegate;
@property (readonly, retain) GalleryAsInPaper *gallery;
@property (readonly, retain) GalleryForColoredPics *galleryColored;
@property (readonly, retain) GalleryForColoredPics *gallerySelectBookUpper;
@property (readonly, retain) GalleryForColoredPics *gallerySelectBookLower;
@property (readonly, retain) Painting *painting;
@property (readonly, retain) DrawingToolsBox *drawingToolsBox;
@property (nonatomic, retain) UIPopoverController* colorPickerPopover;
@property (nonatomic, retain) BrushSizeSlider* brushSizeSlider; 
@property (nonatomic, retain) UIImageView *sliderImage;
@property (retain) ColorPickerViewController* colorPickerController;
@property (readonly, retain) NSArray *buttons;
@property (readonly, retain) EraserPlusUndo *eraserPlusUndo;

@property int activeLayerNumber;
@property (nonatomic, retain) NSMutableArray *layers;

//@property (readonly) GLButton *clearPainting;

- (id)initWithState:(interfaceState)newState;

- (void)changeStateTo:(interfaceState)newState;

- (void)setup;

//- (void)newDrawingToolSelected:(DrawingTool *)dt;
//- (void)colorPickerPressed:(id)sender;

- (void)updatePhysics:(double)currtime;

- (void)touchBeganAtLocation:(CGPoint)location;
- (void)touchesMovedLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation;
- (void)touchesEndedLocation:(CGPoint)location;
- (void)touchesCancelledLocation:(CGPoint)location;

- (BOOL)shouldDrawInterfaceElement:(interfaceElementID)interfaceElement;
- (BOOL)shouldLoadGalleryTextureForSheet:(SheetColored *)sheetColored;
- (BOOL)shouldSaveDrawingTexture;
- (NSString *)pathForCurrentDrawingTextureSaveFile;
- (NSString *)pathForCurrentColoredSampleSaveFile;
- (textureID)getTextureIDForEraserPlusUndo;

- (void)unloadColoredGallery;

- (CGRect)getToolSizeAndColorIndicatorRect;
- (GLfloat *)getToolSizeAndColorIndicatorColor;

- (void)OpenGLViewDidFinishProcessingNewImage;

- (void)disablePrevOrNextButtonIfNessesarily;

- (void)freeData;
- (void)releaseViewsAndObjects;
@end
