//
//  ImageViewController.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 16/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIScrollViewDelegate>

@end

@implementation ImageViewController

-(id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle {
    self = [super initWithNibName:nib bundle:bundle];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.transitioningDelegate = self;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ImageViewController viewDidLoad");
    UIScrollView * scrollView =
        [self p_createTrasnsparentBackgroundViewWithImage:_imageToDisplay];
    [self.view addSubview:scrollView];
//    
//    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]
//                                      initWithTarget:self
//                                      action:@selector(dismiss:)];
//    [self.view addGestureRecognizer:tapGR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

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
    
    if (v2 == self.view) {
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

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self.view viewWithTag:999];
}

#pragma mark - Action

- (void)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (UIScrollView *)p_createTrasnsparentBackgroundViewWithImage:(UIImageView *)imageView {
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    view.opaque = NO;
    view.minimumZoomScale = 1.0;
    view.maximumZoomScale = 2.0;
    view.delegate = self;
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(dismiss:)];
    [view addGestureRecognizer:tapGR];
    
    UIImageView * viewerImageView = [[UIImageView alloc] initWithImage:imageView.image];
    viewerImageView.tag = 999;
    viewerImageView.contentMode = UIViewContentModeScaleAspectFit;
    viewerImageView.frame = view.bounds;
    [view addSubview:viewerImageView];
    return view;
}

@end
