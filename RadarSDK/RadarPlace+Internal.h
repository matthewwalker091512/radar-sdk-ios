//
//  RadarPlace+Internal.h
//  RadarSDK
//
//  Copyright © 2019 Radar Labs, Inc. All rights reserved.
//

#import "RadarJSONCoding.h"
#import "RadarPlace.h"
#import <Foundation/Foundation.h>

@interface RadarPlace ()<RadarJSONCoding>

+ (NSArray<RadarPlace *> *_Nullable)placesFromObject:(id _Nonnull)object;
- (instancetype _Nullable)initWithId:(NSString *_Nonnull)_id
                                name:(NSString *_Nonnull)name
                          categories:(NSArray<NSString *> *_Nullable)categories
                               chain:(RadarChain *_Nullable)chain
                            location:(RadarCoordinate *_Nonnull)location
                               group:(NSString *_Nonnull)group
                            metadata:(NSDictionary *_Nullable)metadata;

@end
