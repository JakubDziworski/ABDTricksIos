//
//  HistoryTableViewController.h
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrickDataBaseManager.h"

@interface HistoryTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource,TrickDataBaseDelegate>

@property (strong,nonatomic) NSMutableArray *tableData;
-(void) populateData;
@end
