//
//  MEMGameKitHelper.h
//  TopDrop
//
//  Created by Michael McCafferty on 5/24/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

@import GameKit;

extern NSString *const PresentAuthenticationViewController;

@interface TDGGameKitHelper : NSObject

@property (nonatomic, readonly)UIViewController *authenticationViewController;
@property (nonatomic, readonly)NSError *lastError;

+(instancetype)sharedGameKitHelper;
-(void)authenticateLocalPlayer;
-(void)showGKGameCenterViewController:(UIViewController *)viewController;
-(void)reportAchievements:(NSArray *)achievements;
-(void)reportScore:(int64_t)score forLeaderboardID:(NSString *)leaderboardID;
@end

