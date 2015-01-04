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

@interface SpotAnnotationMap : NSObject

@property (strong) NSMutableArray *spotsArr;
@property (strong) NSMutableArray *anntArr;
-(SkateSpot*) spotForAnnotation: (MKPointAnnotation*)mkAnn;
-(MKPointAnnotation*) annotationForSpot: (SkateSpot*)spt;
-(void) addSkateSpot: (SkateSpot*)spt andAdnot:(MKPointAnnotation*)mkPtAnot;
@end

@implementation SpotAnnotationMap
-(void) addSkateSpot: (SkateSpot*)spt andAdnot:(MKPointAnnotation*)mkPtAnot {
    [self.spotsArr addObject:spt];
    [self.anntArr addObject:mkPtAnot];
}
-(SkateSpot*) spotForAnnotation: (MKPointAnnotation*)mkAnn {
    NSUInteger i =0;
    for (MKPointAnnotation* ann in self.anntArr) {
        if(ann == mkAnn) return [self.spotsArr objectAtIndex:i];
        i++;
    }
    return nil;
}
-(MKPointAnnotation*) annotationForSpot: (SkateSpot*)sptt {
    NSUInteger i =0;
    for (SkateSpot* spt in self.spotsArr) {
        if(spt == sptt) return [self.anntArr objectAtIndex:i];
        i++;
    }
  return nil;
}

-(id) init {
    if(self = [super init])
    {
        self.spotsArr = [[NSMutableArray alloc] init];
        self.anntArr = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

@end
@interface ABDsOnMapViewController ()

@property SkateSpot* focusedSpot;
@property (strong)SpotAnnotationMap* spotzz;
@end

@implementation ABDsOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spotzz = [[SpotAnnotationMap alloc]init];
    self.mapView.delegate=self;
    [[TrickDataBaseManager sharedInstance] fetchLatestWithTarget:self];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void) onFetched:(NSArray *)trickList {
    NSMutableArray *trickzs = [[NSMutableArray alloc] init];
    [trickzs addObjectsFromArray:trickList];
    id spots = [trickzs valueForKeyPath:@"@distinctUnionOfObjects.skateSpot"];
    for(SkateSpot *spot in spots) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = spot.location;
        point.title = spot.name;
        [self.spotzz addSkateSpot:spot andAdnot:point];
        [self.mapView addAnnotation:point];
    }
    if(self.focusedSpot) [self executeFocusingOnSpot];
}
- (void) onFetchedTrick:(Trick *)trick {

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
    recentTrickVC.spot =[self.spotzz spotForAnnotation:view.annotation];
    [self.navigationController pushViewController:recentTrickVC animated:YES];
}

- (void) focusOnSpot:(SkateSpot *)skateSpot {
    self.focusedSpot = skateSpot;
}

-(void) executeFocusingOnSpot {
    MKPointAnnotation *annotation = [self.spotzz annotationForSpot:self.focusedSpot];
    MKMapPoint pt = MKMapPointForCoordinate(annotation.coordinate);
    MKMapRect r= MKMapRectMake(pt.x-500, pt.y-500, 1000,1000);
    [self.mapView setVisibleMapRect:r animated:YES];
    [self.mapView selectAnnotation:annotation animated:YES];
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
