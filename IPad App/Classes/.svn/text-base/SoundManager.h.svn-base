//
//  SoundManager.h
//  KidsPaint
//
//  Created by Roman Smirnov on 29.03.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject
{
    AVAudioPlayer *bgplayer;
    AVAudioPlayer *effectsplayer;
    BOOL _mute;
}
@property (nonatomic, retain) AVAudioPlayer *bgplayer;
@property (nonatomic, retain) AVAudioPlayer *effectsplayer;
@property BOOL mute;

+ (id)sharedInstance;
- (void)startBackgroundMusicFilePath:(NSString *)soundFilePath;
- (void)stopBackgroundMusic;
- (void)playEffectFilePath:(NSString *)soundFilePath;
@end
