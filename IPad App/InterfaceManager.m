//
//  InterfaceManager.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 05.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "InterfaceManager.h"
#import "DynamicTexturesAppDelegate.h"
#import "SoundManager.h"
#import "Mathematics.h"
#import "Constants.h"
#import "Pencil.h"
#import "ResourceManager.h"

@interface InterfaceManager()
{
    GLfloat indicatorColor[4];
    interfaceElementID activeGallery;
    
}
- (void)disablePrevOrNextButtonIfNessesarily;
- (BOOL)isLocation:(CGPoint)location OnInterfaceElement:(interfaceElementID)elementId;
//- (void)showButtonsAnimated:(BOOL)animated;
- (int)coloredSheetNumberFromSheetNumber:(int)sheetNumber;
- (int)sheetNumberFromColoredSheetNumber:(int)coloredSheetNumber;
@end

@implementation InterfaceManager

@synthesize delegate;
//@synthesize state;
@synthesize currentBook, currentPage;
@synthesize curentVersionNumber;
@synthesize colorPickerPopover;
@synthesize colorPickerController;
@synthesize brushSizeSlider, sliderImage;

- (interfaceState) state
{
    return state;
};

- (void)setState:(interfaceState)newstate{
//    NSLog(@"%@ : %@ newstate = %d", self, NSStringFromSelector(_cmd), newstate);
    state = newstate;
}

- (NSArray *)buttons{
    if (!buttons){
        NSMutableArray *tempArray = [NSMutableArray array];
        
        GLButton *button;
        
        // кнопка очистки раскрашиваемой картинки
        button = [[GLButton alloc] init];
        button.delegate = self;
        button.identificator = BUTTON_CLEAR_PAINTING;
        button.position = CGRectMake(BUTTON_CLEAR_PAINTING_OFFSET_X,
                                     BUTTON_CLEAR_PAINTING_OFFSET_Y, 
                                     BUTTON_CLEAR_PAINTING_WIDTH, 
                                     BUTTON_CLEAR_PAINTING_HEIGHT);
        
        button.touchArea =  CGRectMake(BUTTON_CLEAR_PAINTING_OFFSET_X,
                                       BUTTON_CLEAR_PAINTING_OFFSET_Y, 
                                       BUTTON_CLEAR_PAINTING_WIDTH, 
                                       BUTTON_CLEAR_PAINTING_HEIGHT - 100);
        
        button.shouldDisplace = YES;
        button.alpha = 0.0;
        [tempArray addObject:button];
        [button release];

        
        // кнопка предыдущей картинки
        button = [[GLButton alloc] init];
        button.delegate = self;
        button.identificator = BUTTON_PREVIOUS;
        button.position = CGRectMake(BUTTON_PREVIOUS_OFFSET_X,
                                     BUTTON_PREVIOUS_OFFSET_Y, 
                                     BUTTON_PREVIOUS_WIDTH, 
                                     BUTTON_PREVIOUS_HEIGHT);
        button.touchArea = button.position;
        button.shouldDisplace = YES;
        button.alpha = 0.0;
        [tempArray addObject:button];
        [button release];        
        
        // кнопка следующей картинки
        button = [[GLButton alloc] init];
        button.delegate = self;
        button.identificator = BUTTON_NEXT;
        button.position = CGRectMake(BUTTON_NEXT_OFFSET_X,
                                     BUTTON_NEXT_OFFSET_Y, 
                                     BUTTON_NEXT_WIDTH, 
                                     BUTTON_NEXT_HEIGHT);
        button.touchArea = button.position;
        button.shouldDisplace = YES;
        button.alpha = 0.0;
        [tempArray addObject:button];
        [button release];
        
        // кнопка изменение режима рисования
        button = [[GLButton alloc] init];
        button.delegate = self;
        button.identificator = BUTTON_CHANGE_PAINTING_MODE;
        button.position = CGRectMake(BUTTON_CHANGE_PAINTING_MODE_OFFSET_X,
                                     BUTTON_CHANGE_PAINTING_MODE_OFFSET_Y, 
                                     BUTTON_CHANGE_PAINTING_MODE_WIDTH, 
                                     BUTTON_CHANGE_PAINTING_MODE_HEIGHT);
        button.touchArea = button.position;
        button.shouldDisplace = YES;
        button.alpha = 0.0;
        [tempArray addObject:button];
        [button release];
        
        //кнопка возврата в галерею выбора картинки
        button = [[GLButton alloc] init];
        button.delegate = self;
        button.identificator = BUTTON_BACK_TO_GALLERY;
        button.position = CGRectMake(BUTTON_BACK_TO_GALLERY_OFFSET_X,
                                     BUTTON_BACK_TO_GALLERY_OFFSET_Y, 
                                     BUTTON_BACK_TO_GALLERY_WIDTH, 
                                     BUTTON_BACK_TO_GALLERY_HEIGHT);
        button.touchArea = button.position;
        button.shouldDisplace = YES;
        button.alpha = 0.0;
        [tempArray addObject:button];
        [button release];
        
        // кнопка показа образца
        button = [[GLButton alloc] init];
        button.delegate = self;
        button.identificator = BUTTON_SHOW_SAMPLE;
        button.position = CGRectMake(BUTTON_SHOW_SAMPLE_OFFSET_X,
                                     BUTTON_SHOW_SAMPLE_OFFSET_Y, 
                                     BUTTON_SHOW_SAMPLE_WIDTH, 
                                     BUTTON_SHOW_SAMPLE_HEIGHT);
        button.touchArea = button.position;
        button.shouldDisplace = NO;
        button.alpha = 0.0;
        [tempArray addObject:button];
        [button release];
        
        

        
        
        buttons = [NSArray arrayWithArray:tempArray];
        [buttons retain];
    }
    return buttons;
}

- (EraserPlusUndo *)eraserPlusUndo{
    if (!eraserPlusUndo){
        
        
        eraserPlusUndo = [[EraserPlusUndo alloc] init];
        eraserPlusUndo.delegate = self;
        eraserPlusUndo.position = CGRectMake(-ERASER_UNSELECTED_WIDTH,
                                     ERASER_UNSELECTED_OFFSET_Y, 
                                     ERASER_UNSELECTED_WIDTH, 
                                     ERASER_UNSELECTED_HEIGHT);
        eraserPlusUndo.alpha = 1.0;
    }
    
    return eraserPlusUndo;
}

- (GalleryAsInPaper *)gallery{
    if(!gallery) {
        gallery = [[GalleryAsInPaper alloc] init];
        gallery.delegate = self;
        gallery.state = GALLERY_STATE_SHOWING_PICS;
    }
    return gallery;
}

- (GalleryForColoredPics *)galleryColored{
    if(!galleryColored) {
        galleryColored = [[GalleryForColoredPics alloc] initWithType:GALLERY_TYPE_SIDES_SHEETS_FAR];
        galleryColored.delegate = self;
        galleryColored.state = GALLERY_COLORED_STATE_SHOWING_PICS;
        gallerySelectBookUpper.startPositionShiftLeft = 0;

    }
    return galleryColored;
}

- (GalleryForColoredPics *)gallerySelectBookUpper{
    if(!gallerySelectBookUpper) {
        gallerySelectBookUpper = [[GalleryForColoredPics alloc] initWithType:GALLERY_TYPE_FLAT];
        gallerySelectBookUpper.delegate = self;
        gallerySelectBookUpper.state = GALLERY_COLORED_STATE_SHOWING_PICS;
        gallerySelectBookUpper.startPositionShiftLeft = COLOR_HACK_CONSTANT;
    }
    return gallerySelectBookUpper;
}

- (GalleryForColoredPics *)gallerySelectBookLower{
    if(!gallerySelectBookLower) {
        gallerySelectBookLower = [[GalleryForColoredPics alloc] initWithType:GALLERY_TYPE_FLAT];
        gallerySelectBookLower.delegate = self;
        gallerySelectBookLower.state = GALLERY_COLORED_STATE_SHOWING_PICS;
        gallerySelectBookLower.startPositionShiftLeft = COLOR_HACK_CONSTANT;
    }
    return gallerySelectBookLower;
}

-(Painting *)painting{
    if (!painting){
        painting = [[Painting alloc] init];
        painting.delegate = self;
    }
    return painting;
}

- (DrawingToolsBox *)drawingToolsBox{
    if (!drawingToolsBox)
    {
        drawingToolsBox = [[DrawingToolsBox alloc] init];
        [drawingToolsBox changeStateTo:DRAWING_TOOLS_BOX_STATE_OUT_OF_SCREEN AtTime:CFAbsoluteTimeGetCurrent()];
        drawingToolsBox.delegate = self;
        drawingToolsBox.position = CGRectMake(-DRAWING_TOOLS_BOX_WIDTH, 
                                              DRAWING_TOOLS_BOX_OFFSET_Y, 
                                              DRAWING_TOOLS_BOX_WIDTH, 
                                              DRAWING_TOOLS_BOX_HEIGHT);
        
        [drawingToolsBox retain];
    }
    return drawingToolsBox;
}

#pragma mark - Init & Setup

- (id)init
{
    NSLog(@"%@ : %@ Using initWithState:INTERFACE_STATE_SHOWING_BOOKS", self, NSStringFromSelector(_cmd));
    return [self initWithState:INTERFACE_STATE_SHOWING_BOOKS];
}

- (id)initWithState:(interfaceState)newState
{
    if (self = [super init])
    {
        [self changeStateTo:newState];
    }
    return self;
}



