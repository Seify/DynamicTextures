    //
//  RootController.m
//  KidsPaint
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootController.h"
#import "KidsPaintAppDelegate.h"
#import "PaintImageController.h"
#import "BookPurchaseViewController.h"
#import "Book.h"
#import "MKStoreManager.h"
#import "PictureShower.h"
#import "SoundManager.h"
#import <CoreText/CoreText.h>
#import <StoreKit/StoreKit.h>
#import "EditorPaintImageController.h"
#import "OpenGLViewController.h"

#import "ResourceManager.h"


@implementation RootController

@synthesize delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    
//    self.books;
		
    [super viewDidLoad];
    
    SoundManager *sm = [SoundManager sharedInstance];
    
//    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/paint_music.mp3", [[NSBundle mainBundle] resourcePath]];  
//    [sm startBackgroundMusicFilePath:soundFilePath];

    sm.mute = NO;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
//    return NO;
    return ( (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


//- (void)viewDidUnload {
////    [flowCover release];
////    flowCover = nil;
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // подгружаем данные в кэш
    for (int i=0; i<[self.delegate howManyBooks]; i++)
       [flowCover getTileAtIndex:i];
    
    [flowCover draw];
    
//    [[MKStoreManager sharedManager] requestProductData];
    
//    [self.view setNeedsDisplay];

//    NSLog(@"RootController: viewWillAppear");
}


- (void)dealloc {    
//    [delegate release];
//    [flowCover release];
    
    [booknumber release];
    [pagenumber release];
    [bookstepper release];
    [pagestepper release];
    [super dealloc];
}

/************************************************************************/
/*																		*/
/*	FlowCover Callbacks													*/
/*																		*/
/************************************************************************/

- (int)flowCoverNumberImages:(FlowCoverView *)view
{
    return [self.delegate howManyBooks];
}


- (UIImage *) convertToGrayscaleImage:(UIImage *)oldimage 
{
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, oldimage.size.width * oldimage.scale, oldimage.size.height * oldimage.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
//    NSLog(@"Root controller: context = %@", context);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [oldimage CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:oldimage.scale 
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

- (UIImage *)imageByDrawingLockOnImage:(UIImage *)image
{
	// begin a graphics context of sufficient size
	UIGraphicsBeginImageContext(image.size);
    
	// draw original image into the context
	[image drawAtPoint:CGPointZero];
    
    
     // get the context for CoreGraphics
     CGContextRef ctx = UIGraphicsGetCurrentContext();

    
    [[UIColor whiteColor] setFill];    
    CGContextBeginPath (ctx);
    CGContextMoveToPoint (ctx, image.size.width, 0);
    CGContextAddLineToPoint (ctx, image.size.width - 170, 0);
    CGContextAddLineToPoint (ctx, image.size.width, 170);
    CGContextClosePath (ctx);
    CGContextFillPath (ctx);

    //рисуем замок
    UIImage *lock = [UIImage imageNamed:@"Lock"];
    CGRect lockRect = CGRectMake(image.size.width - lock.size.width - 15,  20, lock.size.width, lock.size.height);
    [lock drawInRect:lockRect];
    
    
     CGContextShowTextAtPoint (ctx, 20, 20, "Quartz 2D", 9);


	// make image out of bitmap context
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
	return retImage;
}

// отрисовывает название книги на изображении кастомным шрифтом с обводкой и тенью.
// Использует NSAttributedString.
//
- (UIImage *)imageByDrawingTitle:(NSString *)title OnImage:(UIImage *)image WithColor:(UIColor *)color
{
	// begin a graphics context of sufficient size
	UIGraphicsBeginImageContext(image.size);
    
	// draw original image into the context
	[image drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
      
    CGContextTranslateCTM(ctx, 0, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
// Функция CTFontCreateWithName почему-то не захотела работать со шрифтом ExposureCThree
// (http://stackoverflow.com/questions/7983992/ctfontcreatewithname-returning-lastresort-font),
// поэтому создаем UIFont и конвертим его в CTFontRef.
// Для понимания полезно почитать: 
// http://iphonedevelopment.blogspot.com/2011/03/attributed-strings-in-ios.html
// http://www.freetimestudios.com/2010/09/20/ipad-and-ios-4-custom-font-loading/
    
    UIFont *font = [UIFont fontWithName:@"ExposureCThree" size:28.0];  
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, 
                                             
                                            font.pointSize, 
                                            NULL);

// Отрисовываем тень как надпись серого цвет
#define LETTER_WIDTH 15 //ширина одной буквы (подобрана примерно)
#define TITLE_HIGHT  13 //высота, на которой надпись
#define SHADOW_HIGHT TITLE_HIGHT-1 //высота, на которой тень
    
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)fontRef, (NSString *)kCTFontAttributeName, 
                                    (id)[[UIColor grayColor] CGColor], (NSString *)(kCTForegroundColorAttributeName), 
                                    (id)[[UIColor grayColor] CGColor], (NSString *) kCTStrokeColorAttributeName, 
                                    (id)[NSNumber numberWithFloat:-5.0], (NSString *)kCTStrokeWidthAttributeName, 
                                    nil];
    CFRelease(fontRef);
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:attrDictionary];
    
    
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attString);
    
    // Set text position and draw the line into the graphic context
    CGContextSetTextPosition(ctx, (image.size.width - [attString length]*LETTER_WIDTH)/2, SHADOW_HIGHT);
    CTLineDraw(line, ctx); 
    CFRelease(line); 
    
    
