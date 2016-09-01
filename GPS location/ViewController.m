//
//  ViewController.m
//  GPS location
//
//  Created by Kuba on 30.08.16.
//  Copyright © 2016 Kuba. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"
#import "Utilities.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController () {
    NSTimer *timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"didChangeAuthorizationStatus" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *nocity = @"City: GPS not available";
        NSString *nostreet = @"Street: GPS not available";
        
        switch ([LocationManager sharedInstance].authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"NotDetermined");
                city.text = nocity;
                street.text = nostreet;
                getLocation.enabled = NO;
                break;
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"Authorized");
                city.text = @"City: not loaded";
                street.text = @"Street: not loaded";
                getLocation.enabled = YES;
                break;
                
            case kCLAuthorizationStatusDenied: {
                NSLog(@"Denied");
                city.text = nocity;
                street.text = nostreet;
                getLocation.enabled = NO;
                break;
            }
                
            default:
                NSLog(@"Unhandled authorization status");
                city.text = nocity;
                street.text = nostreet;
                getLocation.enabled = NO;
                break;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"LocationManagerDidReceiveCityName" object:nil queue:nil usingBlock:^(NSNotification *note) {
        CLPlacemark *placemark = note.object;
        
        /*NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
        NSLog(@"placemark.country %@",placemark.country);
        NSLog(@"placemark.postalCode %@",placemark.postalCode);
        NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
        NSLog(@"placemark.locality %@",placemark.locality);
        NSLog(@"placemark.subLocality %@",placemark.subLocality);
        NSLog(@"placemark.street %@",ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO));
        NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);*/
        
        if (placemark.locality) {
            city.text = [NSString stringWithFormat:@"City: %@", placemark.locality];
        } else {
            city.text = @"City: Unknown";
        }
        
        if (placemark.addressDictionary[@"FormattedAddressLines"][0]) {
            street.text = [NSString stringWithFormat:@"Street: %@", placemark.addressDictionary[@"FormattedAddressLines"][0]];
        } else {
            street.text = @"Street: Unknown";
        }
        
        getLocation.enabled = YES;
        [timer invalidate];
        [Utilities writeToFileText:placemark.locality];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getLocation:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(gpstimeout) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startUpdatingLocation" object:nil];
    getLocation.enabled = NO;
}

- (void)gpstimeout {
    city.text = @"City: GPS timeout";
    street.text = @"Street: GPS timeout";
    getLocation.enabled = YES;
}

@end
