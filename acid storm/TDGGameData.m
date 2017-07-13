//
//  MEMGameData.m
//  TopDrop
//
//  Created by Michael McCafferty on 5/23/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import "TDGGameData.h"
#import "ASConstants.h"


static NSString * const manTextureKey = @"manTextureKey";

static NSString * const highScoreKey = @"highScoreKey";
static NSString * const kScorePurseKey = @"scorePurseKey";
static NSString * const adCountKey = @"adCountKey";
static NSString * const acidDeathsKey = @"acidDeathsKey";
static NSString * const electricDeathsKey = @"electricDeathsKey";
static NSString * const gameCountKey = @"gameCountKey";




static NSString * const blueKey = @"blueKey";
static NSString * const pinkKey = @"pinkKey";
static NSString * const redKey = @"redKey";
static NSString * const greenKey = @"greenKey";
static NSString * const yellowKey = @"yellowKey";
static NSString * const rainbowKey = @"rainbowKey";
static NSString * const pumpkinKey = @"pumpkinKey";
static NSString * const skeletonKey = @"skeletonKey";

// This Sucks Just testing

@implementation TDGGameData
+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
        
    });
    
    return sharedInstance;
}
-(void) achievementsTest
{
    // First Shop Blink
    if (self.gameCount == 2) {
        self.shopButtonShouldBlink = YES;
    }
  
    // Red
    if (!self.unlockedRed && self.highScore >= kRedUnlockNumber) {
        self.unlockedRed = YES;
        self.shopButtonShouldBlink = YES;
    }
    
    // Green
    if (!self.unlockedGreen && self.acidDeaths >= kGreenUnlockNumber) {
        
        self.unlockedGreen = YES;
        self.shopButtonShouldBlink = YES;
    }
    
    // Yellow
    if (!self.unlockedYellow && self.electricDeaths >= kYellowUnlockNumber) {
        
        self.unlockedYellow = YES;
        self.shopButtonShouldBlink = YES;
    }
    

    // Rainbow
    if (!self.unlockedRainbow && self.gameCount >=  kRainbowUnlockNumber) {
        
        self.unlockedRainbow = YES;
        self.shopButtonShouldBlink = YES;
    }
  
    // Pumpkin
    if (!self.unlockedPumpkin && self.highScore >= kPumpkinUnlockNumber) {
      self.unlockedPumpkin = YES;
      self.shopButtonShouldBlink = YES;
    }
  
    // Skeleton
    if (!self.unlockedSkeleton && self.highScore >= kSkeletonUnlockNumber) {
      self.unlockedSkeleton = YES;
      self.shopButtonShouldBlink = YES;
    }
}
-(void)resetScore
{
    self.score = 0;
}
#pragma mark- Encoding Methods

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:manTexture forKey:manTextureKey];

    
    [aCoder encodeInt:self.highScore forKey:highScoreKey];
    [aCoder encodeInt:self.scorePurse forKey:kScorePurseKey];
    [aCoder encodeInt:self.adCount forKey:adCountKey];
    [aCoder encodeInteger:self.acidDeaths forKey:acidDeathsKey];
    [aCoder encodeInteger:self.electricDeaths forKey:electricDeathsKey];
    [aCoder encodeInteger:self.gameCount forKey:gameCountKey];
    
    
    [aCoder encodeBool:self.unlockedBlue forKey:blueKey];
    [aCoder encodeBool:self.unlockedPink forKey:pinkKey];
    [aCoder encodeBool:self.unlockedRed forKey:redKey];
    [aCoder encodeBool:self.unlockedGreen forKey:greenKey];
    [aCoder encodeBool:self.unlockedYellow forKey:yellowKey];
    [aCoder encodeBool:self.unlockedRainbow forKey:rainbowKey];
  
    [aCoder encodeBool:self.unlockedPumpkin forKey:pumpkinKey];
    [aCoder encodeBool:self.unlockedSkeleton forKey:skeletonKey];

  
    
    
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        manTexture = [aDecoder decodeIntegerForKey:manTextureKey];

        _highScore = [aDecoder decodeIntForKey:highScoreKey];
        _scorePurse = [aDecoder decodeIntForKey:kScorePurseKey];
        _adCount = [aDecoder decodeIntForKey:adCountKey];
        _acidDeaths = [aDecoder decodeIntForKey:acidDeathsKey];
        _electricDeaths = [aDecoder decodeIntForKey:electricDeathsKey];
        _gameCount = [aDecoder decodeIntForKey:gameCountKey];
        
        _unlockedBlue = [aDecoder decodeBoolForKey:blueKey];
        _unlockedPink = [aDecoder decodeBoolForKey:pinkKey];
        _unlockedRed = [aDecoder decodeBoolForKey:redKey];
        _unlockedGreen = [aDecoder decodeBoolForKey:greenKey];
        _unlockedYellow = [aDecoder decodeBoolForKey:yellowKey];
        _unlockedRainbow = [aDecoder decodeBoolForKey:rainbowKey];
      
        _unlockedPumpkin = [aDecoder decodeBoolForKey:pumpkinKey];
        _unlockedSkeleton = [aDecoder decodeBoolForKey:skeletonKey];
      

    }
    return self;
    
}
+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}
+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [TDGGameData filePath]];
    if (decodedData) {
        TDGGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[TDGGameData alloc] init];
}
-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[TDGGameData filePath] atomically:YES];
}

@end
