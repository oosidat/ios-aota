//
//  SIGameScene+collision.m
//  spaceinvaders
//
//  Created by Henry Chung on 4/18/14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIGameScene+collision.h"
#import "SIGameScene.h"

NS_ENUM(u_int32_t, SICollisionCategory) {
    SICollisionMonsterCategory,
    SICollisionRocketCategory
};

@interface SIGameScene() <SKPhysicsContactDelegate>

@end

@implementation SIGameScene (collision)

- (void)configurePhysics {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
}

+ (void)prepareCollisionForMonster:(SKSpriteNode *)monster {
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size];
    monster.physicsBody.dynamic = YES;
    monster.physicsBody.categoryBitMask = SICollisionMonsterCategory;
    monster.physicsBody.contactTestBitMask = SICollisionRocketCategory;
    monster.physicsBody.collisionBitMask = 0;
    monster.physicsBody.usesPreciseCollisionDetection = YES;
}

+ (void)prepareCollisionForRocket:(SKSpriteNode *)rocket {
    rocket.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rocket.size];
    rocket.physicsBody.dynamic = YES;
    rocket.physicsBody.categoryBitMask = SICollisionRocketCategory;
    rocket.physicsBody.contactTestBitMask = SICollisionMonsterCategory;
    rocket.physicsBody.collisionBitMask = 0;
    rocket.physicsBody.usesPreciseCollisionDetection = YES;
}

#pragma mark SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *bodyA = contact.bodyA;
    SKPhysicsBody *bodyB = contact.bodyB;
    
    if(bodyA.categoryBitMask == bodyB.contactTestBitMask && bodyB.categoryBitMask == bodyA.contactTestBitMask) {
        NSLog(@"Collision!");
        if(bodyA.categoryBitMask == SICollisionMonsterCategory) {
            [bodyA.node fadeOutWithDuration:0.1];
            [bodyB.node removeFromParent];
        } else {
            [bodyA.node removeFromParent];
            [bodyB.node fadeOutWithDuration:0.1];
        }
        
        
        [self addToScore:1];
    }
}

@end
