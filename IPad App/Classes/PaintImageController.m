//
//  PaintImageController.m
//  DynamicTextures
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "PaintImageController.h"
#import "DynamicTexturesAppDelegate.h"
#import "PaintImageView.h"
#import "Constants.h"
#import "OpenGLViewController.h"

@interface PaintImageController()
@property (retain) ColorShower *colorCircleSmall;
@property (retain) ColorShower *colorCircleBig;

@end

@implementation PaintImageController

//@synthesize imageIndex;
@synthesize colorCircleBig, colorCircleSmall;
@synthesize colorPickerPopover;
@synthesize lastClickedDate;
@synthesize delegate;
@synthesize currentBook, currentPage;

- (NSArray *) pencils
{
    if (!pencils) {
        pencils = [NSArray arrayWithObjects:pencil1, pencil2, pencil3, pencil4, pencil5, pencil6, pencil7, pencil8, pencil9, pencil10, pencil11, pencil12, nil];
        [pencils retain];
    }
    return pencils;
}

- (void) initPencils
{
#define rgb 1.0/255.0*    
    //задаем цвет карандашей
    [[self.pencils objectAtIndex:0] setColorRed:rgb 9 Green:rgb 9 Blue:rgb 9 Alpha:1.0];      //black
    [[self.pencils objectAtIndex:1] setColorRed:rgb 111 Green:rgb 70 Blue:rgb 50 Alpha:1.0];  //brown
    [[self.pencils objectAtIndex:2] setColorRed:rgb 245 Green:rgb 50 Blue:rgb 50 Alpha:1.0];  //red
    [[self.pencils objectAtIndex:3] setColorRed:rgb 248 Green:rgb 173 Blue:rgb 70 Alpha:1.0]; //orange
    [[self.pencils objectAtIndex:4] setColorRed:rgb 255 Green:rgb 242 Blue:rgb 42 Alpha:1.0]; //yellow
    [[self.pencils objectAtIndex:5] setColorRed:rgb 252 Green:rgb 226 Blue:rgb 186 Alpha:1.0];//beuge
    [[self.pencils objectAtIndex:6] setColorRed:rgb 124 Green:rgb 220 Blue:rgb 57 Alpha:1.0]; //light green
    [[self.pencils objectAtIndex:7] setColorRed:rgb 35 Green:rgb 98 Blue:rgb 24 Alpha:1.0];   //dark green
    [[self.pencils objectAtIndex:8] setColorRed:rgb 48 Green:rgb 99 Blue:rgb 233 Alpha:1.0];  //blue
    [[self.pencils objectAtIndex:9] setColorRed:rgb 50 Green:rgb 48 Blue:rgb 131 Alpha:1.0]; //violet1
    [[self.pencils objectAtIndex:10] setColorRed:rgb 117 Green:rgb 53 Blue:rgb 136 Alpha:1.0];//violet2
    [[self.pencils objectAtIndex:11] setColorRed:rgb 254 Green:rgb 73 Blue:rgb 154 Alpha:1.0];//pink
    // задаем цвет рефлексов для карандашей
    [[self.pencils objectAtIndex:0] setReflexColorRed:pencil2.red Green:pencil2.green Blue:pencil2.blue Alpha:pencil2.alpha];
    [[self.pencils objectAtIndex:1] setReflexColorRed:pencil3.red Green:pencil3.green Blue:pencil3.blue Alpha:pencil3.alpha];
    [[self.pencils objectAtIndex:2] setReflexColorRed:pencil4.red Green:pencil4.green Blue:pencil4.blue Alpha:pencil4.alpha];
    [[self.pencils objectAtIndex:3] setReflexColorRed:pencil5.red Green:pencil5.green Blue:pencil5.blue Alpha:pencil5.alpha];
    [[self.pencils objectAtIndex:4] setReflexColorRed:pencil6.red Green:pencil6.green Blue:pencil6.blue Alpha:pencil6.alpha];
    [[self.pencils objectAtIndex:5] setReflexColorRed:pencil7.red Green:pencil7.green Blue:pencil7.blue Alpha:pencil7.alpha];
    [[self.pencils objectAtIndex:6] setReflexColorRed:pencil8.red Green:pencil8.green Blue:pencil8.blue Alpha:pencil8.alpha];
    [[self.pencils objectAtIndex:7] setReflexColorRed:pencil9.red Green:pencil9.green Blue:pencil9.blue Alpha:pencil9.alpha];
    [[self.pencils objectAtIndex:8] setReflexColorRed:pencil10.red Green:pencil10.green Blue:pencil10.blue Alpha:pencil10.alpha];
    [[self.pencils objectAtIndex:9] setReflexColorRed:pencil11.red Green:pencil11.green Blue:pencil11.blue Alpha:pencil11.alpha];
    [[self.pencils objectAtIndex:10] setReflexColorRed:pencil12.red Green:pencil12.green Blue:pencil12.blue Alpha:pencil12.alpha];
    [[self.pencils objectAtIndex:11] setReflexColorRed:pencil12.red Green:pencil12.green Blue:pencil12.blue Alpha:0.0];

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    
//    NSLog(@"PIC: ViewDidLoad");
	
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	[app HideMainNavigationBar];
	
	// Erase the view when recieving a notification named "shake" from the NSNotificationCenter object
	// The "shake" nofification is posted by the PaintingWindow object when user shakes the device
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:@"shake" object:nil];
	
    UIColor* tempColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"FlowCoverBack.png"]];

    
	self.view.backgroundColor = tempColor;
	[tempColor release]; 
    	
	[self selectInitialImage];
	
	//UIImage* selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", app.selectedImageName]];
	
	UIImage* selectedImage;