- (void)setup{
    
    exitButton = [[UIButton alloc] initWithFrame:CGRectMake(28, 40, 115, 76)];
    [exitButton setImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.delegate.view addSubview:exitButton];
    [exitButton setEnabled:YES];
    exampleImageOnButton.hidden = YES;
    
    // Настраиваем slider выбора размера кисти    
    
    brushSizeSlider = [[BrushSizeSlider alloc] initWithFrame:CGRectMake(SLIDER_THUMB_ORIGIN_X, SLIDER_THUMB_ORIGIN_Y, SLIDER_THUMB_WIDTH, SLIDER_THUMB_HEIGHT)];
	brushSizeSlider.minimumValue = brushMinSize;
	brushSizeSlider.maximumValue = brushMaxSize;
	brushSizeSlider.continuous = NO;

	
	UIImage* thumbImage = [UIImage imageNamed:@"thumbSlider.png"];
	[brushSizeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
	[brushSizeSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
	
	UIImage* trackImage = [UIImage imageNamed:@"emptySliderTrack"];
	[brushSizeSlider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
	[brushSizeSlider setMaximumTrackImage:trackImage forState:UIControlStateNormal];
    
//    [brushSizeSlider addTarget:self action:@selector(sliderAction:) forControlEvents: UIControlEventAllTouchEvents];
    
    [brushSizeSlider addTarget:self action:@selector(sliderDragAction:) forControlEvents: UIControlEventTouchDragInside];
    [brushSizeSlider addTarget:self action:@selector(sliderDragAction:) forControlEvents: UIControlEventTouchDragOutside];

    [brushSizeSlider addTarget:self action:@selector(sliderTouchAction:) forControlEvents: UIControlEventTouchDown];

    [brushSizeSlider addTarget:self action:@selector(sliderTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
    
    [brushSizeSlider addTarget:self action:@selector(sliderTouchUpAction:) forControlEvents: UIControlEventTouchUpOutside];
    
    [self.delegate.view addSubview:brushSizeSlider];
    
    self.brushSizeSlider.alpha = 0;
    self.sliderImage.alpha = 0;
    [self.brushSizeSlider setEnabled:NO];
    
    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
    if (app.paintMode == paintModeSimple)
	{

        
        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeFill"];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];        
        
        
        //        [self setColorCirclesColorsRed:1.0 Green:0.0 Blue:0.0 Alpha:0.0];
        
    }
	else 
	{
        
        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeBorders2"];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
        
        //        [self setColorCirclesColorsRed:1.0 Green:0.0 Blue:0.0 Alpha:1.0];
        
	}

    paperShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PaperShadowNew.png"]];
	paperShadow.frame = CGRectMake(PAINTING_ORIGIN_X - 20, PAINTING_ORIGIN_Y, 600, 840);
    paperShadow.opaque = NO;
    paperShadow.alpha = 0.0;
	[self.delegate.view insertSubview:paperShadow atIndex:3];
    
    //картинка образца на кнопке
    UIImage *image = [[BookManager sharedInstance] imageForPage:self.currentPage InBook:self.currentBook];
    exampleImageOnButton = [[UIImageView alloc] initWithImage:image];
    exampleImageOnButton.frame = CGRectMake(20, 33, 100, 143);
    exampleImageOnButton.transform = CGAffineTransformMakeRotation(-0.065);
    exampleImageOnButton.hidden = YES;
    [self.delegate.view addSubview:exampleImageOnButton];
        
}

- (BOOL)isLocation:(CGPoint)location OnInterfaceElement:(interfaceElementID)elementId{
   
    BOOL retValue;
    
    switch (elementId) {
            
        case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
        {
            retValue = (location.x > GALLERY_SELECT_BOOK_UPPER_ORIGIN_X
                        && location.x < GALLERY_SELECT_BOOK_UPPER_ORIGIN_X + GALLERY_SELECT_BOOK_UPPER_WIDTH 
                        && location.y > GALLERY_SELECT_BOOK_UPPER_ORIGIN_Y 
                        && location.y < GALLERY_SELECT_BOOK_UPPER_ORIGIN_Y + GALLERY_SELECT_BOOK_UPPER_HEIGHT);
            break;
        }
            
        case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
        {
            retValue = (location.x > GALLERY_SELECT_BOOK_LOWER_ORIGIN_X
                        && location.x < GALLERY_SELECT_BOOK_LOWER_ORIGIN_X + GALLERY_SELECT_BOOK_LOWER_WIDTH 
                        && location.y > GALLERY_SELECT_BOOK_LOWER_ORIGIN_Y 
                        && location.y < GALLERY_SELECT_BOOK_LOWER_ORIGIN_Y + GALLERY_SELECT_BOOK_LOWER_HEIGHT);
            break;
        }
            
        case INTERFACE_ELEMENT_GALLERY:
        {
            retValue = (location.x > GALLERY_ORIGIN_X
                    && location.x < GALLERY_ORIGIN_X + GALLERY_WIDTH 
                    && location.y > GALLERY_ORIGIN_Y 
                    && location.y < GALLERY_ORIGIN_Y + GALLERY_HEIGHT);
            break;
        }   
            
        case INTERFACE_ELEMENT_GALLERY_COLORED:
        {
            retValue = (location.x > GALLERY_COLORED_ORIGIN_X
                        && location.x < GALLERY_COLORED_ORIGIN_X + GALLERY_COLORED_WIDTH 
                        && location.y > GALLERY_COLORED_ORIGIN_Y 
                        && location.y < GALLERY_COLORED_ORIGIN_Y + GALLERY_COLORED_HEIGHT);
            break;
        }  
            
            
            
        default:
            NSLog(@"%@ : %@ WARNING! Unexpected elementId", self, NSStringFromSelector(_cmd));
            break;
    }
    return retValue;
}

- (CGRect)getToolSizeAndColorIndicatorRect{
    
    float radius = TOOL_SIZE_AND_COLOR_INDICATOR_MIN_RADIUS + TOOL_SIZE_AND_COLOR_INDICATOR_SCALE_FACTOR * self.painting.brushSize;
    
    return CGRectMake(TOOL_COLOR_AND_SIZE_INDICATOR_CENTER_X - radius, 
                      TOOL_COLOR_AND_SIZE_INDICATOR_CENTER_Y - radius, 
                      2 * radius, 
                      2 * radius);
}

- (GLfloat *)getToolSizeAndColorIndicatorColor{
    
    GLfloat *brushColor = [self.painting getBrushColor];
    indicatorColor[0] = brushColor[0]*0.75;
    indicatorColor[1] = brushColor[1]*0.75;
    indicatorColor[2] = brushColor[2]*0.75;
    indicatorColor[3] = brushColor[3];
    
    return indicatorColor;
}

#pragma mark - Gesture handlers

- (void)touchBeganAtLocation:(CGPoint)location{
    
    switch (self.state) {
            
        case INTERFACE_STATE_SHOWING_BOOKS:
        {
            if ([self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_UPPER]){
                [self.gallerySelectBookUpper touchBeganAtLocation:location];
            }
            
            if ([self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_LOWER]){
                [self.gallerySelectBookLower touchBeganAtLocation:location];
            }
            
            break;
        }
            
        case INTERFACE_STATE_SHOWING_EXAMPLE:{
            [exampleImage removeFromSuperview];
            [exampleImage release];
            [examplePanel removeFromSuperview];
            [examplePanel release];
            [cross removeFromSuperview];
            [cross release];
            
            self.state = INTERFACE_STATE_PAINTING;
            
            break;
        }
            
        case INTERFACE_STATE_SHOWING_GALLERY:{
            
            //TO-DO process Exit button touch
            
            if ([self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY]){
                [self.gallery touchBeganAtLocation:location];
            }
            
            if ([self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY_COLORED]){
                [self.galleryColored touchBeganAtLocation:location];
            }          
            break;
        }

        case INTERFACE_STATE_MORPHING_SELECTED_BOOK_TO_GALLERY:
        case INTERFACE_STATE_MORPHING_GALLERY_TO_BOOK:
        case INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING:
        case INTERFACE_STATE_MORPHING_PAINTING_TO_GALLERY:
        case INTERFACE_STATE_CHANGING_PICTURES:{
            // do not process any touches
            break;
        }
        case INTERFACE_STATE_PAINTING:{
            
            //TO-DO process Exit button touch

            BOOL ShouldProcessPainting = YES;
            
            for (GLButton *button in self.buttons) {
                if ([button isIntersectsWithPoint:location])
                {
                    [button touchBeganAtLocation:location];
                    ShouldProcessPainting = NO;
                }
            }
            
            if (ShouldProcessPainting){
                if (isLocationOnPaintingView(location) ) {
                    
                    if (![self.painting areTherePlayingAnimations]){
                        [self.delegate addTextureToUndoCache];
                    }
                    
                    [self.painting touchBeganAtLocation:location];

                } 
            }

            
            if ([self.eraserPlusUndo isIntersectsWithPoint:location])
            {
                [self.eraserPlusUndo touchBeganAtLocation:location];
            }
            
            [drawingToolsBox touchBeganAtLocation:location];
            
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected interface manager state!", self, NSStringFromSelector(_cmd));
            break;
        }
    }
    
    
    
}

- (void)touchesMovedLocation:(CGPoint)location PreviousLocation:(CGPoint)previousLocation{
    
    switch (self.state) {
            
        case INTERFACE_STATE_SHOWING_BOOKS:
        {
            [self.gallerySelectBookUpper touchMovedAtLocation:location
                                             PreviousLocation:previousLocation
                                                InsideGallery:YES];
            
            [self.gallerySelectBookLower touchMovedAtLocation:location
                                             PreviousLocation:previousLocation
                                                InsideGallery:YES];

//            if ([self isLocation:previousLocation OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_UPPER] || [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_UPPER])
//            {
//                
//                BOOL inside = [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_UPPER];
//                [self.gallerySelectBookUpper touchMovedAtLocation:location
//                                                 PreviousLocation:previousLocation
//                                                    InsideGallery:inside];
//            }     
//
//            if ([self isLocation:previousLocation OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_LOWER] || [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_LOWER])
//            {
//                
//                BOOL inside = [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_LOWER];
//                [self.gallerySelectBookLower touchMovedAtLocation:location
//                                                 PreviousLocation:previousLocation
//                                                    InsideGallery:inside];
//            }     

        
        }
            
        case INTERFACE_STATE_SHOWING_EXAMPLE:{
            break;
        }

            
        case INTERFACE_STATE_SHOWING_GALLERY:{
            
            //TO-DO process Exit button touch
            
            if ([self isLocation:previousLocation OnInterfaceElement:INTERFACE_ELEMENT_GALLERY] || [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY])
            {
                
                BOOL inside = [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY];
                [self.gallery touchMovedAtLocation:location 
                                  PreviousLocation:previousLocation
                                     InsideGallery:inside];
            }     
            
            if ([self isLocation:previousLocation OnInterfaceElement:INTERFACE_ELEMENT_GALLERY_COLORED] || [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY_COLORED])
            {
                
                BOOL inside = [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY_COLORED];
                [self.galleryColored touchMovedAtLocation:location 
                                         PreviousLocation:previousLocation
                                            InsideGallery:inside];
            }              
            
            break;
        }
            
        case INTERFACE_STATE_MORPHING_SELECTED_BOOK_TO_GALLERY:
        case INTERFACE_STATE_MORPHING_GALLERY_TO_BOOK:
        case INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING:
        case INTERFACE_STATE_MORPHING_PAINTING_TO_GALLERY:
        case INTERFACE_STATE_CHANGING_PICTURES:{
            // do not process any touches
            break;
        }
        case INTERFACE_STATE_PAINTING:{
            for (GLButton *button in self.buttons) {
                [button touchMovedAtLocation:location PreviousLocation:previousLocation];
            }
            
            [self.eraserPlusUndo touchMovedAtLocation:location PreviousLocation:previousLocation];
            [self.painting touchMovedAtLocation:location PreviousLocation:previousLocation];
            [drawingToolsBox touchMovedAtLocation:location PreviousLocation:previousLocation];
            
            break;

        }
            
        default:{
            NSLog(@"%@ : %@ unexpected interface manager state!", self, NSStringFromSelector(_cmd));
            break;
        }
    }
}

- (void)touchesEndedLocation:(CGPoint)location{
    
    switch (self.state) {
            
        case INTERFACE_STATE_SHOWING_BOOKS:{
            BOOL inside = [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_UPPER];
            [self.gallerySelectBookUpper touchEndedAtLocation:location 
                                                InsideGallery:inside]; 
            
            inside = [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_BOOK_GALLERY_LOWER];
            [self.gallerySelectBookLower touchEndedAtLocation:location 
                                                InsideGallery:inside]; 
            
            break;
        }
            
        case INTERFACE_STATE_SHOWING_EXAMPLE:{
            break;
        }
            
        case INTERFACE_STATE_SHOWING_GALLERY:{
            
            //TO-DO process Exit button touch
            BOOL inside = [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY];
            [self.gallery touchEndedAtLocation:location 
                                 InsideGallery:inside]; 
            
            inside = [self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY_COLORED];
            [self.galleryColored touchEndedAtLocation:location
                                        InsideGallery:inside]; 

            break;
        }
            
        case INTERFACE_STATE_MORPHING_SELECTED_BOOK_TO_GALLERY:
        case INTERFACE_STATE_MORPHING_GALLERY_TO_BOOK:
        case INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING:
        case INTERFACE_STATE_MORPHING_PAINTING_TO_GALLERY:
        case INTERFACE_STATE_CHANGING_PICTURES:{
            // do not process any touches
            break;
        }
        case INTERFACE_STATE_PAINTING:{
            [self.painting touchEndedAtLocation:location];    
            
            for (GLButton *button in self.buttons) {
                [button touchEndedAtLocation:location];
            }
            
            [self.eraserPlusUndo touchEndedAtLocation:location];
            [drawingToolsBox touchEndedAtLocation:location];
            
            break;

        }
            
        default:{
            NSLog(@"%@ : %@ unexpected interface manager state!", self, NSStringFromSelector(_cmd));
            break;
        }
    }
}

- (void)touchesCancelledLocation:(CGPoint)location{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    switch (self.state) {
            
        case INTERFACE_STATE_SHOWING_BOOKS:
        {
            [self.gallerySelectBookUpper touchesCancelledLocation:location]; 
            [self.gallerySelectBookLower touchesCancelledLocation:location]; 
        }
            
        case INTERFACE_STATE_SHOWING_EXAMPLE:{
            break;
        }
            
        case INTERFACE_STATE_SHOWING_GALLERY:{
            
            //TO-DO process Exit button touch
            
            //    if ([self isLocation:location OnInterfaceElement:INTERFACE_ELEMENT_GALLERY]){
            [self.gallery touchesCancelledLocation:location]; 
            //    }
            
            [self.galleryColored touchesCancelledLocation:location]; 
            break;
        }
            
        case INTERFACE_STATE_MORPHING_SELECTED_BOOK_TO_GALLERY:
        case INTERFACE_STATE_MORPHING_GALLERY_TO_BOOK:
        case INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING:
        case INTERFACE_STATE_MORPHING_PAINTING_TO_GALLERY:
        case INTERFACE_STATE_CHANGING_PICTURES:{
            // do not process any touches
            break;
        }
        case INTERFACE_STATE_PAINTING:{
            [self.painting touchesCancelledLocation:location];    
            
            for (GLButton *button in self.buttons) {
                [button touchesCancelledLocation:location];
            }
            
            [self.eraserPlusUndo touchesCancelledLocation:location];
            [drawingToolsBox touchesCancelledLocation:location];
            
            break;

            
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected interface manager state!", self, NSStringFromSelector(_cmd));
            break;
        }
    }
}

#pragma mark - Save & Restore State

- (void)saveInterfaceState{
    [self.drawingToolsBox saveState];
    [self.painting saveState];
    [self.eraserPlusUndo saveState];
    [self.brushSizeSlider saveState];
}

- (void)restoreInterfaceState
{
    [self.drawingToolsBox restoreState];
    [self.painting restoreState];
//    [self.eraserPlusUndo restoreState];
    [self.brushSizeSlider restoreState];
    self.painting.brushSize = self.brushSizeSlider.value;
}

- (void)saveColoredSampleIfNessesary {
    switch (self.painting.currentPictureState) {
        case PICTURE_STATE_NEW_UNMODIFIED:
        case PICTURE_STATE_EXISTING_UNMODIFIED:
        {
            //картинка не менялась, сохранять ненужно
            break;
        }
            
        case PICTURE_STATE_EXISTING_MODIFIED:
        {
            // сохраняем картинку вместо старой и обновляем текстуру в галерее сэмплов
            [self.delegate saveCurrentDrawingSampleCompletionHandler:^(){
                
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:self.currentBook.number], @"booknumber",
                                            [NSNumber numberWithInt:self.currentPage.number], @"pagenumber",
                                            [NSNumber numberWithInt:self.curentVersionNumber], @"pageversionnumber",
                                            nil];
                
                [[ResourceManager sharedInstance] deleteColorGalleryTextureParameters:parameters];
            }
             ];
            
            break;
        }
            
        case PICTURE_STATE_NEW_MODIFIED:
        {
            // добавляем лист в галлерею, сохраняем новую картинку и обновляем текстуры в галерее сэмплов
            
            [self.galleryColored addEmptySheetInTheEnd];
            
            [self.delegate saveCurrentDrawingSampleCompletionHandler:^(){
                                
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:self.currentBook.number], @"booknumber",
                                            [NSNumber numberWithInt:self.currentPage.number], @"pagenumber",
                                            [NSNumber numberWithInt:self.curentVersionNumber], @"pageversionnumber",
                                            nil];
                [[ResourceManager sharedInstance] deleteColorGalleryTexturesInRightParameters:parameters];
            }];
            
            break;
            
        }
            
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected picture state: %d", self, NSStringFromSelector(_cmd), self.painting.currentPictureState);
            break;
        }
    }
}


