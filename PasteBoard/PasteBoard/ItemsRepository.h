//
// Created by Ariel Cardieri on 13/02/14.
// Copyright (c) 2014 Forcha. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemsRepository : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)retriveItems;

- (BOOL)saveItems:(NSArray *)items;

@end