//	NSString* imagePath = [NSString stringWithFormat:@"%@/Book1/%@.png", [[NSBundle mainBundle] resourcePath], app.selectedImageName];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    int booknumber = [defaults integerForKey:@"lastViewedBook"];
//    NSString *key = [NSString stringWithFormat:@"lastViewedPageForBook%d", booknumber];
//    int pagenumber = [defaults integerForKey:key];
    int booknumber = self.currentBook.number;
    int pagenumber = self.currentPage.number;    
    NSString* imagePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];

//    NSLog(@"paintImageController: restored defaults: lastViewedBook = %d, lastViewedPage = %d", booknumber, pagenumber);
//    NSLog(@"paintImageController: imagePath is: %@", imagePath);
    
	
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
	
	if (imagePathExists)
	{
		selectedImage = [UIImage imageWithContentsOfFile:imagePath];
	}
	
	// Отступ верхнего левого угла бумаги для рисования
	CGFloat imageOriginX = 184; //134;
	CGFloat imageOriginY = 100; //148;
    
    OpenGLViewController* oglvc = [[OpenGLViewController alloc] init];
//    oglvc.view.frame = CGRectMake(imageOriginX, imageOriginY, 560, 800);
    oglvc.interfaceManager.currentBook = self.currentBook;
    oglvc.interfaceManager.currentPage = self.currentPage;
    
    [self.view addSubview:oglvc.view];

//        DynamicTexturesAppDelegate *ptr = [DynamicTexturesAppDelegate SharedAppDelegate];
//        [ptr ShowController:oglvc backButtonTitle:@"Back"];
    
	
	// Добавляем фон с выбранной картинкой (рисуют на view выше фона)
