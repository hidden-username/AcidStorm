//
//  GameOverScene.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/25/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import "GameOverScene.h"
#import "TDGCloud.h"
#import "TDGGameData.h"

#import "ASConstants.h"
#import "TDGUtils.h"
@implementation GameOverScene

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        // iAd
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
        
        
        
        //NSLog(@"adCount: %i",[TDGGameData sharedGameData].adCount);

        
        [[TDGGameData sharedGameData] achievementsTest];
        [[TDGGameData sharedGameData] save];
        
        //CGFloat highScoreYPos = (scoreLabel.position.y - firstButton.position.y)/2 + firstButton.position.y;
        
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Gorefest"];
        highScoreLabel.fontSize = 20;
        highScoreLabel.fontColor = [SKColor greenColor];
        highScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), firstButton.position.y + firstButton.size.height - 10);
        highScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        highScoreLabel.text = [NSString stringWithFormat:@"Best: %i", [TDGGameData sharedGameData].highScore];
        [self addChild:highScoreLabel];
        
        
        TDGCloud *cloudLeft = [[TDGCloud alloc]initWithImageNamed:@"cloudFlash_1"];
        TDGCloud *cloudRight = [[TDGCloud alloc]initWithImageNamed:@"cloudFlash_1"];
        TDGCloud *cloudCenter = [[TDGCloud alloc]initWithImageNamed:@"cloudFlash_1"];
        
        [self addChild:cloudLeft];
        [self addChild:cloudCenter];
        [self addChild:cloudRight];
        
        
        
        cloudLeft.position = CGPointMake(cloudLeft.size.width/2 - 30, self.frame.size.height-cloudLeft.size.height/2 -30);
        cloudCenter.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-50);
        cloudRight.position = CGPointMake(self.frame.size.width - cloudRight.size.width/2 + 30, self.frame.size.height - cloudRight.size.height / 2 - 30);
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Gorefest"];
        scoreLabel.fontSize = 50;
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.position = CGPointMake(0, 10);
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        scoreLabel.text = [NSString stringWithFormat:@"%i", [TDGGameData sharedGameData].score];
        [cloudCenter addChild:scoreLabel];
       
        

    }
    return self;
}

@end
