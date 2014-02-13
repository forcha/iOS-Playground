//
// Created by Ariel Cardieri on 13/02/14.
// Copyright (c) 2014 Forcha. All rights reserved.
//

#import "Item.h"


@implementation Item {

}

static const NSString * kItemContentKey = @"content";

- (instancetype)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        self.content = content;
    }

    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    return [self initWithCoder:[coder decodeObjectForKey:kItemContentKey]];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.content forKey:kItemContentKey];
}

@end