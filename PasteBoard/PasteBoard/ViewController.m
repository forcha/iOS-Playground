//
//  ViewController.m
//  PasteBoard
//
//  Created by Ariel Cardieri on 12/02/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import "ViewController.h"
#import "ItemsRepository.h"

@interface ViewController ()

@property(nonatomic, strong) NSMutableArray * items;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.items = [[[ItemsRepository sharedInstance] retriveItems] mutableCopy];

    [self updateFromPasteboard:NO];
}

- (BOOL)saveItems {
    return [[ItemsRepository sharedInstance] saveItems:self.items];
}

- (void)updateFromPasteboard:(BOOL)reloadTable {
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    NSLog(@"pasteboard = %@", pasteboard);
    NSLog(@"pasteboard.numberOfItems = %d", pasteboard.numberOfItems);


    if (pasteboard.numberOfItems > 0) {
        NSLog(@"pasteboard.items[0] = %@", [pasteboard.items[0] description]);
        if ([pasteboard containsPasteboardTypes:@[@"public.plain-text"]]) {
            NSLog(@"[pasteboard strings] = %@", [[pasteboard strings] description]);
            NSString * item = [pasteboard string];
            if (![self.items containsObject:item]) {
                [self.items insertObject:[pasteboard string] atIndex:0];
                if (reloadTable) {
                    [self.tableView reloadData];
                }
            }
        } else {
//            self.label.text = @"";
            NSLog(@"Nothing to add");
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}


@end
