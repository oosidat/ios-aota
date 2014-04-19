//
//  SIMainMenuScene.m
//  spaceinvaders
//
//  Created by Henry Chung on 4/18/14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIMainMenuScene.h"
#import "SIGameScene.h"
#import "HCSpriteNode.h"

@interface SIMainMenuScene()

@property (nonatomic) HCSpriteNode *playButton;

@end

@implementation SIMainMenuScene

- (instancetype)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        _playButton = [HCSpriteNode spriteNodeWithImageNamed:@"play_button.png"];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    
    self.playButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:self.playButton];
    
    __weak SKScene *weakSelf = self;
    [self.playButton setTouchesBegan:^(NSSet *touches, UIEvent *event) {
        SKScene *mainMenu = weakSelf;
        SKScene *gameScene = [SIGameScene sceneWithSize:mainMenu.frame.size];
        gameScene.scaleMode = SKSceneScaleModeAspectFit;

        [mainMenu.view presentScene:gameScene];
    }];
}

@end
