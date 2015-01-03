//
//  TrickDetailTableViewController.h
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Trick;
@interface TrickDetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *trickNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *pertformerTextField;
@property (weak, nonatomic) IBOutlet UILabel *spotNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *dataAddedTextField;
@property (weak, nonatomic) IBOutlet UILabel *publishedTextField;
@property (weak, nonatomic) IBOutlet UILabel *additionalInfoTextField;
@property (strong, nonatomic)  Trick *trick;
- (IBAction)seeOnMapButtonClicked:(id)sender;
@end
