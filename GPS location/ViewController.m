//
//  ViewController.m
//  GPS location
//
//  Created by Kuba on 30.08.16.
//  Copyright © 2016 Kuba. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LocationManager sharedInstance];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getLocation:(id)sender {
    
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
        
    }];
}
@end
