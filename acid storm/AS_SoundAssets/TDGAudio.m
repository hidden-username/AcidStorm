//
//  SKTAudio.m
//  SKTUtils
//
//  Created by Main Account on 6/24/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "TDGAudio.h"

@interface TDGAudio()
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@property (nonatomic) AVAudioPlayer * soundEffectPlayer;
@end

@implementation TDGAudio

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static TDGAudio * _sharedInstance;
    dispatch_once(&pred, ^{ _sharedInstance = [[self alloc] init]; });
    return _sharedInstance;
}

- (void)playBackgroundMusic:(NSString *)filename {
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
}
-(void)doVolumeFade
{
    if (self.backgroundMusicPlayer.volume > 0.1) {
        self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume - 0.1;
        [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.1];
    } else {
        // Stop and get the sound ready for playing again
        [self.backgroundMusicPlayer stop];
        self.backgroundMusicPlayer.currentTime = 0;
        [self.backgroundMusicPlayer prepareToPlay];
        self.backgroundMusicPlayer.volume = 1.0;
    }
}
- (void)pauseBackgroundMusic
{
    [self.backgroundMusicPlayer pause];
}

- (void)playSoundEffect:(NSString*)filename {
    NSError *error;
    NSURL * soundEffectURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    self.soundEffectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundEffectURL error:&error];
    self.soundEffectPlayer.numberOfLoops = 0;
    [self.soundEffectPlayer prepareToPlay];
    [self.soundEffectPlayer play];
}


@end
