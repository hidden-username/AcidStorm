//
//  ManHole.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/26/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import "TDGManHole.h"
#import "TDGUtils.h"

@implementation TDGManHole

-(instancetype)initWithImageNamed:(NSString *)name
{
    if (self = [super initWithImageNamed:name]) {
        
    
        self.name = @"manHole";
        self.size = CGSizeMake(80, 40);
        
        NSArray *acidBubbleTextures      = @[[SKTexture textureWithImageNamed:@"acidBubble_1"],
                                             [SKTexture textureWithImageNamed:@"acidBubble_2"],
                                             [SKTexture textureWithImageNamed:@"acidBubble_3"],
                                             [SKTexture textureWithImageNamed:@"acidBubble_4"],
                                             [SKTexture textureWithImageNamed:@"acidBubble_5"]];
        
        
        SKSpriteNode *bubble1  = [SKSpriteNode spriteNodeWithTexture:acidBubbleTextures[0]];
        [self addChild:bubble1];
        SKSpriteNode *bubble2  = [SKSpriteNode spriteNodeWithTexture:acidBubbleTextures[0]];
        [self addChild:bubble2];
        SKSpriteNode *bubble3  = [SKSpriteNode spriteNodeWithTexture:acidBubbleTextures[0]];
        [self addChild:bubble3];
        SKSpriteNode *bubble4  = [SKSpriteNode spriteNodeWithTexture:acidBubbleTextures[0]];
        [self addChild:bubble4];
        
        // Soft Code This Position and Size
        
        // Add a for loop which adds 5 random size and poisiotn bubles.
        bubble1.size = CGSizeMake(25, 25);
        bubble1.position = CGPointMake(20, 10);
        [bubble1 runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:acidBubbleTextures timePerFrame:.2]]];
        
        bubble2.size = CGSizeMake(15, 15);
        bubble2.position = CGPointMake(25, 7);
        [bubble2 runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:acidBubbleTextures timePerFrame:.17]]];
        
        bubble3.size = CGSizeMake(10, 10);
        bubble3.position = CGPointMake(20, 9);
        [bubble3 runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:acidBubbleTextures timePerFrame:.15]]];
        bubble4.size = CGSizeMake(10, 10);
        bubble4.position = CGPointMake(10, 5);
        [bubble4 runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:acidBubbleTextures timePerFrame:.1]]];
        
        

        
    }
    return self;
    
}
/*-(void) dealloc
{
    NSLog(@"Dealloc <manhole>");
}*/
@end
