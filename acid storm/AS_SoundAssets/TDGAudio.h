//
//  SKTAudio.h
//  SKTUtils
//
//  Created by Main Account on 6/24/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

// Chapters 1-3
#import "TDGAudio.h"
@import AVFoundation;

@interface TDGAudio : NSObject



+ (instancetype)sharedInstance;
- (void)playBackgroundMusic:(NSString *)filename;
- (void)pauseBackgroundMusic;
- (void)playSoundEffect:(NSString*)filename;
-(void)doVolumeFade;

@end