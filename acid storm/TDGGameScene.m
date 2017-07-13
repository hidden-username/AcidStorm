//
//  TDGMyScene.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/19/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//


#import "TDGGameScene.h"

#import "TDGAudio.h"
#import "TDGUtils.h"

#import "GameOverScene.h"
#import "TDGGameData.h"
#import "TDGManHole.h"
#import "TDGCloud.h"

#import "TDGAchievementsHelper.h"
#import "TDGGameKitHelper.h"

static  float MAN_POINTS_PER_SEC = 125;

static SKAction *acidDeathSound;
static SKAction * electricDeathSound;
static SKAction *lightningSound;


@implementation TDGGameScene
{
    BOOL _gameStarted;
    BOOL _gameOver;
    
    SKLabelNode *startGameNode;
    
    NSString *manAtlasString;
    
    SKNode *manContainer;
    
    SKNode *backGroundNode;
    SKNode *gameLayerNode;
    SKNode *soundNode;
    
    SKSpriteNode *bgTree;
    
    TDGManHole *manHole;
    
    SKSpriteNode *man;

    int multiplierForDirection;
    NSArray *manWalkTextures;
    NSArray *acidDeathTextures;
    NSArray *acidSplatTextures;
    NSArray *electricDeathTextures;
    NSArray *cloudFlashTextures;
    
    TDGCloud *cloudLeft;
    TDGCloud *cloudCenter;
    TDGCloud *cloudRight;
    
    
    SKLabelNode *scoreLabel;
    SKLabelNode *gameOverLabel;
    
    SKEmitterNode *electricSmoke;
    SKEmitterNode *electricSpark;
    SKNode *rightElectricNode;
    SKEmitterNode *acidSmoke;
}



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        

        
        // Hide Banner Ad
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
        

        
        
        // add 1 every game
        [TDGGameData sharedGameData].adCount ++;
        
        
        
        

        [[TDGGameData sharedGameData] resetScore];
        
        _gameStarted = NO;
        _gameOver = NO;
        
        // Sounds
        acidDeathSound = [SKAction playSoundFileNamed:@"acidDeath.wav" waitForCompletion:YES];
        electricDeathSound = [SKAction playSoundFileNamed:@"electricDeath.wav" waitForCompletion:YES];
        lightningSound = [SKAction playSoundFileNamed:@"Lightning.wav" waitForCompletion:YES];
       
        switch (manTexture) {
 
            case manBlack:
              manAtlasString = @"manBlack";
                break;
                
            case manBlue:
                manAtlasString = @"manBlue";
                break;
                
            case manPink:
                manAtlasString = @"manPink";
                break;
            
            case manRed:
                manAtlasString = @"manRed";
                break;
            
            case manGreen:
                manAtlasString = @"manGreen";
                break;
                
            case manYellow:
                manAtlasString = @"manYellow";
                break;
                
            case manRainbow:
                manAtlasString = @"manRainbow";
                break;
            
            case manPumpkin:
                manAtlasString = @"manPumpkin";
                break;
            
            case manSkeleton:
                manAtlasString = @"manSkeleton";
                break;
                
            default:
                manAtlasString = @"manBlack";
                break;
        }
        
        
        // Preload Textures
        manWalkTextures         = ASLoadFramesFromAtlas(manAtlasString);
        acidDeathTextures       = ASLoadFramesFromAtlas(@"acidDeath");
        acidSplatTextures       = ASLoadFramesFromAtlas(@"acidSplat");
        electricDeathTextures   = ASLoadFramesFromAtlas(@"electricDeath");
        cloudFlashTextures      = ASLoadFramesFromAtlas(@"cloudFlash");
      
      
      // This is so the melting starts at right part when skeleton is selected.
      if (manTexture == manSkeleton) {
        NSMutableArray *tempArray = [acidDeathTextures mutableCopy];
        [tempArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
        acidDeathTextures = [tempArray copy];
      }
        
        
        // SetUp Worl
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, -2);

        backGroundNode = [SKNode node];
        gameLayerNode = [SKNode node];
        soundNode = [SKNode node];
        backGroundNode.zPosition = 1;
        gameLayerNode.zPosition = 10;
        
        [self addChild:backGroundNode];
        [self addChild:gameLayerNode];
        [self addChild:soundNode];
        
        // Put in texture atlas later
        SKSpriteNode *backGroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"game_BG.png"];
        backGroundImage.anchorPoint = CGPointZero;
        backGroundImage.size = CGSizeMake(self.size.width,
                                          568);// center BG on bottom and use 568 so universal coordinates match;
        [backGroundNode addChild:backGroundImage];
        
        
        SKSpriteNode *gate = [SKSpriteNode spriteNodeWithImageNamed:@"g3.png"];
        gate.size = CGSizeMake(self.size.width + 5, gate.size.height/2);
        gate.position = CGPointMake(CGRectGetMidX(self.frame), 150);
        gate.zPosition = 3;
        [backGroundNode addChild:gate];
        
        bgTree = [SKSpriteNode spriteNodeWithImageNamed:@"treeBG.png"];
        bgTree.size = CGSizeMake(self.size.width + 5, bgTree.size.height/2);
        bgTree.anchorPoint = CGPointMake(0.5, 0);
        bgTree.position = CGPointMake(CGRectGetMidX(self.frame), 110);
        bgTree.zPosition = 2;
        bgTree.alpha = .2;
        [backGroundNode addChild:bgTree];
        
        // ManHole
        manHole = [[TDGManHole alloc]initWithImageNamed:@"manHole"];
        manHole.position = CGPointMake(0, 90);
        
        manHole.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(manHole.size.width - 10, manHole.size.height+50)];
        manHole.physicsBody.dynamic = NO;
        manHole.physicsBody.affectedByGravity = NO;
        manHole.physicsBody.categoryBitMask = ASAcidCategory;
        manHole.physicsBody.contactTestBitMask = ASPlayerCategory;
        manHole.zPosition = 4;
        [backGroundNode addChild:manHole];
        
        // Particles
        NSString *acidSmokePath = [[NSBundle mainBundle]pathForResource:@"AcidSmoke" ofType:@"sks"];
        acidSmoke = [NSKeyedUnarchiver unarchiveObjectWithFile:acidSmokePath];
        acidSmoke.position = CGPointMake(5, 0);
        [manHole addChild:acidSmoke];
        
        NSString*electricSmokePath = [[NSBundle mainBundle]pathForResource:@"ElectricSmoke" ofType:@"sks"];
        electricSmoke = [NSKeyedUnarchiver unarchiveObjectWithFile:electricSmokePath];

        
      
        NSString *electricSparkPath = [[NSBundle mainBundle]pathForResource:@"ElectricSpark" ofType:@"sks"];
        electricSpark = [NSKeyedUnarchiver unarchiveObjectWithFile:electricSparkPath];
    
        
        rightElectricNode = [SKNode node];
        rightElectricNode.position = CGPointMake(CGRectGetMaxX(self.frame), 110);
        rightElectricNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
        rightElectricNode.physicsBody.affectedByGravity = NO;
        rightElectricNode.physicsBody.categoryBitMask = ASElectricCategory;
        rightElectricNode.physicsBody.contactTestBitMask = ASPlayerCategory;
        rightElectricNode.physicsBody.dynamic = NO;
        rightElectricNode.zPosition = 4;
        electricSpark.position = CGPointMake(-20, 80);
        [rightElectricNode addChild:electricSpark];
        [backGroundNode addChild:rightElectricNode];
        

        
        startGameNode = [SKLabelNode labelNodeWithFontNamed:@"Gorefest"];
        startGameNode.fontColor = [SKColor greenColor];
        startGameNode.fontSize = 32;
        startGameNode.name = @"startGame";
        startGameNode.text = [NSString stringWithFormat:@"Tap"];
        startGameNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [backGroundNode addChild:startGameNode];
        SKAction *blink = [SKAction sequence:@[[SKAction fadeAlphaBy:-1 duration:.3],
                                               [SKAction fadeAlphaBy:1 duration:.3]
                                               ]];
        [startGameNode runAction:[SKAction repeatActionForever:blink]];
        [self setClouds];
        [self setMan];
    
    }
    return self;
}
- (void)startGame
{
    [startGameNode removeFromParent];
    [self setGameActions];
    
    [[TDGAudio sharedInstance] playBackgroundMusic:@"BG_Loop.wav"];

    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:8],
                                                                       [SKAction runBlock:^{
        
        [cloudCenter runAction:[SKAction repeatAction:[SKAction animateWithTextures:cloudFlashTextures timePerFrame:.1 resize:NO restore:YES] count:10] completion:^{
            [self performSelector:@selector(drawLightningBolt) withObject:nil afterDelay:0];
        }];
        
    }]]]]];

    
}
-(void)setGameActions
{
    SKAction *animationAction = [SKAction animateWithTextures:manWalkTextures
                                                 timePerFrame:(1.0/12.0)];
    [man runAction:[SKAction repeatActionForever:animationAction]withKey:@"Manimation"];
    
    
    SKAction *cloudLeftBlock = [SKAction runBlock:^{
        [self performSelector:@selector(spawnDropsWithCloud:) withObject:cloudLeft];
    }];
    SKAction *cloudCenterBlock = [SKAction runBlock:^{
        [self performSelector:@selector(spawnDropsWithCloud:) withObject:cloudCenter];
    }];
    SKAction *cloudRightBlock = [SKAction runBlock:^{
        [self performSelector:@selector(spawnDropsWithCloud:) withObject:cloudRight];
    }];
    
    SKAction *makeLeftDrops = [SKAction sequence:@[[SKAction waitForDuration:skRand(1, 3)],
                                                   cloudLeftBlock]];
    SKAction *makeCenterDrops = [SKAction sequence:@[[SKAction waitForDuration:skRand(1, 5)],
                                                     cloudCenterBlock]];
    
    SKAction *makeRightDrops = [SKAction sequence:@[[SKAction waitForDuration:skRand(1, 3)],
                                                cloudRightBlock]];
   

    
    [self runAction:[SKAction repeatActionForever:makeLeftDrops]];
    [self runAction:[SKAction repeatActionForever:makeCenterDrops]];
    [self runAction:[SKAction repeatActionForever:makeRightDrops]];

    
}
-(void)setClouds
{
    
    
    NSString *cloudImage = @"cloudFlash_1";
    
    cloudLeft = [[TDGCloud alloc]initWithImageNamed:cloudImage];
    cloudCenter = [[TDGCloud alloc]initWithImageNamed:cloudImage];
    cloudRight = [[TDGCloud alloc]initWithImageNamed:cloudImage];
    
    cloudLeft.position = CGPointMake(cloudLeft.size.width/2 - 30, self.frame.size.height-cloudLeft.size.height/2 -30);
    cloudCenter.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-50);
    cloudRight.position = CGPointMake(self.frame.size.width - cloudRight.size.width/2 + 30, self.frame.size.height - cloudRight.size.height / 2 - 30);
    
    cloudLeft.zPosition = 2;
    cloudCenter.zPosition = 2;
    cloudRight.zPosition = 2;
    
    
    [gameLayerNode addChild:cloudLeft];
    [gameLayerNode addChild:cloudCenter];
    [gameLayerNode addChild:cloudRight];

    [self setUpHud];
}
- (void)setUpHud
{
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Gorefest"];
    scoreLabel.fontSize = 50;
    scoreLabel.fontColor = [SKColor blackColor];
    scoreLabel.position = CGPointMake(0, 10);
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [cloudCenter addChild:scoreLabel];
    [self updateScore];
}


