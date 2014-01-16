//
//  ViewController.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 16/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate> {
    BOOL _fullscreen;
    CGRect _originalImageViewFrame;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIScrollView * transparentBackgroundView;

//@property (strong, nonatomic) UIImageView *imageViewBack;

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
    
//    self.transparentBackgroundView = [self p_createTrasnsparentBackgroundView];
    
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

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [_transparentBackgroundView viewWithTag:999];
}

#pragma mark Private

- (void)p_toogleFullscreen {
    _fullscreen = !_fullscreen;
    if (_fullscreen) {
        _originalImageViewFrame = _imageView.frame;
        self.transparentBackgroundView = [self p_createTrasnsparentBackgroundViewWithImage:_imageView];
        
        [self setNeedsStatusBarAppearanceUpdate];
        //self.panGR.enabled = NO;
//        _imageView.hidden = YES;
//        [_imageView removeFromSuperview];
//        _transparentBackgroundView.zoomScale = 1.0;
//        [_transparentBackgroundView addSubview:self.imageViewBack];
        
        [self.view addSubview:self.transparentBackgroundView];
        
        [UIView transitionWithView:self.view
                          duration:0.25
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.mainView.transform = CGAffineTransformMakeScale(.9, .9);
                            
//                            [_transparentBackgroundView viewWithTag:999].center = CGPointMake(CGRectGetMidX(_transparentBackgroundView.bounds),
//                                                                    CGRectGetMidY(_transparentBackgroundView.bounds));
//                            CGRect bounds = [_transparentBackgroundView viewWithTag:999].bounds;
//                            bounds.size = CGSizeMake(bounds.size.width * 2, bounds.size.height * 2);
//                            [_transparentBackgroundView viewWithTag:999].bounds = bounds;
                            [_transparentBackgroundView viewWithTag:999].frame = _transparentBackgroundView.bounds;
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
//                            _imageView.frame = _originalImageViewFrame;
                            [_transparentBackgroundView viewWithTag:999].frame = _originalImageViewFrame;
//                            _transparentBackgroundView.zoomScale = 1.0;
                            self.mainView.alpha = 1.0;
                            _transparentBackgroundView.alpha = 0.0;
                        }
                        completion:^(BOOL finished) {
                            [self setNeedsStatusBarAppearanceUpdate];
//                            [self.imageViewBack removeFromSuperview];
                            [self.transparentBackgroundView removeFromSuperview];
//                            [self.mainView addSubview:self.imageViewBack];
//                            _imageView.hidden = NO;
                        }];
    }
}


- (UIScrollView *)p_createTrasnsparentBackgroundViewWithImage:(UIImageView *)imageView {
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    view.opaque = NO;
    view.minimumZoomScale = 1.0;
    view.maximumZoomScale = 2.0;
    view.delegate = self;
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(toogleFullscreen:)];
    [view addGestureRecognizer:tapGR];
    
    UIImageView * viewerImageView = [[UIImageView alloc] initWithImage:imageView.image];
    viewerImageView.tag = 999;
    viewerImageView.contentMode = UIViewContentModeScaleAspectFit;
    viewerImageView.frame = imageView.frame;
    [view addSubview:viewerImageView];
    return view;
}

@end
