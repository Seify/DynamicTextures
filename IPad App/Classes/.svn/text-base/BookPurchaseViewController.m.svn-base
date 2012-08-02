//
//  BookPurchaseViewController.m
//  
//
//  Created by Mac on 26.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BookPurchaseViewController.h"
#import "KidsPaintAppDelegate.h"
#include <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "SoundManager.h"

@implementation BookPurchaseViewController


@synthesize delegate;
@synthesize bookToScroll;
@synthesize bookPrice;
@synthesize buyButton, bookTitle, scrollView;

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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/scroll_3.mp3", [[NSBundle mainBundle] resourcePath]];  
    SoundManager *sm = [SoundManager sharedInstance];        
    [sm playEffectFilePath:soundFilePath];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
	[app HideMainNavigationBar];
    
    //настраиваем кнопку "Купить за..."
    self.buyButton.titleLabel.font = [UIFont fontWithName:@"ExposureCTwo" size:24.0];    
    
//    NSLog(@"TODO: сделать кастомную цену");
    
//    if (!bookPrice) bookPrice = @"?";
    
    NSString *title;
    
    if (!bookPrice) {
        title = NSLocalizedString(@"BUY_BUTTON_TEXT_NO_PRICE", nil);
    } else {
        title = NSLocalizedString(@"BUY_BUTTON_TEXT", nil);
        title = [title stringByAppendingString:self.bookPrice];        
    }
        
    [self.buyButton setTitle:title forState:UIControlStateNormal];
    self.buyButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    //настраиваем надпись с названием книги
    self.bookTitle.image = self.bookToScroll.titleImage;
    
    //настраиваем scrollView
    self.scrollView.delegate = self;    
    int numpages = [self.delegate howManyPagesInBook:bookToScroll];

    //расстояние между двумя соседними картинками
    float spacing = 25.0;
    //во сколько раз надо масштабировать картинку, чтобы она целиком вписалась в scrollView
    float scale = self.scrollView.frame.size.height/800.0;

    for (int i=0; i<numpages; i++)
    {
    
        #define VERT_SHADOW_WIDTH 10 
        #define HOR_SHADOW_HIGHT 8 

        Page *page = [self.delegate pageNumber:i 
                                        InBook:self.bookToScroll];
        UIImage *pageimage = [self.delegate imageForPage:page
                                                  InBook:self.bookToScroll];
        pageimage = [self blendImage:[UIImage imageNamed:@"paperTexture1.png"] withImage:pageimage];
        UIImageView *mview =[[UIImageView alloc] initWithImage:pageimage];
        mview.frame = CGRectMake(spacing/2 + i * (560.0 * scale + spacing), 0, 560.0 * scale - VERT_SHADOW_WIDTH, 800.0 * scale - HOR_SHADOW_HIGHT);        
        [self.scrollView addSubview:mview];
         
        //добавляем тень снизу от картинки
        UIImageView *horisontalshadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paperShadowHorizontal.png"]];
        horisontalshadow.frame = CGRectMake(spacing/2 + i * (560.0 * scale + spacing), 800 * scale - HOR_SHADOW_HIGHT, 560.0 * scale - VERT_SHADOW_WIDTH, HOR_SHADOW_HIGHT);        
        [self.scrollView addSubview:horisontalshadow];

        //добавляем тень справа от картинки
        UIImageView *verticalshadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paperShadowVertical.png"]];
        verticalshadow.frame = CGRectMake(spacing/2 + i * (560.0 * scale + spacing) + (560*scale - VERT_SHADOW_WIDTH), 0, VERT_SHADOW_WIDTH, 800.0 * scale + 16);        
        [self.scrollView addSubview:verticalshadow];
    }
    self.scrollView.contentSize = CGSizeMake(numpages * self.scrollView.frame.size.width, 800.0 * scale);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)releaseOutlets
{
    self.scrollView = nil;
    self.buyButton = nil;
    self.bookTitle = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseOutlets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ((interfaceOrientation == UIInterfaceOrientationPortrait) 
        || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        return YES;
    } else {
        return NO;   
    }
}

- (void) dealloc
{
//    [self.bookpages release];
    [self releaseOutlets];
    [super dealloc];
}

# pragma mark Network Accessability

//
// http://www.friendlydeveloper.com/2011/04/checking-network-availability-on-ios/
//
- (BOOL)connectedToNetwork  {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return 0;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    //below suggested by Ariel
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"]; //comment by friendlydeveloper: maybe use www.google.com
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    //NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:nil]; //suggested by Ariel
    NSURLConnection *testConnection = [[[NSURLConnection alloc] initWithRequest:testRequest delegate:nil] autorelease]; //modified by friendlydeveloper
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

# pragma mark Handle buttons

- (IBAction) backButtonPressed:(UIButton *)sender
{
    KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
	[app goBack];
}

- (IBAction) buyButtonPressed:(UIButton *)sender
{
//    NSLog(@"Buy Button clicked");
    
    if (![SKPaymentQueue canMakePayments])
    {
        NSString *warningtitletext = NSLocalizedString(@"PAYMENT_RESTRICTION_ON_TITLE", nil);
        NSString *warningtext = NSLocalizedString(@"PAYMENT_RESTRICTION_ON", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:warningtitletext
                                                        message:warningtext 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if (![self connectedToNetwork]) {
        NSString *warningtitletext = NSLocalizedString(@"NO_INTERNET_TITLE", nil);
        NSString *warningtext = NSLocalizedString(@"NO_INTERNET", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:warningtitletext
                                                        message:warningtext 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else if (![[MKStoreManager sharedManager] isProductAvaibleForSale:bookToScroll.productID])
    {
        NSString *warningtitletext = NSLocalizedString(@"PRODUCT_ID_INVALID_TITLE", nil);
        NSString *warningtext = NSLocalizedString(@"PRODUCT_ID_INVALID", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:warningtitletext
                                                        message:warningtext 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        MKStoreManager *storemanager = [MKStoreManager sharedManager];
        [storemanager buyBook:bookToScroll.number];
        
        KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
        [app showLoadingStatus];
    }
    
}

# pragma mark Image processing

- (UIImage *) blendImage:(UIImage *)bgimage withImage:(UIImage *)topimage
{
	UIGraphicsBeginImageContext(topimage.size);
    [topimage drawInRect:CGRectMake(0, 0, topimage.size.width, topimage.size.height)];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
	CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
	CGImageRef cgImage = bgimage.CGImage;
	
	CGContextTranslateCTM(ctx, 0, bgimage.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	CGContextDrawImage(ctx, CGRectMake(0, 0, bgimage.size.width, bgimage.size.height), cgImage);
	CGContextSetBlendMode(ctx, kCGBlendModeNormal);
	
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return resultImage;
}


@end
