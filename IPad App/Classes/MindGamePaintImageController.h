//
//  MindGamePaintImageController.h
//  
//
//  Created by Roman Smirnov on 01.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaintImageController.h"
#import <MessageUI/MessageUI.h>

@interface MindGamePaintImageController : PaintImageController<MFMailComposeViewControllerDelegate>
{
    int numberOfAreas;
    int paintedAreas;
    UIImage *perfectImage;
//    NSMutableDictionary *areasDictEditMode;
    NSMutableDictionary *areasDictGameMode;
    int mode;
}
@property (retain) UIImage *perfectImage;
@property (readonly) int numberOfAreas;
@property (retain) NSMutableDictionary *areasDictEditMode;
@property (retain, readonly) NSMutableDictionary *areasDictGameMode;

- (IBAction)checkResultPressed:(id)sender;
- (IBAction)emailPressed;
- (IBAction)modeChanged:(id)sender forEvent:(UIEvent *)event;
@end
