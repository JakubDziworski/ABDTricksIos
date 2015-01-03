//
//  TrickDetailTableViewController.m
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "TrickDetailTableViewController.h"
#import "Trick.h"
@interface TrickDetailTableViewController ()

@end

@implementation TrickDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.trickNameTextField.text = self.trick.name;
    self.pertformerTextField.text = self.trick.performer;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)seeOnMapButtonClicked:(id)sender {
}
@end
