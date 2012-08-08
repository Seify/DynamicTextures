//
//  PaintImageController.h
//  DynamicTextures
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintImageView.h"
#import "PaintingView.h"
#import "ColorPickerViewController.h"
#import "SilhuetteView.h"
#import "ColorShower.h"
#import "Pencil.h"
#import "BookManager.h"
#import "Page.h"

@class PaintingView;
@class ColorPickerViewController;

@interface PaintImageController : UIViewController<ANColorPickerDelegate, ColorPickerDelegate> {
	
	IBOutlet UIButton* eraserButton;
	IBOutlet UIButton* exitButton;
	IBOutlet UIButton* prevButton;
	IBOutlet UIButton* nextButton;
	IBOutlet UIButton* paintModeButton;
	
	IBOutlet UISlider* brushSizeSlider; 
    IBOutlet UIImageView *sliderImage;
    
	IBOutlet UIButton* colorPickerButton;
    IBOutlet ColorShower *colorCircleBig;
    IBOutlet ColorShower *colorCircleSmall;
    
    IBOutlet Pencil* pencil1;
    IBOutlet Pencil* pencil2;
    IBOutlet Pencil* pencil3;    
    IBOutlet Pencil* pencil4;    
    IBOutlet Pencil* pencil5;    
    IBOutlet Pencil* pencil6;    
    IBOutlet Pencil* pencil7;    
    IBOutlet Pencil* pencil8;    
    IBOutlet Pencil* pencil9;    
    IBOutlet Pencil* pencil10;    
    IBOutlet Pencil* pencil11;    
    IBOutlet Pencil* pencil12;    
	CGFloat currentRed;
	CGFloat currentGreen;
	CGFloat currentBlue;
	BOOL isCustomColorActive;
//	UIButton* prevPencilButton;
    Pencil *prevPencil;
    
	Pencil *defaultPencil;
    
	PaintingView* paintingView;
	UIImageView* paintingViewBg;
	
	SilhuetteView* silhuetteView;
	UIImageView* pinView;
	
	UIPopoverController* colorPickerPopover;
	ColorPickerViewController* colorPickerController;
	
	NSInteger imageIndex;
	
	CGFloat prevBrushSize;
	
	NSDate* lastClickedDate;
    
    NSArray *pencils;
    
    Book *currentBook;
    Page *currentPage;

    id <BookManagerDelegate> delegate;
}

@property (nonatomic, retain) UIPopoverController* colorPickerPopover;
@property (nonatomic, copy) NSDate* lastClickedDate;
@property (readonly) NSArray *pencils;

@property (retain) Book *currentBook;
@property (retain) Page *currentPage;

@property (retain) id <BookManagerDelegate> delegate;


- (void)selectInitialImage;
- (void)prevImage;
- (void)nextImage;
- (void)pickImage:(int) pickImageIndex;
- (void)restoreImageBookNumber:(int)booknumber PageNumber:(int)pagenumber;
- (UIImage*) addTextureToImage: (UIImage*) textureImage selectedImage:(UIImage*)selectedImage;

- (void)initPencils;
- (IBAction)pencilClicked:(Pencil *)sender;
- (IBAction)colorPickerButtonClicked:(id)sender;
- (IBAction)eraserClicked:(id)sender;
//- (void)sliderDragAction:(UISlider*)sender;
- (void)restoreEraser;

- (void)newColorButtonPressed:(UIButton *)sender;
- (void)setColorCirclesColorsRed:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha;
- (void)putDownOldPencil;

- (IBAction)exitPaintImage:(id)sender;
- (IBAction)restart:(id)sender;
- (IBAction)prev:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)publish:(id)sender;
- (IBAction)paintModeButtonClicked:(id)sender;
- (IBAction)undo:(id)sender;

- (void)processPaintingOfArea:(int)areanumber withRed:(float)red Green:(float)green Blue:(float)blue;


@end
