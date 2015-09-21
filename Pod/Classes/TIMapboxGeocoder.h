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

/** @name Errors */

extern NSString* const TIGeocoderErrorDomain;

typedef NS_ENUM(NSInteger, TIGeocoderErrorCode) {
    TIGeocoderErrorCodeConnectionError,
    TIGeocoderErrorCodeHTTPError,
    TIGeocoderErrorCodeParseError,
    TIGeocoderErrorCodeLimitExceed
};

/** @name Types for geocoding */

typedef NS_OPTIONS(NSInteger, TIGeocoderType) {
    TIGeocoderTypeNone     = 0,
    TIGeocoderTypeCountry  = 1 << 0,
    TIGeocoderTypeRegion   = 1 << 1,
    TIGeocoderTypePostcode = 1 << 2,
    TIGeocoderTypePlace    = 1 << 3,
    TIGeocoderTypeAddress  = 1 << 4,
    TIGeocoderTypePoi      = 1 << 5
};

/** @name Init Method */

/**
 *  Initialize the Geocoder
 *
 *  @param accessToken The Mapbox access Token
 *  @return a Geocoder instance
 */
- (instancetype) initWithAccessToken:(NSString*)accessToken;

/** @name Geocoding Methods */

/**
 *  Reverse Geocoding with a location
 *
 *  @param location a CLLocation for the reverse geocoding
 *  @param types one or serveral types for the places (optional)
 *  @param completionHandler the completion handler with error and/or results
 */
- (void) reverseGeocodeLocation:(CLLocation*)location
                          types:(TIGeocoderType) types
              completionHandler:(void (^)(NSArray *results, NSError *error)) completionHandler;

/**
 *  Geocoding with query
 *
 *  @param addressString the search query
 *  @param proximity a CLLocation for the proximity search (optional)
 *  @param types one or serveral types for the places (optional)
 *  @param completionHandler the completion handler with error and/or results
 */
- (void) geocodeAddressString:(NSString*) addressString
                    proximity:(CLLocation*) proximity
                        types:(TIGeocoderType) types
            completionHandler:(void (^)(NSArray *results, NSError *error)) completionHandler;

@end

/**
 *  Placemark object
 */
@interface TIPlacemark : NSObject

/** @name Init Method */

/**
 * Initialize the Placemark
 *
 * @param featureJSON the NSDictionary from the Mapbox JSON
 * @return a Placemark instance
 */
- (instancetype) initWithFeatureJSON:(NSDictionary*)featureJSON;

/** @name Accessors */

/**
 * @return the CLLocation of the Placemark
 */
- (CLLocation*) location;

/**
 * @return the name of the Placemark
 */
- (NSString*) name;

/**
 * @return the type of the Placemark
 */
- (NSString*) type;

@end