//	selectedImage = [self addTextureToImage:[UIImage imageNamed:@"paperTexture1.png"] selectedImage:selectedImage];
//	paintingViewBg = [[UIImageView alloc] initWithImage:selectedImage];
//	paintingViewBg.frame = CGRectMake(imageOriginX, imageOriginY, selectedImage.size.width, selectedImage.size.height);
////#define IMAGE_SIZE_X 560
////#define IMAGE_SIZE_Y 800
////    paintingViewBg.frame = CGRectMake(imageOriginX, imageOriginY, IMAGE_SIZE_X, IMAGE_SIZE_Y);
//    
//	[self.view insertSubview:paintingViewBg atIndex:0];
//	[paintingViewBg release];
//		
//	// Это view, на котором рисуют
//	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PaintingView" owner:self options:nil];
//	paintingView = [topLevelObjects objectAtIndex:0];
//    paintingView.delegate = self;
//	paintingView.frame = CGRectMake(imageOriginX, imageOriginY, selectedImage.size.width, selectedImage.size.height);
//	[paintingView initDefaults:selectedImage];
//	[paintingView setBrushColorWithRed:1.0 green:0.0 blue:0.0];
//	
//	// Слой полупрозрачный, иначе не увидим фоновую картинку
////	paintingView.alpha = kPaintingViewAlpha;
//		
//    //загружаем области рисования из файла
//    [paintingView loadAreasFromFileForBookNumber:booknumber Page:pagenumber];
//    
//	[self.view insertSubview:paintingView atIndex:1];
//    
//    [paintingView erase];    
//    [self restoreImageBookNumber:booknumber PageNumber:pagenumber];
//	
//	// А это view для выделения текущей активной области
//	silhuetteView = [[SilhuetteView alloc] initWithFrame:CGRectMake(imageOriginX, imageOriginY, selectedImage.size.width, selectedImage.size.height)];
//	[self.view insertSubview:silhuetteView atIndex:2];
//	[silhuetteView release];
	
	// Добавляем тени от бумаги
	UIImageView* paperShadowHorizontal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paperShadowHorizontal.png"]];
	paperShadowHorizontal.frame = CGRectMake(imageOriginX, imageOriginY+800, 560, 29);
	[self.view insertSubview:paperShadowHorizontal atIndex:3];
	[paperShadowHorizontal release];
	
	UIImageView* paperShadowVertical = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paperShadowVertical.png"]];
	paperShadowVertical.frame = CGRectMake(imageOriginX + 560, imageOriginY + 10, 22, 828);
	[self.view insertSubview:paperShadowVertical atIndex:3];
	[paperShadowVertical release];
	
	// Добавляем "кнопку" поверх картинки
	UIImage* pinImage = [UIImage imageNamed:@"pin.png"];
	pinView = [[UIImageView alloc] initWithImage:pinImage];
	pinView.frame = CGRectMake(imageOriginX + 270, imageOriginY - 10, pinImage.size.width, pinImage.size.height);
	[self.view addSubview:pinView];
	[pinView release];
	
    //инициализируем карандаши
    [self initPencils];
    
	// Настраиваем slider выбора размера кисти
	brushSizeSlider.minimumValue = brushMinSize;
	brushSizeSlider.maximumValue = brushMaxSize;
	brushSizeSlider.continuous = NO;
	
	UIImage* thumbImage = [UIImage imageNamed:@"thumbSlider.png"];
	[brushSizeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
	[brushSizeSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
	
	UIImage* trackImage = [UIImage imageNamed:@"sliderTrack"];
	[brushSizeSlider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
	[brushSizeSlider setMaximumTrackImage:trackImage forState:UIControlStateNormal];

    colorPickerController = [[ColorPickerViewController alloc] init];
    
	if (app.paintMode == paintModeSimple)
	{
        
//        NSLog(@"app.paintMode == paintModeSimple");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        brushSizeSlider.value = [defaults floatForKey:@"brushSize"];
        if (brushSizeSlider.value == 0) {
            brushSizeSlider.value = brushDefaultSize;
            [defaults setFloat:brushDefaultSize forKey:@"brushSize"];        
            [defaults synchronize];
        }
        
//		brushSizeSlider.value = brushInitialSizeSimple;
		[brushSizeSlider setEnabled:NO];
        

//        [paintModeButton setTitle: @"Заливка" forState: UIControlStateNormal];
        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeFill"];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
        
        brushSizeSlider.alpha = 0;
        sliderImage.alpha = 0;
        [self setColorCirclesColorsRed:1.0 Green:0.0 Blue:0.0 Alpha:0.0];
    
    }
	else 
	{
        
//        NSLog(@"app.paintMode != paintModeSimple");

        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeBorders2"];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
        
//		brushSizeSlider.value = brushInitialSizeMedium;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        brushSizeSlider.value = [defaults floatForKey:@"brushSize"];
        if (brushSizeSlider.value == 0) {
            brushSizeSlider.value = brushDefaultSize;
            [defaults setFloat:brushDefaultSize forKey:@"brushSize"];        
            [defaults synchronize];
        }
        
        brushSizeSlider.alpha = 1;
        sliderImage.alpha = 1;
        [self setColorCirclesColorsRed:1.0 Green:0.0 Blue:0.0 Alpha:1.0];

	}

    

    
	// Выбираем начальный карандаш
    defaultPencil = [self.pencils objectAtIndex:2];
    [self pencilClicked:defaultPencil];
    
    [nextButton setImage:[UIImage imageNamed:@"next_disabled"] forState:UIControlStateDisabled];
    [prevButton setImage:[UIImage imageNamed:@"prev_disabled"] forState:UIControlStateDisabled];
    
//	[paintingView becomeFirstResponder];
	
    [super viewDidLoad];
}


-(void) viewDidAppear:(BOOL)animated
{
    
//    NSLog(@"PIC: ViewDidAppear");

//    NSLog(@"PaintImageController: viewDidAppear");
    
//    self.currentBook = [self.delegate bookNumber:0];
//    self.currentPage = [self.delegate pageNumber:2 InBook:self.currentBook];

    
//    [self pickImage:1];
    
//	[self restoreImageBookNumber:self.currentBook.number PageNumber:self.currentPage.number];
	
	[super viewDidAppear:animated];
	
	/*
	 UIImage* selectedImage = [UIImage imageNamed:@"prin_small.jpg"];
	 UIView* imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
	 UIImageView* subView   = [[UIImageView alloc] initWithImage:selectedImage];
	 [imageView addSubview:subView];
	 [subView release];
	 UIImage* blendedImage =nil;
	 UIGraphicsBeginImageContext(imageView.frame.size);
	 [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	 blendedImage = UIGraphicsGetImageFromCurrentImageContext();
	 UIGraphicsEndImageContext();
	 [imageView release];
	 [paintingView mergeWithImage: blendedImage];
	 */
}

-(void)viewDidDisappear:(BOOL)animated 
{
//    NSLog(@"PIC: ViewDidDisappear");

//	[paintingView removeFromSuperview];
//	[silhuetteView removeFromSuperview];
//	[paintingViewBg removeFromSuperview];
	
//	if (colorPickerPopover != nil)
//	{
//		[colorPickerPopover release];
//	}
	
	if (colorPickerController != nil) 
	{
		[colorPickerController release];
	}
	
	[pinView removeFromSuperview];
		
	[brushSizeSlider removeFromSuperview];
//	[brushSizeSlider release];
//	
	[eraserButton removeFromSuperview];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"shake" object:nil];
	
	self.view.backgroundColor = nil;
	[self.view removeFromSuperview];
//	[self.view release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
//    return NO;
    return ( (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    // WARNING!!! Здесь падает !!!
//    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    
    NSLog(@"PIC: ViewDidUnload");

    
//	paintingView = nil;
//	colorPickerPopover = nil;
//	colorPickerController = nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)releaseOutlets
{
    for (Pencil *p in pencils) {
        p = nil;
    }
}

- (void)dealloc {
	
	if (paintingView != nil)
	{
		[paintingView release];
	}
	
	if (colorPickerPopover != nil)
	{
		[colorPickerPopover release];
	}
	
    if (colorPickerController != nil) 
	{
		[colorPickerController release];
	}
    
    [self releaseOutlets];
	
    [super dealloc];
}

- (UIImage*) addTextureToImage: (UIImage*) textureImage selectedImage:(UIImage*)selectedImage
{
	UIGraphicsBeginImageContext(selectedImage.size);
    [selectedImage drawInRect:CGRectMake(0, 0, selectedImage.size.width, selectedImage.size.height)];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
	CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
	CGImageRef cgImage = textureImage.CGImage;
	
	CGContextTranslateCTM(ctx, 0, textureImage.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	CGContextDrawImage(ctx, CGRectMake(0, 0, textureImage.size.width, textureImage.size.height), cgImage);
	CGContextSetBlendMode(ctx, kCGBlendModeNormal);
	
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return resultImage;
}

#pragma mark -
#pragma mark Инструменты

- (IBAction)paintModeButtonClicked:(id)sender
{
	DynamicTexturesAppDelegate* curApp = [DynamicTexturesAppDelegate SharedAppDelegate];
	
//	if (curApp.paintMode == paintModeHard)
//	{
////		brushSizeSlider.value = brushInitialSizeSimple;
////		[paintingView setBrushSize:brushInitialSizeSimple];
//		[brushSizeSlider setEnabled:NO];
//		
//		curApp.paintMode = paintModeSimple;
//		[paintModeButton setTitle: @"Заливка" forState: UIControlStateNormal];
//        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeFill"];
//        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
//	}
//	else 
    if (curApp.paintMode == paintModeSimple)
	{

//        brushSizeSlider.value = brushInitialSizeMedium;
//		[paintingView setBrushSize:brushInitialSizeMedium];
		[brushSizeSlider setEnabled:YES];
		
		curApp.paintMode = paintModeMedium;
		[paintModeButton setTitle: @"Границы" forState: UIControlStateNormal];
        
        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeBorders2"];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];

//        curApp.paintMode = paintModeHard;
//        [brushSizeSlider setEnabled:YES];
//		[paintModeButton setTitle: @"Произвольный" forState: UIControlStateNormal];
//        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeFreestyle2"];
//        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
        
        brushSizeSlider.alpha = 1;
        sliderImage.alpha = 1;
        colorCircleBig.alpha = 1;
        colorCircleSmall.alpha = 1;

        
	}
	else if (curApp.paintMode == paintModeMedium)
	{
//        brushSizeSlider.value = brushInitialSizeSimple;
//		[paintingView setBrushSize:brushInitialSizeSimple];
		[brushSizeSlider setEnabled:NO];
		
		curApp.paintMode = paintModeSimple;
		[paintModeButton setTitle: @"Заливка" forState: UIControlStateNormal];
        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeFill"];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
        
        brushSizeSlider.alpha = 0;
        sliderImage.alpha = 0;
        colorCircleBig.alpha = 0;
        colorCircleSmall.alpha = 0;
        
//		curApp.paintMode = paintModeHard;
//		[paintModeButton setTitle: @"Произвольный" forState: UIControlStateNormal];
//        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeFreestyle2"];
//        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];

	}
}

- (IBAction)undo:(id)sender
{
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString* filePath = [NSString stringWithFormat:@"%@/Book1/SavedData/%@Prev.png", documents, app.selectedImageName];
	
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (imagePathExists)
	{
		UIImage* imageToAdd = [UIImage imageWithContentsOfFile:filePath];
		UIView* imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
		UIImageView* subView   = [[UIImageView alloc] initWithImage:imageToAdd];
		
		[imageView addSubview:subView];
		[subView release];
		
		UIImage* blendedImage =nil;
		UIGraphicsBeginImageContext(imageView.frame.size);
		[imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
		blendedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[imageView release];
		
		[paintingView erase];
		[paintingView mergeWithImage:blendedImage];
		
//		UIImage* viewImage = [paintingView imageRepresentation];
//		[app saveCurrentImage:viewImage];
//        [app saveCurrentImage:viewImage BookNumber:self.currentBook.number PageNumber:self.currentPage.number];
	}
}

- (void)sliderAction:(UISlider*)sender
{
    
//    NSLog(@"PaintImageController: SLIDER TOUCHED");
    
	float sliderValue = sender.value;
    NSInteger intValue = round(sliderValue);
	
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	if (app.paintMode != paintModeSimple)
	{
		[paintingView setBrushSize:intValue];
	}
}

- (IBAction)exitPaintImage:(id)sender
{
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
    
    UIImage* viewImage = [paintingView imageRepresentation];
    [app saveCurrentImage:viewImage BookNumber:self.currentBook.number PageNumber:self.currentPage.number];

    
	[app goBack];
}

- (IBAction)restart:(id)sender
{
	if (paintingView != nil)
	{
		[paintingView restartDrawing];
	}
}

- (IBAction)prev:(id)sender
{
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	[app showLoadingStatus];
    
    UIImage* viewImage = [paintingView imageRepresentation];
    [app saveCurrentImage:viewImage BookNumber:self.currentBook.number PageNumber:self.currentPage.number];

    
//    NSLog(@"PaintImageController: prev button pressed");
	
	[self performSelectorInBackground:@selector(prevImage) withObject:nil];
    
}

- (IBAction)next:(id)sender
{
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	[app showLoadingStatus];
    
    
    UIImage* viewImage = [paintingView imageRepresentation];
    [app saveCurrentImage:viewImage BookNumber:self.currentBook.number PageNumber:self.currentPage.number];
	
//    NSLog(@"PaintImageController: next button pressed");
    
	[self performSelectorInBackground:@selector(nextImage) withObject:nil];
    
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self nextImage];
//    });
//    [self nextImage];
}

- (IBAction)publish:(id)sender
{
	/*
	UIImage* viewImage = [paintingView imageRepresentation];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString *filePath = [documents stringByAppendingPathComponent:@"Screenshot.png"];
	
	// Write image to PNG
	[UIImagePNGRepresentation(viewImage) writeToFile:filePath atomically:YES];
	*/
}

#pragma mark -
#pragma mark Управление картинками


-(void) selectInitialImage
{

	
    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];

//	int lastViewedPage = [[app.savedUserData getLastViewedPageNumberOfBook:@"book1"] intValue];
//   NSString *bookname = [NSString stringWithFormat:@"book%d", self.currentBook.number];
//    int lastViewedPage = [[app.savedUserData getLastViewedPageNumberOfBook:bookname] intValue];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int booknumber = [defaults integerForKey:@"lastViewedBook"];
    NSString *key = [NSString stringWithFormat:@"lastViewedPageForBook%d", booknumber];
    int pagenumber = [defaults integerForKey:key];
    
//	int lastViewedPage = [[app.savedUserData getLastViewedPageNumberOfBook:bookname] intValue];
    
    int lastViewedPage = pagenumber;
    
//	NSString* path = [NSString stringWithFormat:@"%@/Book1", [[NSBundle mainBundle] resourcePath]];
	//NSLog(path);
    NSString* path = [NSString stringWithFormat:@"%@/books/book%d/images/", [[NSBundle mainBundle] resourcePath], self.currentBook.number];

	
	NSArray* bookImages = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	
	int index = 0;
	
	for(NSString* imagePath in bookImages)
	{
		if ([imagePath rangeOfString:@".png"].location != NSNotFound)
		{
			index++;
			
			if (index == lastViewedPage)
			{
				app.selectedImageName = [imagePath stringByReplacingOccurrencesOfString:@".png" withString:@""];
			}
		}
	}
	
	imageIndex = lastViewedPage;
	

    
    NSString *imagePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
     
    app.selectedImageName = [imagePath stringByReplacingOccurrencesOfString:@".png" withString:@""];
    imageIndex = pagenumber+1;
    
	if (index < imageIndex + 1)
	{
		[nextButton setEnabled:NO];
	}
	else 
	{
		[nextButton setEnabled:YES];
	}
	
	if (imageIndex == 1)
	{
//        if (TRUE);//test
		[prevButton setEnabled:NO];
	}
	else 
	{
		[prevButton setEnabled:YES];
	}
}

- (void)prevImage
{
//    NSLog(@"PaintImageController: imageIndex = %d", imageIndex);
//    self.currentPage = [self.delegate pageNumber:(imageIndex-1) InBook:self.currentBook];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    
    self.currentPage = [self.delegate pageNumber:(self.currentPage.number-1) InBook:self.currentBook];
    
    NSString *newImagePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], self.currentBook.number, self.currentPage.number];
    paintingViewBg.image = [UIImage imageWithContentsOfFile:newImagePath];
	[self pickImage:(imageIndex - 1)];
    [paintingView loadAreasFromFileForBookNumber:self.currentBook.number Page:self.currentPage.number];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"lastViewedPageForBook%d", self.currentBook.number];
    [defaults setInteger:(imageIndex-1) forKey:key];
    [defaults setInteger:self.currentBook.number forKey:@"lastViewedBook"];

    if (![defaults synchronize]) NSLog(@"ERROR: Failed to synchronize lastViewedPage in [PaintImageController prevImage]");

    
//    NSLog(@"PaintImageController: saved %@ = %d", key, imageIndex-1);
    
//    NSLog(@"PaintImageController: self.currentPage = %d", self.currentPage.number);
    
    [pool drain];
    
}

- (void)nextImage
{
//    NSLog(@"PaintImageController: imageIndex = %d", imageIndex);
//    self.currentPage = [self.delegate pageNumber:(imageIndex-1) InBook:self.currentBook];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    
    self.currentPage = [self.delegate pageNumber:(self.currentPage.number+1) InBook:self.currentBook];
    NSString *newImagePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], self.currentBook.number, self.currentPage.number];
    paintingViewBg.image = [UIImage imageWithContentsOfFile:newImagePath];
	[self pickImage:(imageIndex + 1)];
    [paintingView loadAreasFromFileForBookNumber:self.currentBook.number Page:self.currentPage.number];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"lastViewedPageForBook%d", self.currentBook.number];
    [defaults setInteger:(imageIndex-1) forKey:key];
    [defaults setInteger:self.currentBook.number forKey:@"lastViewedBook"];
    
    if (![defaults synchronize]) NSLog(@"ERROR: Failed to synchronize lastViewedPage in [PaintImageController nextImage]");

    
