//
//  BookManager.m
//  
//
//  Created by Mac on 02.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BookManager.h"

@implementation BookManager

- (NSArray *)books
{
    if (!books) {
        NSMutableArray *booksarray = [NSMutableArray array];
        
        // код не работает на симуляторе, вероятно из-за того, что path получается другой, нежели на боевом устройстве
        //
        
        
        if (!TARGET_IPHONE_SIMULATOR) {
            NSString *path = [NSString stringWithFormat:@"%@/books", [[NSBundle mainBundle] resourcePath]];
            NSFileManager *filemanager = [NSFileManager defaultManager];
            NSDirectoryEnumerationOptions ops = NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles;
                      
    //         NSLog(@"BookManager: path is %@", path);
             NSArray *dirs = [filemanager contentsOfDirectoryAtURL: [NSURL URLWithString:path]
                                        includingPropertiesForKeys: [NSArray arrayWithObject:NSURLIsDirectoryKey]
                                                           options: ops
                                                             error: NULL];
             
             int numberofbooks = [dirs count];
             
    //         NSLog(@"RootController: Found %d books in directory %@", numberofbooks, path);
    //         NSLog(@"RootController: books description:%@", [dirs description]);
             
             for (int i=0; i<numberofbooks; i++) {
             
             NSString *path = [NSString stringWithFormat:@"%@/books/book%d/images", [[NSBundle mainBundle] resourcePath], i];
             
             NSArray *pages = [filemanager contentsOfDirectoryAtURL: [NSURL URLWithString:path]
                                         includingPropertiesForKeys: nil
                                                            options: 0
                                                              error: NULL];
             
             int numberofpages = [pages count];
             
    //         NSLog(@"RootController: Found %d pages for book%d in images directory",numberofpages, i);
    //         NSLog(@"RootController: Pages description: %@", [pages description]);
             
             Book *book = [[Book alloc] initWithId:i NumberOfPages:numberofpages];
             [booksarray addObject:book];
             }
            
            books = booksarray;
            [books retain];
        } else { //мы на симуляторе
            #define NUMBER_OF_BOOKS 4
            #define NUMBER_OF_PAGES 5
            
            for (int i=0; i<NUMBER_OF_BOOKS; i++) {
                Book *book = [[Book alloc] initWithId:i NumberOfPages:NUMBER_OF_PAGES];
                [booksarray addObject:book];
            }
            NSLog(@"Running on simulator. Created NUMBER_OF_BOOKS books with NUMBER_OF_PAGES images in each");
            
            books = booksarray;
            [books retain];
        }
    }
    
    return books;
}

- (int) howManyBooks;
//- (int) numberOfBooks
{
    return [self.books count];
}

- (int) howManyPagesInBook:(Book *)book;
//- (int) numberOfPagesInBook:(Book *)book
{
    return book.numberOfPages;
}

- (Book *) bookNumber:(int)booknumber
{
    return [self.books objectAtIndex:booknumber];
}

- (Page *) pageNumber:(int)pagenumber InBook:(Book *)book
{
    if ((pagenumber < book.numberOfPages) && (pagenumber >= 0)) {
//        NSLog(@"BookManager: for pageNumber = %d in Book %d page number is: %d",
//              pagenumber,              book.number,       ((Page *)[book.pages objectAtIndex:pagenumber]).number);
        return [book.pages objectAtIndex:pagenumber];
    } else {
        NSLog(@"BookManager: WARNING! Requested page out of diapason");
        return nil;
    }
}

- (UIImage *) imageForPage:(Page *)page InBook:(Book *)book
{
    return page.image;
}

- (UIImage *) imageForTitleOfBook:(Book *)book
{
    return book.titleImage;
}

#pragma mark Singleton methods

static BookManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (BookManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
    }
    
    return self;
}

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
-(void)dealloc
{
    // I'm never called!
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

@end
