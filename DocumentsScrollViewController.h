//
//  DocumentsScrollViewController.h
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigationController.h"
#import "ModeSelectorController.h"

@interface DocumentsScrollViewController : UITableViewController{
	NSArray *fileNames;
	NSArray *fileSizes;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(id)initWithStyle:(UITableViewStyle)style;
-(void)viewDidLoad;
@end
