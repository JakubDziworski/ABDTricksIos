//
//  TutorialContentViewController.h
//  TrickTips
//
//  Created by Kuba on 05/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController <UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@property BOOL isLast;
- (IBAction)onStartBtnclicked:(id)sender;
@end