//    NSLog(@"PaintImageController: saved %@ = %d", key, imageIndex-1);    
//    NSLog(@"PaintImageController: self.currentPage = %d", self.currentPage.number);
    
    [pool drain];

}

-(void)pickImage:(int) pickImageIndex
{   
//    NSLog(@"PaintImageController: start picking image");
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSString* path = [NSString stringWithFormat:@"%@/books/book%d/images", [[NSBundle mainBundle] resourcePath], self.currentBook.number];
    
//    NSLog(@"PaintImageController > pickImage:  path is %@", path);
	
	NSArray* bookImages = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	
	int index = 0;
	
	for(NSString* imagePath in bookImages)
	{
		if ([imagePath rangeOfString:@".png"].location != NSNotFound)
		{
			index++;
			
			if (index == pickImageIndex)
			{
				app.selectedImageName = [imagePath stringByReplacingOccurrencesOfString:@".png" withString:@""];
//                NSLog(@"PaintImageController > pickImage: app.selectedImageName = %@", app.selectedImageName);
			}
		}
	}
	
    imageIndex = pickImageIndex;
	
	if (index < imageIndex + 1)
	{
		[nextButton setEnabled:NO];
	}
	else 
	{
		[nextButton setEnabled:YES];
	}
	
	if (imageIndex == 1)
	{
		[prevButton setEnabled:NO];
	}
	else 
	{
		[prevButton setEnabled:YES];
	}
	
//	[app.savedUserData saveLastViewedPageNumberOfBook:@"book1" pageNumber:[NSString stringWithFormat:@"%i", imageIndex]];
//    NSString *booknumber = [NSString stringWithFormat:@"book%d", self.currentBook.number];
//    NSString *pagenumber = self.currentPage.number; 
    int booknumber = self.currentBook.number;
    int pagenumber = self.currentPage.number;
    
//    [app.savedUserData saveLastViewedPageNumberOfBook:booknumber pageNumber:pagenumber];

	
//	NSString* imagePath = [NSString stringWithFormat:@"%@/Book1/%@.png", [[NSBundle mainBundle] resourcePath], app.selectedImageName];
	NSString* imagePath = [NSString stringWithFormat:@"%@/books/book%d/images/%@.png", [[NSBundle mainBundle] resourcePath], self.currentBook.number, app.selectedImageName];
    
//    NSString* imagePath = [NSString stringWithFormat:@"%@/library/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], self.currentBook.number, pickImageIndex];
	
	
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
	
	if (imagePathExists)
	{
        UIImage* selectedImage = [UIImage imageWithContentsOfFile:imagePath];
        selectedImage = [self addTextureToImage:[UIImage imageNamed:@"paper2.png"] selectedImage:selectedImage];
//        NSLog(@"PaintImageController: selectedImage added to texture");

        
         paintingViewBg.image = selectedImage;
//        NSLog(@"PaintImageController: paintingViewBg set up image");
		
//		[paintingView erase]; //очищаем paintingview
//        NSLog(@"PaintImageController: paintingView erased");
        
//		[paintingView changeImage:selectedImage]; //flooder подгружает areas из файла
//       NSLog(@"PaintImageController: paintingView changed image to selected image");
//        [paintingView erase];
		[self restoreImageBookNumber:booknumber PageNumber:pagenumber]; //считываем сохраненную картинку из файла и выводим ее на paintingview
//        NSLog(@"PaintImageController: paintingView restored image");
        
//        [paintingView getAreasForPixels:pickImageIndex];

//        [paintingView loadAreasFromFileForPictureIndex:pickImageIndex];
//        [paintingView loadAreasFromFileForBookNumber:self.currentBook.number Page:self.currentPage.number];
	} else {
        NSLog(@"PaintImageController: imagePath %@ does not exist", imagePath);
    }
        
    
//    NSLog(@"PaintImageController: ready to hide indicator");
	
	[app hideLoadingStatus];
    
//    NSLog(@"PaintImageController: loading indicator hidden");
	
	[pool drain];
    
//    NSLog(@"PaintImageController: pool drained");
}

