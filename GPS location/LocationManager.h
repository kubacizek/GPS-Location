//
//  LocationManager.h
//  JRm
//
//  Created by Kuba on 30.08.16.
//  Copyright © 2016 Kuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic) CLAuthorizationStatus authorizationStatus;

+ (instancetype)sharedInstance;
/*+ (void)addObserverForLocationManagerDidReceiveCityName;
+ (void)addObserverForLocationManagerDidReceiveCityNameWCompletion:(void (^)(void))completionBlock;*/

@end
