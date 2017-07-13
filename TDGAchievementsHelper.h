//
//  TDGAchievementsHelper.h
//  Acid Storm
//
//  Created by Michael McCafferty on 8/30/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GameKit;

@interface TDGAchievementsHelper : NSObject


+ (GKAchievement *)blueMohawkAchievement;
+ (GKAchievement *)pinkMohawkAchievement;
+ (GKAchievement *)redMohawkAchievement:(NSUInteger)bestScore;
+ (GKAchievement *)greenMohawkAchievement:(NSUInteger)noOfAcidDeaths;
+ (GKAchievement *)yellowMohawkAchievement:(NSUInteger)noOfElectricDeaths;
+ (GKAchievement *)rainbowMohawkAchievement:(NSUInteger)noOfGamesPlayed;
+ (GKAchievement *)pumpkinHeadAchievement:(NSUInteger)bestScore;
+ (GKAchievement *)skeletonHeadAchievement:(NSUInteger)bestScore;




@end
