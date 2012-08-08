//
//  DynamicTexturesAppDelegate.m
//  DynamicTextures
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DynamicTexturesAppDelegate.h"
#import "RootController.h"
#import "BookManager.h"
#import "MKStoreManager.h"
#import "OpenGLViewController.h"

@implementation MainNavigationController

- (id)init
{
	self = [super init];
	
	return self;
}

-(void)loadView  
{
	[super loadView];
} 

-(void)dealloc{
	[super dealloc];
}

@end


@implementation DynamicTexturesAppDelegate

@synthesize window;
@synthesize paintMode;
@synthesize selectedImageName;
@synthesize savedUserData;
@synthesize bookManager;


static DynamicTexturesAppDelegate *classAppDelegatePtr = nil;

+ (DynamicTexturesAppDelegate *) SharedAppDelegate
{
	return classAppDelegatePtr;
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    classAppDelegatePtr = self;
	paintMode = paintModeSimple; //paintModeMedium;
    
	
	navigCtrl = [[MainNavigationController alloc] init];
	[window addSubview:navigCtrl.view];

// загрузка старого контроллера с CoverFlow на OpenGL 1.1
//    
//    RootController* rootViewController = [[RootController alloc] initWithNibName:@"RootController" bundle:nil];
//	[navigCtrl pushViewController:rootViewController animated:YES];
//    
//    bookManager = [[BookManager alloc] init];
//    rootViewController.delegate = bookManager;
        
    
//    BookManager *bm = [BookManager sharedInstance];
//    Book *book = [bm bookNumber:0];
//    Page *page = [bm pageNumber:0 InBook:book];
    
    OpenGLViewController* oglvc = [[OpenGLViewController alloc] init];
//    oglvc.interfaceManager.currentBook = book;
//    oglvc.interfaceManager.currentPage = page;
    
    [navigCtrl pushViewController:oglvc animated:YES];
    
    [oglvc release];
    
    
    
    
    NSMutableArray *features = [NSMutableArray array];

    // идентификаторы in-app purchases (заводятся в iTunes Connect) 
    [features addObject:@"ru.aplica.kidspaint.books.book1"];
    [features addObject:@"ru.aplica.kidspaint.books.book2"];
    [features addObject:@"ru.aplica.kidspaint.books.book3"];

//    [features addObject:@"ru.aplica.kidspaint.books.test123456"];

    [[MKStoreManager sharedManager] initWithFeatureSet:features];
    
    [self HideMainNavigationBar];
	self.savedUserData = [[SavedUserData alloc] init];
	
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    id topcon = [navigCtrl topViewController];
    if([topcon isKindOfClass:[OpenGLViewController class]])
    {
        [(OpenGLViewController *)topcon applicationWillResignActive];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{    
    id topcon = [navigCtrl topViewController];
    if([topcon isKindOfClass:[OpenGLViewController class]])
    {
        [(OpenGLViewController *)topcon applicationWillEnterForeground];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    id topcon = [navigCtrl topViewController];
    if([topcon isKindOfClass:[OpenGLViewController class]])
    {
        [(OpenGLViewController *)topcon applicationDidBecomeActive];
    }

}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}

- (void)ShowMainNavigationBar
{
	[navigCtrl.navigationBar setHidden:NO];
}

- (void)HideMainNavigationBar
{
	[navigCtrl.navigationBar setHidden:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void) ShowController:(UIViewController*) controller backButtonTitle:(NSString*) backButtonTitle
{
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: backButtonTitle style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[navigCtrl.topViewController navigationItem] setBackBarButtonItem: newBackButton];
    [newBackButton release];
	
	[navigCtrl pushViewController:controller animated:YES];
}

-(void) goBack
{
	[navigCtrl popViewControllerAnimated:YES];
}

- (void)dealloc {
//    [self.savedUserData release];
    [bookManager release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Utils

-(void)showLoadingStatus
{
	if( loadingView == nil )
	{
		loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
		
		UIColor *color = [[UIColor alloc] initWithWhite:0.5f alpha:0.5f];  
		[loadingView setBackgroundColor:color];  
		[color release];
		
		UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(350, 500, 100, 100)];  
		progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;  
		progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |  
										 UIViewAutoresizingFlexibleRightMargin |  
										 UIViewAutoresizingFlexibleTopMargin |  
										 UIViewAutoresizingFlexibleBottomMargin);  
		[progressView startAnimating];  
		[loadingView addSubview:progressView];
		
		[window  addSubview:loadingView];  
		[progressView release];  
	}
    
    NSLog(@"%@ : %@ ended", self, NSStringFromSelector(_cmd));
}

-(void)hideLoadingStatus
{
	if( loadingView != nil )
	{ 
		[loadingView removeFromSuperview];  
		[loadingView release];  
		loadingView = nil;
	}
}

// Сохраняет текущую редактируемую картинку

- (void)saveCurrentImage:(UIImage*)viewImage BookNumber:(int)booknumber PageNumber:(int) pagenumber
{
    
//	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
    
//    NSLog(@"app saving current image of book %d, page %d", booknumber, pagenumber);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
    //	NSString* saveDir = [NSString stringWithFormat:@"%@/Book1/SavedData", documents];
    NSString* saveDir = [NSString stringWithFormat:@"%@/SavedData/drawings/book%d", documents, booknumber];
	
	//NSLog(saveDir);
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	
	BOOL dirExists = YES;
	
	if(![fileManager fileExistsAtPath:saveDir isDirectory:nil])
	{
		dirExists = [fileManager createDirectoryAtPath:saveDir withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	if (dirExists)
	{
		NSString* filePath = [NSString stringWithFormat:@"%@/%d.png", saveDir, pagenumber];
		
		// Write image to PNG
		[UIImagePNGRepresentation(viewImage) writeToFile:filePath atomically:YES];
	}
}
/*
- (void)saveCurrentImage:(UIImage*)viewImage
{
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString* saveDir = [NSString stringWithFormat:@"%@/Book1/SavedData", documents];
 
	//NSLog(saveDir);
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	
	BOOL dirExists = YES;
	
	if(![fileManager fileExistsAtPath:saveDir isDirectory:nil])
	{
		dirExists = [fileManager createDirectoryAtPath:saveDir withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	if (dirExists)
	{
		NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", saveDir, app.selectedImageName];
		
		// Write image to PNG
		[UIImagePNGRepresentation(viewImage) writeToFile:filePath atomically:YES];
	}
}
 */

// Сохраняет прошлую редактируемую картинку (для Undo)
- (void)savePreviousImage:(UIImage*)viewImage BookNumber:(int)booknumber PageNumber:(int)pagenumber
{
    
//    NSLog(@"app saving prev image of book %d, page %d", booknumber, pagenumber);
    
//	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString* saveDir = [NSString stringWithFormat:@"%@/SavedData/drawings/book%d/", documents, booknumber];
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	
	BOOL dirExists = YES;
	
	if(![fileManager fileExistsAtPath:saveDir isDirectory:nil])
	{
		dirExists = [fileManager createDirectoryAtPath:saveDir withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	if (dirExists)
	{
		NSString* filePath = [NSString stringWithFormat:@"%@/%dPrev.png", saveDir, pagenumber];
		
		// Write image to PNG
		[UIImagePNGRepresentation(viewImage) writeToFile:filePath atomically:YES];
	}
}

/*
- (void)savePreviousImage:(UIImage*) viewImage
{
	DynamicTexturesAppDelegate* app = [DynamicTexturesAppDelegate SharedAppDelegate];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString* saveDir = [NSString stringWithFormat:@"%@/Book1/SavedData", documents];
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	
	BOOL dirExists = YES;
	
	if(![fileManager fileExistsAtPath:saveDir isDirectory:nil])
	{
		dirExists = [fileManager createDirectoryAtPath:saveDir withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	if (dirExists)
	{
		NSString* filePath = [NSString stringWithFormat:@"%@/%@Prev.png", saveDir, app.selectedImageName];
		
		// Write image to PNG
		[UIImagePNGRepresentation(viewImage) writeToFile:filePath atomically:YES];
	}
}
*/

@end