-(void)setMan
{
    SKTextureAtlas *stillAtlas = [SKTextureAtlas atlasNamed:@"manStillFrames"];
    manContainer = [SKNode node];
    //man = [SKSpriteNode spriteNodeWithTexture:manWalkTextures[0]];
    man = [SKSpriteNode spriteNodeWithTexture:[stillAtlas textureNamed:manAtlasString]];
    man.physicsBody.dynamic = NO;
    man.size = CGSizeMake(110, 110);// 90,90

    CGSize manContPhysicsSize = CGSizeMake(man.size.width/5, 75); // May need to readjust this
    
    manContainer.position = CGPointMake(CGRectGetMidX(self.frame), man.size.height + 35);
    manContainer.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:manContPhysicsSize];//CGSizeMake(15, 70)];
    manContainer.physicsBody.affectedByGravity = NO;
    manContainer.physicsBody.categoryBitMask = ASPlayerCategory;
    manContainer.physicsBody.contactTestBitMask = ASAcidCategory;
    manContainer.physicsBody.collisionBitMask = 0;
    manContainer.zPosition = 2;
    [gameLayerNode addChild:manContainer];
    [manContainer addChild:man];
}
-(void)spawnDropsWithCloud:(SKSpriteNode *)cloud
{
    SKSpriteNode *drop = [SKSpriteNode spriteNodeWithImageNamed:@"drop"];
    CGRectGetWidth(cloud.frame);

    drop.size = CGSizeMake(40, 40);
    drop.position = CGPointMake(skRand(cloud.position.x - cloud.size.width/2 + drop.size.width/2 + 15/*padding on cloud*/,cloud.position.x + cloud.size.width/2 - drop.size.width/2- 15/*padding on cloud*/), cloud.position.y);
    drop.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:drop.size.width/3];//was/2
    drop.physicsBody.affectedByGravity = YES;
    drop.physicsBody.categoryBitMask = ASAcidCategory;
    drop.physicsBody.contactTestBitMask = ASPlayerCategory;
    drop.physicsBody.collisionBitMask = 0;
    drop.name = [NSString stringWithFormat:@"drop"];
    drop.zPosition = 1;
    [gameLayerNode addChild:drop];
    
}

