//
//  LocationManager.m
//  GPS location
//
//  Created by Kuba on 30.08.16.
//  Copyright © 2016 Kuba. All rights reserved.
//

#import "LocationManager.h"
#import <AddressBookUI/AddressBookUI.h>
#import "SMHAlertController.h"

@implementation LocationManager

- (id) init {
    self = [super init];
    
    if (self != nil)
    {
        [self locationManagerInit];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static LocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationManager alloc] init];
    });
    return sharedInstance;
}

- (void) locationManagerInit {
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 10 meters
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        [_locationManager requestWhenInUseAuthorization];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"startUpdatingLocation" object:nil queue:nil usingBlock:^(NSNotification *note) {
            [_locationManager startUpdatingLocation];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }];
    }
    else {
        SMHAlertController * alert = [SMHAlertController alertControllerWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled."];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:okAction];
        [alert show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    _authorizationStatus = status;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangeAuthorizationStatus" object:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *location;
    location =  [manager location];
    
    float accuracy = newLocation.horizontalAccuracy;
    //NSLog(@"accuracy: %f", accuracy);
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    _currentLocation = [[CLLocation alloc] init];
    _currentLocation = newLocation;
    _longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       if (accuracy <= 10.f) {
                           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           [_locationManager stopUpdatingLocation];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationManagerDidReceiveCityName" object:placemark];
                       }
                   }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationManagerDidUpdateLocation" object:location];
}

@end
