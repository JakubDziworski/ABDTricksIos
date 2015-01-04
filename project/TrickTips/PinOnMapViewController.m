//
//  PinOnMapViewController.m
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "PinOnMapViewController.h"
#import "SubmitTrickViewController.h"

@interface PinOnMapViewController ()

@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
@end

@implementation PinOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    [self.mapView addGestureRecognizer:self.lpgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
MKPointAnnotation *currannotation;
- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    if([currannotation.title isEqualToString:@"Create New Spot Here"]){
        [self.mapView removeAnnotation:currannotation];
    }
    CGPoint touchPoint = [gesture locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    currannotation = point;
    point.coordinate = location;
    point.title = @"Create New Spot Here";
    [self.mapView addAnnotation:point];
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if(annotation != currannotation){
        return [super mapView:mapView viewForAnnotation:annotation];
    }
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    customPinView.animatesDrop = YES;
    return customPinView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([currannotation.title isEqualToString:@"Create New Spot Here"]){
        [self.mapView removeAnnotation:currannotation];
    }
    currannotation = view.annotation;
}
- (IBAction)onAcceptButtonClicked:(id)sender
{
    if( currannotation ) {
        [self.navigationController popViewControllerAnimated:YES];
        SubmitTrickViewController* tricksubmitter = (SubmitTrickViewController*)self.navigationController.viewControllers.lastObject;
        SkateSpot *skatespot = [self getSpotForAnnotation:currannotation];
        if(!skatespot){
            skatespot = [[SkateSpot alloc]init];
            skatespot.location = currannotation.coordinate;
        }
        [tricksubmitter onReceviedLocationWithSkateSpot:skatespot];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No skate spot location set" message:@"Put a pin on a map (long press)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
