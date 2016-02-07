//
//  DocumentsScrollViewController.m
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DocumentsScrollViewController.h"

@implementation DocumentsScrollViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *kCustomCellID = @"CustomCellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID] autorelease];
	}
	int k = [indexPath indexAtPosition:1];
	NSLog(@"%d", k);
	cell.textLabel.text = [fileNames objectAtIndex:k];
	unsigned long g= [[fileSizes objectAtIndex:k] unsignedLongLongValue];
	if(g< 1000){
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d bytes", g ];
	}else if(g<1000000){
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.1f kilobytes", g/1000.0 ];
	}else{
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.1f megabytes", g/1000000.0 ];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
   	int k = [indexPath indexAtPosition:1];
	UINavigationController * c = self.navigationController;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString * temp = [NSString stringWithFormat:@"%@/%@", documentsDirectory, [fileNames objectAtIndex:k]]; 
	ModeSelectorController *d= [[ModeSelectorController alloc] initWithPath: temp];
    [temp retain];
	//[temp release];
	d.title = [fileNames objectAtIndex:k];
	[c pushViewController:d animated:YES]; 
	[d release];
}
-(void)viewDidLoad{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@", documentsDirectory);
    fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    
    [fileNames retain];
    //NSLog(@"%@",[NSString stringWithFormat:@"%@/%@", documentsDirectory, [fileNames objectAtIndex:0]]);
    NSMutableArray * tempSizes= [[NSMutableArray alloc] init];
    for(int k = 0; k < [fileNames count]; k++){
        unsigned long long g= [[[NSFileManager defaultManager]attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, [fileNames objectAtIndex:k]] error:NULL ] fileSize];
        [tempSizes addObject:[NSNumber numberWithUnsignedLongLong:g]];
    }
    fileSizes = [[NSArray alloc] initWithArray:tempSizes];
    [tempSizes release];
  //  for(int i =0 ; i < []){
        
  //  }
    
    [ModeSelectorController loadDefaultImage];
    [self setTitle:@"Maps"];

}
-(id)initWithStyle:(UITableViewStyle)style{
    NSLog(@"sdfsdf");
	if(self = [super initWithStyle:style]){
		}
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSLog(@"Called");
	int k =[fileNames count];
	return k;	
}
@end
