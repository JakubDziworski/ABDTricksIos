//
//  Trick.h
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkateSpot;
@interface Trick : NSObject

@property NSString *name;
@property NSString *performer;
@property NSString  *submitter;
@property NSString *whereToSee;
@property NSString *additonalInfo;
@property NSDate *date;
@property SkateSpot* skateSpot;

-(id) initWithName:(NSString *)name_
         performer:(NSString *)performer_
         submitter:(NSString *)submitter_
       whereTosSee:(NSString *)whereToSee_
    additionalInfo:(NSString *)additionalInfo
              date:(NSDate *)date_
         skateSpot:(SkateSpot *)skatespot_;

@end
