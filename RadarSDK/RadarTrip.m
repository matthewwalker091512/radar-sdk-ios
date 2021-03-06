//
//  RadarTrip.m
//  RadarSDK
//
//  Copyright © 2020 Radar Labs, Inc. All rights reserved.
//

#import "RadarTrip.h"
#import "Radar.h"
#import "RadarCoordinate+Internal.h"
#import "RadarTrip+Internal.h"

@implementation RadarTrip

- (instancetype _Nullable)initWithExternalId:(NSString *_Nonnull)externalId
                                    metadata:(NSDictionary *_Nullable)metadata
                      destinationGeofenceTag:(NSString *_Nullable)destinationGeofenceTag
               destinationGeofenceExternalId:(NSString *_Nullable)destinationGeofenceExternalId
                         destinationLocation:(RadarCoordinate *_Nullable)destinationLocation
                                        mode:(RadarRouteMode)mode
                                 etaDistance:(float)etaDistance
                                 etaDuration:(float)etaDuration
                                     arrived:(BOOL)arrived {
    self = [super init];
    if (self) {
        _externalId = externalId;
        _metadata = metadata;
        _destinationGeofenceTag = destinationGeofenceTag;
        _destinationGeofenceExternalId = destinationGeofenceExternalId;
        _destinationLocation = destinationLocation;
        _mode = mode;
        _etaDistance = etaDistance;
        _etaDuration = etaDuration;
        _arrived = arrived;
    }
    return self;
}

- (instancetype _Nullable)initWithObject:(NSObject *)object {
    if (!object || ![object isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSDictionary *dict = (NSDictionary *)object;

    NSString *externalId;
    NSDictionary *metadata;
    NSString *destinationGeofenceTag;
    NSString *destinationGeofenceExternalId;
    RadarCoordinate *destinationLocation;
    RadarRouteMode mode = RadarRouteModeCar;
    float etaDistance = 0;
    float etaDuration = 0;
    BOOL arrived = NO;

    id externalIdObj = dict[@"externalId"];
    if (externalIdObj && [externalIdObj isKindOfClass:[NSString class]]) {
        externalId = (NSString *)externalIdObj;
    }

    id metadataObj = dict[@"metadata"];
    if (metadataObj && [metadataObj isKindOfClass:[NSDictionary class]]) {
        metadata = (NSDictionary *)metadataObj;
    }

    id destinationGeofenceTagObj = dict[@"destinationGeofenceTag"];
    if (destinationGeofenceTagObj && [destinationGeofenceTagObj isKindOfClass:[NSString class]]) {
        destinationGeofenceTag = (NSString *)destinationGeofenceTagObj;
    }

    id destinationGeofenceExternalIdObj = dict[@"destinationGeofenceExternalId"];
    if (destinationGeofenceExternalIdObj && [destinationGeofenceExternalIdObj isKindOfClass:[NSString class]]) {
        destinationGeofenceExternalId = (NSString *)destinationGeofenceExternalIdObj;
    }

    id destinationLocationObj = dict[@"destinationLocation"];
    if (destinationLocationObj && [destinationLocationObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *destinationLocationDict = (NSDictionary *)destinationLocationObj;

        id destinationLocationCoordinatesObj = destinationLocationDict[@"coordinates"];
        if (!destinationLocationCoordinatesObj || ![destinationLocationCoordinatesObj isKindOfClass:[NSArray class]]) {
            return nil;
        }

        NSArray *destinationLocationCoordinatesArr = (NSArray *)destinationLocationCoordinatesObj;
        if (destinationLocationCoordinatesArr.count != 2) {
            return nil;
        }

        id destinationLocationCoordinatesLongitudeObj = destinationLocationCoordinatesArr[0];
        id destinationLocationCoordinatesLatitudeObj = destinationLocationCoordinatesArr[1];
        if (!destinationLocationCoordinatesLongitudeObj || !destinationLocationCoordinatesLatitudeObj ||
            ![destinationLocationCoordinatesLongitudeObj isKindOfClass:[NSNumber class]] || ![destinationLocationCoordinatesLatitudeObj isKindOfClass:[NSNumber class]]) {
            return nil;
        }

        NSNumber *destinationLocationCoordinatesLongitudeNumber = (NSNumber *)destinationLocationCoordinatesLongitudeObj;
        NSNumber *destinationLocationCoordinatesLatitudeNumber = (NSNumber *)destinationLocationCoordinatesLatitudeObj;

        float destinationLocationCoordinatesLongitudeFloat = [destinationLocationCoordinatesLongitudeNumber floatValue];
        float destinationLocationCoordinatesLatitudeFloat = [destinationLocationCoordinatesLatitudeNumber floatValue];

        destinationLocation =
            [[RadarCoordinate alloc] initWithCoordinate:CLLocationCoordinate2DMake(destinationLocationCoordinatesLatitudeFloat, destinationLocationCoordinatesLongitudeFloat)];
    }

    id modeObj = dict[@"mode"];
    if (modeObj && [modeObj isKindOfClass:[NSString class]]) {
        NSString *modeStr = (NSString *)modeObj;
        if ([modeStr isEqualToString:@"foot"]) {
            mode = RadarRouteModeFoot;
        } else if ([modeStr isEqualToString:@"bike"]) {
            mode = RadarRouteModeBike;
        } else {
            mode = RadarRouteModeCar;
        }
    }

    id etaObj = dict[@"eta"];
    if (etaObj && [etaObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *etaDict = (NSDictionary *)etaObj;
        id etaDistanceObj = etaDict[@"distance"];
        if (etaDistanceObj && [etaDistanceObj isKindOfClass:[NSNumber class]]) {
            etaDistance = [(NSNumber *)etaDistanceObj floatValue];
        }
        id etaDurationObj = etaDict[@"duration"];
        if (etaDurationObj && [etaDurationObj isKindOfClass:[NSNumber class]]) {
            etaDuration = [(NSNumber *)etaDurationObj floatValue];
        }
    }

    id arrivedObj = dict[@"arrived"];
    if (arrivedObj && [arrivedObj isKindOfClass:[NSNumber class]]) {
        arrived = [(NSNumber *)arrivedObj boolValue];
    }

    if (externalId) {
        return [[RadarTrip alloc] initWithExternalId:externalId
                                            metadata:metadata
                              destinationGeofenceTag:destinationGeofenceTag
                       destinationGeofenceExternalId:destinationGeofenceExternalId
                                 destinationLocation:destinationLocation
                                                mode:mode
                                         etaDistance:etaDistance
                                         etaDuration:etaDuration
                                             arrived:arrived];
    }

    return nil;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"externalId"] = self.externalId;
    dict[@"metadata"] = self.metadata;
    dict[@"destinationGeofenceTag"] = self.destinationGeofenceTag;
    dict[@"destinationGeofenceExternalId"] = self.destinationGeofenceExternalId;
    NSMutableDictionary *destinationLocationDict = [NSMutableDictionary new];
    destinationLocationDict[@"type"] = @"Point";
    NSArray *coordinates = @[@(self.destinationLocation.coordinate.longitude), @(self.destinationLocation.coordinate.latitude)];
    destinationLocationDict[@"coordinates"] = coordinates;
    dict[@"destinationLocation"] = destinationLocationDict;
    dict[@"mode"] = [Radar stringForMode:self.mode];
    NSDictionary *etaDict = @{@"distance": @(self.etaDistance), @"duration": @(self.etaDuration)};
    dict[@"eta"] = etaDict;
    dict[@"arrived"] = @(self.arrived);
    return dict;
}

@end
