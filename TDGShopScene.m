//
//  TDGShopScene.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/27/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import <Social/Social.h>

#import "TDGUtils.h"
#import "ASConstants.h"

#import "TDGGameData.h"
#import "GameOverScene.h"

#import "TDGShopScene.h"
#import "TDGSpriteButton.h"

#import "TDGGameKitHelper.h"
#import "TDGAchievementsHelper.h"

static NSString * const redTitle = @"High Score 10";
static NSString * const greenTitle = @"100 Acid Deaths";
static NSString * const yellowTitle =  @"100 Electric Deaths";
static NSString * const rainbowTitle = @"Play 1000 Storms";
static NSString * const pumpkinTitle = @"High Score 31";
static NSString * const skeletonTitle = @"High Score 100";


typedef NS_ENUM(NSUInteger, ShopItem)
{
    // Must Match order to manTexture enum in data.h
    ShopItemBlackHair,
    ShopItemBlueHair,
    ShopItemPinkHair,
    ShopItemRedHair,
    ShopItemGreenHair,
    ShopItemYellowHair,
    ShopItemRainbowHair,
    ShopItemPumpkinHair,
    ShopItemSkeletonHair
};

enum ShopItem  CurrentItem;


@implementation TDGShopScene
{
    NSString *  redProgress;
    NSString *  greenProgress;
    NSString *  yellowProgress;
    NSString *  rainbowProgress;
    NSString *  pumpkinProgress;
    NSString *  skeletonProgress;
  
    SKSpriteNode *currentItemPic;
    
    SKLabelNode *progressNode;
    SKLabelNode *titleNode;
    
    TDGSpriteButton *selectButton;
    TDGSpriteButton *facebookButton;
    TDGSpriteButton *twitterButton;
    TDGSpriteButton *rateButton;
    
    void(^selectButtonBlock)(void);
    void(^facebookButtonBlock)(void);
    void(^twitterButtonBlock)(void);
    void(^rateButtonBlock)(void);

    NSArray *positiveZ;

    
    SKTexture *selectTexture;
}

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
    
        // Hide Banner Ad
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
        
        
        // Start at first item
        redProgress =       [NSString stringWithFormat:@"%i", [TDGGameData sharedGameData].highScore];
        greenProgress =     [NSString stringWithFormat:@"%i/%i", [TDGGameData sharedGameData].acidDeaths, kGreenUnlockNumber];
        yellowProgress =    [NSString stringWithFormat:@"%i/%i", [TDGGameData sharedGameData].electricDeaths, kYellowUnlockNumber] ;
        rainbowProgress =   [NSString stringWithFormat:@"%i/%i", [TDGGameData sharedGameData].gameCount, kRainbowUnlockNumber];
        pumpkinProgress =   [NSString stringWithFormat:@"%i", [TDGGameData sharedGameData].highScore];
        skeletonProgress =  [NSString stringWithFormat:@"%i", [TDGGameData sharedGameData].highScore];
      
        CurrentItem = ShopItemBlackHair;
        
        [self setUpBlocks];
        
        SKTextureAtlas *shopSceneAtlas = [SKTextureAtlas atlasNamed:@"ShopScene"];
        
        
        SKSpriteNode *backGround = [SKSpriteNode spriteNodeWithImageNamed:@"shop_BG.png"];
        backGround.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        backGround.anchorPoint = CGPointZero;
        [self addChild:backGround];
        
        currentItemPic = [SKSpriteNode spriteNodeWithTexture:[shopSceneAtlas textureNamed:@"blackStore"]];
        currentItemPic.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        currentItemPic.size = CGSizeMake(251, 260);
        [self addChild:currentItemPic];
        
        titleNode = [SKLabelNode labelNodeWithFontNamed:@"Gorefest"];
        titleNode.fontColor = [UIColor colorWithRed:126.0/255.0 green:211.0/255.0 blue:33.0/255.0 alpha:1.0];
        titleNode.position = CGPointMake(0, -45);
        titleNode.fontSize = 18;

        [currentItemPic addChild:titleNode];

        
        progressNode = [SKLabelNode labelNodeWithFontNamed:@"Gorefest"];
        progressNode.fontColor = [UIColor colorWithRed:126.0/255.0 green:211.0/255.0 blue:33.0/255.0 alpha:1.0];
        progressNode.position = CGPointMake(0, -75);
        progressNode.fontSize = 25;
        [currentItemPic addChild:progressNode];
        
        selectTexture = [shopSceneAtlas textureNamed:@"selectButton"];
        [self setUpButtons];
        
    }
    return self;
}

