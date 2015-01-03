//
//  TrickDataBaseManager.h
//  TrickTips
//
//  Created by Kuba on 03/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Trick;
@class SkateSpot;

@interface TrickDataBaseManager : NSObject {
    NSMutableArray *_tricks;
}

@property (strong,nonatomic,readonly) NSMutableArray* tricks;

+ (TrickDataBaseManager *)sharedInstance;
- (void) addTrick:(Trick *) trick_;
//- (void) addSpot:(SkateSpot *) spot_;
@end
