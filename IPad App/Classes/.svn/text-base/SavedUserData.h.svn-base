//
//  SavedUserData.h
//  KidsPaint
//
//  Created by naceka on 03.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Сохраненные пользовательские данные
@interface SavedUserData : NSObject {
	NSMutableArray *booksList;
}

@property (nonatomic, retain) NSMutableArray* booksList;

- (NSString*) getLastViewedPageNumberOfBook:(NSString*) bookID;
- (void) saveLastViewedPageNumberOfBook:(NSString*) bookID pageNumber:(NSString*)pageNumber;
- (void) save;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end
