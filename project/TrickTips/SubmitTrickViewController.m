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
@property CLLocationCoordinate2D location;
@property NSMutableArray *data;
@end

@implementation SubmitTrickViewController

- (void)generateData
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
        NSError* err = nil;
        self.data = [[NSMutableArray alloc] init];
        NSMutableArray *companyData = [[NSMutableArray alloc] init];
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"sample_data" ofType:@"json"];
        NSArray* contents = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[obj objectForKey:@"first_name"] stringByAppendingString:[NSString stringWithFormat:@" %@", [obj objectForKey:@"last_name"]]], @"DisplayText", [obj objectForKey:@"email"], @"DisplaySubText",obj,@"CustomObject", nil]];
                [companyData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"company_name"], @"DisplayText", [obj objectForKey:@"address"], @"DisplaySubText",obj,@"CustomObject", nil]];
            }];
        });
    });
}

- (NSArray *)dataForPopoverInTextField:(AutocompletedTextField *)textField
{
    NSDictionary *elem1 = [NSDictionary dictionaryWithObjectsAndKeys:@"someText",@"DisplayText", nil];
    return [[NSMutableArray alloc] initWithObjects:elem1, nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.location = kCLLocationCoordinate2DInvalid;
    [self generateData];
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
        SkateSpot *spot = [[SkateSpot alloc]initWithName:self.spotNameTextField.text location:self.location];
        Trick *trick = [[Trick alloc]init];
        trick.name = self.trickNameTextField.text;
        trick.performer = self.performerNameTextField.text;
        trick.whereToSee = self.wherePublishedTextField.text;
        trick.additonalInfo = self.additionalInfoTextField.text;
        trick.dateAdded = [NSDate date];
        trick.skateSpot = spot;
        [[TrickDataBaseManager sharedInstance] addTrick:trick];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you" message:@"Your Trick has been submitted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)onReceviedLocation:(CLLocationCoordinate2D) locationn {
    self.location = locationn;
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
    if(!CLLocationCoordinate2DIsValid(self.location)) {
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
