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
    //[LocationManager sharedInstance];
    
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
        
        NSError *error;
        NSString *newStr = [NSString stringWithFormat:@"%@\n", placemark.locality];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"log.txt"];
        
        NSString *oldStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSString *stringToWrite = [NSString stringWithFormat:@"%@%@", oldStr, newStr];
        
        
        [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        
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
    [LocationManager sharedInstance];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startUpdatingLocation" object:nil];
    getLocation.enabled = NO;
}

@end
