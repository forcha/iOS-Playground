//
// Created by Ariel Cardieri on 13/02/14.
// Copyright (c) 2014 Forcha. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Item : NSObject <NSCoding>

@property (nonatomic, copy) NSString * content;

- (instancetype)initWithContent:(NSString *)content;

@end