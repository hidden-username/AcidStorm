//
//  MainMenuScene.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/25/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import "MainMenuScene.h"
#import "TDGUtils.h"

#import "TDGGameData.h"



@implementation MainMenuScene
-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        SKSpriteNode *gameTitle = [SKSpriteNode spriteNodeWithImageNamed:@"AcidStormTitle"];
        gameTitle.size = CGSizeMake(gameTitle.size.width/2, gameTitle.size.height/2);
        
       CGFloat TitleYPos = CGRectGetMaxY(self.frame)-firstButton.position.y/2 + gameTitle.size.height/2;
        gameTitle.position = CGPointMake(CGRectGetMidX(self.frame), TitleYPos);
        
        [self addChild:gameTitle];

    }
    return self;
}
@end
