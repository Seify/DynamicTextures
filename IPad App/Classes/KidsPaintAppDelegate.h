//
//  KidsPaintAppDelegate.h
//  KidsPaint
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedUserData.h"
#import "BookManager.h"
#import "MKStoreManager.h"

@interface MainNavigationController  : UINavigationController
{
	
}
-(id)init;
-(void)dealloc;
-(void)loadView;
@end

enum PaintMode {
	paintModeSimple,
	paintModeMedium,
//	paintModeHard
};

typedef enum PaintMode PaintMode;

@interface KidsPaintAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	PaintMode paintMode;
	NSString* selectedImageName;
	
	MainNavigationController *navigCtrl;
    
    BookManager *bookManager;
//    MKStoreManager *storeManager;
    
	
	UIView   *loadingView;
	
	SavedUserData* savedUserData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic) PaintMode paintMode;
@property (nonatomic, copy) NSString* selectedImageName;
@property (retain) BookManager *bookManager;
@property (nonatomic, retain) SavedUserData* savedUserData;

+ (KidsPaintAppDelegate *) SharedAppDelegate;
- (void) ShowController:(UIViewController*) controller backButtonTitle:(NSString*) backButtonTitle;
- (void)ShowMainNavigationBar;
- (void)HideMainNavigationBar;
-(void) goBack;

-(void)showLoadingStatus;
-(void)hideLoadingStatus;

//- (void)saveCurrentImage:(UIImage*) viewImage;
- (void)saveCurrentImage:(UIImage*)viewImage BookNumber:(int)booknumber PageNumber:(int)pagenumber;
//- (void)savePreviousImage:(UIImage*) viewImage;
- (void)savePreviousImage:(UIImage*) viewImage BookNumber:(int)booknumber PageNumber:(int)pagenumber;
@end

