//
//  SIViewController.m
//  spaceinvaders
//
//  Created by Osama Sidat on 2014-04-14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIViewController.h"
#import "SIGameScene.h"

@interface SIViewController()

@property (nonatomic, getter = isPaused) BOOL paused;
@property (nonatomic, weak) SIGameScene *gameScene;

- (IBAction)pauseButtonAction:(id)sender;

@end

@implementation SIViewController

- (void)viewDidLayoutSubviews {
    // Configure the view.
    SKView *skView = (SKView *)self.view;
    if (skView) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        SIGameScene *scene = [SIGameScene sceneWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        scene.viewController = self;
        
        self.gameScene = scene;

        [skView presentScene:scene];
        [self registerNotifications];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (IBAction)pauseButtonAction:(id)sender {
    if(self.isPaused) {
        [self.gameScene resume];
    } else {
        [self.gameScene pause];
    }
    self.paused = !self.isPaused;
}

#pragma mark UIApplication Notification

- (void)registerNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didEnterBackground:(NSNotification *)obj {
    if(!self.isPaused) {
        [self.gameScene pause];
        self.paused = YES;
    }
}

@end
