//
//  MainViewController.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 17/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "MainViewController.h"
#import "ImageViewController.h"
#import "ImageViewAnimatedTransitioning.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //FIXME: User Autolayout
    _mainView.frame = self.view.bounds;
    
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(toogleFullscreen:)];
    [_imageView addGestureRecognizer:tapGR];
    
    UIPanGestureRecognizer * panGR = [[UIPanGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(panImage:)];
    [_imageView addGestureRecognizer:panGR];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    ImageViewAnimatedTransitioning * animator = [[ImageViewAnimatedTransitioning alloc] initWithImageView:self.imageView];
    animator.presenting = YES;
    return animator;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ImageViewAnimatedTransitioning * animator = [[ImageViewAnimatedTransitioning alloc] initWithImageView:self.imageView];
    animator.presenting = NO;
    return animator;
}

#pragma mark - Action

- (IBAction)toogleFullscreen:(id)sender {
    ImageViewController * vc = [ImageViewController new];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    vc.transitioningDelegate = self;
    vc.imageToDisplay = _imageView.image;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)panImage:(UIPanGestureRecognizer *)gr {
    UIView* vv = gr.view;
    if (gr.state == UIGestureRecognizerStateBegan ||
        gr.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [gr translationInView: vv.superview];
        CGPoint c = vv.center;
        c.x += delta.x; c.y += delta.y;
        vv.center = c;
        [gr setTranslation: CGPointZero inView: vv.superview];
    }
}

@end
