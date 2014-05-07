//
//  SIGameOverVC.m
//  spaceinvaders
//
//  Created by Henry Chung on 2014-05-07.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIGameOverVC.h"

@implementation SIGameOverVC

- (IBAction)playAgainAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
