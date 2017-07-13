//
//  MEMGameData.h
//  TopDrop
//
//  Created by Michael McCafferty on 5/23/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, character)
{
    // Must match order of currentItem enum in ShopScene
    manBlack,
    manBlue,
    manPink,
    manRed,
    manGreen,
    manYellow,
    manRainbow,
    manPumpkin,
    manSkeleton
};
enum character manTexture;



@interface TDGGameData : NSObject <NSCoding>

@property (assign, nonatomic) BOOL shopButtonShouldBlink;


@property (assign, nonatomic) int score;
@property (assign, nonatomic) int highScore;
@property (assign, nonatomic) int scorePurse;
// test
@property (assign, nonatomic) int adCount;

// Unlocked Tests
@property (assign, nonatomic) int acidDeaths;
@property (assign, nonatomic) int electricDeaths;
@property (assign, nonatomic) int gameCount;
@property (assign, nonatomic) BOOL rated;
@property (assign, nonatomic) BOOL shared;


// Unlocked State
@property (assign, nonatomic) BOOL unlockedBlue;
@property (assign, nonatomic) BOOL unlockedPink;
@property (assign, nonatomic) BOOL unlockedRed;
@property (assign, nonatomic) BOOL unlockedGreen;
@property (assign, nonatomic) BOOL unlockedYellow;
@property (assign, nonatomic) BOOL unlockedRainbow;

@property (assign, nonatomic) BOOL unlockedPumpkin;
@property (assign, nonatomic) BOOL unlockedSkeleton;


+(instancetype)sharedGameData;
-(void) achievementsTest;
-(void)resetScore;
-(void)save;
@end
