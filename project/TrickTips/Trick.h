//
//  Trick.h
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkateSpot.h"

@interface Trick : NSObject <NSCoding>

@property NSString *name;
@property NSString *performer;
@property NSString *whereToSee;
@property NSString *additonalInfo;
@property NSDate *dateAdded;
@property NSString *parseID;
@property SkateSpot* skateSpot;

-(id) initWithName:(NSString *)name_
         performer:(NSString *)performer_
       whereTosSee:(NSString *)whereToSee_
    additionalInfo:(NSString *)additionalInfo
         skateSpot:(SkateSpot *)skatespot_;

@end
