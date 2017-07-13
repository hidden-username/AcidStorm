//
//  TDGMyScene.h
//  Acid Storm
//

//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


typedef NS_OPTIONS(uint32_t, ASPhysicsCategory)
{
    ASPlayerCategory        = 1 << 0,
    ASAcidCategory          = 1 << 1,
    ASElectricCategory      = 1 << 2,
};

@interface TDGGameScene : SKScene <SKPhysicsContactDelegate>


@end
