//
//  RecentTricksOnSpotViewController.h
//  TrickTips
//
//  Created by Kuba on 04/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "SkateSpot.h"
@interface RecentTricksOnSpotViewController : HistoryTableViewController
@property SkateSpot *spot;
@property NSMutableArray *tricksDoneOnSpot;
@end
