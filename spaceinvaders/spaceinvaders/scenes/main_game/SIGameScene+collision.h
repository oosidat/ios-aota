//
//  SIGameScene+collision.h
//  spaceinvaders
//
//  Created by Henry Chung on 4/18/14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIGameScene.h"

@interface SIGameScene (collision)

- (void)configurePhysics;
+ (void)prepareCollisionForMonster:(SKSpriteNode *)monster;
+ (void)prepareCollisionForRocket:(SKSpriteNode *)rocket;

@end
