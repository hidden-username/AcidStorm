//
//  TDGCloud.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/26/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import "TDGCloud.h"
#import "TDGGameData.h"
#import "TDGUtils.h"

@implementation TDGCloud

- (instancetype)initWithImageNamed:(NSString *)name
{
    if (self=[super initWithImageNamed:name]) {
        
        self.size = CGSizeMake(190, 190);
        self.zPosition = 10;
        
    }
    return self;
}

@end
