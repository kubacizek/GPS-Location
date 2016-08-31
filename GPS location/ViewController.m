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
    
    //[LocationManager sharedInstance];
    
    /*CLAuthorizationStatus status = [LocationManager sharedInstance].authorizationStatus;
    NSLog(@"%d", status);*/
    
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
                //[_locationManager startUpdatingLocation];
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
    
    
    
    //NSLog(@"status:%d@", );
    
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
        
        city.text = [NSString stringWithFormat:@"City: %@", placemark.locality];
        street.text = [NSString stringWithFormat:@"Street: %@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
        
        getLocation.enabled = YES;
        [timer invalidate];
        [Utilities writeToFileText:placemark.locality];
        
        
        /*NSError *error;
        NSString *stringToWrite = @"1\n2\n3\n4";
        //NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"log.txt"];
        NSString *cesta = @"log.txt";
        NSURL *groupContainerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.jrm"];
        NSString *sharedDirectory = [groupContainerURL path];
        NSString *filePath = [sharedDirectory stringByAppendingPathComponent:cesta];
        
        [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];*/
        
        /*NSString *cesta = [NSString stringWithFormat:@"%@_%@_%@", idDopravceParam, currentPack, nazevSouboru];
        NSURL *groupContainerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.jrm"];
        NSString *sharedDirectory = [groupContainerURL path];
        NSString *filePath = [sharedDirectory stringByAppendingPathComponent:cesta];
        [data writeToFile:filePath atomically:YES];*/
        
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
}

@end
