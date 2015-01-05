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
       whereTosSee:(NSString *)whereToSee_
    additionalInfo:(NSString *)additionalInfo
         skateSpot:(SkateSpot *)skatespot_
{
    if(self = [super init])
    {
        self.name = name_;
        self.performer = performer_;
        self.whereToSee = whereToSee_;
        self.additonalInfo = additionalInfo;
        self.skateSpot = skatespot_;
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name    forKey:@"name"];
    [coder encodeObject:self.parseID    forKey:@"parseID"];
    [coder encodeObject:self.performer    forKey:@"performer"];
    [coder encodeObject:self.whereToSee    forKey:@"whereToSee"];
    [coder encodeObject:self.additonalInfo    forKey:@"additonalInfo"];
    [coder encodeObject:self.dateAdded    forKey:@"dateAdded"];
    [coder encodeObject:self.skateSpot.name    forKey:@"sktSpotName"];
    [coder encodeObject:self.skateSpot.parseId    forKey:@"sktSpotParseId"];
    [coder encodeDouble:self.skateSpot.location.latitude    forKey:@"sktSpotLatitude"];
    [coder encodeDouble:self.skateSpot.location.longitude    forKey:@"sktSpotLongitude"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.skateSpot = [[SkateSpot alloc] init];
    self.name = [coder decodeObjectForKey:@"name"];
    self.parseID = [coder decodeObjectForKey:@"parseID"];
    self.performer = [coder decodeObjectForKey:@"performer"];
    self.whereToSee = [coder decodeObjectForKey:@"whereToSee"];
    self.additonalInfo = [coder decodeObjectForKey:@"additonalInfo"];
    self.dateAdded = [coder decodeObjectForKey:@"dateAdded"];
    self.skateSpot.name = [coder decodeObjectForKey:@"sktSpotName"];
    self.skateSpot.parseId = [coder decodeObjectForKey:@"sktSpotParseId"];
    self.skateSpot.location = CLLocationCoordinate2DMake([coder decodeDoubleForKey:@"sktSpotLatitude"], [coder decodeDoubleForKey:@"sktSpotLongitude"]);
    return self;
}

@end