- (void)restoreImageBookNumber:(int)booknumber PageNumber:(int)pagenumber
{
    
    [paintingView erase];

    
 
//    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
		
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
//    NSLog(@"paths are %@", paths);
    
	NSString *documents = [[paths objectAtIndex:0] retain];
    
//    NSLog(@"documents are %@", documents);
    
//    NSLog(@"app.selectedImegename is%@", app.selectedImageName);
    
    
//	NSString* filePath = [NSString stringWithFormat:@"%@/Book1/SavedData/%@.png", documents, app.selectedImageName];
//    NSString* filePath = [NSString stringWithFormat:@"%@/Book1/SavedData/%@.png", documents, app.selectedImageName];
    NSString *filePath = [NSString stringWithFormat:@"%@/SavedData/drawings/book%d/%d.png", documents, booknumber, pagenumber];
    

	
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (imagePathExists)
	{
		UIImage* imageToAdd = [UIImage imageWithContentsOfFile:filePath];
        UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
		UIImageView* imageView   = [[UIImageView alloc] initWithImage:imageToAdd];
		
		[containerView addSubview:imageView];
		[imageView release];
		
                
		UIImage* blendedImage = nil;
		UIGraphicsBeginImageContext(containerView.frame.size);
		[containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
		blendedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[containerView release];
        
         
		[paintingView setImage:blendedImage];
//        NSLog(@"PaintImageController: end of [paintingView setImage:blendedImage]");
	} else {
        NSLog(@"PaintImageController: failed to restore image. Path %@ does not exist.", filePath);
    }
 

}

#pragma mark -
#pragma mark Colors
/*
- (IBAction)colorButtonClicked:(id)sender
{
    NSLog(@"- (IBAction)colorButtonClicked:(id)sender");	
    
	isCustomColorActive = NO;
	
	[self restoreEraser];
		
	UIButton* clickedButton = (UIButton*)sender;
	
	if (clickedButton.frame.size.width != 145)
	{
		CGRect buttonRect = clickedButton.frame;
		buttonRect.size.width = 145;
		[clickedButton setImage:[UIImage imageNamed: [NSString stringWithFormat:@"pencil%iSelected", [sender tag]]] forState:UIControlStateNormal];
		clickedButton.frame = buttonRect;
		
		[self layOldPencil];
		
		prevPencilButton = clickedButton;
	}
		
	[self changeCurrentColor:sender];
}
*/
/*
- (void)changeCurrentColor:(id)button
{
	NSInteger tag = [button tag];
	
	CGFloat red;
	CGFloat green;
	CGFloat blue;
	
	if (tag == 1)
	{
		red = 0.059;
		green = 0.059;
		blue = 0.059;
	}
	else if (tag == 2)
	{
		red = 0.664;
		green = 0.395;
		blue = 0.051;
	}
	else if (tag == 3)
	{
		red = 0.711;
		green = 0.066;
		blue = 0.066;
	}
	else if (tag == 4)
	{
		red = 0.872;
		green = 0.641;
		blue = 0.121;
	}
	else if (tag == 5)
	{
		red = 0.871;
		green = 0.832;
		blue = 0.191;
	}
	else if (tag == 6)
	{
		red = 0.141;
		green = 0.516;
		blue = 0.129;
	}
	else if (tag == 7)
	{
		red = 0.477;
		green = 0.871;
		blue = 0.871;
	}
	else if (tag == 8)
	{
		red = 0.570;
		green = 0.527;
		blue = 0.898;
	}
	else if (tag == 9)
	{
		red = 0.820;
		green = 0.523;
		blue = 0.890;
	}
	else if (tag == 10)
	{
		red = 0.898;
		green = 0.531;
		blue = 0.855;
	}
	else if (tag == 11)
	{
		red = 0.891;
		green = 0.891;
		blue = 0.891;
	}
	
//	colorCircleSmall.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//	colorCircleBig.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//    [colorCircleSmall setColorRed:red Green:green Blue:blue Alpha:1.0];
//    [colorCircleBig setColorRed:red Green:green Blue:blue Alpha:1.0];
    
    [self setColorCirclesColorsRed:red
                             Green:green
                              Blue:blue
                             Alpha:1.0];   
    
	[paintingView setBrushColorWithRed:red green:green blue:blue];
	[colorPickerController pickColorWithRed:red green:green blue:blue];
     
}
*/

- (void)changeCurrentDrawingColor:(Pencil *)currpencil
{

    
    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
    
    if (app.paintMode == paintModeMedium) {
        [self setColorCirclesColorsRed:currpencil.red
                                 Green:currpencil.green
                                  Blue:currpencil.blue
                                 Alpha:currpencil.alpha];
    } else {
        [self setColorCirclesColorsRed:currpencil.red
                                 Green:currpencil.green
                                  Blue:currpencil.blue
                                 Alpha:0.0];        
    }

    [paintingView setBrushColorWithRed:currpencil.red green:currpencil.green blue:currpencil.blue];
    [colorPickerController pickColorWithRed:currpencil.red green:currpencil.green blue:currpencil.blue];
}


- (IBAction)colorPickerButtonClicked:(id)sender
{
//	[self layOldPencil];
    [self putDownOldPencil];
	
	UIButton *button = (UIButton *)sender;
	
	if (colorPickerPopover == nil) 
	{
		  self.colorPickerPopover = [[[UIPopoverController alloc] initWithContentViewController:colorPickerController] autorelease];
	}

	[colorPickerPopover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
	
//	[colorPickerController setColorPickerDelegate:self];
    colorPickerController.delegate = self;
}

- (void)restoreEraser
{
	if (eraserButton.frame.size.width != 113)
	{
		[eraserButton setImage:[UIImage imageNamed:@"eraser"] forState:UIControlStateNormal];
		eraserButton.frame = CGRectMake(eraserButton.frame.origin.x, eraserButton.frame.origin.y, 113, 123);
		
//		DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
//		
//		if (app.paintMode != paintModeSimple)
//		{
//			brushSizeSlider.maximumValue = brushMaxSize;
//			[brushSizeSlider setValue:prevBrushSize];
//			
//			float sliderValue = prevBrushSize;
//			NSInteger intValue = round(sliderValue);
////			[paintingView setBrushSize:intValue];
//		}
	}
}

- (void)setColorCirclesColorsRed:(float) newred Green:(float)newgreen Blue:(float)newblue
{
    self.colorCircleSmall.red = newred;
    self.colorCircleSmall.green = newgreen;
    self.colorCircleSmall.blue = newblue;
    
    self.colorCircleBig.red = newred;
    self.colorCircleBig.green = newgreen;
    self.colorCircleBig.blue = newblue;
}


- (void)setColorCirclesColorsRed:(float) newred Green:(float)newgreen Blue:(float)newblue Alpha:(float) newalpha
{
    self.colorCircleSmall.red = newred;
    self.colorCircleSmall.green = newgreen;
    self.colorCircleSmall.blue = newblue;
    self.colorCircleSmall.alpha = newalpha;
    
    self.colorCircleBig.red = newred;
    self.colorCircleBig.green = newgreen;
    self.colorCircleBig.blue = newblue;
    self.colorCircleBig.alpha = newalpha;
}

- (IBAction)pencilClicked:(Pencil *)sender
{
    
    isCustomColorActive = NO;
	
	[self restoreEraser];
    
//    NSLog(@"pencilClicked. sender - %@", [sender description]);
    if ((!sender.isSelected)) {
//        NSLog(@"sender is NOT selected");
        sender.isSelected = TRUE;
        sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, 103+45, 37);
        [sender setNeedsDisplay];
        
        if (![sender isEqual:prevPencil])[self putDownOldPencil];
    }
    
    prevPencil = sender;
    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
    
    if (app.paintMode == paintModeMedium) {
        [self setColorCirclesColorsRed:sender.red 
                                 Green:sender.green 
                                  Blue:sender.blue 
                                 Alpha:sender.alpha];
    }
    [self changeCurrentDrawingColor:sender];
    
}




- (IBAction)eraserClicked:(id)sender
{
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
			[self undo:self];
		}
	}
	
	if (eraserButton.frame.size.width != 134)
	{
		// Первый клик
		prevBrushSize = brushSizeSlider.value;
		
		[paintingView serEraserBrush];
		
		[eraserButton setImage:[UIImage imageNamed:@"eraserSelected"] forState:UIControlStateNormal];
//		eraserButton.frame = CGRectMake(0, 860, 134, 104);
        eraserButton.frame = CGRectMake(eraserButton.frame.origin.x, eraserButton.frame.origin.y, 134, 104);
			
//		DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
		
//		if (app.paintMode != paintModeSimple)
//		{
//			brushSizeSlider.maximumValue = eraserMaxSize;
//			[brushSizeSlider setValue:30];
//			[paintingView setBrushSize:30];
//		}
			
        [self setColorCirclesColorsRed:1.0 Green:1.0 Blue:1.0 Alpha:0.0];
//		[self layOldPencil];
        [self putDownOldPencil];
	}
	else 
	{
		// Повторный клик
		[self restoreEraser];
		
		if (!isCustomColorActive)
		{
//			CGRect buttonRect = prevPencilButton.frame;
//			buttonRect.size.width = 145;
//			[prevPencilButton setImage:[UIImage imageNamed: [NSString stringWithFormat:@"pencil%iSelected", [prevPencilButton tag]]] forState:UIControlStateNormal];
//			prevPencilButton.frame = buttonRect;
            
            prevPencil.isSelected = TRUE;
            prevPencil.frame = CGRectMake(prevPencil.frame.origin.x, prevPencil.frame.origin.y, 103+45, 37);
            [prevPencil setNeedsDisplay];
			
//			[self changeCurrentColor:prevPencilButton];
            [self changeCurrentDrawingColor:prevPencil];
		}
		else 
		{
			[self colorChangedWithRed:currentRed green:currentGreen blue:currentBlue];
		}
	}
}
/*
-(void)layOldPencil
{
	if (prevPencilButton.frame.size.width != 95)
	{
		CGRect oldButtonRect = prevPencilButton.frame;
		oldButtonRect.size.width = 95;
		[prevPencilButton setImage:[UIImage imageNamed: [NSString stringWithFormat:@"pencil%i", [prevPencilButton tag]]] forState:UIControlStateNormal];
		prevPencilButton.frame = oldButtonRect;
	}
}
 */
