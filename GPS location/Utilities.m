//
//  Utilities.m
//  GPS location
//
//  Created by Kuba on 31.08.16.
//  Copyright © 2016 Kuba. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (void)writeToFileText:(NSString *)text {
    NSError *error;
    NSString *newStr = [NSString stringWithFormat:@"%@\n", text];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"log.txt"];
    
    NSString *oldStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSString *stringToWrite = [NSString stringWithFormat:@"%@%@", oldStr, newStr];
    
    
    [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

@end
