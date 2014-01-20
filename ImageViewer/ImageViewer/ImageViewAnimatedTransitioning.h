//
//  ImageViewAnimatedTransitioning.h
//  ImageViewer
//
//  Created by Ariel Cardieri on 20/01/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageViewAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;

@end
