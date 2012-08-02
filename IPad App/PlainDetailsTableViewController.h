//
//  PlainDetailsTableViewController.h
//  Wall Painting Prototipe
//
//  Created by Roman Smirnov on 19.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLViewController.h"

@class OpenGLViewController;

@interface PlainDetailsTableViewController : UITableViewController
{
    PlainWithPattern *plain;
    OpenGLViewController *delegate;
}
@property (assign) PlainWithPattern *plain;
@property (assign) OpenGLViewController *delegate;

@end
