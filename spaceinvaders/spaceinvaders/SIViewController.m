//
//  SIViewController.m
//  spaceinvaders
//
//  Created by Osama Sidat on 2014-04-14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIViewController.h"
#import "SIGameScene.h"

@implementation SIViewController

- (void)viewDidLayoutSubviews
{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (skView) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        SKScene * scene = [SIGameScene sceneWithSize:CGSizeMake(320, 480)];
        scene.scaleMode = SKSceneScaleModeAspectFit;

        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
