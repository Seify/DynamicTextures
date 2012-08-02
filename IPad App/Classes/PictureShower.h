//
//  Picture Shower.h
//  
//
//  Created by Roman Smirnov on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface PictureShower : UIViewController
{
    IBOutlet UIImageView *perfectPicture;
    UIImage *perfectImage;

    Book *currentBook;
    Page *currentPage;
}

@property (retain) UIImageView *perfectPicture;
@property (retain) UIImage *perfectImage;

@property (retain) Book *currentBook;
@property (retain) Page *currentPage;

- (IBAction) readyToDrawPressed: (UIButton *)sender;

@end