//отрисовываем надпись
    attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        (id)fontRef, (NSString *)kCTFontAttributeName, 
        (id)[color CGColor], (NSString *)(kCTForegroundColorAttributeName), 
        (id)[[UIColor whiteColor] CGColor], (NSString *) kCTStrokeColorAttributeName, 
        (id)[NSNumber numberWithFloat:-5.0], (NSString *)kCTStrokeWidthAttributeName, 
                                    nil];
    CFRelease(fontRef); 
    


    NSAttributedString *attString2 = [[NSAttributedString alloc] initWithString:title attributes:attrDictionary];
    CTLineRef line2 = CTLineCreateWithAttributedString((CFAttributedStringRef)attString2);
    
    
    // Set text position and draw the line into the graphic context
    CGContextSetTextPosition(ctx, (image.size.width - [attString2 length]*LETTER_WIDTH)/2, TITLE_HIGHT);
    CTLineDraw(line2, ctx);
    

    CFRelease(line2);
    

	// make image out of bitmap context
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
    [attString release];
    
//    [attString2 release];
    
	return retImage;
}


- (UIImage *)drawBookCover:(UIImage *)coverimage
{
    
    UIImage *resImage = [UIImage imageNamed:@"bookCoverBg.png"];
    
    // begin a graphics context of sufficient size
	UIGraphicsBeginImageContext(resImage.size);
    
	// draw original image into the context
	[resImage drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //рисуем обложку
    CGRect coverImageRect = CGRectMake(30,  10, resImage.size.width - 55, resImage.size.height - 50);
    [coverimage drawInRect:coverImageRect];
    
    
	// make image out of bitmap context
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
	return retImage;

    
}

- (UIImage *)flowCover:(FlowCoverView *)view cover:(int)image
{
    
    MKStoreManager *storemanager = [MKStoreManager sharedManager];
    BOOL bookIsBought = [storemanager isBookBought:image];
    
    
    NSString *path = [NSString stringWithFormat:@"%@/books/book%d/cover/cover.png", [[NSBundle mainBundle] resourcePath], image];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path])
    {
        NSLog(@"RootController: Failed to load book cover at path: %@", path);
        return nil;
    } 
    else {
        UIImage *resImage = [UIImage imageWithContentsOfFile:path]; //картинка на обложке книги
        Book *book = [self.delegate bookNumber:image];
        UIColor *color;
        switch (image){
            case 0: 
                color = [UIColor colorWithRed:155.0/255.0 
                                        green:43.0/255.0 
                                         blue:82.0/255.0 
                                        alpha:1.0];
                break;
            case 1:
                color = [UIColor colorWithRed:34.0/255.0 
                                        green:83.0/255.0 
                                         blue:159.0/255.0 
                                        alpha:1.0];
                break;
            case 2:
                color = [UIColor colorWithRed:209.0/255.0 
                                        green:146.0/255.0 
                                         blue:9.0/255.0 
                                        alpha:1.0];
                break;
            case 3:
                color = [UIColor colorWithRed:52.0/255.0 
                                        green:113.0/255.0 
                                         blue:6.0/255.0 
                                        alpha:1.0];
                break;
            default:
                color = [UIColor blueColor];
        }
        resImage = [self imageByDrawingTitle:book.title OnImage:resImage WithColor:color];//название книги
        if (!bookIsBought) {
            resImage = [self convertToGrayscaleImage:resImage];     //переводим в чб
            resImage = [self imageByDrawingLockOnImage:resImage];   //рисуем замОк
        }    
        resImage = [self drawBookCover:resImage];                   //обложка книги

        return resImage;
    }
}

