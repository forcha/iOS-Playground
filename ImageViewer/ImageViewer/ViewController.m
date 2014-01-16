//
//  ViewController.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 16/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    BOOL _fullscreen;
    CGRect _originalImageViewFrame;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIView * transparentBackgroundView;

@property (strong, nonatomic) UIImageView *imageViewBack;

@property (strong, nonatomic) UIPanGestureRecognizer * panGR;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _fullscreen = NO;
    
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(toogleFullscreen:)];
    [_imageView addGestureRecognizer:tapGR];
    
    self.panGR = [[UIPanGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(panImage:)];
    [_imageView addGestureRecognizer:self.panGR];
    
    self.transparentBackgroundView = [self p_createTrasnsparentBackgroundView];
    
    _mainView.frame = [UIScreen mainScreen].bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Status Bar

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden {
    return _fullscreen;
}

#pragma mark Actions

- (IBAction)toogleFullscreen:(id)sender {
    [self p_toogleFullscreen];
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

#pragma mark Private

- (void)p_toogleFullscreen {
    _fullscreen = !_fullscreen;
    if (_fullscreen) {
        self.panGR.enabled = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        self.imageViewBack = _imageView;
        _originalImageViewFrame = _imageView.frame;
        [_imageView removeFromSuperview];
        [self.transparentBackgroundView addSubview:self.imageViewBack];
        
        [UIView transitionWithView:self.view
                          duration:0.25
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.mainView.transform = CGAffineTransformMakeScale(.9, .9);
                            [self.view addSubview:self.transparentBackgroundView];
                            self.imageViewBack.center = CGPointMake(CGRectGetMidX(self.transparentBackgroundView.bounds),
                                                                    CGRectGetMidY(self.transparentBackgroundView.bounds));
                            CGRect bounds = self.imageViewBack.bounds;
                            bounds.size = CGSizeMake(bounds.size.width * 2, bounds.size.height * 2);
                            self.imageViewBack.bounds = bounds;
                            self.mainView.alpha = 0.3;
                        }
                        completion:nil];
        
    } else {
        self.panGR.enabled = YES;
        
        [UIView transitionWithView:self.view
                          duration:0.25
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.mainView.transform = CGAffineTransformIdentity;
                            _imageView.frame = _originalImageViewFrame;
                            self.mainView.alpha = 1.0;
                        }
                        completion:^(BOOL finished) {
                            [self setNeedsStatusBarAppearanceUpdate];
                            [self.imageViewBack removeFromSuperview];
                            [self.transparentBackgroundView removeFromSuperview];
                            [self.mainView addSubview:self.imageViewBack];
                        }];
    }
    
    /*
     CGAffineTransform transform = _fullscreen ?
     CGAffineTransformMakeScale(.9, .9) : CGAffineTransformIdentity;
     
     [UIView transitionWithView:self.view
     duration:0.25
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
     self.mainView.transform = transform;
     if (_fullscreen) {
     [self.view addSubview:self.transparentBackgroundView];
     self.imageViewBack.center = CGPointMake(CGRectGetMidX(self.transparentBackgroundView.bounds),
     CGRectGetMidY(self.transparentBackgroundView.bounds));
     CGRect bounds = self.imageViewBack.bounds;
     bounds.size = CGSizeMake(bounds.size.width * 2, bounds.size.height * 2);
     self.imageViewBack.bounds = bounds;
     self.mainView.alpha = 0.3;
     } else {
     _imageView.frame = _originalImageViewFrame;
     self.mainView.alpha = 1.0;
     }
     }
     completion:^(BOOL finished) {
     if (!_fullscreen) {
     [self setNeedsStatusBarAppearanceUpdate];
     [self.imageViewBack removeFromSuperview];
     [self.transparentBackgroundView removeFromSuperview];
     [self.mainView addSubview:self.imageViewBack];
     }
     }];
     */
}


- (UIView *)p_createTrasnsparentBackgroundView {
    UIView * view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.opaque = NO;
    
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(toogleFullscreen:)];
    [view addGestureRecognizer:tapGR];
    return view;
}

@end
