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
    self.titleItem.title = self.spot.name;
}
- (void) onFetchedTrick:(Trick *)trick
{
    if(trick.skateSpot != self.spot) return;
    [self.tableData addObject:trick];
    [self.tableView reloadData];
}
- (void) onFetched:(NSArray *)trickList {
    if(self.tableData.count == 0) {
        for(Trick *trick in trickList) {
            if(trick.skateSpot == self.spot) {
                [self.tableData addObject:trick];
            }
        }
        [self.tableView reloadData];
    }
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