-(void)drawLightningBolt
{
    UIBezierPath *lightningPath = [UIBezierPath bezierPath];
    CGPoint start = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-20);
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-20);
    
    int i = 15;
    [lightningPath moveToPoint:start];
    do {
        center.x += (int)(arc4random() % 31) - i;
        if (center.x > start.x + i) {
            center.x = start.x + i;
        }
        if (center.x < start.x - i) {
            center.x = start.x - i;
        }
        center.y -= arc4random() % i;
        [lightningPath addLineToPoint:center];
        
    } while (center.y > 100);
    
 
    SKShapeNode *shape = [SKShapeNode node];
    shape.lineWidth = 2;
    shape.glowWidth = 3;
    shape.path = lightningPath.CGPath;
    shape.strokeColor = [SKColor yellowColor];
    //shape.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:lightningPath.CGPath];
    shape.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30, CGRectGetHeight(self.frame)) center:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    shape.physicsBody.categoryBitMask = ASElectricCategory;
    shape.physicsBody.contactTestBitMask = ASPlayerCategory;
    shape.physicsBody.collisionBitMask = kNilOptions;
    shape.physicsBody.dynamic = NO;
    [gameLayerNode addChild:shape];
    [backGroundNode runAction:lightningSound];
 
    
    SKAction *scaleUp = [SKAction fadeAlphaBy:-1 duration:.1];
    SKAction *scaleDown = [scaleUp reversedAction];
    SKAction *repeat = [SKAction repeatAction:[SKAction sequence:@[scaleUp,scaleDown]] count:10];
    
    SKAction *bgTreeFadeUp = [SKAction fadeAlphaTo:1 duration:.1];
    SKAction *bgTreeFadeDown = [SKAction fadeAlphaTo:.2 duration:.1];
    SKAction *bgTreeBlink = [SKAction repeatAction:[SKAction sequence:@[bgTreeFadeUp, bgTreeFadeDown]] count:10];
    [bgTree runAction:bgTreeBlink withKey:@"treeBlink"];
    [shape runAction:repeat completion:^{
        [shape removeFromParent];
        [bgTree removeActionForKey:@"treeBlink"];
        bgTree.alpha = .2;
    }];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (!_gameStarted) {
        _gameStarted = YES;
        [self startGame];
    }
    
    if (_gameOver) return;
    
    //[[TDGAudio sharedInstance]playSoundEffect:@"bloop.wav"];
    [soundNode runAction:[SKAction playSoundFileNamed:@"bloop.wav" waitForCompletion:NO]];
    
    if ([manContainer actionForKey:@"Moving"]) {
        [manContainer removeActionForKey:@"Moving"];
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGFloat middleScreen = CGRectGetMidX(self.frame);
        CGFloat destination = 0;
        if (location.x < middleScreen) { // Move man left
            multiplierForDirection = -1;
            destination = 0;
        }else if (location.x >= middleScreen) { // Move man Right
            multiplierForDirection = 1;
            destination = CGRectGetMaxX(self.frame);
        }
        
        
        man.xScale = multiplierForDirection;
        SKAction *moveAction = [SKAction moveToX:destination duration:(abs(destination - manContainer.position.x))/MAN_POINTS_PER_SEC];
        
        [manContainer runAction:moveAction withKey:@"Moving"];

    }
}
-(void)didSimulatePhysics
{
    
    [gameLayerNode enumerateChildNodesWithName:@"drop" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < manContainer.position.y - man.size.height/2) {
            SKSpriteNode *drop = (SKSpriteNode*)node;
            [drop removeFromParent];
            SKSpriteNode *splat = [SKSpriteNode node];
            splat.position = CGPointMake(drop.position.x, 100);
            splat.size = CGSizeMake(40, 40);
            [gameLayerNode addChild:splat];
            
            SKAction *splatAnimation = [SKAction animateWithTextures:acidSplatTextures timePerFrame:.02];
            [splat runAction: splatAnimation completion:^{
                [splat removeFromParent];
                if (!_gameOver) {
                    [TDGGameData sharedGameData].score ++;
                    [self updateScore];
                }
            }];

        };
    }];
}
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if (_gameOver) return;
    
    uint32_t collision = (contact.bodyA.categoryBitMask |
                          contact.bodyB.categoryBitMask);
