//
//  TutorialContentViewController.m
//  TrickTips
//
//  Created by Kuba on 05/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "TutorialContentViewController.h"

@interface TutorialContentViewController ()

@end
@implementation TutorialContentViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![self.imageFile isEqualToString:@""]) {
        self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    }
    self.titleLabel.text = self.titleText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStartBtnclicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    UITabBarController *firstPage = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTapBar"];
    [self presentViewController:firstPage animated:YES completion:nil];
}
@end