#pragma mark - Button's handlers

- (void)buttonPressed:(id)button{
//    NSLog(@"%@ : %@ button: %@", self, NSStringFromSelector(_cmd), button);
    
    SoundManager *sm = [SoundManager sharedInstance];        
    GLButton *sender = (GLButton *)button;
    switch (sender.identificator) 
    {
        case BUTTON_CLEAR_PAINTING:{
            [self restartButtonPressed];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_3.mp3", [[NSBundle mainBundle] resourcePath]];  
            [sm playEffectFilePath:soundFilePath];

            break;
        }
            
        case BUTTON_PREVIOUS:{
            [self prevButtonPressed];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_3.mp3", [[NSBundle mainBundle] resourcePath]];  
            [sm playEffectFilePath:soundFilePath];
            break;
        }
            
        case BUTTON_NEXT:{
            [self nextButtonPressed];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_3.mp3", [[NSBundle mainBundle] resourcePath]];  
            [sm playEffectFilePath:soundFilePath];
            break;
        }

        case BUTTON_CHANGE_PAINTING_MODE:{
            [self paintModeButtonPressed];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_4.mp3", [[NSBundle mainBundle] resourcePath]];  
            [sm playEffectFilePath:soundFilePath];
            break;
        }
            
        case BUTTON_CUSTOM_COLOR:{
            [self colorPickerPressed];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_3.mp3", [[NSBundle mainBundle] resourcePath]];  
            [sm playEffectFilePath:soundFilePath];

            break;
        }
                        
        case BUTTON_ERASER_PLUS_UNDO:{
            
            if ([self.eraserPlusUndo areYouEraserNow]) {
                [self eraserPressed];
            } else {
                [self undoButtonPressed];
            }
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/choise.mp3", [[NSBundle mainBundle] resourcePath]];  
            [sm playEffectFilePath:soundFilePath];

            break;
        }
            
        case BUTTON_BACK_TO_GALLERY:{
            [self backToGalleryPressed];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_3.mp3", [[NSBundle mainBundle] resourcePath]];  
            [sm playEffectFilePath:soundFilePath];

            break;
        }
            
        case BUTTON_SHOW_SAMPLE:{
            [self showSamplePressed];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/pencil_3.mp3", [[NSBundle mainBundle] resourcePath]];  
            [sm playEffectFilePath:soundFilePath];

            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unknown button identifier: %d", self, NSStringFromSelector(_cmd), sender.identificator);
            break;
        }
    }
}

- (void)restartButtonPressed {
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    if (![self.painting areTherePlayingAnimations]){
        
        [self playButtonSound];
        
        [self.delegate addTextureToUndoCache];
        [self.delegate clearDrawingTexture];
    }
}

- (BOOL)shouldProcessTouchButton:(buttonID)button
{
    switch (button)
    {
     
        case BUTTON_EXIT:
        {
            return YES;
        }
            
        case BUTTON_BACK_TO_GALLERY:
        {
            if ([self.painting areTherePlayingAnimations])
            {
                return NO;
            }
            
            if ([self.drawingToolsBox areTherePlayingAnimations])
            {
                return NO;
            }
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected button type: %d", self, NSStringFromSelector(_cmd), button);
            break;
        }
            
    }
    
    return YES;
}

- (void)exitButtonPressed:(id)sender{
    //    NSLog(@"%@ : %@ begin", self, NSStringFromSelector(_cmd) );
    
    if ([self shouldProcessTouchButton:BUTTON_EXIT])
    {
                    
//        DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
//        [app goBack];        

        [self changeStateTo:INTERFACE_STATE_SHOWING_BOOKS];
        
        ResourceManager *rm = [ResourceManager sharedInstance];
        
//        [rm deleteAllResources];
//        [self.delegate deleteAllResources];
     }
}

