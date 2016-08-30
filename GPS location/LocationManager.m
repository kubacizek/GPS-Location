//
//  LocationManager.m
//  JRm
//
//  Created by Kuba on 30.08.16.
//  Copyright © 2016 Kuba. All rights reserved.
//

#import "LocationManager.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation LocationManager {
    //CLLocationManager *loc_manager;
}

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
    
    if ([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 10 meters
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        /*if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [_locationManager requestWhenInUseAuthorization];
        }*/
        //[_locationManager startUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"startUpdatingLocation" object:nil queue:nil usingBlock:^(NSNotification *note) {
            [_locationManager startUpdatingLocation];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }];
    }
    else{
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"Continue",nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert setDelegate:self];
    }
}

+ (void)startUpdatingLocation {
    [LocationManager new];
}

/*+ (void)stopUpdatingLocation {
    [_locationManager stopUpdatingLocation];
}*/

/*- (void)requestWhenInUseAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertViews = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Settings", nil];
        [alertViews show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
}*/

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"NotDetermined");
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Authorized");
            //[_locationManager startUpdatingLocation];
            break;
            
        case kCLAuthorizationStatusDenied: {
            NSLog(@"Denied");
            NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.jrm"];
            [myDefaults setBool:NO forKey:@"citygps"];
            [myDefaults synchronize];
            break;
        }
            
        default:
            NSLog(@"Unhandled authorization status");
            break;
    }
}

/*- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationManagerDidUpdateLocation" object:location];
}*/

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    CLLocation *location;
    location =  [manager location];
    
    float accuracy = newLocation.horizontalAccuracy;
    NSLog(@"accuracy: %f", accuracy);
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    _currentLocation = [[CLLocation alloc] init];
    _currentLocation = newLocation;
    _longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       //NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                       
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                           
                       }
                       
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       /*NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                       NSLog(@"placemark.country %@",placemark.country);
                       NSLog(@"placemark.postalCode %@",placemark.postalCode);
                       NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
                       NSLog(@"placemark.locality %@",placemark.locality);
                       NSLog(@"placemark.subLocality %@",placemark.subLocality);
                       NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);*/
                       //NSLog(@"%@", placemark);
                       
                       if (accuracy <= 10.f) {
                           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           [_locationManager stopUpdatingLocation];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationManagerDidReceiveCityName" object:placemark];
                       }
                   }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationManagerDidUpdateLocation" object:location];
}

+ (void)addObserverForLocationManagerDidReceiveCityNameWCompletion:(void (^)(void))completionBlock {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"LocationManagerDidReceiveCityName" object:nil queue:nil usingBlock:^(NSNotification *note) {
        CLPlacemark *placemark = note.object;
        NSLog(@"dopravce: %@  |  mesto: %@ -- %@", @"", placemark.locality, placemark.subAdministrativeArea);
    }];
}

+ (void)addObserverForLocationManagerDidReceiveCityName {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"LocationManagerDidReceiveCityName" object:nil queue:nil usingBlock:^(NSNotification *note) {
        CLPlacemark *placemark = note.object;
        
        NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
        NSLog(@"placemark.country %@",placemark.country);
        NSLog(@"placemark.postalCode %@",placemark.postalCode);
        NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
        NSLog(@"placemark.locality %@",placemark.locality);
        NSLog(@"placemark.subLocality %@",placemark.subLocality);
        NSLog(@"placemark.street %@",ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO));
        NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
        
    }];
}


@end
