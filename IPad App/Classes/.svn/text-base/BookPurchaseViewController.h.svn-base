//
//  BookPurchaseViewController.h
//  
//
//  Created by Mac on 26.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookManager.h"
#import "BookScroller.h"
#import "PagingScrollView.h"

@interface BookPurchaseViewController : UIViewController <UIScrollViewDelegate>
{
    
    Book *bookToScroll; //книга, страницы которой будем показывать
    NSString *bookPrice;
    id<BookManagerDelegate> delegate;
    
    IBOutlet UIButton *buyButton;
    IBOutlet UIImageView *bookTitle; //название книги (картинкой)
    IBOutlet PagingScrollView *scrollView;
    

}

@property (assign) id <BookManagerDelegate> delegate;
@property (retain) Book *bookToScroll;
@property (retain) UIButton *buyButton;
@property (retain) UIImageView *bookTitle;
@property (retain) UIScrollView *scrollView;
@property (retain) NSString *bookPrice;

- (IBAction) buyButtonPressed:(UIButton *)sender;
- (IBAction) backButtonPressed:(UIButton *)sender;
@end
