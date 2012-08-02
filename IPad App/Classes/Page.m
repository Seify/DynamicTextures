//
//  Page.m
//  
//
//  Created by Mac on 05.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Page.h"

@implementation Page

@synthesize number;
@synthesize book;

- (UIImage *)image
{
    NSString *path = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], self.book.number, self.number];
    UIImage *retImage = [UIImage imageWithContentsOfFile:path];
    return retImage;

};

- (NSData *)areas
{
    NSString *path = [NSString stringWithFormat:@"%@/books/book%d/areas/%d", [[NSBundle mainBundle] resourcePath], self.book.number, self.number];
    return [NSData dataWithContentsOfFile:path];
};

- (id)initWithNumberOfPage:(int)pagenumber Book:(Book *)mybook
{
    if (self == [super init])
    {
        self.number = pagenumber;
        self.book = mybook;
    }
    return self;
}
@end
