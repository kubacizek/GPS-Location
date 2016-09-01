//
//  ViewController.h
//  GPS location
//
//  Created by Kuba on 30.08.16.
//  Copyright © 2016 Kuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    __weak IBOutlet UILabel *city;
    __weak IBOutlet UILabel *street;
    __weak IBOutlet UIButton *getLocation;
}

- (IBAction)getLocation:(id)sender;

@end

