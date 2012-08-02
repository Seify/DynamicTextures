//
//  Book.h
//  KidsPaint
//
//  Created by naceka on 03.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "Page.h"

@class Book;
@class Page;

@protocol BookManagerDelegate
//- (int) numberOfBooks;
//- (int) numberOfPagesInBook:(Book *)book;

- (int) howManyBooks;
- (Book *) bookNumber:(int)booknumber;
- (int) howManyPagesInBook:(Book *)book;
- (Page *) pageNumber:(int)pagenumber InBook:(Book *)book;
- (UIImage *) imageForPage:(Page *)page InBook:(Book *)book;
- (UIImage *) imageForTitleOfBook:(Book *)book;
@end

// Книга, состоящая из страниц раскраски
@interface Book : NSObject {
//	NSString *bookID;
//	NSString *lastViewedPageNumber;
    
    int number;
    int numberOfLastViewedPage;
    int numberOfPages;
    UIImage *cover;
    UIImage *titleImage;
    NSArray *pages;
    
    BOOL isBought;
}

//@property (nonatomic, copy) NSString *bookID;
//@property (nonatomic, copy) NSString *lastViewedPageNumber;

@property int number;
@property int numberOfLastViewedPage;
@property int numberOfPages;
@property (retain) UIImage *cover;
@property (retain, readonly) UIImage *titleImage;
@property (retain, readonly) NSArray *pages;
@property BOOL isBought;
@property (readonly) NSString *title;
@property (readonly) NSString *productID;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithId:(int)bookid NumberOfPages:(int)numpages;
@end
