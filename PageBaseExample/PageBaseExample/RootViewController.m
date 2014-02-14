//
//  RootViewController.m
//  PageBaseExample
//
//  Created by Ariel Cardieri on 14/02/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController () <UIPageViewControllerDelegate> // , UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController * pageViewController;

@property (nonatomic, strong) NSArray * pages;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pages = @[@"PhotoPickerViewController", @"DetailViewController", @"PreviewViewController", @"ShareViewController"];


    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;
//    self.pageViewController.dataSource = self;

    UIViewController *startingViewController = [self viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
//    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.pages count] == 0) || (index >= [self.pages count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:self.pages[index]];
    return viewController;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pages indexOfObject:viewController.title];
}

- (void)nextViewController:(NSUInteger)index direction:(UIPageViewControllerNavigationDirection)direction {
    UIViewController *viewController = [self viewControllerAtIndex:index storyboard:self.storyboard];
    NSArray *viewControllers = @[viewController];
    [self.pageViewController setViewControllers:viewControllers direction:direction animated:YES completion:nil];
}

#pragma mark - UIPageViewController delegate methods

//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//    NSLog(@"before");
//    NSUInteger index = [self indexOfViewController:viewController];
//    if ((index == 0) || (index == NSNotFound)) {
//        return nil;
//    }
//
//    if (index == 3) {
//        return nil;
//    }
//
//    index--;
//    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
//    return nil;
//}

//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//    NSLog(@"after");
//    NSUInteger index = [self indexOfViewController:viewController];
//    if (index == NSNotFound) {
//        return nil;
//    }
//
//    if (index == 0) {
//        return nil;
//    }
//
//    if (index == 2) {
//        return nil;
//    }
//
//    index++;
//    if (index == [self.pages count]) {
//        return nil;
//    }
//    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
//    return nil;
//}

#pragma mark - Actions

- (void)cameraButtonPressed:(id)sender {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)libraryButtonPressed:(id)sender {
    [self cameraButtonPressed:sender];
}

- (void)acceptPhotoPressed:(id)sender {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        [self nextViewController:1 direction:UIPageViewControllerNavigationDirectionForward];
    }];
}

- (void)cancelPhotoPressed:(id)sender {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)detailNextButtonPressed:(id)sender {
    [self nextViewController:2 direction:UIPageViewControllerNavigationDirectionForward];
}

- (void)detailBackButtonPressed:(id)sender {
    [self nextViewController:0 direction:UIPageViewControllerNavigationDirectionReverse];
}

- (void)shareButtonPressed:(id)sender {
    [self nextViewController:3 direction:UIPageViewControllerNavigationDirectionForward];
}

- (void)previewBackButtonPressed:(id)sender {
    [self nextViewController:1 direction:UIPageViewControllerNavigationDirectionReverse];
}

- (void)newButtonPressed:(id)sender {
    [self nextViewController:0 direction:UIPageViewControllerNavigationDirectionReverse];
}

@end
