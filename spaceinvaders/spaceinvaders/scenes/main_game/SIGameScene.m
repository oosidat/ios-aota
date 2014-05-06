//
//  SIMyScene.m
//  spaceinvaders
//
//  Created by Osama Sidat on 2014-04-14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIGameScene.h"
#import "SISpaceship.h"
#import "SIGameScene+collision.h"

#define kRocketRange 1000.0
#define kVelocity 300.0

@interface SIGameScene()

@property (nonatomic) SISpaceship *spaceship;
@property (nonatomic) SKTexture *monsterTexture;
@property (nonatomic) SKTexture *rocketTexture;
@property (nonatomic) NSTimeInterval timeUntilMonsterSpawn;
@property (nonatomic) NSTimeInterval timeLastUpdate;

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKLabelNode *escapedLabel;
@property NSUInteger score;
@property NSUInteger escapedAndroids;
@property double currentMaxAccelX;

@end

@implementation SIGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _spaceship = [[SISpaceship alloc] initWithImageNamed:@"Spaceship32.png"];
        _monsterTexture = [SKTexture textureWithImageNamed:@"Monster32.png"];
        _rocketTexture = [SKTexture textureWithImageNamed:@"Rocket32.png"];
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Thin"];
        _escapedLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Thin"];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.1;
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
            [self outputAccelerationData:accelerometerData.acceleration];
            if(error)
            {
                NSLog(@"%@", error);
            }
        }];
        
    }
    return self;
}

-(void)outputAccelerationData:(CMAcceleration)acceleration {
    self.currentMaxAccelX = acceleration.x;
}

-(void)setupDisplay {
    self.backgroundColor = [SKColor whiteColor];
    self.spaceship.position = CGPointMake(self.frame.size.width/2, self.spaceship.size.height);
    [self addChild:self.spaceship];
    
    self.scoreLabel.fontSize = 12;
    self.scoreLabel.fontColor = [SKColor blueColor];
    self.scoreLabel.text = [NSString stringWithFormat:@"Androids Destroyed: %d", 0];
    self.scoreLabel.position = CGPointMake(15 + self.scoreLabel.frame.size.width/2, self.size.height - (15 + self.scoreLabel.frame.size.height/2));
    
    self.escapedLabel.fontSize = 12;
    self.escapedLabel.fontColor = [SKColor redColor];
    self.escapedLabel.text = [NSString stringWithFormat:@"Androids Escaped: %d", 0];
    self.escapedLabel.position = CGPointMake(self.frame.size.width - (self.escapedLabel.frame.size.width/2 + 15), self.size.height - (15 + self.escapedLabel.frame.size.height/2));
    
    [self addChild:self.scoreLabel];
    [self addChild:self.escapedLabel];
}

- (void)didMoveToView:(SKView *)view {
    [self setupDisplay];
    
    [self configurePhysics];
}

- (void)addAndroid:(NSTimeInterval)timeSinceLastUpdate {
    self.timeUntilMonsterSpawn -= timeSinceLastUpdate;
    if(self.timeUntilMonsterSpawn > 0) {
        return;
    }
    self.timeUntilMonsterSpawn += [SIRandomGenerator randomTimeIntervalFrom:0.5 to:1.0];
    
    SKSpriteNode *android = [SKSpriteNode spriteNodeWithTexture:self.monsterTexture];
    
    NSInteger androidWidth = android.size.width;
    NSInteger androidHeight = android.size.height;
    
    NSInteger minX = androidWidth;
    NSInteger maxX = self.frame.size.width - androidWidth;
    NSInteger actualX = [SIRandomGenerator randomIntegerFrom:minX to:maxX];
    
    android.position = CGPointMake(actualX, self.frame.size.height);
    [self addChild:android];
    
    NSTimeInterval duration = [SIRandomGenerator randomTimeIntervalFrom:1.5 to:4.5];
    
    __weak SIGameScene *weakSelf = self;
    SKAction *actionMove = [SKAction moveTo:CGPointMake(actualX, -androidHeight) duration:duration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    SKAction *actionAddToEscapedScore = [SKAction runBlock:^{
        SIGameScene *gameScene = weakSelf;
        [gameScene addToEscaped:1];
    }];
    [android runAction:[SKAction sequence:@[actionMove, actionAddToEscapedScore, actionMoveDone]]];
    
    [SIGameScene prepareCollisionForMonster:android];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch * touch = [touches anyObject];
    SKSpriteNode *rocket = [SKSpriteNode spriteNodeWithTexture:self.rocketTexture];
    rocket.position = CGPointMake(self.spaceship.position.x, self.spaceship.position.y + self.spaceship.size.height/2);
    
    [self addChild:rocket];
    
    CGFloat moveDuration = self.size.width / kVelocity;
    
    CGPoint rocketDest = CGPointMake(rocket.position.x, kRocketRange);
    
    SKAction *actionMove = [SKAction moveTo:rocketDest duration:moveDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [rocket runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    [SIGameScene prepareCollisionForRocket:rocket];
}

-(void)addToScore:(NSUInteger)points {
    self.score += points;
    self.scoreLabel.text = [NSString stringWithFormat: @"Androids Destroyed: %d", self.score];
}

-(void)addToEscaped:(NSUInteger)badpoints {
    self.escapedAndroids += badpoints;
    self.escapedLabel.text = [NSString stringWithFormat: @"Androids Escaped: %d", self.escapedAndroids];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    NSTimeInterval timeSinceLastUpdate = currentTime - self.timeLastUpdate;
    if(timeSinceLastUpdate > 1) {
        timeSinceLastUpdate = 1.0/60;
    }
    self.timeLastUpdate = currentTime;
    
    [self addAndroid:timeSinceLastUpdate];
    [self movement];
    
}

-(void)movement {
    float maxX = self.frame.size.width - _spaceship.size.width/2;
    float minX = _spaceship.size.width/2;
    
    float newX = self.currentMaxAccelX * 20;
    newX = MIN(MAX(newX + _spaceship.position.x, minX), maxX);
    self.spaceship.position = CGPointMake(newX, _spaceship.position.y);
}

@end