-(void)setUpButtons
{
    selectButton = [[TDGSpriteButton alloc]initWithTexture:selectTexture];
    selectButton.size = CGSizeMake(100, 50);
    selectButton.position = CGPointMake(0, -55);
    [currentItemPic addChild:selectButton];
    
    facebookButton = [[TDGSpriteButton alloc]initWithTexture:[SKTexture textureWithImageNamed:@"facebookButton"]];
    facebookButton.size = CGSizeMake(60, 60);
    facebookButton.position = CGPointMake(-46, -55);
    facebookButton.zPosition = -1;
    [currentItemPic addChild:facebookButton];
    
    twitterButton = [[TDGSpriteButton alloc]initWithTexture:[SKTexture textureWithImageNamed:@"twitterButton"]];
    twitterButton.size = CGSizeMake(60, 50);
    twitterButton.position = CGPointMake(47, -55);
    twitterButton.zPosition = -1;
    [currentItemPic addChild:twitterButton];
    
    rateButton = [[TDGSpriteButton alloc]initWithTexture:[SKTexture textureWithImageNamed:@"rateButton"]];
    rateButton.size = CGSizeMake(100, 50);
    rateButton.position = CGPointMake(0, -55);
    rateButton.zPosition = -1;
    [currentItemPic addChild:rateButton];
    
}
-(void)setUpBlocks
{
    __weak typeof(self) weakSelf = self;
    selectButtonBlock = ^(void){
        manTexture = (NSInteger) CurrentItem;
        
        GameOverScene *newScene = [[GameOverScene alloc]initWithSize:weakSelf.size];
        //[weakSelf.view presentScene:newScene];
        [weakSelf.scene.view presentScene:newScene];
    };
    
    facebookButtonBlock = ^(void){
        
        [weakSelf setUpSocialWithType:SLServiceTypeFacebook];
        
        
        
    };
    
    twitterButtonBlock = ^(void){
        
        [weakSelf setUpSocialWithType:SLServiceTypeTwitter];
    };
    
    rateButtonBlock = ^(void){
        
        [TDGGameData sharedGameData].unlockedPink = TRUE;
        
        GKAchievement *pinkMohawk = [TDGAchievementsHelper pinkMohawkAchievement];
        NSArray *pinkGC = @[pinkMohawk];
        [[TDGGameKitHelper sharedGameKitHelper] reportAchievements:pinkGC];
        
        // We also update the item, so the select button is visible.
        //[self updateItem];

        [GKAchievement reportAchievements:pinkGC withCompletionHandler:^(NSError *error) {
            [weakSelf updateItem];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kReviewAddress]];
        }];


    };
}
-(void)setUpSocialWithType:(NSString *)type
{

    // I removed the image, because it looks better without it
    

        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:type];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
                // Unlock it, report the ahievement, and update so unlock shows.
                [TDGGameData sharedGameData].unlockedBlue = YES;
                GKAchievement *blueMohawk = [TDGAchievementsHelper blueMohawkAchievement];
                NSArray *blueGC = @[blueMohawk];
                [[TDGGameKitHelper sharedGameKitHelper] reportAchievements:blueGC];
                [[TDGGameData sharedGameData] save];
                [self updateItem];
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        
        controller.completionHandler = myBlock;
        [controller setInitialText:@"Just unlocked the Blue Mohawk"];
        [controller addURL:[NSURL URLWithString:kAppStoreAddress]];
        [self.view.window.rootViewController presentViewController:controller animated:YES completion:Nil];

    

    
}
-(void)setNegZPosExcept:(NSArray*)posZ
{
    selectButton.zPosition = -1;
    rateButton.zPosition = -1;
    progressNode.zPosition = -1;
    facebookButton.zPosition = -1;
    twitterButton. zPosition = -1;
    titleNode.zPosition = -1;
    
    for (SKSpriteNode *node in posZ) {
        node.zPosition = 1;
    }
    

}
- (void)updateItem
{
 
    
    
    switch (CurrentItem) {

        case ShopItemBlackHair:
            
            // Black
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"blackStore"];
            selectButton.texture = selectTexture;
            positiveZ = @[selectButton];
            [self setNegZPosExcept:positiveZ];
   
          break;

        case ShopItemBlueHair:
            
            // Blue
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"blueStore"];
            positiveZ = @[facebookButton, twitterButton];

            if ([TDGGameData sharedGameData].unlockedBlue) {
                positiveZ = @[selectButton];
            }
            [self setNegZPosExcept:positiveZ];

          break;
            
        case ShopItemPinkHair:
            
            // Pink
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"pinkStore"];
            positiveZ = @[rateButton];
            
            if ([TDGGameData sharedGameData].unlockedPink) {
                positiveZ = @[selectButton];
            }
            [self setNegZPosExcept:positiveZ];

          break;
        
        case ShopItemRedHair:
        
            // Red
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"redStore"];
            titleNode.text = redTitle;
            progressNode.text = redProgress;
            positiveZ = @[titleNode, progressNode];
        
            if ([TDGGameData sharedGameData].unlockedRed) {
                positiveZ = @[selectButton];
            }
            [self setNegZPosExcept:positiveZ];
        
          break;
        

        case ShopItemGreenHair:
            
            // Green
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"greenStore"];
            titleNode.text = greenTitle;
            progressNode.text = greenProgress;
            positiveZ = @[progressNode, titleNode];
            
            if ([TDGGameData sharedGameData].unlockedGreen) {
                positiveZ = @[selectButton];
            }
            [self setNegZPosExcept:positiveZ];

          break;
            
        case ShopItemYellowHair:
            
            // Yellow
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"yellowStore"];
            titleNode.text = yellowTitle;
            progressNode.text = yellowProgress;
            positiveZ = @[progressNode,titleNode];
            
            if ([TDGGameData sharedGameData].unlockedYellow) {
                positiveZ = @[selectButton];
            }
            [self setNegZPosExcept:positiveZ];

          break;
            
        case ShopItemRainbowHair:
            
            // Rainbow
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"rainbowStore"];
            titleNode.text = rainbowTitle;
            progressNode.text = rainbowProgress;
            positiveZ = @[progressNode, titleNode];
            
            if ([TDGGameData sharedGameData].unlockedRainbow) {
                positiveZ = @[selectButton];
            }
            [self setNegZPosExcept:positiveZ];

          break;
        
        case ShopItemPumpkinHair:
        
            // Pumpkin
        
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"pumpkinStore"];
            titleNode.text = pumpkinTitle;
            progressNode.text = pumpkinProgress;
            positiveZ = @[titleNode, progressNode];
        
            if ([TDGGameData sharedGameData].unlockedPumpkin) {
                positiveZ = @[selectButton];
            }
            [self setNegZPosExcept:positiveZ];
        
          break;
        
        case ShopItemSkeletonHair:
        
            // Skeleton
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"skeletonStore"];
            titleNode.text = skeletonTitle;
            progressNode.text = skeletonProgress;
            positiveZ = @[titleNode, progressNode];
        
            if ([TDGGameData sharedGameData].unlockedSkeleton) {
                positiveZ = @[selectButton];
            }
            [self setNegZPosExcept:positiveZ];
          break;
        
        default: ShopItemBlackHair:
            
            //Black
            CurrentItem = 0;
            currentItemPic.texture = [SKTexture textureWithImageNamed:@"blackStore"];
            selectButton.texture = selectTexture;
            positiveZ = @[selectButton];
            [self setNegZPosExcept:positiveZ];
          break;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGFloat middleScreen = CGRectGetMidX(self.frame);
        
        // Outside Buttons Because left/Right are not buttons.
        [self runAction:[SKAction playSoundFileNamed:@"bloop.wav" waitForCompletion:NO]];

        
        // Select Button
        if ([self nodeAtPoint:location] == selectButton) {
            [selectButton runTappedActionWithBlock:selectButtonBlock];
            return;
        }
        
        
        
        // FaceBook Button
        if ([self nodeAtPoint:location] == facebookButton && CurrentItem == ShopItemBlueHair && ![TDGGameData sharedGameData].unlockedBlue) {
            [facebookButton runTappedActionWithBlock:facebookButtonBlock];
            return;
        }
        // Twitter Button
        if ([self nodeAtPoint:location] == twitterButton && CurrentItem == ShopItemBlueHair && ![TDGGameData sharedGameData].unlockedBlue) {
            [twitterButton runTappedActionWithBlock:twitterButtonBlock];
            return;
        }
        // Rate Button
        if ([self nodeAtPoint:location] == rateButton) {
            [rateButton runTappedActionWithBlock:rateButtonBlock];
            return;
        }
        
        if (location.x < middleScreen && location.y) { // Move left
            /* Test allows player to loop backwards.  (always == first ShopItemEnum)*/
            if (CurrentItem == ShopItemBlackHair) {
                CurrentItem = ShopItemSkeletonHair;
            } else {
                CurrentItem--;
            }
        }else if (location.x >= middleScreen && location.y) { // Move Right
            /* Default case shopitemblackhari allows forward looping without test*/
            CurrentItem ++;
        }
        
        [self updateItem];

    }
}

@end