#pragma mark Acid Death
    if (collision == (ASPlayerCategory | ASAcidCategory)) {
        SKSpriteNode *drop = (contact.bodyA.categoryBitMask==ASAcidCategory?(SKSpriteNode*)contact.bodyA.node:(SKSpriteNode*)contact.bodyB.node);
        
        // Sound
        [[TDGAudio sharedInstance] doVolumeFade];
        [soundNode runAction:acidDeathSound];

        
        [TDGGameData sharedGameData].acidDeaths ++;
        [self endGame];

        if ([drop.name isEqualToString:@"drop"]) {
            [drop removeFromParent];
        }
        //
        SKSpriteNode *splat = [SKSpriteNode node];
        splat.position = CGPointMake(man.position.x, man.size.height/2 - 10);
        splat.size = CGSizeMake(40, 40);
        [man addChild:splat];
        
        SKAction *splatAnimation = [SKAction animateWithTextures:acidSplatTextures timePerFrame:.1];
        [splat runAction: splatAnimation completion:^{
            [splat removeFromParent];

        }];
        
        
        //
        
        [man removeActionForKey:@"Manimation"];
        [manContainer removeActionForKey:@"Moving"];
        [man runAction:[SKAction animateWithTextures:acidDeathTextures timePerFrame:/*.05*//*.07*/.065 resize:NO restore:NO]];

    };
    
    
