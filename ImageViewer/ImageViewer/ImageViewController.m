//
//  ImageViewController.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 16/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ImageViewController.h"
#import "MyScrollView.h"

@interface ImageViewController () <UIScrollViewDelegate>

@end

@implementation ImageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ImageViewController viewDidLoad");
    UIScrollView * scrollView =
        [self p_createTrasnsparentBackgroundViewWithImage:_imageToDisplay];
    [self.view addSubview:scrollView];

    //NOTE: Added call to beginGeneratingDeviceOrientationNotifications but tested without it and worked
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

static const float kRotationAnimationDuration = 0.25;

- (void)deviceRotated:(id)info {
    UIScrollView * scrollView = [[self.view subviews] firstObject];
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    UIView * imageView = [scrollView viewWithTag:998];
//    NSLog(@"imageView.transform = %@", NSStringFromCGAffineTransform(imageView.transform));

    if (deviceOrientation == UIDeviceOrientationPortrait) {
        NSLog(@"UIDeviceOrientationPortrait");
        [UIView animateWithDuration:kRotationAnimationDuration animations:^{
            imageView.transform = CGAffineTransformIdentity;
        }];
    } else if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        NSLog(@"UIDeviceOrientationLandscapeLeft");
        [UIView animateWithDuration:kRotationAnimationDuration animations:^{
            imageView.transform = CGAffineTransformMakeRotation((CGFloat) (90.0 * M_PI/180.0));
        }];
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        NSLog(@"UIDeviceOrientationLandscapeRight");
        [UIView animateWithDuration:kRotationAnimationDuration animations:^{
            imageView.transform = CGAffineTransformMakeRotation((CGFloat) (- 90 * M_PI/180.0));
        }];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self.view viewWithTag:999];
}

#pragma mark - Action

- (void)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)zoomInOut:(UIGestureRecognizer *)gestureRecognizer {
    UIScrollView* sv = (UIScrollView *)gestureRecognizer.view;
    if (sv.zoomScale < 1)
        [sv setZoomScale:1 animated:YES];
    else if (sv.zoomScale < sv.maximumZoomScale)
        [sv setZoomScale:sv.maximumZoomScale animated:YES];
    else
        [sv setZoomScale:sv.minimumZoomScale animated:YES];
}

#pragma mark - Private

- (UIScrollView *)p_createTrasnsparentBackgroundViewWithImage:(UIImage *)image {
    UIScrollView *scrollView = [[MyScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.opaque = NO;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismiss:)];
    [scrollView addGestureRecognizer:tapGR];

    UITapGestureRecognizer * doubleTapGR = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(zoomInOut:)];
    doubleTapGR.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTapGR];
    [tapGR requireGestureRecognizerToFail:doubleTapGR];

    UIView * contentView = [[UIView alloc] initWithFrame:scrollView.bounds];
    contentView.tag = 999;
    [scrollView addSubview:contentView];

    UIImageView * viewerImageView = [[UIImageView alloc] initWithImage:image];
    viewerImageView.tag = 998;
    viewerImageView.frame = [self p_frameForImageView:viewerImageView inView:contentView];
    viewerImageView.center = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(contentView.bounds));

    [contentView addSubview:viewerImageView];
    return scrollView;
}

- (CGRect)p_frameForImageView:(UIImageView *)imageView inView:(UIView *)view {
    CGSize kMaxImageViewSize = view.bounds.size;

    CGSize imageSize = imageView.image.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    //CGRect frame = imageView.frame;
    CGRect frame = CGRectMake(.0,.0,.0,.0);
    if (kMaxImageViewSize.width / aspectRatio <= kMaxImageViewSize.height) {
        frame.size.width = kMaxImageViewSize.width;
        frame.size.height = frame.size.width / aspectRatio;
    } else {
        frame.size.height = kMaxImageViewSize.height;
        frame.size.width = frame.size.height * aspectRatio;
    }

    return frame;
}

@end
