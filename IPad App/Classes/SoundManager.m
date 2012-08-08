//
//  SoundManager.m
//  DynamicTextures
//
//  Created by Roman Smirnov on 29.03.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

@synthesize bgplayer, effectsplayer; // the player object
//@synthesize mute; // the player object

- (BOOL)mute
{
    return _mute;
}

- (void)setMute:(BOOL)mute
{
    if (mute == YES)
    {
        [self stopBackgroundMusic];
    }
    
    if (mute == NO)
    {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/Sounds/paint_music.mp3", [[NSBundle mainBundle] resourcePath]];  
        [self startBackgroundMusicFilePath:soundFilePath];
    }
    
    _mute = mute;
}

#pragma mark - Music playing

- (void)startBackgroundMusicFilePath:(NSString *)soundFilePath
{
    if (!bgplayer)
    {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        
        NSError *error;
        self.bgplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        [fileURL release];
        self.bgplayer.numberOfLoops = -1;
        
        if (self.bgplayer == nil) 
            NSLog(@"%@", [error description]);
        else
            [self.bgplayer play];
    }
}

- (void)playEffectFilePath:(NSString *)soundFilePath
{
    if (!self.mute) 
    {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];    
    
        NSError *error;
        if (!self.effectsplayer)
            self.effectsplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];        
        if (self.effectsplayer == nil) 
            NSLog(@"%@", [error description]);
        else
        {
            [self.effectsplayer release];
            self.effectsplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];        
            if (self.effectsplayer == nil) 
                NSLog(@"%@", [error description]);

            if (!self.effectsplayer.playing)
                [self.effectsplayer play];
        }
    }
}

- (void)stopBackgroundMusic
{
    if (self.bgplayer){
        if (self.bgplayer.isPlaying) {
            [self.bgplayer stop];
        }
        [self.bgplayer release];
        self.bgplayer = nil;
    }
}

#pragma mark - Sound

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	
	if (flag) {
		NSLog(@"Did finish playing successfully");
	} else {
		NSLog(@"Did NOT finish playing successfully");
	}
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	
	NSLog(@"%@", [error description]);
}

#pragma mark - Singleton methods

static SoundManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (SoundManager *)sharedInstance {
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
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:NULL];
        self.mute = NO;
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
