//
//  RootController.h
//  DynamicTextures
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowCoverView.h"
#import "BookManager.h"
#import "MKStoreManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RootController : UIViewController<FlowCoverViewDelegate> {
    id <BookManagerDelegate> delegate;
    IBOutlet FlowCoverView *flowCover;
    IBOutlet UILabel *booknumber;
    IBOutlet UILabel *pagenumber;
    IBOutlet UIStepper *bookstepper;
    IBOutlet UIStepper *pagestepper;
    
    MPMoviePlayerViewController *moviePlayerController;
}

- (IBAction)mindGamePressed;
- (IBAction)editorPressed:(id)sender;
- (IBAction)booknumberChanged:(id)sender forEvent:(UIEvent *)event;
- (IBAction)booknumberChanged:(id)sender forEvent:(UIEvent *)event;
- (IBAction)videoPressed:(UIButton *)sender;
- (IBAction)mutePressed:(UIButton *)sender;

@property (retain) id <BookManagerDelegate> delegate;
@end
