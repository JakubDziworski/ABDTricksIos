//
//  TrickDetailTableViewController.m
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "TrickDetailTableViewController.h"
#import "Trick.h"
#import "ABDsOnMapViewController.h"
@interface TrickDetailTableViewController ()

@end

@implementation TrickDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *dateString = [format stringFromDate:self.trick.dateAdded];
    
    self.dataAddedTextField.text = dateString;
    self.trickNameTextField.text = self.trick.name;
    self.pertformerTextField.text = self.trick.performer;
    self.spotNameTextField.text = self.trick.skateSpot.name;
    self.publishedTextField.text = self.trick.whereToSee;
    self.additionalInfoTextField.text = self.trick.additonalInfo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ABDsOnMapViewController *mapView = segue.destinationViewController;
    [mapView focusOnSpot:self.trick.skateSpot];
}
@end
