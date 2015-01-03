//
//  PinOnMapViewController.h
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface PinOnMapViewController : UIViewController <MKMapViewDelegate,MKAnnotation>
- (IBAction)onAcceptButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@end
