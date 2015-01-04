//
//  TrickDataBaseManager.h
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class Trick;

@protocol TrickDataBaseDelegate <NSObject>
@optional
- (void) onFetched:(NSArray *)trickList;
- (void) onFetchedTrick:(Trick *)trick;
@end

@interface TrickDataBaseManager : NSObject

+ (TrickDataBaseManager *)sharedInstance;
- (void) addTrick:(Trick *) trick_;
- (void) fetchLatestSpotsWithTarget:(id<TrickDataBaseDelegate>)target;
- (void) fetchLatestWithTarget: (id<TrickDataBaseDelegate>)target;
- (void) fetchClosestToPoint: (CLLocationCoordinate2D)location andTarget:(id<TrickDataBaseDelegate>)target;
//- (void) addSpot:(SkateSpot *) spot_;
@end
