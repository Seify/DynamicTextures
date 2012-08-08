//
//  Book.m
//  DynamicTextures
//
//  Created by naceka on 03.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Book.h"
#import "Page.h"


@implementation Book

//@synthesize bookID;
//@synthesize lastViewedPageNumber;

@synthesize number;
@synthesize numberOfLastViewedPage;
@synthesize numberOfPages;
@synthesize cover;
@synthesize isBought;


- (NSString *)title
{
    NSString *key = [NSString stringWithFormat:@"BOOK_%d_TITLE", self.number];
    return NSLocalizedString(key, nil);
}

- (NSString *)productID
{
    return [@"ru.aplica.kidspaint.books.book" stringByAppendingFormat:@"%d", self.number];
}

- (NSArray *)pages
{
    if (!pages)
    {
        
        NSMutableArray *pagesarray = [NSMutableArray array];
        for (int i=0; i<numberOfPages; i++) {
            Page *newPage = [[Page alloc] initWithNumberOfPage:i Book:self];
            [pagesarray addObject:newPage];
            [newPage release];
        }
        pages = pagesarray;
        [pages retain];
    }
    return pages;
}

- (UIImage *) titleImage
{
//    [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], self.book.number, self.number];
    NSString *name = [NSString stringWithFormat:@"titlebook%d", self.number];
    return [UIImage imageNamed:name];
    
};

- (id)init
{
	self = [super init];
	
//	bookID = nil;
//	lastViewedPageNumber = nil;
		
	return self;
}

- (id)initWithId:(int)bookid NumberOfPages:(int)numpages
{
	if (self = [super init]){
	
        self.number = bookid;
        self.numberOfPages = numpages;
        
        if (self.number%2 == 1) isBought = TRUE;
        
        self.numberOfLastViewedPage = 1;
        
        //	bookID = nil;
        //	lastViewedPageNumber = nil;

    }
    
	return self;
}


- (void)dealloc
{
//	if( bookID != nil )
//	{
//		[bookID release];
//	}
//	
//	if( lastViewedPageNumber != nil )
//	{
//		[lastViewedPageNumber release];
//	}
    
    [pages release];
	
	[super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super init])
	{
//		bookID = [[aDecoder decodeObjectForKey:@"bookID"] retain];
//		lastViewedPageNumber = [[aDecoder decodeObjectForKey:@"lastViewedPageNumber"] retain];
	}
	
	return self;
}	

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
//	[encoder encodeObject:bookID forKey:@"bookID"];
//	[encoder encodeObject:lastViewedPageNumber forKey:@"lastViewedPageNumber"];
}

@end
