//
//  SKNode+si_collision_animation.m
//  spaceinvaders
//
//  Created by Henry Chung on 2014-04-30.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SKNode+si_collision_animation.h"

@implementation SKNode (si_collision_animation)

- (void)fadeOutWithDuration:(NSTimeInterval)sec {
    NSAssert(sec >= 0, @"What am I suppose to do with a negative number?");
    SKAction *fadeAway = [SKAction fadeOutWithDuration:sec];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeAway, removeNode]];
    
    [self runAction:sequence];
}

@end
