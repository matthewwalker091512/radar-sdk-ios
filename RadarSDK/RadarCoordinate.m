//
//  RadarCoordinate.m
//  RadarSDK
//
//  Copyright © 2019 Radar Labs, Inc. All rights reserved.
//

#import "RadarCoordinate+Internal.h"

@implementation RadarCoordinate

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    return self;
}

@end