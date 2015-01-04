//
//  SubmitTrickViewController.h
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CLLocation.h>

@interface SubmitTrickViewController : UITableViewController  <UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *trickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *performerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *spotNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *wherePublishedTextField;
@property (weak, nonatomic) IBOutlet UITextField *additionalInfoTextField;
@property (weak, nonatomic) IBOutlet UIImageView *locationVerifiedImage;
- (IBAction)onSubmitButtonClicked:(id)sender;
- (void)onReceviedLocation:(CLLocationCoordinate2D) locationn;

@end

