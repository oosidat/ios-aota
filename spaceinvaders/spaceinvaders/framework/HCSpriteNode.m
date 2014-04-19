//
//  HCSpriteNode.m
//  RacingGame
//
//  Created by Henry Chung on 4/12/14.
//  Copyright (c) 2014 HenryChung. All rights reserved.
//

#import "HCSpriteNode.h"

@interface HCSpriteNode()

@property (nonatomic, copy) HCSpriteNodeTouchEvent touchesBegan;
@property (nonatomic, copy) HCSpriteNodeTouchEvent touchesMoved;
@property (nonatomic, copy) HCSpriteNodeTouchEvent touchesEnded;
@property (nonatomic, copy) HCSpriteNodeTouchEvent touchesCancelled;

@end

@implementation HCSpriteNode

- (instancetype)initWithImageNamed:(NSString *)name {
    if(self = [super initWithImageNamed:name]) {
        self.userInteractionEnabled = true;
    }
    return self;
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name {
    return [[HCSpriteNode alloc] initWithImageNamed:name];
}

#pragma mark TouchEventHandler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.touchesBegan) {
        self.touchesBegan(touches, event);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.touchesMoved) {
        self.touchesMoved(touches, event);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.touchesEnded) {
        self.touchesEnded(touches, event);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.touchesCancelled) {
        self.touchesCancelled(touches, event);
    }
}

@end
