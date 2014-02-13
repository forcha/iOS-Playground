//
//  ViewController.h
//  PasteBoard
//
//  Created by Ariel Cardieri on 12/02/14.
//  Copyright (c) 2014 Forcha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController

- (BOOL)saveItems;

- (void)updateFromPasteboard:(BOOL)reloadTable;

@end
