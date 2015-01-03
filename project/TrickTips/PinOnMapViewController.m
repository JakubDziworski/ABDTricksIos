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

@property CLLocationCoordinate2D location;
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
@end

@implementation PinOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _location = kCLLocationCoordinate2DInvalid;
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    [self.mapview addGestureRecognizer:self.lpgr];
    self.mapview.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    [self.mapview removeAnnotations:self.mapview.annotations];
    CGPoint touchPoint = [gesture locationInView:self.mapview];
    _location = [self.mapview convertPoint:touchPoint toCoordinateFromView:self.mapview];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = _location;
    point.title = @"Sample title";
    
    [self.mapview addAnnotation:point];
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    customPinView.animatesDrop = YES;
    return customPinView;
}

- (IBAction)onAcceptButtonClicked:(id)sender
{
    
    if( CLLocationCoordinate2DIsValid(_location) ) {
        [self.navigationController popViewControllerAnimated:YES];
        SubmitTrickViewController* tricksubmitter = (SubmitTrickViewController*)self.navigationController.viewControllers.lastObject;
        [tricksubmitter onReceviedLocation:_location];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No skate spot location set" message:@"Put a pin on a map (long press)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

    
    
//    test2AfterLogging *afterLoginController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"test2AfterLogging"];
//    [afterLoginController setLogin:self.loginTextField.text];
//    [self.navigationController pushViewController:afterLoginController animated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
