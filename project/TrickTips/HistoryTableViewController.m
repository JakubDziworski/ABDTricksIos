//
//  HistoryTableViewController.m
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "TrickDetailTableViewController.h"
#import "TrickDataBaseManager.h"
#import "Trick.h"
#import <Foundation/Foundation.h>
#import "NSDate+TimeAgo.h"

@interface HistoryTableViewController ()
@property UIActivityIndicatorView *activityView;
@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.tableData) {
        self.tableData = [[NSMutableArray alloc] init];
        [self populateData];
    }
}
-(void) populateData {
    [[TrickDataBaseManager sharedInstance] fetchLatestWithTarget:self];
}
- (void) onFetchedTrick:(Trick *)trick
{
    [self.tableData addObject:trick];
    [self.tableView reloadData];
}
- (void) onFetched:(NSArray *)trickList {
    if(self.tableData.count == 0) {
        [self.tableData addObjectsFromArray:trickList];
        [self.tableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(self.tableData.count == 0 ){
        if(self.activityView == nil){
            self.activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.activityView.center= CGPointMake(self.view.center.x,self.view.center.y-self.view.bounds.size.height/2.0+25);
            [self.activityView startAnimating];
            [self.view addSubview:self.activityView];
        }
    }
    else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             CGRect frame = self.activityView.frame;
             frame.origin.x = (-100);
             self.activityView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
       
    }
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trickItems" ];
    
    UILabel *postContent = (UILabel *)[cell viewWithTag:1];
    UILabel *postTime = (UILabel *)[cell viewWithTag:2];

    Trick *trick = (Trick*)[self.tableData objectAtIndex:indexPath.row];
    
    postTime.text = [trick.dateAdded timeAgo];
    postContent.text = [NSString stringWithFormat:@"'%@' did '%@'" ,trick.performer,trick.name];
    return cell;
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TrickDetailTableViewController *trickDetailView = (TrickDetailTableViewController*)[segue destinationViewController];
    Trick *trick = (Trick*)[self.tableData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    trickDetailView.trick = trick;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
*/

@end
