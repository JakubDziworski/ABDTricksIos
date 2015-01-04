//
//  RecentTricksOnSpotViewController.m
//  TrickTips
//
//  Created by Kuba on 04/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "RecentTricksOnSpotViewController.h"
#import "TrickDataBaseManager.h"
#import "Trick.h"
@interface RecentTricksOnSpotViewController ()

@end

@implementation RecentTricksOnSpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSArray*) populateData {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(Trick* trick in [TrickDataBaseManager sharedInstance].tricks) {
        if(trick.skateSpot != self.spot)
        {
            [arr addObject:trick];
        }
    }
    return arr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
