//
//  TDGViewController.h
//  Acid Storm
//

//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

@interface TDGViewController : UIViewController <ADBannerViewDelegate>

@property (nonatomic) BOOL bannerIsVisible;
@property (nonatomic, strong)   ADBannerView *adBanner;

@end
