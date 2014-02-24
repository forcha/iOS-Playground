//
//  ImageViewAnimatedTransitioning.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 20/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ImageViewAnimatedTransitioning.h"


@interface ImageViewAnimatedTransitioning ()

@property (strong, nonatomic) UIImageView * originalImageView;

@end

@implementation ImageViewAnimatedTransitioning

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Must use initWithImageView: instead."
                                 userInfo:nil];
}

- (instancetype)initWithImageView:(UIImageView *)imageView {
    NSParameterAssert(imageView != nil);
    self = [super init];
    if (self) {
        self.originalImageView = imageView;
    }

    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

static const float kDuration = 0.25f;

static const NSInteger kSnapshotTag = 12345;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView*containerView = [transitionContext containerView];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    CGRect originalImageViewFrame = [self.originalImageView convertRect:self.originalImageView.bounds toView:containerView];

    if (self.isPresenting) {
        UIView *presentingViewControllerSnapshot = [v1 snapshotViewAfterScreenUpdates:NO];
        presentingViewControllerSnapshot.tag = kSnapshotTag;
        [containerView addSubview:presentingViewControllerSnapshot];

        UIImageView * animatedImageView = [[UIImageView alloc] initWithImage:self.originalImageView.image];
        animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
        animatedImageView.frame = originalImageViewFrame;
        [containerView addSubview:animatedImageView];

        v1.hidden = YES;

        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            animatedImageView.frame = containerView.bounds;
            presentingViewControllerSnapshot.alpha = 0.4;
            presentingViewControllerSnapshot.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.9, .9), presentingViewControllerSnapshot.transform);
        } completion:^(BOOL finished) {
            [animatedImageView removeFromSuperview];
            v2.frame = containerView.bounds;
            [containerView addSubview:v2];
            [transitionContext completeTransition:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    } else {
        UIView *presentingViewControllerSnapshot = [containerView viewWithTag:kSnapshotTag];
        UIView *zoomedImageView = [v1 viewWithTag:998];
        CGRect zoomedImageViewFrame = [zoomedImageView convertRect:zoomedImageView.bounds toView:containerView];

        UIImageView * animatedImageView = [[UIImageView alloc] initWithImage:self.originalImageView.image];
        animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
        animatedImageView.frame = zoomedImageViewFrame;
        [containerView addSubview:animatedImageView];
        [v1 removeFromSuperview];

        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            animatedImageView.frame = originalImageViewFrame;

            presentingViewControllerSnapshot.alpha = 1.0;
            presentingViewControllerSnapshot.transform = CGAffineTransformConcat(CGAffineTransformInvert(CGAffineTransformMakeScale(.9, .9)), presentingViewControllerSnapshot.transform);
        } completion:^(BOOL finished) {
            [presentingViewControllerSnapshot removeFromSuperview];
            [animatedImageView removeFromSuperview];
            v2.hidden = NO;
            [transitionContext completeTransition:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}

@end
