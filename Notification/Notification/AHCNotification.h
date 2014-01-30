//
//  AHCNotification.h
//  Notification
//
//  Created by Ariel Cardieri on 30/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "UIKit/UIKit.h"

@class AHCUserNotification;

typedef NS_ENUM(NSUInteger, AHCUserNotificationType) {
    AHCUserNotificationTypeInfo = 0,
    AHCUserNotificationTypeError
};

@interface AHCUserNotification : NSObject

@property (nonatomic, assign) AHCUserNotificationType type;

@property (nonatomic, copy) NSString * message;

@property (nonatomic, strong) id userInfo;

@end

@protocol AHCUserNotificationCenterDelegate <NSObject>

@optional

- (void)didSelectNotification:(AHCUserNotification *)notification;

@end

@interface AHCUserNotificationCenter : NSObject

@property (nonatomic, weak) id<AHCUserNotificationCenterDelegate> delegate;

@property (nonatomic, assign) CGFloat notificationHeight;

@property (nonatomic, assign) CGFloat notificationDuration;

@property (nonatomic, assign) CGFloat notificationAnimationDuration;

+ (instancetype)defaultCenter;

- (void)postInfoWithMessage:(NSString *)message;

- (void)postErrorWithMessage:(NSString *)message;

@end
