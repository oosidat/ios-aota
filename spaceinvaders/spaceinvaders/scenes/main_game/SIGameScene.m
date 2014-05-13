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
#import "SIScoreManager.h"

#define kRocketRange 1000.0
#define kVelocity 300.0

@interface SIGameScene ()

@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic) SISpaceship *spaceship;
@property (nonatomic) SKTexture *monsterTexture;
@property (nonatomic) SKTexture *rocketTexture;
@property (nonatomic) NSTimeInterval timeUntilMonsterSpawn;
@property (nonatomic) NSTimeInterval timeLastUpdate;

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKLabelNode *escapedLabel;
@property (nonatomic) SKLabelNode *countDownLabel;
@property NSUInteger score;
@property NSUInteger escapedAndroids;
@property NSUInteger waitingTime;
@property NSTimeInterval startTime;
@property (getter = isGameStarted) BOOL gameStarted;

@property double currentAccelX;

@property (nonatomic) SKLabelNode *pauseLabel;
@property (nonatomic, getter = isGamePaused) BOOL gamePaused;

@end

@implementation SIGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _motionManager = [[CMMotionManager alloc] init];
        _spaceship = [[SISpaceship alloc] initWithImageNamed:@"Spaceship32.png"];
        _monsterTexture = [SKTexture textureWithImageNamed:@"Monster32.png"];
        _rocketTexture = [SKTexture textureWithImageNamed:@"Rocket32.png"];
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Thin"];
        _escapedLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Thin"];
        _waitingTime = 3;
        _countDownLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Thin"];
        _gameStarted = NO;
        _pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Thin"];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [self setupDisplay];
    [self configurePhysics];
    [self setupMotionManager];
    [self beginCountDown];
}

- (void)beginCountDown {
    __weak SIGameScene *weakSelf = self;
    SKAction *delay = [SKAction waitForDuration:1];
    SKAction *countdown = [SKAction runBlock:^{
        SIGameScene *gameScene = weakSelf;
        gameScene.countDownLabel.text = [NSString stringWithFormat:@"%d", gameScene.waitingTime];
        gameScene.waitingTime--;
    }];
    SKAction *countDownSequence = [SKAction sequence:@[countdown, delay]];
    SKAction *repeat = [SKAction repeatAction:countDownSequence count:self.waitingTime];
    
    SKAction *complete = [SKAction runBlock:^{
        SIGameScene *gameScene = weakSelf;
        gameScene.gameStarted = YES;
        gameScene.countDownLabel.hidden = YES;
    }];
    [self.countDownLabel runAction:[SKAction sequence:@[repeat, complete]]];
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
    
    self.countDownLabel.fontSize = 24;
    self.countDownLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*0.75);
    self.countDownLabel.fontColor = [SKColor blueColor ];
    self.countDownLabel.name = @"countDown";
    self.countDownLabel.zPosition = 100;

    self.pauseLabel.text = @"Paused";
    self.pauseLabel.fontSize = 36;
    self.pauseLabel.fontColor = [SKColor blackColor];
    self.pauseLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.pauseLabel.zPosition = 100;
    
    [self addChild:self.scoreLabel];
    [self addChild:self.escapedLabel];
    [self addChild:self.countDownLabel];
}

-(void)setupMotionManager {
    self.motionManager.accelerometerUpdateInterval = 0.1;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
        if(!error) {
            [self processAccelerationData:accelerometerData.acceleration];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

-(void)processAccelerationData:(CMAcceleration)acceleration {
    self.currentAccelX = acceleration.x;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKSpriteNode *rocket = [SKSpriteNode spriteNodeWithTexture:self.rocketTexture];
    rocket.position = CGPointMake(self.spaceship.position.x, self.spaceship.position.y + self.spaceship.size.height);
    
    [self addChild:rocket];
    
    CGFloat moveDuration = self.size.width / kVelocity;
    
    CGPoint rocketDest = CGPointMake(rocket.position.x, kRocketRange);
    
    SKAction *actionMove = [SKAction moveTo:rocketDest duration:moveDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [rocket runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    [SIGameScene prepareCollisionForRocket:rocket];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (self.isGameStarted && !self.isGamePaused) {
        self.startTime = currentTime;
        NSTimeInterval timeSinceLastUpdate = currentTime - self.timeLastUpdate;
        if(timeSinceLastUpdate > 1) {
            timeSinceLastUpdate = 1.0/60;
        }
        self.timeLastUpdate = currentTime;
        
        [self addAndroid:timeSinceLastUpdate];
        [self movement];
    }
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

-(void)addToScore:(NSUInteger)points {
    self.score += points;
    self.scoreLabel.text = [NSString stringWithFormat: @"Androids Destroyed: %d", self.score];
}

-(void)addToEscaped:(NSUInteger)badpoints {
    self.escapedAndroids += badpoints;
    self.escapedLabel.text = [NSString stringWithFormat: @"Androids Escaped: %d", self.escapedAndroids];
    if(self.escapedAndroids >= 3) {
        [self gameOver];
    }
}

- (void)pause {
    self.paused = true;
    self.gamePaused = true;
    
    [self addChild:self.pauseLabel];
}

- (void)resume {
    self.paused = false;
    self.gamePaused = false;
    
    [self.pauseLabel removeFromParent];
}

-(void)gameOver {
    SIScoreManager *scoreManager = [SIScoreManager sharedManager];
    [scoreManager addScoreToLeaderboard:self.score];
    NSLog(@"Most Recent Score: %d", scoreManager.mostRecentScore);
    NSLog(@"High Score: %d", scoreManager.highscore);
    self.gameStarted = NO;
    self.paused = YES;
    [self.viewController performSegueWithIdentifier:@"gameOverSegue" sender:nil];
}

-(void)movement {
    float maxX = self.frame.size.width - self.spaceship.size.width/2;
    float minX = self.spaceship.size.width/2;
    
    float newX = self.currentAccelX * 20;
    newX = MIN(MAX(newX + self.spaceship.position.x, minX), maxX);
    self.spaceship.position = CGPointMake(newX, self.spaceship.position.y);
}

@end
