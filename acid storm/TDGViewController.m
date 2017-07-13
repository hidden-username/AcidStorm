//
//  TDGViewController.m
//  Acid Storm
//
//  Created by Michael McCafferty on 8/19/14.
//  Copyright (c) 2014 Michael McCafferty. All rights reserved.
//

#import <Social/Social.h>
#import "TDGViewController.h"
#import "TDGGameScene.h"
#import "MainMenuScene.h"
#import "TDGGameData.h"

#import "TDGGameKitHelper.h"

#import "ASConstants.h"


@implementation TDGViewController
{
    SKView *_skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
    
    // Do any additional setup after loading the view.
    // Game Center
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showAuthenticationViewController)
                                                name:PresentAuthenticationViewController
                                              object:nil];
    
    // Prevents Gl rendering in BG, causing bad_Access
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    

    
    
    
    [[TDGGameKitHelper sharedGameKitHelper]
     authenticateLocalPlayer];
    

    // Game Data
    [TDGGameData sharedGameData];
    

    
    // Configure the view.
    _skView = (SKView *)self.view;
    
    
    //_skView.showsFPS = YES;
    //_skView.showsNodeCount = YES;
    //_skView.showsPhysics = YES;
    //_skView.showsDrawCount = YES;
    
    
    CGSize viewSize = self.view.bounds.size;

    // Scales for iPad
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        viewSize.height *= .5;
        viewSize.width *= .5;
    }
    
    // Create and configure the scene.
    SKScene *scene = [MainMenuScene sceneWithSize:viewSize];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [_skView presentScene:scene];
    
   
/**********************************************
 
 iAd is causing the:
 
 <Error>: CGAffineTransformInvert: singular matrix.
 
 **********************************************/
   // self.canDisplayBannerAds = YES;
  //  This Method Resizes Our SKView, Left it commented, so i don't use it again.
    
    self.adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-self.adBanner.frame.size.height,self.adBanner.frame.size.width, self.adBanner.frame.size.height)];
    

    self.adBanner.delegate=self;
    [self.view/*_skView*/ addSubview:self.adBanner];
    
    
    
}
#pragma mark- iAD Methods
-(void)handleNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"hideAd"]) {
        [self hideBanner];
    }else if ([notification.name isEqualToString:@"showAd"]) {
        [self showBanner];
    }
    
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    _skView.paused = YES;
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    _skView.paused = NO;
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!self.bannerIsVisible) {
      
      if (self.adBanner.superview == nil) {
       [_skView addSubview:self.adBanner];
       }
      
        [UIView beginAnimations:@"animatedAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0.0, -banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.bannerIsVisible) {
      

        [UIView beginAnimations:@"animatedAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0.0, banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}




-(void)hideBanner {
    
    self.adBanner.Hidden = YES;
}


-(void)showBanner {
    
    self.adBanner.hidden = NO;
    
}
#pragma mark- Game Kit
- (void)showAuthenticationViewController
{
    TDGGameKitHelper *gameKitHelper = [TDGGameKitHelper sharedGameKitHelper];
    
    [self.view.window.rootViewController presentViewController:
     gameKitHelper.authenticationViewController
                                         animated:YES
                                       completion:nil];
    
}

#pragma mark- UI Methods
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    // The Original Method
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }*/
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark- Pause GL Rendering
- (void)willEnterForeground
{
    // Need to unpause the view, but not the scene.
    _skView.paused = NO;
    
}

- (void)willEnterBackground
{
    // Need to pause the view to prevent bad access, but also need to pause scene.
    _skView.Paused = YES;
    _skView.scene.paused = YES;
}

#pragma mark- Memory
- (void)dealloc
{
    NSLog(@"VC deallocated");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
