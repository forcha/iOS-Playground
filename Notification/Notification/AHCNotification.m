//
//  AHCNotification.m
//  Notification
//
//  Created by Ariel Cardieri on 30/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "AHCNotification.h"

@interface AHCUserNotificationView : UIView

@property (nonatomic, weak) UILabel * message;

@property (nonatomic, weak) UIImageView * icon;

@end;

static const CGFloat kExtraSpace = 50.0f;

@implementation AHCUserNotificationView

- (id)initWithHeight:(CGFloat)height {
    BOOL landscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = CGRectMake(0, - (height + kExtraSpace), landscape ? screenSize.height : screenSize.width, height + kExtraSpace);
    self = [super initWithFrame:frame];
    if (self) {
        [self p_initWithHeight:height];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }

    return self;
}

- (void)p_initWithHeight:(CGFloat)height {
    self.backgroundColor = [UIColor redColor];

    UIImage *iconImage = [UIImage imageNamed:@"checkmark"];
    UIImageView *icon = [[UIImageView alloc] initWithImage:iconImage];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:icon];
    UILabel *message = [UILabel new];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    [message sizeToFit];
    [self addSubview:message];

    NSDictionary * views = NSDictionaryOfVariableBindings(icon, message);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[icon]-(10)-[message]-(>=10)-|" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:icon attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:kExtraSpace / 2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:message attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:kExtraSpace / 2]];

    self.icon = icon;
    self.message = message;
}

//- (void)layoutSubviews {
//    NSLog(@"before frame %@", NSStringFromCGRect(self.frame));
//    [super layoutSubviews];
//    NSLog(@"after  frame %@", NSStringFromCGRect(self.frame));
//}

@end;

@implementation AHCUserNotification

@end

@interface AHCUserNotificationCenter ()

@property (nonatomic, strong) NSMutableArray * notifications;

@property (nonatomic, strong) AHCUserNotificationView * reusableNotificationView;

@property (nonatomic, strong) AHCUserNotification * currentNotification;

@end

@implementation AHCUserNotificationCenter

+ (instancetype)defaultCenter {
    static AHCUserNotificationCenter * singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [AHCUserNotificationCenter new];
    });

    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _notificationHeight = 100.0f;
        _notificationDuration = 1.5f;
        _notificationAnimationDuration = 0.25f;
        self.notifications = [NSMutableArray new];
    }

    return self;
}

- (void)postInfoWithMessage:(NSString *)message {
    AHCUserNotification * notification = [AHCUserNotification new];
    notification.type = AHCUserNotificationTypeInfo;
    notification.message = message;
    [self postNotification:notification];
}

- (void)postErrorWithMessage:(NSString *)message {
    AHCUserNotification * notification = [AHCUserNotification new];
    notification.type = AHCUserNotificationTypeError;
    notification.message = message;
    [self postNotification:notification];
}

- (void)postNotification:(AHCUserNotification *)notification {
    [_notifications addObject:notification];
    if (_currentNotification == nil) {
        [self showNextNotification];
    }
}

- (void)showNextNotification {
    if (_reusableNotificationView == nil) {
        self.reusableNotificationView = [[AHCUserNotificationView alloc] initWithHeight:_notificationHeight];
        UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNotification:)];
        [_reusableNotificationView addGestureRecognizer:gr];
    }

    self.currentNotification = [_notifications firstObject];
    UILabel *message = _reusableNotificationView.message;
    message.text = _currentNotification.message;
    UIImageView * icon = _reusableNotificationView.icon;
    if (_currentNotification.type == AHCUserNotificationTypeError) {
        _reusableNotificationView.backgroundColor = [UIColor redColor];
        icon.image = [UIImage imageNamed:@"checkmark"];
    } else {
        _reusableNotificationView.backgroundColor = [UIColor blueColor];
        icon.image = [UIImage imageNamed:@"checkmark"];
    }

    UIView * rootView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    [rootView addSubview:_reusableNotificationView];

    CGRect notificationFinalFrame = _reusableNotificationView.frame;
    notificationFinalFrame.origin.y = - kExtraSpace;

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [UIView animateWithDuration:_notificationAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _reusableNotificationView.frame = notificationFinalFrame;
    } completion:^(BOOL finished) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:_notificationDuration target:self selector:@selector(dismissTimerTriggered:) userInfo:_currentNotification repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }];
}

- (void)tapNotification:(UITapGestureRecognizer *)gr {
    if ([self.delegate respondsToSelector:@selector(didSelectNotification:)]) {
        [self.delegate didSelectNotification:_currentNotification];
    }

    [self dismissNotification];
}

- (void)dismissTimerTriggered:(NSTimer *)timer {
    AHCUserNotification * notification = timer.userInfo;
    // Avoid dismiss if user already dismissed
    if ([_notifications containsObject:notification]) {
        [self dismissNotification];
    }
}

- (void)dismissNotification {
    [_notifications removeObject:_currentNotification];
    __block CGRect frame = _reusableNotificationView.frame;
    [UIView animateKeyframesWithDuration:_notificationAnimationDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.75 animations:^{
            frame.origin.y = frame.origin.y + 10;
            _reusableNotificationView.frame = frame;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            frame.origin.y = - frame.size.height;
            _reusableNotificationView.frame = frame;
        }];
    } completion:^(BOOL finished) {
        [_reusableNotificationView removeFromSuperview];
        _currentNotification = nil;
        if (_notifications.count == 0) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        } else {
            [self showNextNotification];
        }
    }];
}

@end