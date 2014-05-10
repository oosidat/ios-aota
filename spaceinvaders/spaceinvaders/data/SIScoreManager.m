//
//  SIScoreManager.m
//  spaceinvaders
//
//  Created by Henry Chung on 2014-05-07.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIScoreManager.h"

#define kScoreFilename @"scores.dat"
#define kMaximumNumberOfScores 5

@interface SIScoreManager()

@property (nonatomic) NSUInteger mostRecentScore;
@property (nonatomic) NSMutableArray *scores;
@property (nonatomic) BOOL dirty;

@end

@implementation SIScoreManager

+ (instancetype)sharedManager {
    static SIScoreManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SIScoreManager alloc] initPrivate];
    });
    return sharedManager;
}

- (id)init {
    NSAssert(NO, @"Call into the singleton!");
    return nil;
}

- (instancetype)initPrivate {
    if(self = [super init]) {
        _scores = [SIScoreManager loadScoreFromFile];
    }
    return self;
}

+ (NSMutableArray *)loadScoreFromFile {
    NSString *path = [SIScoreManager pathForFile];
    NSMutableArray *scores = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] mutableCopy];
    return scores ? scores : [NSMutableArray array];
}

+ (NSString *)pathForFile {
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *path = [url.path stringByAppendingPathComponent:kScoreFilename];
    return path;
}

- (NSUInteger)highscore {
    return [[self.scores firstObject] unsignedIntegerValue];
}

- (NSArray *)leaderboard {
    return self.scores;
}

- (void)addScoreToLeaderboard:(NSUInteger)score {
    [self insertScore:score intoSortedArray:self.scores];
    self.mostRecentScore = score;
    
    if(self.dirty) {
        NSString *path = [SIScoreManager pathForFile];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.scores];
        [data writeToFile:path atomically:YES];
        self.dirty = NO;
    }
}

- (void)insertScore:(NSUInteger)score intoSortedArray:(NSMutableArray *)array {
    NSUInteger indexToInsert = [array count];
    for(int i = 0; i < [array count]; i++) {
        if(score <= [array[i] unsignedIntegerValue]) {
            continue;
        }
        indexToInsert = i;
        break;
    }
    
    if(indexToInsert >= kMaximumNumberOfScores) {
        return;
    }
    
    [array insertObject:[NSNumber numberWithUnsignedInteger:score] atIndex:indexToInsert];
    if([array count] >= kMaximumNumberOfScores) {
        [array removeLastObject];
    }
    self.dirty = YES;
}

@end
