//
//  TIMapboxGeocoder.m
//  ios.tings.io
//
//  Created by Benjamin Digeon on 15/09/2015.
//  Copyright (c) 2015 Benjamin Digeon. All rights reserved.
//

#import "TIMapboxGeocoder.h"

@interface TIMapboxGeocoder()

@property (strong, nonatomic) NSString* accessToken;

@end

@implementation TIMapboxGeocoder

NSString * const TIGeocoderErrorDomain = @"TIGeocoderErrorDomain";

#pragma mark - Init

- (instancetype) initWithAccessToken:(NSString*)accessToken {
    self = [super init];
    if (self) {
        self.accessToken = accessToken;
    }
    return self;
}

#pragma mark - Public API

- (void) reverseGeocodeLocation:(CLLocation*)location
                          types:(TIGeocoderType) types
              completionHandler:(void (^)(NSArray *results, NSError *error)) completionHandler {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *pathSting = [NSMutableString stringWithFormat:@"https://api.tiles.mapbox.com/v4/geocode/mapbox.places/%f,%f.json?access_token=%@",location.coordinate.longitude, location.coordinate.latitude, self.accessToken];
    
    if(types) {
        pathSting = [pathSting stringByAppendingString:[TIMapboxGeocoder typesParamsWithTypes:types]];
    }
    
    NSURL *path = [NSURL URLWithString:pathSting];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:path cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError* responseError = [TIMapboxGeocoder checkRequestResponse:response andError:error];
        if (responseError) {
            completionHandler(nil, error);
        }
        
        [TIMapboxGeocoder parseData:data completionHandler:^(NSArray *results, NSError *error) {
            completionHandler(results, error);
        }];
    }];
    
    [dataTask resume];
}

- (void) geocodeAddressString:(NSString*)addressString
                    proximity:(CLLocation*) proximity
                        types:(TIGeocoderType) types
            completionHandler:(void (^)(NSArray *results, NSError *error)) completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *pathSting = [NSMutableString stringWithFormat:@"https://api.tiles.mapbox.com/v4/geocode/mapbox.places/%@.json?access_token=%@",[addressString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.accessToken];
    
    if (proximity) {
        pathSting = [pathSting stringByAppendingString:[NSString stringWithFormat:@"&proximity=%f,%f", proximity.coordinate.longitude, proximity.coordinate.longitude]];
    }
    
    if(types) {
        pathSting = [pathSting stringByAppendingString:[TIMapboxGeocoder typesParamsWithTypes:types]];
    }
    
    NSURL *path = [NSURL URLWithString:pathSting];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:path cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError* responseError = [TIMapboxGeocoder checkRequestResponse:response andError:error];
        if (responseError) {
            completionHandler(nil, error);
        }
        
        [TIMapboxGeocoder parseData:data completionHandler:^(NSArray *results, NSError *error) {
            completionHandler(results, error);
        }];
    }];
    
    [dataTask resume];
}

#pragma mark - Connection & HTTP Error

