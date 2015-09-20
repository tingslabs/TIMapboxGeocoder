# TIMapboxGeocoder

## Requirements

ios7 or highter

## Installation

TIMapboxGeocoder is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TIMapboxGeocoder"
```

## Usage

First, import this lib:

```objective-c
#import "TIMapboxGeocoder.h"
```

### Initialization

```objective-c
    TIMapboxGeocoder* geocoder = [[TIMapboxGeocoder alloc] initWithAccessToken:@"XXXX-XXXXX-XXXXX"];
```

You need a Mapbox access token

### Geocoding

```objective-c
    TIMapboxGeocoder* geocoder = [[TIMapboxGeocoder alloc] initWithAccessToken:@"XXXX-XXXXX-XXXXX"];
    [geocoder geocodeAddressString:@"Paris" proximity:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            // Handle error
        }
        TIPlacemark* placemark = results.firstObject;
        NSLog(@"First placemark name : %@", placemark.name);
    }]; 
```

Nb : proximity can be nil or a `CLLocation` object near the search area

### Reverse Geocoding

```objective-c
    CLLocation* location = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            // Handle error
        }
        TIPlacemark* placemark = results.firstObject;
        NSLog(@"First placemark name : %@", placemark.name);
}];
```

### TIPlacemark object

```objective-c
@interface TIPlacemark : NSObject

- (CLLocation*) location;
- (NSString*) name;

@end
```

## Author

Benjamin Digeon, TingsLabs (http://www.tingslabs.com), benjamin@tingslabs.com

## Credits

This Objective-C implementation is inspired by the original MapBox Geocoder implementation.

Check out the original Swift implementation here: https://github.com/mapbox/MapboxGeocoder.swift

## License

TIMapboxGeocoder is available under the MIT license. See the LICENSE file for more info.
