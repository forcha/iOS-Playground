//
//  ImageViewAnimatedTransitioning.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 20/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ImageViewAnimatedTransitioning.h"

@implementation ImageViewAnimatedTransitioning

#pragma mark - UIViewControllerAnimatedTransitioning

static const float kDuration = 0.25f;

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kDuration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"ImageViewController animateTransition");
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    
    NSLog(@"v1 = %@", v1);
    NSLog(@"v2 = %@", v2);
    NSLog(@"con subviews = %@", [con subviews]);
    
    if (self.isPresenting) {
        v2.frame = con.bounds;
        v2.alpha = 0.0;
        CGAffineTransform scale = CGAffineTransformMakeScale(0.5,0.5);
        v2.transform = CGAffineTransformConcat(scale, v2.transform);
        [con addSubview: v2];
        v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        
        UIView * mainView = [[v1 subviews] firstObject];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            v2.alpha = 1.0;
            v2.transform = CGAffineTransformConcat(CGAffineTransformInvert(scale), v2.transform);
            
            mainView.alpha = 0.4;
            mainView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.9, .9), mainView.transform);
        } completion:^(BOOL finished) {
            NSLog(@"completion before");
            [transitionContext completeTransition:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            NSLog(@"completion after");
        }];
    } else {
        UIView * mainView = [[v2 subviews] firstObject];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            v1.alpha = 0.0;
            v1.transform = CGAffineTransformScale(v1.transform,0.5,0.5);
            
            mainView.alpha = 1.0;
            mainView.transform = CGAffineTransformConcat(CGAffineTransformInvert(CGAffineTransformMakeScale(.9, .9)), mainView.transform);
        } completion:^(BOOL finished) {
            [v1 removeFromSuperview];
            [transitionContext completeTransition:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}

@end
