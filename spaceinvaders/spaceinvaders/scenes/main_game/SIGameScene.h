//
//  SIMyScene.h
//  spaceinvaders
//

//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface SIGameScene : SKScene

//TODO: I don't like this
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, readonly, getter = isGameStarted) BOOL gameStarted;

- (void)addToScore:(NSUInteger)points;
- (void)pause;
- (void)resume;

@end
