//
//  TutorialRootViewController.h
//  TrickTips
//
//  Created by Kuba on 05/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialRootViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