- (void) putDownOldPencil
{
    if(prevPencil) {
        prevPencil.isSelected = FALSE;
        prevPencil.frame = CGRectMake(prevPencil.frame.origin.x, prevPencil.frame.origin.y, 103, 37);
        [prevPencil setNeedsDisplay];
    }
}
#pragma mark -
#pragma mark ANColorPickerDelegate

- (void)colorChangedWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{

    DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
    if (app.paintMode == paintModeMedium) {
        [self setColorCirclesColorsRed:red Green:green Blue:blue Alpha:1.0];
    } else {
        [self setColorCirclesColorsRed:red Green:green Blue:blue Alpha:0.0];
    }
    
    
	[colorPickerController colorChangedWithRed:red green:green blue:blue];
	[paintingView setBrushColorWithRed:red green:green blue:blue];

	currentRed = red;
	currentGreen = green;
	currentBlue = blue;
	
	isCustomColorActive = YES;
}

- (void) changeSelectColorButtonColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue
{

}


- (void)newColorButtonPressed:(UIButton *)sender
{
    UIColor *newcolor = (UIColor *) sender.backgroundColor;
    
//    TO-DO: getRed... works in ios5 only!!!
//    CGFloat red, green, blue;    
//    [newcolor getRed:&red green:&green blue:&blue alpha:nil];
//    [self colorChangedWithRed:red green:green blue:blue];

    const float* colors = CGColorGetComponents(newcolor.CGColor );
    [self colorChangedWithRed:colors[0] green:colors[1] blue:colors[2]
     ];
    
//    NSLog(@"PIC newColorButtonPressed, sender = %@", sender);
    [colorPickerPopover dismissPopoverAnimated:YES];
}


- (void)processPaintingOfArea:(int)areanumber withRed:(float)red Green:(float)green Blue:(float)blue{};


@end
