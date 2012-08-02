//
//  PlainsManager.h
//  Wall Painting Prototipe
//
//  Created by Roman Smirnov on 18.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLViewController.h"
#import "PlainDetailsTableViewController.h"

@class PlainDetailsTableViewController;
@class OpenGLViewController;

@interface PlainsManager : UITableViewController
{
    OpenGLViewController *delegate;
    PlainDetailsTableViewController *plainDetails;
}
@property (assign) OpenGLViewController *delegate;
@property (retain, readonly) PlainDetailsTableViewController *plainDetails;
@end
