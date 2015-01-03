//
//  SkateSpot.m
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import "SkateSpot.h"

@implementation SkateSpot
-(id) initWithName:(NSString *) name_
          location:(MKMapItem *)location_
{
    if(self = [super init])
    {
        self.name = name_;
        self.location = location_;
        return self;
    
    }
    return nil;
}
@end
