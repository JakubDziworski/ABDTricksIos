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
                [_tricks addObject:  [self convertPFObjectToTrick:obj]];
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
- (Trick*) convertPFObjectToTrick: (PFObject* )pfobject {
    Trick *trick = [[Trick alloc] init];
    trick.name = [pfobject objectForKey:@"name"];
    trick.performer = [pfobject objectForKey:@"performer"];
    trick.dateAdded = pfobject.createdAt;
    return trick;
}
- (PFObject *) convertTrickToPfObject: (Trick *) trick {
    PFObject *pfobject = [PFObject objectWithClassName:@"Trick"];
    pfobject[@"name"]=trick.name;
    pfobject[@"performer"]=trick.performer;
    return pfobject;
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