- (void)processNewPageNumber:(NSNumber *)newpagenumber
{
    //    NSLog(@"%@ : %@ begin", self, NSStringFromSelector(_cmd) );
    
    [self.delegate clearUndoCache];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if ([self shouldSaveDrawingTexture]){
        [self.delegate saveCurrentDrawingTexture];
    }
    
    [self saveColoredSampleIfNessesary];
    
    BookManager *bm = [BookManager sharedInstance];
    self.currentPage = [bm pageNumber:([newpagenumber intValue]) InBook:self.currentBook];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"lastViewedPageForBook%d", self.currentBook.number];
    [defaults setInteger:self.currentPage.number forKey:key];
    [defaults setInteger:self.currentBook.number forKey:@"lastViewedBook"];
    if (![defaults synchronize]) NSLog(@"ERROR: Failed to synchronize lastViewedPage in [PaintImageController nextImage]");
    
    [self.painting loadAreasFromFileForBookNumber:self.currentBook.number PageNumber:self.currentPage.number];
    
    UIImage *image = [bm imageForPage:self.currentPage InBook:self.currentBook];
    [self.delegate setupAndMixWithAreasTexture:self.delegate->blackAndWhitePictureTexture WithImage:image];
    
    
    if (self.delegate->isDrawingTextureUsed) {NSLog(@"WARNING!! isDrawingTextureUsed");}
    
    GLubyte *restoredDrawingTexture = [self.delegate restoreCurrentDrawingTextureData];  
        
    if (!restoredDrawingTexture) {
        [self.delegate clearDrawingTexture];
        self.painting.currentPictureState = PICTURE_STATE_NEW_UNMODIFIED;

    } else {
        self.painting.currentPictureState = PICTURE_STATE_EXISTING_UNMODIFIED;
        
        if (self.delegate->isDrawingTextureUsed) {NSLog(@"WARNING!! isDrawingTextureUsed");}
        
        self.delegate->isDrawingTextureUsed = YES;
        
        glBindTexture(GL_TEXTURE_2D, self.delegate->currentDrawingTexture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1024, 1024, 0, GL_RGBA, GL_UNSIGNED_BYTE, restoredDrawingTexture);
        
        self.delegate->isDrawingTextureUsed = NO;
    }
    
    free (restoredDrawingTexture);
    
    [self.delegate waitForDrawFrame];
    
    [pool drain];
    
}

- (void)findNewVersionNumber {
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                        self.currentBook.number, 
                        (self.currentPage.number + 1)];
    int newVersionNumber = ([defauls integerForKey:numkey]);
    if (newVersionNumber == 0) {
        self.curentVersionNumber = 0;
    } else {
        self.curentVersionNumber = newVersionNumber-1;
    }
}

- (void)unloadColoredGalleryTextures {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:self.currentBook.number], @"booknumber",
                                nil];
    [[ResourceManager sharedInstance] deleteAllColorGalleryTexturesParameters:parameters];
}

- (void)prevButtonPressed{
    
    if (![self.painting areTherePlayingAnimations]){    
        
        if (self.currentPage.number > 0){
        
            self.state = INTERFACE_STATE_CHANGING_PICTURES;
            
            [self playButtonSound];
            
            self.painting.shadowing.state = ANIMATION_STATE_STOPPED;
            self.painting.shadowing.alpha = 0.0;

            [self findNewVersionNumber];
            
            [self processNewPageNumber:[NSNumber numberWithInt:(self.currentPage.number - 1)] ];
            [self disablePrevOrNextButtonIfNessesarily];
            
            UIImage *image = [[BookManager sharedInstance] imageForPage:self.currentPage InBook:self.currentBook];
            exampleImageOnButton.image = image;
        }
    }
}

- (void)nextButtonPressed{  
    
    if (![self.painting areTherePlayingAnimations]){        
        
        if (self.currentPage.number < [[BookManager sharedInstance] howManyPagesInBook:self.currentBook] - 1)
        {
        
            self.state = INTERFACE_STATE_CHANGING_PICTURES;
            
            [self playButtonSound];
            
            self.painting.shadowing.state = ANIMATION_STATE_STOPPED;
            self.painting.shadowing.alpha = 0.0;
            
            [self findNewVersionNumber];
            
            [self processNewPageNumber:[NSNumber numberWithInt:(self.currentPage.number + 1)] ];
            [self disablePrevOrNextButtonIfNessesarily];
            
            UIImage *image = [[BookManager sharedInstance] imageForPage:self.currentPage InBook:self.currentBook];
            exampleImageOnButton.image = image;
            
//            [self unloadColoredGalleryTextures];
            
//            [self unloadColoredGallery];
            
        }
    }
}
- (void)paintModeButtonPressed{
	DynamicTexturesAppDelegate* curApp = [DynamicTexturesAppDelegate SharedAppDelegate];
	
    if (curApp.paintMode == paintModeSimple)
	{
        
		[self.brushSizeSlider setEnabled:YES];
        
        [self.eraserPlusUndo switchToEraser];
		
		curApp.paintMode = paintModeMedium;
		[paintModeButton setTitle: @"Границы" forState: UIControlStateNormal];
        
        UIImage *buttonImage = [UIImage imageNamed:@""];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
                
        self.brushSizeSlider.alpha = 1;
        self.sliderImage.alpha = 1;
        //        colorCircleBig.alpha = 1;
        //        colorCircleSmall.alpha = 1;
        
        
	}
	else if (curApp.paintMode == paintModeMedium)
	{
        
        self.painting.shadowing.state = ANIMATION_STATE_STOPPED;
        self.painting.shadowing.alpha = 0.0;

		[self.brushSizeSlider setEnabled:NO];
        
        [self.eraserPlusUndo switchToUndo];
		
		curApp.paintMode = paintModeSimple;
		[paintModeButton setTitle: @"Заливка" forState: UIControlStateNormal];
        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeFill"];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
        
        self.brushSizeSlider.alpha = 0;
        self.sliderImage.alpha = 0;
        //        colorCircleBig.alpha = 0;
        //        colorCircleSmall.alpha = 0;
	}
}


- (void)undoButtonPressed{    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    if (![self.painting areTherePlayingAnimations]){
        [self.delegate restoreTextureFromUndoCache];
    }
}

#pragma mark - Changing colors

//deprecated
- (void)colorChangedWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    [self.painting setBrushColorRed:red
                              Green:green
                               Blue:blue];
    NSLog(@"%@ : %@   I AM DEPRECATED !!!!!", self, NSStringFromSelector(_cmd));
}

- (void)colorChangedWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    [self.painting setBrushColorRed:red
                              Green:green
                               Blue:blue
                              Alpha:alpha];
}

- (void)colorPickerPressed{
    //    [self.drawingToolsBox unselectTools];
    //    
    //    if (colorPickerController == nil) {
    //        self.colorPickerController = [[ColorPickerViewController alloc] init];    
    //    }
    //	
    //	if (colorPickerPopover == nil) 
    //	{
    //        self.colorPickerPopover = [[[UIPopoverController alloc] initWithContentViewController:self.colorPickerController] autorelease];
    //	} 
    //    
    //	[self.colorPickerPopover presentPopoverFromRect:self.drawingToolsBox.customColorButton.position 
    //                                             inView:self.delegate.view 
    //                           permittedArrowDirections:UIPopoverArrowDirectionAny 
    //                                           animated:YES];        
    //	
    //    self.colorPickerController.delegate = self;
    switch (drawingToolsBox.activeToolType) 
    {
        case DRAWING_TOOL_FLOWMASTER:
        {
            drawingToolsBox.nextToolType = DRAWING_TOOL_RAINBOW;
            break;
        }
            
        case DRAWING_TOOL_RAINBOW:
        {
            drawingToolsBox.nextToolType = DRAWING_TOOL_FLOWMASTER;
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ WARNING!!! unexpected DrawingToolsBox activeToolType : %d", self, NSStringFromSelector(_cmd), drawingToolsBox.activeToolType);
            break;
        }
    }
    
    [drawingToolsBox saveStateForTool];
    double currtime = CFAbsoluteTimeGetCurrent();
    [drawingToolsBox changeStateTo:DRAWING_TOOLS_BOX_STATE_DISAPPEARS_FROM_SCREEN AtTime:currtime];
}

//- (void)eraserPressed{
//	
//	if (eraserPlusUndoButton.frame.size.width != 134)
//	{
//		// Первый клик
//        //		prevBrushSize = brushSizeSlider.value;
//        //		
//        //		[paintingView serEraserBrush];
//        
//        //        [self colorChangedWithRed:1.0 green:1.0 blue:1.0];
//        
//        
//        [self.painting setBrushColorRed:1.0
//                                  Green:1.0
//                                   Blue:1.0
//                                  Alpha:1.0];
//        
//        [self.eraserPlusUndo changeStateTo:ERASER_STATE_SELECTED AtTime:CFAbsoluteTimeGetCurrent()];
//		
//        [eraserPlusUndoButton setImage:[UIImage imageNamed:@"eraserSelected"] forState:UIControlStateNormal];
//        eraserPlusUndoButton.frame = CGRectMake(eraserPlusUndoButton.frame.origin.x, eraserPlusUndoButton.frame.origin.y, ERASER_SELECTED_WIDTH, ERASER_SELECTED_HEIGHT);
//
//        
//        
//        //        DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
//		
//        //		if (app.paintMode != paintModeSimple)
//        //		{
//        //			brushSizeSlider.maximumValue = eraserMaxSize;
//        //			[brushSizeSlider setValue:30];
//        //			[paintingView setBrushSize:30];
//        //		}
//        
//        //        [self setColorCirclesColorsRed:1.0 Green:1.0 Blue:1.0 Alpha:0.0];
//        //		[self layOldPencil];
//        //        [self putDownOldPencil];
//        //        [self putDownOldDrawingTool];
////        [self eraserPressed];
//        
//        [self.drawingToolsBox unselectTools]; 
//        
//	}
//	else 
//	{
//		// Повторный клик
//		[self restoreEraser];
//        
//        [self.eraserPlusUndo changeStateTo:ERASER_STATE_UNSELECTED AtTime:CFAbsoluteTimeGetCurrent()];
//
//		
//		if (!self.painting.isCustomColorActive)
//		{
//            //			CGRect buttonRect = prevPencilButton.frame;
//            //			buttonRect.size.width = 145;
//            //			[prevPencilButton setImage:[UIImage imageNamed: [NSString stringWithFormat:@"pencil%iSelected", [prevPencilButton tag]]] forState:UIControlStateNormal];
//            //			prevPencilButton.frame = buttonRect;
//            
//            //            prevPencil.isSelected = TRUE;
//            //            prevPencil.frame = CGRectMake(prevPencil.frame.origin.x, prevPencil.frame.origin.y, 103+45, 37);
//            //            [prevPencil setNeedsDisplay];
//            //			
//            //            //			[self changeCurrentColor:prevPencilButton];
//            //            [self changeCurrentDrawingColor:prevPencil];
//		}
//		else 
//		{
////			[self colorChangedWithRed:self.painting->currentRed green:self.painting->currentGreen blue:self.painting->currentBlue];
//		}
//	}
//}

