//
//  TDGAchievementsHelper.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/30/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import "TDGAchievementsHelper.h"
#import "ASConstants.h"



static NSString * const kBlueMohawkAchievementID = @"com.TopDropGames.AcidStorm.BlueMohawk";
static NSString * const kPinkMohawAchievementID = @"com.TopDropGames.AcidStorm.PinkMohawk";
static NSString * const kGreenMohawkAchievementID = @"com.TopDropGames.AcidStorm.GreenMohawk";
static NSString * const kYellowAchievementID = @"com.TopDropGames.AcidStorm.YellowMohawk";
static NSString * const kRainbowAchievementID = @"com.TopDropGames.AcidStorm.RainbowMohawk";

static NSString * const kSkeletonAchievementID = @"com.TopDropGames.AcidStorm.SkullHead";
static NSString * const kPumpkinAchievementID = @"com.TopDropGames.AcidStorm.PumpkinHead";
static NSString * const kRedMohawkAchievementID = @"com.TopDropGames.AcidStorm.RedMohawk";



@implementation TDGAchievementsHelper
+ (GKAchievement *)blueMohawkAchievement
{
    // Sent in ShopScene
    GKAchievement *blueMohawkAchievement = [[GKAchievement alloc]initWithIdentifier:kBlueMohawkAchievementID];
    blueMohawkAchievement.percentComplete = 100.0;
    blueMohawkAchievement.showsCompletionBanner = YES;
    return blueMohawkAchievement;
}
+ (GKAchievement *)pinkMohawkAchievement
{
    // Sent in ShopScene
    GKAchievement *pinkMohawkAchievement = [[GKAchievement alloc]initWithIdentifier:kPinkMohawAchievementID];
    pinkMohawkAchievement.percentComplete = 100.0;
    pinkMohawkAchievement.showsCompletionBanner = YES;
    return pinkMohawkAchievement;
}

+ (GKAchievement *)redMohawkAchievement:(NSUInteger)bestScore
{
  // Sent in GameScene
  CGFloat percent = (bestScore/kRedUnlockNumber) * 100;
  
  GKAchievement *redMohawkAchievement = [[GKAchievement alloc]initWithIdentifier:kRedMohawkAchievementID];
  
  redMohawkAchievement.percentComplete = percent;
  redMohawkAchievement.showsCompletionBanner = YES;
  return redMohawkAchievement;
  
}
+ (GKAchievement *)greenMohawkAchievement:(NSUInteger)noOfAcidDeaths
{
    // Sent in GameScene
    CGFloat percent = (noOfAcidDeaths/kGreenUnlockNumber) * 100;
    
    GKAchievement *greenMohawkAchievement = [[GKAchievement alloc]initWithIdentifier:kGreenMohawkAchievementID];
    
    greenMohawkAchievement.percentComplete = percent;
    greenMohawkAchievement.showsCompletionBanner = YES;
    return greenMohawkAchievement;
}
+ (GKAchievement *)yellowMohawkAchievement:(NSUInteger)noOfElectricDeaths
{
    // Sent in GameScene
    CGFloat percent = (noOfElectricDeaths/kYellowUnlockNumber) * 100;
    
    GKAchievement *yellowMohawkAchievement = [[GKAchievement alloc]initWithIdentifier:kYellowAchievementID];
    
    yellowMohawkAchievement.percentComplete = percent;
    yellowMohawkAchievement.showsCompletionBanner = YES;
    return yellowMohawkAchievement;
}
+ (GKAchievement *)rainbowMohawkAchievement:(NSUInteger)noOfGamesPlayed
{
    // Sent in GameScene
    CGFloat percent = (noOfGamesPlayed/kRainbowUnlockNumber) * 100;
    
    GKAchievement *rainbowMohawkAchievement = [[GKAchievement alloc]initWithIdentifier:kRainbowAchievementID];
    
    rainbowMohawkAchievement.percentComplete = percent;
    rainbowMohawkAchievement.showsCompletionBanner = YES;
    return rainbowMohawkAchievement;
}

+ (GKAchievement *)pumpkinHeadAchievement:(NSUInteger)bestScore
{
  // Sent in GameScene
  CGFloat percent = (bestScore/kPumpkinUnlockNumber) * 100;
  
  GKAchievement *pumpkinHeadAchievement = [[GKAchievement alloc]initWithIdentifier:kPumpkinAchievementID];
  
  pumpkinHeadAchievement.percentComplete = percent;
  pumpkinHeadAchievement.showsCompletionBanner = YES;
  return pumpkinHeadAchievement;
  
}

+ (GKAchievement *)skeletonHeadAchievement:(NSUInteger)bestScore
{
  // Sent in GameScene
  CGFloat percent = (bestScore/kSkeletonUnlockNumber) * 100;
  
  GKAchievement *skeletonHeadAchievement = [[GKAchievement alloc]initWithIdentifier:kSkeletonAchievementID];
  
  skeletonHeadAchievement.percentComplete = percent;
  skeletonHeadAchievement.showsCompletionBanner = YES;
  return skeletonHeadAchievement;
  
}


@end
