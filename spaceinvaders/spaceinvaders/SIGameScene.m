//
//  SIMyScene.m
//  spaceinvaders
//
//  Created by Osama Sidat on 2014-04-14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIGameScene.h"
#import "SISpaceship.h"

@interface SIGameScene()

@property (nonatomic) SISpaceship *spaceship;

@end


@implementation SIGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _spaceship = [[SISpaceship alloc] initWithImageNamed:@"Spaceship32.png"];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    self.spaceship.position = CGPointMake(self.frame.size.width/2, self.spaceship.size.height);
    [self addChild:self.spaceship];
}

- (void)addAndroid {
    SKSpriteNode * android = [SKSpriteNode spriteNodeWithImageNamed:@"Monster32.png"];
    
    int androidWidth = android.size.width;
    int minX = androidWidth;
    int maxX = self.frame.size.width - androidWidth;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + androidWidth;
    
    android.position = CGPointMake(actualX, self.frame.size.height);
    [self addChild:android];
    
    int minDuration = 0.5;
    int maxDuration = 3.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, -androidWidth) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [android runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.spaceship.position = CGPointMake(self.frame.size.width/2, self.spaceship.position.y + 5);
    
    for (UITouch *touch in touches) {
        
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self addAndroid];
}

@end
