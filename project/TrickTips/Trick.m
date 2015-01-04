//
//  Trick.m
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "Trick.h"
#import "SkateSpot.h"

@implementation Trick

-(id) initWithName:(NSString *)name_
         performer:(NSString *)performer_
         submitter:(NSString *)submitter_
       whereTosSee:(NSString *)whereToSee_
    additionalInfo:(NSString *)additionalInfo
              date:(NSDate *)date_
         skateSpot:(SkateSpot *)skatespot_
{
    if(self = [super init])
    {
        self.name = name_;
        self.performer = performer_;
        self.submitter = submitter_;
        self.whereToSee = whereToSee_;
        self.additonalInfo = additionalInfo;
        self.date = date_;
        self.skateSpot = skatespot_;
        return self;
    }
    return nil;
}

@end
