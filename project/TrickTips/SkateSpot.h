//
//  SkateSpot.h
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
@interface SkateSpot : NSObject
@property NSString *name;
@property NSString *parseId;
@property CLLocationCoordinate2D location;

-(id) initWithName:(NSString *) name_
          location:(CLLocationCoordinate2D)location_;
@end
