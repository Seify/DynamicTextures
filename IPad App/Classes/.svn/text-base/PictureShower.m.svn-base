//
//  Picture Shower.m
//  
//
//  Created by Roman Smirnov on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PictureShower.h"
#import "PaintImageController.h"
#import "MindGamePaintImageController.h"
#import "KidsPaintAppDelegate.h"

@implementation PictureShower

@synthesize perfectPicture, perfectImage, currentBook, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* imageToAdd = self.perfectImage;
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.perfectImage.size.width, self.perfectImage.size.height)];
    UIImageView* imageView   = [[UIImageView alloc] initWithImage:imageToAdd];
    [containerView addSubview:imageView];
    [imageView release];
    
    NSString* imagePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], self.currentBook.number, self.currentPage.number];
    UIImage* blendedImage = [UIImage imageWithContentsOfFile:imagePath];
    UIGraphicsBeginImageContext(containerView.frame.size);
    [blendedImage drawInRect:CGRectMake(0, 0, blendedImage.size.width, blendedImage.size.height)
//                   blendMode:nil 
                   blendMode:kCGBlendModeNormal 
                       alpha:1.0];
    [imageToAdd drawInRect:CGRectMake(0, 0, imageToAdd.size.width, imageToAdd.size.height)
//                 blendMode:nil
                 blendMode:kCGBlendModeNormal
                     alpha:0.85];
    
    blendedImage = UIGraphicsGetImageFromCurrentImageContext();

    
    
    self.perfectPicture.image = blendedImage;
    [self.perfectPicture setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ( (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));

}

- (IBAction) readyToDrawPressed: (UIButton *)sender
{
    NSLog(@"readyToDrawPressed");
    
    KidsPaintAppDelegate *ptr = [KidsPaintAppDelegate SharedAppDelegate];
    MindGamePaintImageController* paintController = [[MindGamePaintImageController alloc] initWithNibName:@"MindGamePaintImageController" bundle:nil];
//    paintController.delegate = self.delegate;
//    paintController.currentBook = [self.delegate bookNumber:image];
//    
//    key = [NSString stringWithFormat:@"lastViewedPageForBook%d", image];
//    int pagenumber = [myUserDefaults integerForKey:key];
//    paintController.currentPage = [self.delegate pageNumber:pagenumber InBook:paintController.currentBook]; 
    
//    BookManager *bm = [BookManager sharedInstance];
//    
//    
//    
    
    paintController.currentBook = self.currentBook;
    paintController.currentPage = self.currentPage;
    
    paintController.perfectImage = self.perfectPicture.image;
    
    [ptr ShowController:paintController backButtonTitle:@"Back"];

}

@end
