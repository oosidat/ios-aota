//
//  SIGameOverVC.m
//  spaceinvaders
//
//  Created by Henry Chung on 2014-05-07.
//  Copyright (c) 2014 OsamaSidat-HenryChung. All rights reserved.
//

#import "SIGameOverVC.h"
#import "SIScoreManager.h"

@interface SIGameOverVC()
@property (nonatomic, retain) IBOutlet UILabel *currentScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *highScoreLabel;
@end

@implementation SIGameOverVC

- (IBAction)playAgainAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    SIScoreManager *scoreManager = [SIScoreManager sharedManager];
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", scoreManager.mostRecentScore];
    self.highScoreLabel.text = [NSString stringWithFormat:@"%d", scoreManager.highscore];
}

@end
