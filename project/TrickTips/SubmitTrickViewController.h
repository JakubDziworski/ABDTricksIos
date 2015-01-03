//
//  SubmitTrickViewController.h
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "ViewController.h"
#import "AutocompletedTextField.h"
@interface SubmitTrickViewController : UITableViewController  <UITextViewDelegate,AutocompletedTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *trickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *performerNameTextField;
@property (weak, nonatomic) IBOutlet AutocompletedTextField *spotNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *wherePublishedTextField;
@property (weak, nonatomic) IBOutlet UITextField *additionalInfoTextField;
- (IBAction)onSubmitButtonClicked:(id)sender;

@end

