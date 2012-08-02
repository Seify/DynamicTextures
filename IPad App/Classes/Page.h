//
//  Page.h
//  
//
//  Created by Mac on 05.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@class Book;

@interface Page : NSObject
{
    Book *book;
    int number;
    UIImage *image;
    NSData *areas;
    
}
@property int number;
@property (assign) Book *book;
@property (readonly) UIImage *image;
@property (readonly) NSData *areas;
- (id)initWithNumberOfPage:(int)pagenumber Book:(Book *)mybook;
@end
