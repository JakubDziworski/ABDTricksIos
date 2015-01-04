//
//  TrickDataBaseManager.m
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "TrickDataBaseManager.h"
#import "Trick.h"
#import <Parse/Parse.h>
@interface TrickDataBaseManager()
@property(strong) NSMutableArray *latestTricks;
@end

@implementation TrickDataBaseManager

+ (TrickDataBaseManager *)sharedInstance {
    static TrickDataBaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrickDataBaseManager alloc] init];
        sharedInstance.latestTricks = [[NSMutableArray alloc]init];
    });
    return sharedInstance;
}
- (void) fetchLatestSpotsWithTarget:(id<TrickDataBaseDelegate>)target {
    if(self.latestTricks.count > 0){
        [target onFetched:[self.latestTricks valueForKeyPath:@"@distinctUnionOfObjects.skateSpot"]];
    }
}
- (void) fetchLatestWithTarget: (id<TrickDataBaseDelegate>)target {
    if(self.latestTricks.count > 0) {
        [target onFetched:self.latestTricks];
        return;
    }
    NSUInteger limit = 25;
    PFQuery *query = [PFQuery queryWithClassName:@"Trick"];
    query.limit = limit;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(PFObject *obj in objects){
                Trick *trick = [self convertPFObjectToTrick:obj];
                [self.latestTricks addObject:trick];
                [target onFetchedTrick:trick];
            }
            [target onFetched:self.latestTricks];
            NSLog(@"Finished fetching %d tricks",[query countObjects]);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void) fetchClosestToPoint: (CLLocationCoordinate2D)location andTarget:(id<TrickDataBaseDelegate>)target{
    //TO DO
    [self fetchLatestWithTarget:target];
}

- (Trick*) convertPFObjectToTrick: (PFObject* )pfTrick {
    Trick *trick = [[Trick alloc] init];
    trick.name = [pfTrick objectForKey:@"name"];
    trick.performer = [pfTrick objectForKey:@"performer"];
    trick.whereToSee = [pfTrick objectForKey:@"whereToSee"];
    trick.additonalInfo = [pfTrick objectForKey:@"additionalInfo"];
    trick.dateAdded = pfTrick.createdAt;
    trick.parseID = [pfTrick objectId];
    PFObject *pfSpot = [pfTrick objectForKey:@"skateSpot"];
    for(SkateSpot* spot in [self.latestTricks valueForKeyPath:@"@distinctUnionOfObjects.skateSpot"]) {
        if([spot.parseId isEqualToString:[pfSpot objectId]]) {
            trick.skateSpot = spot;
            return trick;
        }
    }
    SkateSpot *spot = [[SkateSpot alloc]init];
    [pfSpot fetchIfNeeded];
    spot.name = [pfSpot objectForKey:@"name"];
    spot.parseId = [pfSpot objectId];
    PFGeoPoint *location = [pfSpot objectForKey:@"location"];
    spot.location = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude].coordinate;
    trick.skateSpot = spot;
    return trick;
}

- (PFObject *) convertTrickToPfObject: (Trick *) trick {
    PFObject *pfTrick = [PFObject objectWithClassName:@"Trick"];
    if(trick.skateSpot.parseId){
        pfTrick[@"skateSpot"] = [PFObject objectWithoutDataWithClassName:@"SkateSpot" objectId:trick.skateSpot.parseId];
    }
    else {
        PFObject *pfSkateSpot = [PFObject objectWithClassName:@"SkateSpot"];
        pfSkateSpot[@"name"] = trick.skateSpot.name;
        pfSkateSpot[@"location"] = [PFGeoPoint geoPointWithLatitude:trick.skateSpot.location.latitude longitude:trick.skateSpot.location.longitude];
        pfTrick[@"skateSpot"] = pfSkateSpot;
    }
    pfTrick[@"name"] = trick.name;
    pfTrick[@"performer"] = trick.performer;
    pfTrick[@"whereToSee"] = trick.whereToSee;
    pfTrick[@"additionalInfo"] = trick.additonalInfo;
    return pfTrick;
}
- (void) addTrick:(Trick *)trick_ {
    PFObject *obj = [self convertTrickToPfObject:trick_];
    [obj saveInBackground];
}
-(id) init
{
    if(self = [super init])
    {
        
        return self;
    }
    return nil;
}

@end
