//
//  SIMyScene.h
//  spaceinvaders
//

//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface SIGameScene : SKScene

@property (strong, nonatomic) CMMotionManager *motionManager;

-(void)addToScore:(NSUInteger)points;

@end
