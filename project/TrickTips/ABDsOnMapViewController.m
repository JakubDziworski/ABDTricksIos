//
//  ABDsOnMapViewController.m
//  TrickTips
//
//  Created by Kuba on 04/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//
#import "TrickDataBaseManager.h"
#import "RecentTricksOnSpotViewController.h"
#import "ABDsOnMapViewController.h"

@interface ABDsOnMapViewController ()

@property NSMutableDictionary* buttonSpotDict;
@end

@implementation ABDsOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonSpotDict = [[NSMutableDictionary alloc]init];
    self.mapView.delegate=self;

    [self preparePins];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) preparePins {
    NSArray *tricks = [TrickDataBaseManager sharedInstance].tricks;
    NSArray *spots = [tricks valueForKeyPath:@"@distinctUnionOfObjects.skateSpot"];
    for(SkateSpot *spot in spots) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = spot.location;
        point.title = spot.name;
        [self.buttonSpotDict setObject:spot forKey:spot.name];
        [self.mapView addAnnotation:point];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) return nil;
      MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        UIButton*accessory = [UIButton buttonWithType:UIButtonTypeInfoLight];
        //[accessory addTarget:self action:@selector(openDetail:) forControlEvents:UIControlEventTouchUpInside];
        [accessory setFrame:CGRectMake(0, 0, 30, 30)];
        [annView setRightCalloutAccessoryView:accessory];
   [annView setEnabled:YES];
    [annView setCanShowCallout:YES];
    return annView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    RecentTricksOnSpotViewController *recentTrickVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecentTricksOnSpotViewController"];
    recentTrickVC.spot =[self.buttonSpotDict objectForKey: view.annotation.title];
    [self.navigationController pushViewController:recentTrickVC animated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)openDetail:(id)sender {
  
}
- (void) focusOnSpot:(SkateSpot *)skateSpot {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
