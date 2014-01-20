//
//  MainViewController.m
//  ImageViewer
//
//  Created by Ariel Cardieri on 17/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "MainViewController.h"
#import "ImageViewController.h"
#import "ImageViewTransitioningDelegate.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) ImageViewTransitioningDelegate * imageViewTD;

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

    self.imageViewTD = [ImageViewTransitioningDelegate new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//- (BOOL)prefersStatusBarHidden {
//    NSLog(@"main prefersStatusBarHidden called");
//    return NO;
//}

#pragma mark - Action

- (IBAction)toogleFullscreen:(id)sender {
    ImageViewController * vc = [ImageViewController new];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalPresentationCapturesStatusBarAppearance = YES;
    vc.transitioningDelegate = _imageViewTD;
    vc.imageToDisplay = _imageView;
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"finished presenting VC");
    }];
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
