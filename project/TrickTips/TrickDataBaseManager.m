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

@implementation TrickDataBaseManager

@synthesize tricks = _tricks;
+ (TrickDataBaseManager *)sharedInstance {
    static TrickDataBaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrickDataBaseManager alloc] init];
    });
    return sharedInstance;
}

- (void) fetchData {
    NSUInteger limit = 100;
    __block NSUInteger skip = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"Trick"];
    [query orderByDescending:@"createdAt"];
    [query setSkip: skip];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            for(PFObject *obj in objects){
                [self convertPFObjectToTrick:obj];
            }
            if (objects.count == limit) {
                // There might be more objects in the table. Update the skip value and execute the query again.
                skip += limit;
                [query setSkip: skip];
                [query findObjectsInBackgroundWithBlock:nil];
                 }
                 
                 } else {
                     // Log details of the failure
                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                 }
                 }];
}
- (void) convertPFObjectToTrick: (PFObject* )pfTrick {
    SkateSpot *spot = [[SkateSpot alloc]init];
    PFObject *pfSpot = [pfTrick objectForKey:@"skateSpot"];
    [pfSpot fetchIfNeededInBackgroundWithBlock:^(PFObject *pSpot, NSError *error) {
        Trick *trick = [[Trick alloc] init];
        spot.name = [pSpot objectForKey:@"name"];
        PFGeoPoint *location = [pSpot objectForKey:@"location"];
        spot.location = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude].coordinate;
        trick.name = [pfTrick objectForKey:@"name"];
        trick.performer = [pfTrick objectForKey:@"performer"];
        trick.whereToSee = [pfTrick objectForKey:@"whereToSee"];
        trick.additonalInfo = [pfTrick objectForKey:@"additionalInfo"];
        trick.skateSpot = spot;
        trick.dateAdded = pfTrick.createdAt;
        [self onFetchedTrick:trick];
    }];
}

- (void) onFetchedTrick: (Trick *)trick {
    [self.tricks addObject:trick];
}

- (PFObject *) convertTrickToPfObject: (Trick *) trick {
    PFObject *pfSkateSpot = [PFObject objectWithClassName:@"SkateSpot"];
    PFObject *pfTrick = [PFObject objectWithClassName:@"Trick"];
    pfSkateSpot[@"name"] = trick.skateSpot.name;
    pfSkateSpot[@"location"] = [PFGeoPoint geoPointWithLatitude:trick.skateSpot.location.latitude longitude:trick.skateSpot.location.longitude];
    pfTrick[@"name"] = trick.name;
    pfTrick[@"performer"] = trick.performer;
    pfTrick[@"whereToSee"] = trick.whereToSee;
    pfTrick[@"additionalInfo"] = trick.additonalInfo;
    pfTrick[@"skateSpot"] = pfSkateSpot;
    return pfTrick;
}
- (void) addTrick:(Trick *)trick_ {
    [_tricks addObject:trick_];
    PFObject *obj = [self convertTrickToPfObject:trick_];
    [obj saveInBackground];
}
-(id) init
{
    if(self = [super init])
    {
        _tricks = [[NSMutableArray alloc]init];
        [self fetchData];
        return self;
    }
    return nil;
}

@end
