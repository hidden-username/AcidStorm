//
//  TDGUtils.h
//  Acid Storm
//
//  Created by Michael McCafferty on 8/26/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>


#define TDG_INLINE      static __inline__


#pragma mark - Loading from a Texture Atlas
TDG_INLINE NSArray *ASLoadFramesFromAtlas(NSString *atlasName) {
    
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:atlas.textureNames.count];
    
    
    for (int i = 1; i <= atlas.textureNames.count; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@_%d", atlasName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [frames addObject:texture];
    }
    
    return frames;
}

#pragma mark - Game Logic
TDG_INLINE CGFloat skRandf(){
    return rand() / (CGFloat)RAND_MAX;
}

TDG_INLINE CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}







