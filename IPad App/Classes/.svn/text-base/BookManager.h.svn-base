//
//  BookManager.h
//  
//
//  Created by Mac on 02.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "RootController.h"




@interface BookManager : NSObject <BookManagerDelegate>
{
    NSArray *books;
}
@property (readonly) NSArray *books;
- (int) howManyBooks;
- (Book *) bookNumber:(int)booknumber;
- (int) howManyPagesInBook:(Book *)book;
- (Page *) pageNumber:(int)pagenumber InBook:(Book *)book;
- (UIImage *) imageForPage:(Page *)page InBook:(Book *)book;
- (UIImage *) imageForTitleOfBook:(Book *)book;

+ (id)sharedInstance;

@end