- (void)flowCover:(FlowCoverView *)view didSelect:(int)image
{
    
    MKStoreManager *storemanager = [MKStoreManager sharedManager];
    
    [storemanager requestProductData];

    
    BOOL bookIsBought = [storemanager isBookBought:image];
    
    if (bookIsBought) {
//        NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *key = [NSString stringWithFormat:@"lastViewedBook"];
//        [myUserDefaults setInteger:(image) forKey:key];
//        
//        KidsPaintAppDelegate *ptr = [KidsPaintAppDelegate SharedAppDelegate];
//        PaintImageController* paintController = [[PaintImageController alloc] initWithNibName:@"PaintImageController" bundle:nil];
//        paintController.delegate = self.delegate;
//        paintController.currentBook = [self.delegate bookNumber:image];
//        
//        key = [NSString stringWithFormat:@"lastViewedPageForBook%d", image];
//        int pagenumber = [myUserDefaults integerForKey:key];
//        paintController.currentPage = [self.delegate pageNumber:pagenumber InBook:paintController.currentBook];    
//        [ptr ShowController:paintController backButtonTitle:@"Back"];
        
        NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
        [myUserDefaults setInteger:(image) forKey:@"lastViewedBook"];
        NSString *key = [NSString stringWithFormat:@"lastViewedPageForBook%d", image];
        int currentPageNumber = [myUserDefaults integerForKey:key];
    
        
        [flowCover invalidateCache];
        
        BookManager *bm = [BookManager sharedInstance];
        Book *book = [bm bookNumber:image];
        Page *page = [bm pageNumber:currentPageNumber InBook:book];
//        Page *page = [bm pageNumber:0 InBook:book];

        OpenGLViewController* oglvc = [[OpenGLViewController alloc] init];
        oglvc.interfaceManager.currentBook = book;
        oglvc.interfaceManager.currentPage = page;

        KidsPaintAppDelegate *ptr = [KidsPaintAppDelegate SharedAppDelegate];
        [ptr ShowController:oglvc backButtonTitle:@"Back"];

        [oglvc release];
        
    } else {
        KidsPaintAppDelegate *ptr = [KidsPaintAppDelegate SharedAppDelegate];
        BookPurchaseViewController* bpvc = [[BookPurchaseViewController alloc] initWithNibName:@"BookPurchaseViewController" bundle:nil];
        NSString *bookID = [NSString stringWithFormat:@"ru.aplica.kidspaint.books.book%d", image];
        bpvc.bookPrice = [storemanager priceForIdentifier:bookID];
        bpvc.delegate = self.delegate;
        bpvc.bookToScroll = [self.delegate bookNumber:image];
        [ptr ShowController:bpvc backButtonTitle:@"Back"];
    }
}

- (IBAction)mindGamePressed {
    
    NSLog(@"MindGame pressed");
    
    KidsPaintAppDelegate *ptr = [KidsPaintAppDelegate SharedAppDelegate];
    PictureShower* ps = [[PictureShower alloc] initWithNibName:@"PictureShower" bundle:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/SavedData/editor/book%d/%d.png", documents, (int)bookstepper.value, (int)pagestepper.value];
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (imagePathExists)
	{
        ps.perfectImage = [UIImage imageWithContentsOfFile:filePath];
	} else {
        NSLog(@"RootController: failed to restore image. Path %@ does not exist.", filePath);
    }
    
    
    BookManager *bm = [BookManager sharedInstance];
    
    ps.currentBook = [bm bookNumber:(int)bookstepper.value];
    ps.currentPage = [bm pageNumber:(int)pagestepper.value InBook:ps.currentBook];
       

    [ptr ShowController:ps backButtonTitle:@"Back"];
    [ps release];
}

- (IBAction)editorPressed:(id)sender {
    KidsPaintAppDelegate *ptr = [KidsPaintAppDelegate SharedAppDelegate];
    EditorPaintImageController* paintController = [[EditorPaintImageController alloc] initWithNibName:@"EditorPaintImageController" bundle:nil];
   
    BookManager *bm = [BookManager sharedInstance];
    
    paintController.currentBook = [bm bookNumber:(int)bookstepper.value];
    paintController.currentPage = [bm pageNumber:(int)pagestepper.value InBook:paintController.currentBook];
    
//    paintController.perfectImage = self.perfectPicture.image;
    
    [ptr ShowController:paintController backButtonTitle:@"Back"];
}

- (IBAction)booknumberChanged:(UIStepper *)sender forEvent:(UIEvent *)event {
    booknumber.text = [NSString stringWithFormat: @"Book = %d", (int)sender.value];
    [booknumber setNeedsDisplay];
    NSLog(@"booknumberChanged");
}

- (IBAction)videoPressed:(UIButton *)sender {
    NSString *mediaPath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"ggg3.mp4"];
    
    moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:mediaPath]];
    
    moviePlayerController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
//    [[moviePlayerController.moviePlayer view] setFrame:[[self view] bounds]];
//    [[self view] addSubview: [moviePlayer view]];
    
    [moviePlayerController.moviePlayer play];
}

- (IBAction)mutePressed:(UIButton *)sender {

    SoundManager *sm = [SoundManager sharedInstance];
    if (sm.mute) {
        sm.mute = NO;
        [sender setTitle:@"Mute OFF" forState:UIControlStateNormal];
    }
    else {
     sm.mute = YES;   
    [sender setTitle:@"Mute ON" forState:UIControlStateNormal];

    }
}

- (IBAction)pagenumberChanged:(UIStepper *)sender forEvent:(UIEvent *)event {
    pagenumber.text = [NSString stringWithFormat: @"Page = %d", (int)sender.value];
    [pagenumber setNeedsDisplay];
    NSLog(@"pagenumber ch");
}


- (void)viewDidUnload {
    [booknumber release];
    booknumber = nil;
    [pagenumber release];
    pagenumber = nil;
    [bookstepper release];
    bookstepper = nil;
    [pagestepper release];
    pagestepper = nil;
    [super viewDidUnload];
}


@end
