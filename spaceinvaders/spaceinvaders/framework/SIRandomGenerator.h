//
//  SIRandomGenerator.h
//  spaceinvaders
//
//  Created by Henry Chung on 4/17/14.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIRandomGenerator : NSObject

+ (NSInteger)randomIntegerFrom:(NSInteger)lower to:(NSInteger)upper;
+ (NSTimeInterval)randomTimeIntervalFrom:(NSTimeInterval)lower to:(NSTimeInterval)upper;
@end