- (void)restoreEraser
{
    [self.eraserPlusUndo unselectSelf];
}

- (void)backToGalleryPressed{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    if ([self shouldProcessTouchButton:BUTTON_BACK_TO_GALLERY])
    {
        [self saveInterfaceState];
        
        [self.delegate clearUndoCache];
        
        exampleImageOnButton.hidden = YES;
            
        double currtime = CFAbsoluteTimeGetCurrent();
        
        self.state = INTERFACE_STATE_MORPHING_PAINTING_TO_GALLERY;
        
//        if([self shouldSaveDrawingTexture])
//            [self.delegate saveCurrentDrawingTexture];
//        
//        [self saveColoredSampleIfNessesary];
                
        [self.drawingToolsBox changeStateTo:DRAWING_TOOLS_BOX_STATE_DISAPPEARS_FROM_SCREEN AtTime:currtime];
        
        paperShadow.alpha = 0.0;
        
        self.brushSizeSlider.alpha = 0.0;
        self.sliderImage.alpha = 0.0;
        [self.brushSizeSlider setEnabled:NO];
        
        [self hideButtonsAnimated:YES 
                           AtTime:currtime];
        [self.eraserPlusUndo changeStateTo:ERASER_STATE_DISAPPERS_FROM_SCREEN 
                            AtTime:currtime];
        
        if (activeGallery == INTERFACE_ELEMENT_GALLERY){
            [self.gallery changeStateTo:GALLERY_STATE_UNSCALING_FROM_PAINTING_AREA 
                                 AtTime:currtime];
            
        } else if (activeGallery == INTERFACE_ELEMENT_GALLERY_COLORED){
            [self.galleryColored changeStateTo:GALLERY_COLORED_STATE_UNSCALING_FROM_PAINTING_AREA
                                        AtTime:currtime];
        }
        
        
        if([self shouldSaveDrawingTexture])
            [self.delegate saveCurrentDrawingTexture];
        
        [self saveColoredSampleIfNessesary];

        
        
    }
}

- (void)showSamplePressed
{
    self.state = INTERFACE_STATE_SHOWING_EXAMPLE;
    examplePanel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    examplePanel.image = [UIImage imageNamed:@"ExamplePanelOverlay.png"];
    examplePanel.opaque = NO;
    [self.delegate.view addSubview:examplePanel];
    
    exampleImage = [[UIImageView alloc] initWithFrame:CGRectMake(110, 140, 550, 760)];
    exampleImage.image = [[BookManager sharedInstance] imageForPage:self.currentPage InBook:self.currentBook];
    [self.delegate.view addSubview:exampleImage];
    
    cross = [[UIImageView alloc] initWithFrame:CGRectMake(643, 93, 68, 65)];
    cross.image = [UIImage imageNamed:@"CrossButton.png"];
    [self.delegate.view addSubview:cross];
    
}

#pragma mark - Slider

- (void)setBrushSize:(float)newBrushSize{
    
    self.painting.brushSize = newBrushSize;
}

- (float)sliderNearestValueForValue:(float)value{
    float retValue = SLIDER_FIXED_VALUE_1;
    if (fabs(value - SLIDER_FIXED_VALUE_2) <= fabs(value - retValue)){
        retValue = SLIDER_FIXED_VALUE_2;
    }
    if (fabs(value - SLIDER_FIXED_VALUE_3) <= fabs(value - retValue)){
        retValue = SLIDER_FIXED_VALUE_3;
    }
    
    return retValue;
}

- (void)sliderDragAction:(BrushSizeSlider*)sender{
    
    sender.state = SLIDER_STATE_DRAGGIN;
    [self setBrushSize:sender.value];
}

- (void)sliderTouchAction:(BrushSizeSlider*)sender{
    
    sender.state = SLIDER_STATE_TOUCHIN;
    [self setBrushSize:sender.value];

}

- (void)sliderTouchUpAction:(BrushSizeSlider*)sender{
    if (sender.state == SLIDER_STATE_TOUCHIN){
//        NSLog(@"%@ : %@ sender.value = %f", self, NSStringFromSelector(_cmd), sender.value);
        sender.value = [self sliderNearestValueForValue:sender.value];
        [self setBrushSize:sender.value];

    }
    
}


//- (void)eraserPressed{
//    [self.drawingToolsBox unselectTools];    
//}



- (void)newColorButtonPressed:(UIButton *)sender{
    
    [self restoreEraser];
    
    UIColor *newcolor = (UIColor *) sender.backgroundColor;
    
    //    TO-DO: getRed... works in ios5 only!!!
    //    CGFloat red, green, blue;    
    //    [newcolor getRed:&red green:&green blue:&blue alpha:nil];
    //    [self colorChangedWithRed:red green:green blue:blue];
    
    const float* colors = CGColorGetComponents(newcolor.CGColor );
    //    [self colorChangedWithRed:colors[0] green:colors[1] blue:colors[2]];
    
    [self.painting setBrushColorRed:colors[0]
                              Green:colors[1]
                               Blue:colors[2]
                              Alpha:1.0];
    
//    brushColor[0] = colors[0];
//    brushColor[1] = colors[1];
//    brushColor[2] = colors[2];
//    brushColor[3] = 1.0;
//    //    brushColor[3] = currpencil.alpha;
    
    [self.colorPickerPopover dismissPopoverAnimated:YES];
}

#pragma mark - Sound

- (void)playButtonSound {
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/click_4.mp3", [[NSBundle mainBundle] resourcePath]];  
    SoundManager *sm = [SoundManager sharedInstance];        
    [sm playEffectFilePath:soundFilePath];
}

- (void)disablePrevOrNextButtonIfNessesarily{
    if (self.currentPage.number == 0) {
        prevButton.enabled = NO;
        nextButton.enabled = YES;        
    } else if (self.currentPage.number == self.currentBook.numberOfPages-1) {
        nextButton.enabled = NO;        
        prevButton.enabled = YES;
    } else {
        nextButton.enabled = YES;        
        prevButton.enabled = YES;        
    }
}

- (void)showButtonsAnimated:(BOOL)animated AtTime:(double)currtime{
    if(!animated){
        for (GLButton *button in self.buttons){
            button.alpha = 1.0;
        }
    } else {
        
        for (GLButton *button in self.buttons){
            button.animation.startAlpha = button.alpha;
            button.animation.endAlpha = 1.0;
            button.animation.startPosition = button.position;
            button.animation.endPosition = button.position;
            button.animation.startTime = currtime;
            button.animation.endTime = button.animation.startTime + BUTTONS_UNHIDING_DURATION;
            button.animation.state = ANIMATION_STATE_PLAYING;
        }
    }
};

- (void)hideButtonsAnimated:(BOOL)animated AtTime:(double)currtime{
    if(!animated){
        for (GLButton *button in self.buttons){
            button.alpha = 0.0;
        }
    } else {
        
        for (GLButton *button in self.buttons){
            button.animation.startAlpha = button.alpha;
            button.animation.endAlpha = 0.0;
            button.animation.startPosition = button.position;
            button.animation.endPosition = button.position;
            button.animation.startTime = currtime;
            button.animation.endTime = button.animation.startTime + BUTTONS_HIDING_DURATION;
            button.animation.state = ANIMATION_STATE_PLAYING;
        }
    }
};


# pragma mark - States & Physics

- (void)changeStateTo:(interfaceState)newState
{
    switch (newState) {
        case INTERFACE_STATE_SHOWING_BOOKS:
        {
            //do nothing
            [self.gallerySelectBookLower changeStateTo:GALLERY_STATE_SHOWING_PICS AtTime:CFAbsoluteTimeGetCurrent()];
            [self.gallerySelectBookUpper changeStateTo:GALLERY_STATE_SHOWING_PICS AtTime:CFAbsoluteTimeGetCurrent()];
            
            break;
        }
        case INTERFACE_STATE_MORPHING_SELECTED_BOOK_TO_GALLERY:
        {
            //do nothing
            break;
        }
        case INTERFACE_STATE_SHOWING_GALLERY:
        {
            //do nothing
            break;
        }
        case INTERFACE_STATE_MORPHING_GALLERY_TO_BOOK:
        {
            //do nothing
            break;
        }
        case INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING:
        {
            //do nothing
            break;
        }
        case INTERFACE_STATE_PAINTING:
        {
            //do nothing
            break;
        }
        case INTERFACE_STATE_SHOWING_EXAMPLE:
        {
            //do nothing
            break;
        }
        case INTERFACE_STATE_CHANGING_PICTURES:
        {
            //do nothing
            break;
        }
        case INTERFACE_STATE_MORPHING_PAINTING_TO_GALLERY:
        {
            //do nothing
            break;
        }
            
        default:
        {
            NSLog(@"%@ : %@ Warning! Unexpected new state: %d", self, NSStringFromSelector(_cmd), newState);
            break;
        }
    }
    
    
    self.state = newState;
}

- (void) updatePhysics:(double)currtime{
    
    switch (self.state) {
        case INTERFACE_STATE_SHOWING_BOOKS:
        {
            [self.gallerySelectBookUpper updateSheets:currtime];
            [self.gallerySelectBookLower updateSheets:currtime];
            break;
        }
            
        default:
        {
            [self.gallery updateSheets:currtime];
            [self.galleryColored updateSheets:currtime];
            [self.drawingToolsBox updatePhysicsAtTime:currtime];
            [self.painting updateAnimations:currtime];
            for (GLButton *button in self.buttons){
                [button updatePhysicsAtTime:currtime];
            }
            [self.eraserPlusUndo updatePhysicsAtTime:currtime];
            break;
        }
    }    
}

- (BOOL)isThereSavedColoredPicsForBookNumber:(int) booknumber PageNumber:(int)pagenumber
{
    
    BOOL retValue;
    NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                        booknumber, 
                        pagenumber];
    int numberOfVersions = [[NSUserDefaults standardUserDefaults] integerForKey:numkey];
    if (numberOfVersions > 0) retValue = YES;
    else {
        retValue = NO;
    }
    
    return retValue;
}

- (int)coloredSheetNumberFromSheetNumber:(int)sheetNumber
{
     int counter = 0;
     for (int pagenumber = 0; pagenumber < sheetNumber; pagenumber++){
         NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                             self.currentBook.number, 
                             pagenumber];
         int numberOfVersions = [[NSUserDefaults standardUserDefaults] integerForKey:numkey];
         counter += numberOfVersions;
     }

