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
#import "Reachability.h"
@interface TrickDataBaseManager()
@property(strong) NSMutableArray *latestTricks;
@property NSString *localStorageFilePath;
@end

@implementation TrickDataBaseManager

+ (TrickDataBaseManager *)sharedInstance {
    static TrickDataBaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrickDataBaseManager alloc] init];
        sharedInstance.isCloudReachable = NO;
        sharedInstance.latestTricks = [[NSMutableArray alloc]init];
    });
    return sharedInstance;
}

- (void) fetchWithTarget: (id<TrickDataBaseDelegate>)target {
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.parse.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchOnlineWithTarget:target];
            self.isCloudReachable = YES;
            NSLog(@"REACHABLE!");
        });
    };
    reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchFromLocalStorageWithTarget:target];
            self.isCloudReachable = NO;
            NSLog(@"UNREACHABLE!");
        });
        
    };
    [reach startNotifier];
}

- (void) prepareLocalStorage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"ABDTricksArchive"];
    self.localStorageFilePath = [cacheDirectory stringByAppendingPathComponent:@"StoredTricks.data"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.localStorageFilePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
- (void) fetchFromLocalStorageWithTarget: (id<TrickDataBaseDelegate>)target {
    [self prepareLocalStorage];
     self.latestTricks = [NSKeyedUnarchiver unarchiveObjectWithFile:self.localStorageFilePath];
    [self fixDuplicatedSpots:self.latestTricks];
    [target onFetched:self.latestTricks];
}
- (BOOL) saveToLocalStorage {
    [self prepareLocalStorage];
   return [NSKeyedArchiver archiveRootObject:self.latestTricks toFile:self.localStorageFilePath];
}
- (void) fetchOnlineWithTarget: (id<TrickDataBaseDelegate>)target {
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
            [self saveToLocalStorage];
            NSLog(@"Finished fetching %d tricks",[query countObjects]);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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

-(void) fixDuplicatedSpots: (NSArray*)array {
    for(Trick *trick in array) {
        for(SkateSpot* spot in [array valueForKeyPath:@"@distinctUnionOfObjects.skateSpot"]) {
            if([spot.parseId isEqualToString:trick.skateSpot.parseId]) {
                trick.skateSpot = spot;
            }
        }
    }
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
@end
