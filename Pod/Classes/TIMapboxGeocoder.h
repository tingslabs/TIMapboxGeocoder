//
//  TIMapboxGeocoder.h
//  ios.tings.io
//
//  Created by Benjamin Digeon on 15/09/2015.
//  Copyright (c) 2015 TingsLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

/**
 *  Map Box Geocoder
 */
@interface TIMapboxGeocoder : NSObject

extern NSString* const TIGeocoderErrorDomain;

typedef NS_ENUM(NSInteger, TIGeocoderErrorCode) {
    TIGeocoderErrorCodeConnectionError,
    TIGeocoderErrorCodeHTTPError,
    TIGeocoderErrorCodeParseError,
    TIGeocoderErrorCodeLimitExceed
};

- (instancetype) initWithAccessToken:(NSString*)accessToken;
- (void) reverseGeocodeLocation:(CLLocation*)location completionHandler:(void (^)(NSArray *results, NSError *error)) completionHandler;
- (void) geocodeAddressString:(NSString*)addressString proximity:(CLLocation*) proximity completionHandler:(void (^)(NSArray *results, NSError *error)) completionHandler;

@end

/**
 *  Placemark object
 */
@interface TIPlacemark : NSObject

- (instancetype) initWithFeatureJSON:(NSDictionary*)featureJSON;

- (CLLocation*) location;
- (NSString*) name;

@end