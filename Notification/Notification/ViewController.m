//
//  ViewController.m
//  Notification
//
//  Created by Ariel Cardieri on 30/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ViewController.h"
#import "AHCNotification.h"

@interface ViewController () <AHCUserNotificationCenterDelegate> {
    NSUInteger count;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    [AHCUserNotificationCenter defaultCenter].delegate = self;
}

#pragma mark - Actions

- (IBAction)showNotification:(id)sender {
    if (count++ % 2) {
        [[AHCUserNotificationCenter defaultCenter] postErrorWithMessage:@"This is an error"];
    } else {
        [[AHCUserNotificationCenter defaultCenter] postInfoWithMessage:@"Hey there!"];
    }
}

#pragma mark - AHCUserNotificationCenterDelegate

- (void)didSelectNotification:(AHCUserNotification *)notification {
    NSLog(@"didSelectNotification: %@", notification);
}


@end
