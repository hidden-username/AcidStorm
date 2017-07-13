//
//  TelephonePole.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/26/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import "TDGTelephonePole.h"
#import "TDGUtils.h"

@implementation TDGTelephonePole
- (instancetype)initWithImageNamed:(NSString *)name
{
    if (self = [super initWithImageNamed:name]) {
        
        
        // TelephonePole
        self.name = @"telephonePole";
        self.size = CGSizeMake(100, 100);
        self.position = CGPointMake(CGRectGetMaxX(self.frame)-self.size.width/4, self.size.height/2);
        
        
        NSString *electricSparkPath = [[NSBundle mainBundle]pathForResource:@"ElectricSpark" ofType:@"sks"];
        
        
        SKEmitterNode *electricSpark = [NSKeyedUnarchiver unarchiveObjectWithFile:electricSparkPath];
        
        
        electricSpark.position = CGPointZero;
        [self addChild:electricSpark];
        
        
        

    }
    return self;
}
@end