//    NSLog(@"colored sheet for page %d is %d", sheetNumber, counter);

    return counter;   
}

- (int)sheetNumberFromColoredSheetNumber:(int)coloredSheetNumber{
    
    int counter = 0;
    
    int maxPageNumber = [[BookManager sharedInstance] howManyPagesInBook:self.currentBook];
    
    for (int pagenumber = 0; pagenumber < maxPageNumber; pagenumber++){
        NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                            self.currentBook.number, 
                            pagenumber];
        int numberOfVersions = [[NSUserDefaults standardUserDefaults] integerForKey:numkey];
        
//        NSLog(@"%@ : %@ numberOfVersions for book %d page %d is %d", self, NSStringFromSelector(_cmd), self.currentBook.number, pagenumber, numberOfVersions);
        
        if (counter <= coloredSheetNumber && coloredSheetNumber < counter + numberOfVersions) {
            
//            NSLog(@"sheetNumber for coloredSheetNumber %d is %d", coloredSheetNumber, pagenumber);
            
            return pagenumber;
        }
        counter += numberOfVersions;
    }
    
    NSLog(@"%@ : %@ warning! page not found!", self, NSStringFromSelector(_cmd));
    return 0;   
    
};

- (int)versionNumberFromColoredSheetNumber:(int)coloredSheetNumber
{
    int retValue;
    int counter = 0;
    
    int maxPageNumber = [[BookManager sharedInstance] howManyPagesInBook:self.currentBook];
    
    for (int pagenumber = 0; pagenumber < maxPageNumber; pagenumber++){
        NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                            self.currentBook.number, 
                            pagenumber];
        int numberOfVersions = [[NSUserDefaults standardUserDefaults] integerForKey:numkey];
        if (counter <= coloredSheetNumber && coloredSheetNumber < counter + numberOfVersions) {
            retValue = coloredSheetNumber - counter;
            return retValue;
        }
        counter += numberOfVersions;
    }
    
    NSLog(@"%@ : %@ warning! page not found!", self, NSStringFromSelector(_cmd));
    return 0;   

}

#pragma mark - Gallery Delegate methods
- (int)howManySheets
{
//    NSLog(@"%@ : %@ self.currentBook.numberOfPages = %d", self, NSStringFromSelector(_cmd), self.currentBook.numberOfPages);
    
    return self.currentBook.numberOfPages;
}

- (void)newActiveSheetNumber:(int)sheetNumber
{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
//    [self.galleryColored scrollToSheetNumber:5];
}

- (void)galleryWillStabilizeToSheetNumber:(int)sheetNumber
                                StartTime:(double)startTime 
                                  EndTime:(double)endTime
{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    BookManager *bm = [BookManager sharedInstance];
    self.currentPage = [bm pageNumber:sheetNumber InBook:self.currentBook];
    
    if ([self isThereSavedColoredPicsForBookNumber:self.currentBook.number PageNumber:sheetNumber]){
    
        int newSheetNumber = [self coloredSheetNumberFromSheetNumber:sheetNumber];
        
        [self.galleryColored scrollToSheetNumber:newSheetNumber 
                                       StartTime:startTime 
                                         EndTime:endTime];
    }
}

- (void)galleryDidStabilized{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));

}


- (void)sheetWillAnimateToPaintingPage:(int)sheetNumber
{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    [exitButton setHidden:YES];
    
    activeGallery = INTERFACE_ELEMENT_GALLERY;
    
    self.galleryColored.state = GALLERY_COLORED_STATE_HIDDEN;    
        
    self.state = INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING;
    
    [[ResourceManager sharedInstance] loadResourcesForScene:SCENE_PAINTING
                                                 Parameters:nil
                                                  InContext:self.delegate->resourceLoadingEAGLContext];
    
    BookManager *bm = [BookManager sharedInstance];
    self.currentPage = [bm pageNumber:sheetNumber InBook:self.currentBook];
    [self disablePrevOrNextButtonIfNessesarily];
    [self.painting loadAreasFromFileForBookNumber:self.currentBook.number 
                                       PageNumber:self.currentPage.number];
    [self.delegate initBlackAndWhiteTexture]; 
    [self.delegate loadDrawingTextureRestored:NO];
    
    
}

- (void)sheetDidAnimateToPaintingPage:(int)sheetNumber
{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    
    UIImage *image = [[BookManager sharedInstance] imageForPage:self.currentPage InBook:self.currentBook];
    exampleImageOnButton.image = image;
    exampleImageOnButton.hidden = NO;
        
    [self restoreInterfaceState];

    self.painting.currentPictureState = PICTURE_STATE_NEW_UNMODIFIED;
    
    double currtime = CFAbsoluteTimeGetCurrent();
    
    self.state = INTERFACE_STATE_PAINTING;
    
    [self.drawingToolsBox changeStateTo:DRAWING_TOOLS_BOX_STATE_APPEARS_ON_SCREEN AtTime:currtime];
    
    paperShadow.alpha = 1.0;

    DynamicTexturesAppDelegate *app = [DynamicTexturesAppDelegate SharedAppDelegate];
    if (app.paintMode == paintModeMedium){
        self.brushSizeSlider.alpha = 1;
        self.sliderImage.alpha = 1;
        
        [self.brushSizeSlider setEnabled:YES];
    }

    
//    pinView.alpha = 1.0;
    
    [self showButtonsAnimated:YES AtTime:currtime];
    
    [self.eraserPlusUndo appearsOnScreenWithRestoredState];
//    [self.eraserPlusUndo changeStateTo:ERASER_STATE_APPEARS_ON_SCREEN AtTime:currtime];
//    [self showEraserAnimated:YES AtTime:currtime];
    
}

- (void)sheetDidAnimateToGallery{

//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    

    [exitButton setHidden:NO];
    exampleImageOnButton.hidden = YES;

    
    self.state = INTERFACE_STATE_SHOWING_GALLERY;
    [self.galleryColored changeStateTo:GALLERY_STATE_SHOWING_PICS AtTime:CFAbsoluteTimeGetCurrent()];
    
}

#pragma mark - Unload Color Gallery

- (void)unloadColoredGallery
{
    [galleryColored release];
    galleryColored = nil;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:self.currentBook.number], @"booknumber",
                                nil];
    [[ResourceManager sharedInstance] deleteAllColorGalleryTexturesParameters:parameters];
}

#pragma mark - Colored Gallery Delegate methods

- (int)howManyColoredSheetsInGallery:(GalleryForColoredPics *)sender
{    
    if (sender == self.galleryColored) {    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"number of totalsavings in book %d", self.currentBook.number];
        int retValue = [defaults integerForKey:key];
        return retValue;
    } else if (sender == self.gallerySelectBookUpper){
        int total = [[BookManager sharedInstance] howManyBooks];
        return (total - round(total/2) );
    } else if (sender == self.gallerySelectBookLower) {
        int total = [[BookManager sharedInstance] howManyBooks];
        return round(total/2);
    } 
    else {
        NSLog(@"%@ : %@ Warning! Unexpected sender: %@", self, NSStringFromSelector(_cmd), sender);
        return 0;
    }
    
    return 0;
}


- (void)newActiveColoredSheetNumber:(int)sheetNumber
                          InGallery:(id)sender{

}

- (void)coloredGallery:(id)sender WillStabilizeToSheetNumber:(int)sheetNumber
                                       StartTime:(double)startTime
                                         EndTime:(double)endTime{
    
//    NSLog(@"%@ : %@ sheetNumber = %d", self, NSStringFromSelector(_cmd), sheetNumber);

    for (SheetColored *sh in self.galleryColored.sheets){
        

        
        
        if ( (sh.number < sheetNumber - (COLORED_SHEET_NEIGHBOORS_COUNT_LEFT) ) || 
             (sh.number > sheetNumber + (COLORED_SHEET_NEIGHBOORS_COUNT_RIGHT) )
            )
        {
            // помечаем, что текстуру можно не загружать, а использовать дефолтную
            sh.shouldLoadTextureIfUnloaded = NO;
//            NSLog(@"%@ : %@ texture for Sheet %d should not be loaded", self, NSStringFromSelector(_cmd), sh.number);
        } 
        else 
        {
            sh.shouldLoadTextureIfUnloaded = YES;
            // заранее загружаем текстуры
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:self.currentBook.number], @"booknumber", 
                                        [NSNumber numberWithInt:sh.number], @"versionnumber",
                                        nil];
            
            [[ResourceManager sharedInstance] getTexture:TEXTURE_COLORING_PICTURE
                                              Parameters:parameters
                                               InContext:self.delegate->resourceLoadingEAGLContext
                                              ShouldLoad:YES 
                                                   Async:YES];       
        }
    }
}



- (void)coloredGallery:(id)sender DidStabilizedToSheetNumber:(int)newColoredSheetNumber{
//    NSLog(@"%@ : %@ newColoredSheetNumber = %d", self, NSStringFromSelector(_cmd), newColoredSheetNumber);
    
    for (SheetColored *sh in self.galleryColored.sheets){
        if ((sh.number < newColoredSheetNumber - (COLORED_SHEET_NEIGHBOORS_COUNT_LEFT)) || 
            (sh.number > newColoredSheetNumber + (COLORED_SHEET_NEIGHBOORS_COUNT_RIGHT)))
        {
            //помечаем текстуру как неиспользованную, она может быть удалена при нехватке памяти
    
//            NSLog(@"%@ : %@ deleting texture for Sheet %d", self, NSStringFromSelector(_cmd), sh.number);
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:self.currentBook.number], @"booknumber", 
                                        [NSNumber numberWithInt:sh.number], @"versionnumber",
                                        nil];
            
            [[ResourceManager sharedInstance] markUnusedTexture:TEXTURE_COLORING_PICTURE
                                                     Parameters:parameters];
            
        }
    }
    
    [[ResourceManager sharedInstance] deleteAllUnusedTextures];
}

- (void)userDidSelectSheetNumber:(int)sheetNumber InGallery:(id)sender
{
    if (sender == self.gallerySelectBookUpper)
    {
        int booknumber = sheetNumber;
        
        NSLog(@"%@ : %@ booknumber = %d", self, NSStringFromSelector(_cmd), booknumber);
        
        self.currentBook = [[BookManager sharedInstance] bookNumber:booknumber];
        
        [self.galleryColored release];
        galleryColored = nil;
        
        [self changeStateTo:INTERFACE_STATE_SHOWING_GALLERY];
    }
    
    else if (sender == self.gallerySelectBookLower)
    {
        int total = [[BookManager sharedInstance] howManyBooks];
        int pagesInUpperGAllery = (total - round(total/2) );
        int booknumber = sheetNumber + pagesInUpperGAllery;
        
        NSLog(@"%@ : %@ booknumber = %d", self, NSStringFromSelector(_cmd), booknumber);

        self.currentBook = [[BookManager sharedInstance] bookNumber:booknumber];
        
        [self.galleryColored release];
        galleryColored = nil;

        
        [self changeStateTo:INTERFACE_STATE_SHOWING_GALLERY];
    }
}

