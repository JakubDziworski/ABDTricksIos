//
//  SubmitTrickViewController.m
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "SubmitTrickViewController.h"
#import "Trick.h"
#import "SkateSpot.h"
#import "TrickDataBaseManager.h"
#import <MapKit/MapKit.h>

@interface SubmitTrickViewController ()
@property SkateSpot *spot;
@property BOOL locationSet;
@end

@implementation SubmitTrickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationSet = NO;
    self.trickNameTextField.delegate = self;
    self.performerNameTextField.delegate = self;
    self.spotNameTextField.delegate = self;
    self.wherePublishedTextField.delegate = self;
    self.additionalInfoTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onSubmitButtonClicked:(id)sender {
    if([self verifyFields] == YES){
        //SkateSpot *spot = [[SkateSpot alloc]initWithName:self.spotNameTextField.text location:self.location];
        Trick *trick = [[Trick alloc]init];
        trick.name = self.trickNameTextField.text;
        trick.performer = self.performerNameTextField.text;
        trick.whereToSee = self.wherePublishedTextField.text;
        trick.additonalInfo = self.additionalInfoTextField.text;
        trick.dateAdded = [NSDate date];
        trick.skateSpot = self.spot;
        if(!trick.skateSpot.name) trick.skateSpot.name = self.spotNameTextField.text;
        [[TrickDataBaseManager sharedInstance] addTrick:trick];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you" message:@"Your Trick has been submitted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)onReceviedLocationWithSkateSpot:(SkateSpot*) skatespot {
    self.spot = skatespot;
    if(skatespot.name) {
        self.spotNameTextField.text = skatespot.name;
    }
    self.locationSet = YES;
    self.locationVerifiedImage.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{self.locationVerifiedImage.transform = CGAffineTransformIdentity;} completion:nil];
    self.locationVerifiedImage.alpha = 1;
}
- (BOOL) verifyFields {
    
    NSString *errorStr =  @"";
    BOOL result = YES;
    if ([self.trickNameTextField.text isEqualToString:@""]) {
        errorStr = [errorStr stringByAppendingString: @"Enter Trick Name"];
        result = NO;
    }
    if ([self.spotNameTextField.text isEqualToString:@""]) {
        errorStr = [errorStr stringByAppendingString: @"\nEnter Spot Name"];
        result = NO;
    }
    if ([self.performerNameTextField.text isEqualToString:@""]) {
        errorStr = [errorStr stringByAppendingString: @"\nEnter Who did the trick"];
        result = NO;
    }
    if(!self.locationSet) {
        errorStr = [errorStr stringByAppendingString: @"\nEnter spot location"];
        result = NO;
    }
    if(result == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete information" message:errorStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    return result;
}
@end
