//
//  MenuSceneSuper.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/25/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import "MenuSceneSuper.h"
#import "TDGSpriteButton.h"
#import "TDGGameScene.h"
#import "TDGShopScene.h"
#import "TDGGameKitHelper.h"
#import "TDGGameData.h"

#import "TDGUtils.h"
#import "TDGManHole.h"
@implementation MenuSceneSuper
{
    TDGManHole *mH;
    SKEmitterNode *acidSmoke;
}


-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *backGroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"menu_BG.png"];
        backGroundImage.anchorPoint = CGPointZero;
        backGroundImage.size = CGSizeMake(self.size.width, self.size.height);
        
        [self addChild:backGroundImage];
        
       
        mH = [[TDGManHole alloc]initWithImageNamed:@"manHole"];
        mH.position = CGPointMake(0, 10);
        [self addChild:mH];
       
        NSString *acidSmokePath = [[NSBundle mainBundle]pathForResource:@"AcidSmoke" ofType:@"sks"];
        acidSmoke = [NSKeyedUnarchiver unarchiveObjectWithFile:acidSmokePath];
        acidSmoke.position = CGPointMake(5, 0);
        [mH addChild:acidSmoke];
       
        
        SKSpriteNode *bones = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"acidDeath_30"]];
        bones.size = CGSizeMake(150, 150);
        bones.position = CGPointMake(CGRectGetMidX(self.frame),bones.size.height/2);
        [self addChild:bones];
        
        
        
        // Scene Custom Code
        //[self setUpSceneSpecificCode];
        
        // Textures
        [self setUpButtonTextures];
        
        // Blocks
        [self createBlocks];
        
        
        
        // Buttons
        [self setUpButtons];
        
        // I need to set position after Buttons.
        // Button Positions
        [self setUpButtonPositions];
        
        if ([TDGGameData sharedGameData].shopButtonShouldBlink == YES) {
            SKAction *blink = [SKAction sequence:@[[SKAction fadeAlphaBy:-1 duration:.3],
                                                   [SKAction fadeAlphaBy:1 duration:.3]
                                                   ]];
            
        
            [thirdButton runAction:[SKAction repeatActionForever:blink]];
        }
        

        
    }
    return self;
}
-(void)setUpSceneSpecificCode
{

    NSLog(@"SceneSpecificCode not overwritten");
    
}

-(void)setUpButtons
{
    firstButton = [[TDGSpriteButton alloc]initWithTexture:firstButtonTexture size:CGSizeMake(200, 100) position:firstButton.position zPosition:3];
    [self addChild:firstButton];
    secondButton = [[TDGSpriteButton alloc]initWithTexture:secondButtonTexture size:CGSizeMake(80, 110) position:secondButton.position zPosition:3];
    [self addChild:secondButton];
    thirdButton = [[TDGSpriteButton alloc]initWithTexture:thirdButtonTexture size:CGSizeMake(80 , 110) position:thirdButton.position zPosition:3];
    [self addChild:thirdButton];
}
-(void)setUpButtonTextures
{
    firstButtonTexture  = [SKTexture textureWithImageNamed:@"PlayButton"];
    secondButtonTexture = [SKTexture textureWithImageNamed:@"GameCenterButton.png"];
    thirdButtonTexture  = [SKTexture textureWithImageNamed:@"ShopButton.png"];
    
}
-(void)createBlocks
{
    __weak typeof(self) weakSelf = self;
    firstButtonBlock = ^(void){
        
        // Customize
        TDGGameScene *newGame = [[TDGGameScene alloc]initWithSize:weakSelf.size];
        //  [weakSelf.view presentScene:newGame];
        [weakSelf.scene.view presentScene:newGame];
        
    };
    secondButtonBlock = ^(void){
        
        // Customize GameCenter
        [[TDGGameKitHelper sharedGameKitHelper]
         showGKGameCenterViewController:weakSelf.view.window.rootViewController];
    };
    
    thirdButtonBlock = ^(void){
    
        // Removes Blining When button Pressed
        
        [TDGGameData sharedGameData].shopButtonShouldBlink = FALSE;
            
        // Customize
        TDGShopScene *shopScene = [[TDGShopScene alloc]initWithSize:weakSelf.size];
        [weakSelf.scene.view presentScene:shopScene];


        
    };
    
}
-(void)setUpButtonPositions
{
    firstButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)- 20);
    //Original/*CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));*/
    secondButton.position = CGPointMake(secondButton.size.width/2 + 10, secondButton.size.height/2 + 60);
    thirdButton.position = CGPointMake(CGRectGetMaxX(self.frame)-thirdButton.size.width/2 - 10,thirdButton.size.height/2 + 60);

    

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        self.view.userInteractionEnabled = YES;
        
        //[self runAction:[SKAction playSoundFileNamed:@"bloop.wav" waitForCompletion:NO]];

        
        if ([self nodeAtPoint:location] == firstButton) {
            [self runAction:[SKAction playSoundFileNamed:@"PlayButtonSound.wav" waitForCompletion:NO]];
            [self removeEmitters];
            [firstButton runTappedActionWithBlock:firstButtonBlock];
        }
        if ([self nodeAtPoint:location] == secondButton) {
            [self runAction:[SKAction playSoundFileNamed:@"bloop.wav" waitForCompletion:NO]];
            [secondButton runTappedActionWithBlock:secondButtonBlock];
        }
        if ([self nodeAtPoint:location] == thirdButton) {
            [self removeEmitters];
            [self runAction:[SKAction playSoundFileNamed:@"bloop.wav" waitForCompletion:NO]];
            [thirdButton runTappedActionWithBlock:thirdButtonBlock];
        }

    }
}
-(void)removeEmitters
{
    [acidSmoke removeAllChildren];
    [acidSmoke removeFromParent];
    acidSmoke = nil;
}
@end
