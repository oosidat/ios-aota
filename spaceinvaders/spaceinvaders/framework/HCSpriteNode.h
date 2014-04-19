//
//  HCSpriteNode.h
//  RacingGame
//
//  Created by Henry Chung on 4/12/14.
//  Copyright (c) 2014 HenryChung. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^HCSpriteNodeTouchEvent)(NSSet *touches, UIEvent *event);

@interface HCSpriteNode : SKSpriteNode

// Implemented as methods to get autocomplete for blocks
- (void)setTouchesBegan:(HCSpriteNodeTouchEvent)touchesBegan;
- (void)setTouchesMoved:(HCSpriteNodeTouchEvent)touchesMoved;
- (void)setTouchesEnded:(HCSpriteNodeTouchEvent)touchesMoved;
- (void)setTouchesCancelled:(HCSpriteNodeTouchEvent)touchesMoved;

@end
