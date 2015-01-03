//
//  SkateSpot.h
//  TrickTips
//
//  Created by Kuba on 02/01/15.
//  Copyright (c) 2015 Kuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SkateSpot : NSObject
@property NSString *name;
@property MKMapItem *location;

-(id) initWithName:(NSString *) name_
          location:(MKMapItem *)location_;
@end
