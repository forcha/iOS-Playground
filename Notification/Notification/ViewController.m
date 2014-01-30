//
//  ViewController.m
//  Notification
//
//  Created by Ariel Cardieri on 30/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSUInteger _hideStatusBar;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _hideStatusBar = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return _hideStatusBar == 0U ? NO : YES;
}

#pragma mark - Actions

- (IBAction)showNotification:(id)sender {
    const CGFloat notificationHeight = 100;
    const CGFloat extraSpace = 50;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect notificationInitialFrame = CGRectMake(0, - (notificationHeight + extraSpace), screenBounds.size.width, notificationHeight + extraSpace);
    CGRect notificationFinalFrame = notificationInitialFrame;
    notificationFinalFrame.origin.y = - extraSpace;
    UIView * notification = [[UIView alloc] initWithFrame:notificationInitialFrame];
    notification.backgroundColor = [UIColor redColor];

    UIImage * checkmarkImage = [UIImage imageNamed:@"checkmark"];
    UIImageView * check = [[UIImageView alloc] initWithImage:checkmarkImage];
    check.translatesAutoresizingMaskIntoConstraints = NO;
    [notification addSubview:check];
    UILabel * label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"This is a notification";
    [label sizeToFit];
    [notification addSubview:label];

    NSDictionary * views = NSDictionaryOfVariableBindings(check, label);
    [notification addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[check]-(10)-[label]-(>=10)-|" options:0 metrics:nil views:views]];
    [notification addConstraint: [NSLayoutConstraint constraintWithItem:check attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:notification attribute:NSLayoutAttributeCenterY multiplier:1 constant:extraSpace / 2]];
    [notification addConstraint: [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:notification attribute:NSLayoutAttributeCenterY multiplier:1 constant:extraSpace / 2]];

    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotification:)];
    [notification addGestureRecognizer:gr];

    [self.view addSubview:notification];

    ++_hideStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];

    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        notification.frame = notificationFinalFrame;
    } completion:^(BOOL finished) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(dismissNotificationWithTimer:) userInfo:notification repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }];
}

- (void)dismissNotification:(UITapGestureRecognizer *)gr {
    UIView * notification = gr.view;
    [self p_dismissNotificationWithView:notification];
}

- (void)dismissNotificationWithTimer:(NSTimer *)timer {
    UIView * notification = timer.userInfo;
    if (notification.superview) {
        [self p_dismissNotificationWithView:notification];
    }
}

#pragma mark - Private

- (void)p_dismissNotificationWithView:(UIView *)view {
    __block CGRect frame = view.frame;
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.75 animations:^{
            frame.origin.y = frame.origin.y + 10;
            view.frame = frame;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            frame.origin.y = - frame.size.height;
            view.frame = frame;
        }];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        --_hideStatusBar;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

@end
