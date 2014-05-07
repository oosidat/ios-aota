//
//  SIScoreManager.h
//  spaceinvaders
//
//  Created by Henry Chung on 2014-05-07.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIScoreManager : NSObject

@property (nonatomic, readonly) NSUInteger mostRecentScore;
@property (nonatomic, readonly) NSUInteger highscore;
@property (nonatomic, readonly) NSArray *leaderboard;

+ (instancetype)sharedManager;
- (void)addScoreToLeaderboard:(NSUInteger)score;

@end