#pragma mark Electric Death
    if (collision == (ASPlayerCategory | ASElectricCategory)) {
        
        // Fade for acid, but this sounds better just pausing.
        [[TDGAudio sharedInstance] pauseBackgroundMusic];
        [soundNode runAction:electricDeathSound];
        
        [TDGGameData sharedGameData].electricDeaths ++;
        [self endGame];
        

        [man addChild:electricSmoke];
        
        [man removeActionForKey:@"Manimation"];
        [manContainer removeActionForKey:@"Moving"];
        [man runAction:[SKAction animateWithTextures:electricDeathTextures timePerFrame:/*.05*/.07 resize:NO restore:NO]];

    };

}

-(void)updateScore
{
    // Score
    scoreLabel.text = [NSString stringWithFormat:@"%i", [TDGGameData sharedGameData].score];
    
}
- (void)endGame
{
    _gameOver = YES;
    [self removeAllActions];
    gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Gorefest"];
    gameOverLabel.text = [NSString stringWithFormat:@"Game Over"];
    gameOverLabel.fontSize = 32;
    gameOverLabel.fontColor = [SKColor greenColor];
    gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    gameOverLabel.alpha = 0;
    [gameLayerNode addChild:gameOverLabel];
    
    [gameOverLabel runAction:[SKAction fadeAlphaTo:1 duration:2 ]];
    [TDGGameData sharedGameData].gameCount ++;
    [TDGGameData sharedGameData].scorePurse += [TDGGameData sharedGameData].score;
    
    // Game Center
    // This allows Achievement to show on the life it was acheived rather than the next.
    [TDGGameData sharedGameData].highScore = MAX([TDGGameData sharedGameData].score, [TDGGameData sharedGameData].highScore);

  
    GKAchievement *redMohawk = [TDGAchievementsHelper redMohawkAchievement:[TDGGameData sharedGameData].highScore];
    GKAchievement *greenMohawk = [TDGAchievementsHelper greenMohawkAchievement:[TDGGameData sharedGameData].acidDeaths];
    GKAchievement *yellowMohawk = [TDGAchievementsHelper yellowMohawkAchievement:[TDGGameData sharedGameData].electricDeaths];
    GKAchievement *rainbowMohawk = [TDGAchievementsHelper rainbowMohawkAchievement:[TDGGameData sharedGameData].gameCount];
    GKAchievement *pumpkinHead = [TDGAchievementsHelper pumpkinHeadAchievement:[TDGGameData sharedGameData].highScore];
    GKAchievement *skeletonHead = [TDGAchievementsHelper skeletonHeadAchievement:[TDGGameData sharedGameData].highScore];

    NSArray *achivements = @[redMohawk, greenMohawk, yellowMohawk, rainbowMohawk, pumpkinHead, skeletonHead];
    [[TDGGameKitHelper sharedGameKitHelper] reportAchievements:achivements];
    [[TDGGameKitHelper sharedGameKitHelper]reportScore:[TDGGameData sharedGameData].score forLeaderboardID:@"com.topdrop.acidstorm.highscore"];
 
    
    [self runAction:[SKAction waitForDuration:3] completion:^{
        [self removeEmitters];
        GameOverScene *gameOver = [[GameOverScene alloc]initWithSize:self.size];
        
        [self.scene.view presentScene:gameOver];
    }];
}
-(void)removeEmitters
{
    [electricSpark removeAllChildren];
    [electricSpark removeFromParent];
    electricSpark = nil;
    [rightElectricNode removeAllChildren];
    [rightElectricNode removeFromParent];
    rightElectricNode = nil;
    [electricSmoke removeAllChildren];
    [electricSmoke removeFromParent];
    electricSmoke = nil;
    [acidSmoke removeAllChildren];
    [acidSmoke removeFromParent];
    acidSmoke = nil;
}
@end