+ (NSError*) checkRequestResponse:(NSURLResponse*) response andError:(NSError*) error {
    if (error) {
        return [[NSError alloc] initWithDomain:TIGeocoderErrorDomain
                                          code:TIGeocoderErrorCodeConnectionError
                                      userInfo:error.userInfo];
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if (httpResponse.statusCode == 429) { // Limit Exceed
        NSDictionary* headers = [httpResponse allHeaderFields];
        NSDictionary* userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Limit exceed, rate-limit-interval : %@, limit : %@, remaining: %@, reset time: %@", [headers objectForKey:@"x-rate-limit-interval"],[headers objectForKey:@"x-rate-limit-limit"],[headers objectForKey:@"x-rate-limit-remaining"],[headers objectForKey:@"x-rate-limit-reset"]]};
        return [[NSError alloc] initWithDomain:TIGeocoderErrorDomain
                                          code:TIGeocoderErrorCodeLimitExceed
                                      userInfo:userInfo];
    } else if (httpResponse.statusCode != 200) {
        NSDictionary* userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Received HTTP status code %li", (long)httpResponse.statusCode]};
        return [[NSError alloc] initWithDomain:TIGeocoderErrorDomain
                                          code:TIGeocoderErrorCodeHTTPError
                                      userInfo:userInfo];
    }
    
    return nil;
}

#pragma mark - Types option

+ (NSString*) typesParamsWithTypes:(TIGeocoderType) types {
    
    if (types & TIGeocoderTypeNone) {
        return @"";
    }
    
    NSMutableString* typesString = [[NSMutableString alloc] initWithString:@"&types="];
    
    if (types & TIGeocoderTypeCountry) {
        [typesString appendString:@"country,"];
    }
    if (types & TIGeocoderTypeRegion) {
        [typesString appendString:@"region,"];
    }
    if (types & TIGeocoderTypePostcode) {
        [typesString appendString:@"postcode,"];
    }
    if (types & TIGeocoderTypePlace) {
        [typesString appendString:@"place,"];
    }
    if (types & TIGeocoderTypeAddress) {
        [typesString appendString:@"address,"];
    }
    if (types & TIGeocoderTypePoi) {
        [typesString appendString:@"poi,"];
    }
    
    // Delete last comma
    NSRange lastComma = [typesString rangeOfString:@"," options:NSBackwardsSearch];
    if(lastComma.location != NSNotFound) {
        typesString = [[NSMutableString alloc] initWithString:[typesString
                                                               stringByReplacingCharactersInRange:lastComma withString: @""]];
    }
    
    return typesString;
}

#pragma mark - Parsing

+ (void) parseData:(NSData*)data completionHandler:(void (^)(NSArray *results, NSError *error)) completionHandler {
    
    NSError *parseError = nil;
    id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    if(parseError) {
        completionHandler(nil, [[NSError alloc] initWithDomain:TIGeocoderErrorDomain
                                                          code:TIGeocoderErrorCodeParseError
                                                      userInfo:@{NSLocalizedDescriptionKey: @"Unable to parse results"}]);
    }
    
    if([response isKindOfClass:[NSDictionary class]] &&
       [response objectForKey:@"features"] &&
       [[response objectForKey:@"features"] isKindOfClass:[NSArray class]]) {
        NSDictionary *features = [response objectForKey:@"features"];
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (NSDictionary *feature in features) {
            [results addObject:[[TIPlacemark alloc] initWithFeatureJSON:feature]];
        }
        completionHandler(results, nil);
    } else {
        completionHandler(@[] ,nil);
    }
    
}
@end

@interface TIPlacemark()

@property(nonatomic, strong) NSDictionary* featureJSON;

@end

@implementation TIPlacemark

#pragma mark - Init

- (instancetype) initWithFeatureJSON:(NSDictionary*)featureJSON {
    self = [super init];
    if (self) {
        self.featureJSON = featureJSON;
    }
    return self;
}

#pragma mark - Getters

- (CLLocation*) location {
    if ([[self.featureJSON objectForKey:@"geometry"] isKindOfClass:[NSDictionary class]]) {
        if ([[[self.featureJSON objectForKey:@"geometry"] objectForKey:@"coordinates"] isKindOfClass:[NSArray class]]) {
            NSArray* coordinates = [[self.featureJSON objectForKey:@"geometry"] objectForKey:@"coordinates"];
            NSNumber* latitude = coordinates[1];
            NSNumber* longitude = coordinates[0];
            return [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
        }
    }
    return nil;
}

- (NSString*) name {
    if([[self.featureJSON objectForKey:@"place_name"] isKindOfClass:[NSString class]]) {
        return [self.featureJSON objectForKey:@"place_name"];
    }
    return nil;
}

- (NSString*) type {
    if ([[self.featureJSON objectForKey:@"properties"] isKindOfClass:[NSDictionary class]]) {
        if ([[[self.featureJSON objectForKey:@"properties"] objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            return [[self.featureJSON objectForKey:@"properties"] objectForKey:@"type"];
        }
    }
    return nil;
}

@end