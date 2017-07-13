//
//  MenuSceneSuper.h
//  Acid Storm
//
//  Created by Michael McCafferty on 8/25/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TDGSpriteButton.h"

@interface MenuSceneSuper : SKScene
{
    TDGSpriteButton *firstButton;
    TDGSpriteButton *secondButton;
    TDGSpriteButton *thirdButton;
    
    
    SKTexture *firstButtonTexture;
    SKTexture *secondButtonTexture;
    SKTexture *thirdButtonTexture;
    
    void(^firstButtonBlock)(void);
    void(^secondButtonBlock)(void);
    void(^thirdButtonBlock)(void);
   
}

-(void)setUpSceneSpecificCode;
-(void)setUpButtonTextures;
-(void)createBlocks;
-(void)setUpButtonPositions;
-(void)setUpButtons;
@end
