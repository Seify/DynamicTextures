//
//  SavedUserData.m
//  DynamicTextures
//
//  Created by naceka on 03.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavedUserData.h"
#import "Book.h"

@implementation SavedUserData

@synthesize booksList;

- (id)init
{
	self = [super init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString *filePath = [documents stringByAppendingPathComponent:@"SavedUserData"];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (fileExists)
	{
		self = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	}
	
	if (booksList == nil)
	{
		self.booksList = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	if(booksList != nil )
	{
		[booksList release];
	}
		
	[super dealloc];
}

- (NSString*) getLastViewedPageNumberOfBook:(NSString*) bookID
{
	NSString* pageNumber = @"1";
/*	
	for (Book* book in self.booksList) 
	{
		if ([book.bookID compare:bookID] == NSOrderedSame)
		{
			if (book.lastViewedPageNumber != nil)
			{
				pageNumber = [NSString stringWithString:book.lastViewedPageNumber];
			}
		}
	}
*/	
	return pageNumber;
}

- (void) saveLastViewedPageNumberOfBook:(NSString*) bookID pageNumber:(NSString*)pageNumber
{
//	Book* bookToSave = nil;
/*	
	for (Book* book in self.booksList) 
	{
		if ([book.bookID compare:bookID] == NSOrderedSame)
		{
			bookToSave = book;
			break;
		}
	}
	
	if (bookToSave == nil)
	{
		bookToSave = [[Book alloc] init];
		bookToSave.bookID = bookID;
		[self.booksList addObject:bookToSave];
		bookToSave.lastViewedPageNumber = pageNumber;
		[bookToSave release];
	}
	else 
	{
		bookToSave.lastViewedPageNumber = pageNumber;
	}
*/	
	[self save];
}

-(void) save
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString *filePath = [documents stringByAppendingPathComponent:@"SavedUserData"];
	
	[NSKeyedArchiver archiveRootObject: self toFile:filePath];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super init])
	{
		booksList = [[aDecoder decodeObjectForKey:@"booksList"] retain];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:booksList forKey:@"booksList"];
}

@end
