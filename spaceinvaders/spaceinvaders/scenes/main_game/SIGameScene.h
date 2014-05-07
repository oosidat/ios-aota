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

-(void)addToScore:(NSUInteger)points;

@end
