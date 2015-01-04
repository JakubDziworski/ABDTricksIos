//
//  ABDsOnMapViewController.h
//  TrickTips
//
//  Created by Kuba on 04/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkateSpot.h"
#import <MapKit/MapKit.h>

@interface ABDsOnMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (void) focusOnSpot:(SkateSpot *)skateSpot;

@end
