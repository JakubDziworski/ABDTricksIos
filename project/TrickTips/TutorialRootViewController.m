//
//  TutorialRootViewController.m
//  TrickTips
//
//  Created by Kuba on 05/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "TutorialRootViewController.h"
#import "TutorialContentViewController.h"

@interface TutorialRootViewController ()

@end

@implementation TutorialRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageTitles = @[@"", @"Browse recent Tricks", @"Submit your own Tricks",@"Check out spot map", @"Read ABDs details ",@""];
    _pageImages = @[@"",@"recent", @"submit", @"witos",@"detail",@""];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(!completed) return;
    TutorialContentViewController *currentView = [pageViewController.viewControllers objectAtIndex:0];
    TutorialContentViewController *prevView = [previousViewControllers objectAtIndex:0];
    
    UILabel *prevAnimatedText = prevView.titleLabel;
    prevAnimatedText.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    UIImageView *prevImgView = prevView.backgroundImageView;
    prevImgView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    UIImageView *imgView = currentView.backgroundImageView;
    [self animIn:imgView];
    
    UILabel *animatedTextField = currentView.titleLabel;
    [self animIn:animatedTextField];
    
    if(currentView.isLast){
        UIButton *animatedButton = currentView.startBtn;
        if(!animatedButton.isHidden) return;
        [animatedButton setHidden:NO];
        [self animIn:animatedButton];
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) animIn:(UIView*)view {
    view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{view.transform = CGAffineTransformIdentity;} completion:nil];
}
- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    TutorialContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    if(index + 1 == [self.pageTitles count]) {
        pageContentViewController.isLast = YES;
    }
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
