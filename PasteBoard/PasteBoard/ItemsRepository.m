//
// Created by Ariel Cardieri on 13/02/14.
// Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ItemsRepository.h"


@implementation ItemsRepository {

}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ItemsRepository * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ItemsRepository alloc] init];
    });

    return instance;
}

- (NSArray *)retriveItems {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * filePath = [self itemsFilePath];
    NSArray * items;
    if ([fileManager fileExistsAtPath:filePath.path]) {
        NSData * data = [[NSData alloc] initWithContentsOfURL:filePath];
        items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        items = [NSArray array];
    }

    return items;
}

- (BOOL)saveItems:(NSArray *)items {
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:items];
    NSURL * filePath = [self itemsFilePath];
    NSError * error = nil;
    BOOL result = [data writeToURL:filePath options:0 error:&error];
    if (!result) {
        NSLog(@"error = %@", error);
    }
//    return [data writeToURL:filePath atomically:NO];

    return result;
}

#pragma mark - Private

- (NSURL *)itemsFilePath {
    NSURL * documentsDirectoryURL = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    return [documentsDirectoryURL URLByAppendingPathComponent:@"items.data"];
}

@end