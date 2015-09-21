#
# Be sure to run `pod lib lint TIMapboxGeocoder.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = "TIMapboxGeocoder"
  s.version          = "0.2.0"
  s.summary          = "Mapbox geocoder in Objective-C"

  s.description      = "MapBox geocoder in Objective-C for geocoding and reverse geocoding with Mapbox geocoding API"

  s.homepage         = "https://github.com/tingslabs/TIMapboxGeocoder"
  s.license          = 'MIT'
  s.author           = { "Benjamin Digeon" => "benjamin@tingslabs.com" }
  s.source           = { :git => "https://github.com/tingslabs/TIMapboxGeocoder.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreLocation'
end