- (void)coloredSheetWillAnimateToPaintingPage:(int)sheetNumber 
                                    InGallery:(id)sender{
    
    if (sender == self.galleryColored){

        [exitButton setHidden:YES];
            
        activeGallery = INTERFACE_ELEMENT_GALLERY_COLORED;
        
        self.gallery.state = GALLERY_STATE_HIDDEN;    
        
        self.state = INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING;
        
        [[ResourceManager sharedInstance] loadResourcesForScene:SCENE_PAINTING
                                                     Parameters:nil
                                                      InContext:self.delegate->resourceLoadingEAGLContext];
        
        int pagenumber = [self sheetNumberFromColoredSheetNumber:sheetNumber];
        self.curentVersionNumber = [self versionNumberFromColoredSheetNumber:sheetNumber];
        
    //    NSLog(@"%@ : %@ sheetNumber = %d pagenumber = %d curentVersionNumber = %d", self, NSStringFromSelector(_cmd), sheetNumber, pagenumber, self.curentVersionNumber);
        
        BookManager *bm = [BookManager sharedInstance];
        self.currentPage = [bm pageNumber:pagenumber InBook:self.currentBook];
        [self disablePrevOrNextButtonIfNessesarily];
        [self.painting loadAreasFromFileForBookNumber:self.currentBook.number 
                                           PageNumber:self.currentPage.number];
        [self.delegate initBlackAndWhiteTexture]; 
        [self.delegate loadDrawingTextureRestored:YES];
        
    }

    else 
    {
        NSLog(@"%@ : %@ Warning! Unexpected sender: %@", self, NSStringFromSelector(_cmd), sender);
    }
}

- (void)coloredSheetDidAnimateToPaintingPage:(int)sheetNumber 
                                   InGallery:(id)sender{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    UIImage *image = [[BookManager sharedInstance] imageForPage:self.currentPage InBook:self.currentBook];
    exampleImageOnButton.image = image;
    exampleImageOnButton.hidden = NO;

    
    self.painting.currentPictureState = PICTURE_STATE_EXISTING_UNMODIFIED;    
    double currtime = CFAbsoluteTimeGetCurrent();
    
    self.state = INTERFACE_STATE_PAINTING;
    
    [self restoreInterfaceState];
    
    paperShadow.alpha = 1.0;
    
    DynamicTexturesAppDelegate *app = [DynamicTexturesAppDelegate SharedAppDelegate];
    if (app.paintMode == paintModeMedium){
        self.brushSizeSlider.alpha = 1;
        self.sliderImage.alpha = 1;
        
        [self.brushSizeSlider setEnabled:YES];
    }
    
    
    //    pinView.alpha = 1.0;
    
    [self showButtonsAnimated:YES AtTime:currtime];
    [self.eraserPlusUndo appearsOnScreenWithRestoredState];
//    [self.eraserPlusUndo changeStateTo:ERASER_STATE_APPEARS_ON_SCREEN AtTime:currtime];
    //    [self showEraserAnimated:YES AtTime:currtime];
    
}

- (void)coloredSheetDidAnimateToGallery:(id)sender{
    
    //    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    [exitButton setHidden:NO];
    exampleImageOnButton.hidden = YES;
    
    double currTime = CFAbsoluteTimeGetCurrent();
    
    [self.gallery changeStateTo:GALLERY_STATE_SHOWING_PICS AtTime:currTime];
    [self.galleryColored changeStateTo:GALLERY_COLORED_STATE_SHOWING_PICS AtTime:currTime];
    
    self.state = INTERFACE_STATE_SHOWING_GALLERY;
    
}

- (BOOL)shouldAnimateSelectedSheetInGallery:(id)sender
{
    BOOL retValue;
    
    if (sender == self.galleryColored){
        retValue = YES;
    } 
    else if (sender == self.gallerySelectBookLower)
    {
        retValue = NO;
    }
    else if (sender == self.gallerySelectBookUpper)
    {
        retValue = NO;
    }
    else {
        NSLog(@"%@ : %@ Warning! Unexpected sender: %@", self, NSStringFromSelector(_cmd), sender);
    }
    
    return retValue;
}

#pragma mark - Eraser Delegate methods

- (void)eraserSelected{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    [self.painting setBrushColorRed:1.0
                              Green:1.0
                               Blue:1.0
                              Alpha:1.0];
    
    self.eraserPlusUndo.position = CGRectMake(ERASER_SELECTED_OFFSET_X,
                                              ERASER_SELECTED_OFFSET_Y, 
                                              ERASER_SELECTED_WIDTH,
                                              ERASER_SELECTED_HEIGHT);

    
    [self.drawingToolsBox unselectTools]; 
    
}

- (void)eraserUnselected{
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    self.eraserPlusUndo.position = CGRectMake(ERASER_UNSELECTED_OFFSET_X,
                                              ERASER_UNSELECTED_OFFSET_Y, 
                                              ERASER_UNSELECTED_WIDTH,
                                              ERASER_UNSELECTED_HEIGHT);
    
}

#pragma mark - DrawingToolsBox Delegate methods

- (void)newDrawingToolSelected:(DrawingTool *)dt{
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/choice.mp3", [[NSBundle mainBundle] resourcePath]];  
    SoundManager *sm = [SoundManager sharedInstance];        
    [sm playEffectFilePath:soundFilePath];
    
    self.painting.isCustomColorActive = NO;
	
	[self restoreEraser];
    
    self.drawingToolsBox.prevDrawingTool = dt;
    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
    
    if (app.paintMode == paintModeMedium) {
        //        [self setColorCirclesColorsRed:sender.red 
        //                                 Green:sender.green 
        //                                  Blue:sender.blue 
        //                                 Alpha:sender.alpha];
    }
    [self changeCurrentDrawingColor:dt];
}

- (void)changeCurrentDrawingColor:(DrawingTool *)currpencil{
    [self.painting setBrushColorRed:currpencil.red
                              Green:currpencil.green
                               Blue:currpencil.blue
                              Alpha:currpencil.alpha];
}

- (void)newColorSelectedWithRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha
{
    [self.painting setBrushColorRed:red
                              Green:green
                               Blue:blue
                              Alpha:alpha];
}

#pragma mark - OpenGLViewController Delegate

