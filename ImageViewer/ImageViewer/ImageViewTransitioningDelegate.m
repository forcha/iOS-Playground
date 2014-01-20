//
//  ImageViewTransitioningDelegate.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 20/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ImageViewTransitioningDelegate.h"
#import "ImageViewAnimatedTransitioning.h"

@implementation ImageViewTransitioningDelegate

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    ImageViewAnimatedTransitioning * animator = [ImageViewAnimatedTransitioning new];
    animator.presenting = YES;
    return animator;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ImageViewAnimatedTransitioning * animator = [ImageViewAnimatedTransitioning new];
    animator.presenting = NO;
    return animator;
}

@end
