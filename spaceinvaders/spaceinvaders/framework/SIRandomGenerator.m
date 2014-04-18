//
//  SIRandomGenerator.m
//  spaceinvaders
//
//  Created by Henry Chung on 4/17/14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIRandomGenerator.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation SIRandomGenerator

+ (NSInteger)randomIntegerFrom:(NSInteger)lower to:(NSInteger)upper {
    NSAssert(lower < upper, @"Seriously?");
    NSInteger range = upper - lower;
    return (arc4random() % range) + lower + 1;
}

+ (NSTimeInterval)randomTimeIntervalFrom:(NSTimeInterval)lower to:(NSTimeInterval)upper {
    NSAssert(lower < upper, @"Seriously?");
    return ((NSTimeInterval)arc4random() / ARC4RANDOM_MAX) * (upper - lower) + lower;
}

@end