- (BOOL)shouldDrawInterfaceElement:(interfaceElementID)interfaceElement
{
    BOOL retValue;
    
    switch (self.state){
        case INTERFACE_STATE_SHOWING_GALLERY:
        {
            switch (interfaceElement) 
            {
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                case INTERFACE_ELEMENT_GALLERY_COLORED:
                {
                    retValue = YES;
                    break;
                }
                case INTERFACE_ELEMENT_PAINTING:
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                case INTERFACE_ELEMENT_UNDO_LIGHTS:
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                {
                    retValue = NO;
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }
            break;
        }
            
        case INTERFACE_STATE_SHOWING_EXAMPLE:
        {
            switch (interfaceElement) {
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                {
                    retValue = NO;
                    break;
                }
                    
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_GALLERY_COLORED:
                case INTERFACE_ELEMENT_PAINTING:
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                case INTERFACE_ELEMENT_UNDO_LIGHTS:{
                    retValue = YES;
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }
            break;
        }
            
        case INTERFACE_STATE_MORPHING_GALLERY_TO_PAINTING:
        {
            switch (interfaceElement) {
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                case INTERFACE_ELEMENT_PAINTING:
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:
                case INTERFACE_ELEMENT_UNDO_LIGHTS:

                {
                    retValue = NO;
                    break;
                }
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                case INTERFACE_ELEMENT_GALLERY_COLORED:{
                    retValue = YES;
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }
            break;
        }
            
        case INTERFACE_STATE_MORPHING_PAINTING_TO_GALLERY:
        {
            
            switch (interfaceElement) {
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                case INTERFACE_ELEMENT_PAINTING:
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:
                case INTERFACE_ELEMENT_UNDO_LIGHTS:
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                {
                    retValue = NO;
                    break;
                }
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                case INTERFACE_ELEMENT_GALLERY_COLORED:
                {
                    retValue = YES;
                    break;
                }

                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }
            break;
        }

        case INTERFACE_STATE_PAINTING:
        {
            switch (interfaceElement) {
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                case INTERFACE_ELEMENT_GALLERY_COLORED:
                {
                    retValue = NO;
                    break;
                }
                case INTERFACE_ELEMENT_PAINTING:
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                {
                    retValue = YES;
                    break;
                }
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:{
                    DynamicTexturesAppDelegate* curApp = [DynamicTexturesAppDelegate SharedAppDelegate];
                    if (curApp.paintMode == paintModeSimple){
                        retValue = NO;
                    } else {
                        retValue = YES;
                    }
                    break;
                }
                    
                case INTERFACE_ELEMENT_UNDO_LIGHTS:{
                    if ([self.eraserPlusUndo areYouEraserNow]){
                        retValue = NO;
                    } else {
                        retValue = YES;
                    }
                    break;
                }

                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }
            break;
        }
            
        case INTERFACE_STATE_CHANGING_PICTURES:
        {
            switch (interfaceElement) 
            {
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                case INTERFACE_ELEMENT_GALLERY_COLORED:{
                    retValue = NO;
                    break;
                }
                    
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                case INTERFACE_ELEMENT_PAINTING:{
                    retValue = YES;
                    break;
                }
                    
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:{
                    DynamicTexturesAppDelegate* curApp = [DynamicTexturesAppDelegate SharedAppDelegate];
                    if (curApp.paintMode == paintModeSimple){
                        retValue = NO;
                    } else {
                        retValue = YES;
                    }
                    break;
                }
                    
                case INTERFACE_ELEMENT_UNDO_LIGHTS:{
                    if ([self.eraserPlusUndo areYouEraserNow]){
                        retValue = NO;
                    } else {
                        retValue = YES;
                    }
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }

            break;
        }
            
        case INTERFACE_STATE_SHOWING_BOOKS:
        {
            switch (interfaceElement) 
            {
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                {
                    retValue = YES;
                    break;
                }
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_GALLERY_COLORED:
                case INTERFACE_ELEMENT_PAINTING:
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                case INTERFACE_ELEMENT_UNDO_LIGHTS:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                {
                    retValue = NO;
                    break;
                }
                
                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }
            
            break;
        }
            
        case INTERFACE_STATE_MORPHING_SELECTED_BOOK_TO_GALLERY:
        {
            switch (interfaceElement) 
            {
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                {
                    retValue = YES;
                    break;
                }
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                case INTERFACE_ELEMENT_GALLERY_COLORED:
                case INTERFACE_ELEMENT_PAINTING:
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                case INTERFACE_ELEMENT_UNDO_LIGHTS:
                {
                    retValue = NO;
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }
            break;
                    
        }      
            
        case INTERFACE_STATE_MORPHING_GALLERY_TO_BOOK:
        {
            switch (interfaceElement) 
            {
                case INTERFACE_ELEMENT_BOOK_SELECT_PAGE:
                case INTERFACE_ELEMENT_BOOK_GALLERY_UPPER:
                case INTERFACE_ELEMENT_BOOK_GALLERY_LOWER:
                {
                    retValue = YES;
                    break;
                }
                case INTERFACE_ELEMENT_GALLERY:
                case INTERFACE_ELEMENT_GALLERY_BOOK_COVER:
                case INTERFACE_ELEMENT_GALLERY_COLORED:
                case INTERFACE_ELEMENT_PAINTING:
                case INTERFACE_ELEMENT_TOOL_SIZE_SLIDER:
                case INTERFACE_ELEMENT_DRAWING_TOOLS_BOX:
                case INTERFACE_ELEMENT_UNDO_LIGHTS:
                {
                    retValue = NO;
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ unexpected interfaceElementID : %d", self, NSStringFromSelector(_cmd), interfaceElement);
                    break;
                }
            }
            break;
        }   
            
        default:{
            NSLog(@"%@ : %@ WARNING! Unexpected state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
    
    return retValue;
}

- (BOOL)shouldSaveDrawingTexture
{
    BOOL retValue;
    switch (self.painting.currentPictureState) {
        case PICTURE_STATE_NEW_UNMODIFIED:
        case PICTURE_STATE_EXISTING_UNMODIFIED:
        {
            retValue = NO;
            break;
        }
            
        case PICTURE_STATE_EXISTING_MODIFIED:
        case PICTURE_STATE_NEW_MODIFIED:
        {
            retValue = YES;
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected picture's state: %d", self, NSStringFromSelector(_cmd), self.painting.currentPictureState);
            break;
        }
    }
    
    return retValue;
}

- (void)OpenGLViewDidFinishProcessingNewImage{
    if (self.state == INTERFACE_STATE_CHANGING_PICTURES){
        self.state = INTERFACE_STATE_PAINTING;
    }
}

- (NSString *)pathForCurrentDrawingTextureSaveFile
{
    NSString* filePath;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString* saveDir = [NSString stringWithFormat:@"%@/SavedData/drawings/book%d/page%d", documents, self.currentBook.number, self.currentPage.number];
    
    NSFileManager *fileManager= [NSFileManager defaultManager]; 
    
    BOOL dirExists = YES;
    
    if(![fileManager fileExistsAtPath:saveDir isDirectory:nil])
    {
        dirExists = [fileManager createDirectoryAtPath:saveDir withIntermediateDirectories:YES attributes:nil error:NULL];
        
        if (!dirExists){
            NSLog(@"%@ : %@ Warning! Failed to create saving dir", self, NSStringFromSelector(_cmd));
            return nil;
        }
        
    }
    
    switch (self.painting.currentPictureState) {
        case PICTURE_STATE_NEW_MODIFIED:{
            NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
            NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                                self.currentBook.number, 
                                self.currentPage.number];
            int newnum = [defauls integerForKey:numkey];
            filePath = [NSString stringWithFormat:@"%@/version%d.png", saveDir, newnum];             
            
            break;
        }
            
        case PICTURE_STATE_EXISTING_MODIFIED:{
            filePath = [NSString stringWithFormat:@"%@/version%d.png", saveDir, self.curentVersionNumber];
            
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected picture's state: %d", self, NSStringFromSelector(_cmd), self.painting.currentPictureState);
            break;
        }
    }
    
    NSLog(@"%@ : %@ filePath = %@", self, NSStringFromSelector(_cmd), filePath);
    
    return filePath;
}

- (NSString *)pathForCurrentColoredSampleSaveFile
{
    NSString* filePath;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString* saveDir = [NSString stringWithFormat:@"%@/SavedData/coloredSamples/book%d/page%d", documents, self.currentBook.number, self.currentPage.number];
    NSFileManager *fileManager= [NSFileManager defaultManager]; 
    
    BOOL dirExists = YES;
    
    if(![fileManager fileExistsAtPath:saveDir isDirectory:nil])
    {
        NSError *error = nil;
        dirExists = [fileManager createDirectoryAtPath:saveDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@ : %@ Failed to create dir at path: %@ returned error: %@", self, NSStringFromSelector(_cmd), saveDir, [error localizedDescription]);
        }
        
    }

    
    switch (self.painting.currentPictureState) {
        case PICTURE_STATE_NEW_MODIFIED:{

        NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    
        for(int i=0; i<INT_MAX; i++){
            
            NSString *key = [NSString stringWithFormat:@"is there saving Book %d Page %d Version %d",
                             self.currentBook.number, 
                             self.currentPage.number,
                             i];
            if (![defauls boolForKey:key]){
                filePath = [NSString stringWithFormat:@"%@/version%d.png", saveDir, i];  
                [defauls setBool:YES forKey:key];
                
                NSString *numkey = [NSString stringWithFormat:@"number of savings in Book %d Page %d",
                                    self.currentBook.number, 
                                    self.currentPage.number];
                int newnum = [defauls integerForKey:numkey] + 1;
                [defauls setInteger:newnum forKey:numkey];
                
                
                NSString *keytotal = [NSString stringWithFormat:@"number of totalsavings in book %d", self.currentBook.number];
                
                int newtotalnum = [defauls integerForKey:keytotal] + 1;
                [defauls setInteger:newtotalnum forKey:keytotal];
                [defauls synchronize];
                
                break;
            }
        }

            
            break;
        }
            
        case PICTURE_STATE_EXISTING_MODIFIED:{
            
            filePath = [NSString stringWithFormat:@"%@/version%d.png", saveDir, self.curentVersionNumber];
            
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected picture's state: %d", self, NSStringFromSelector(_cmd), self.painting.currentPictureState);
            break;
        }
    }
    
    return filePath;
    
    
}

- (textureID)getTextureIDForEraserPlusUndo
{
    textureID retValue = 0;
    
    if([self.eraserPlusUndo areYouEraserNow]) 
    {
        switch (self.eraserPlusUndo.state) {
            case ERASER_STATE_SELECTED:{
                retValue = ERASER_SELECTED_TEXTURE;
                break;
            }
            case ERASER_STATE_UNSELECTED:{
                retValue = ERASER_UNSELECTED_TEXTURE;
                break;
            }
                
            case ERASER_STATE_APPEARS_ON_SCREEN:
            {
                switch (self.eraserPlusUndo.nextState) {
                    case ERASER_STATE_SELECTED:
                    {
                        retValue = ERASER_SELECTED_TEXTURE;
                        break;
                    }
                        
                    case ERASER_STATE_UNSELECTED:
                    {
                        retValue = ERASER_UNSELECTED_TEXTURE;
                        break;
                    }
                        
                    case UNDO_STATE_SELECTED:
                    case UNDO_STATE_UNSELECTED:
                    case UNDO_STATE_OUT_OF_SCREEN:
                    {
                        retValue = UNDO_TEXTURE;              
                    }
                        
                    default:{
                        NSLog(@"%@ : %@ Warning! Unexpected eraser next state: %d", self, NSStringFromSelector(_cmd), self.eraserPlusUndo.nextState);
                        break;
                    }
                }
                break;
            }
            case ERASER_STATE_DISAPPERS_FROM_SCREEN:
            {
                switch (self.eraserPlusUndo.prevState) {
                    case ERASER_STATE_SELECTED:
                    {
                        retValue = ERASER_SELECTED_TEXTURE;
                        break;
                    }
                        
                    case ERASER_STATE_UNSELECTED:
                    {
                        retValue = ERASER_UNSELECTED_TEXTURE;
                        break;
                    }
                        
                    case UNDO_STATE_SELECTED:
                    case UNDO_STATE_UNSELECTED:
                    case UNDO_STATE_OUT_OF_SCREEN:
                    {
                        retValue = UNDO_TEXTURE;     
                        break;
                    }
                    
                    default:{
                        NSLog(@"%@ : %@ Warning! Unexpected eraser prev state: %d", self, NSStringFromSelector(_cmd), self.eraserPlusUndo.prevState);
                        break;
                    }
                }
                break;                
            }
                
            case ERASER_STATE_OUT_OF_SCREEN:{
                retValue = ERASER_SELECTED_TEXTURE;
                break;
            }

                
            default:{
                NSLog(@"%@ : %@ Warning! Unexpected eraser state: %d", self, NSStringFromSelector(_cmd), self.eraserPlusUndo.state);
                break;
            }
        }        
    }
    else 
    {
        retValue = UNDO_TEXTURE;
    }
    
    return retValue;
}





- (void)freeData{
    [self.painting freeArrays];
}

- (void)releaseViewsAndObjects{
//    if (restartButton)[restartButton release];
    if (buttons) [buttons release];
    if (eraserPlusUndo) [eraserPlusUndo release];
    if (exitButton) [exitButton release];
    if (prevButton) [prevButton release];
    if (nextButton) [nextButton release];
    if (paintModeButton) [paintModeButton release];
    if (colorPickerButton) [colorPickerButton release];
    if (colorPickerPopover)[colorPickerPopover release];
    if (undoButton) [undoButton release];
    if (sliderImage) [sliderImage release];
    if (brushSizeSlider) [brushSizeSlider release];
    if (eraserPlusUndoButton) [eraserPlusUndoButton release];
    
    if (painting) [painting release];
    if (drawingToolsBox) [drawingToolsBox release];
    
    if (paperShadow) [paperShadow release];
//    if (pinView) [pinView release];
}

- (void)dealloc{
//    if (drawingToolsBox) [drawingToolsBox release];
//    if (painting) [painting release];
    if (gallery) [gallery release];
    if (paperShadow) [paperShadow release];
    if (examplePanel) [examplePanel release];
    if (exampleImage) [exampleImage release];
    if (cross) [cross release];
    if (exampleImageOnButton) [exampleImageOnButton release];
    
    [super dealloc];
}

@end
