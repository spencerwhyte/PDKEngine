//
//  BonjourPeerPicker.m
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BonjourPeerPicker.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <CFNetwork/CFSocketStream.h>
#include <sys/socket.h>
#include <netinet/in.h>


@implementation BonjourPeerPicker
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"Updating cell");
	static NSString *kCustomCellID = @"CustomCellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID] autorelease];
	}
	int k = [indexPath indexAtPosition:1];
//	NSLog(@"%@zzzsda", [[hosts objectAtIndex:k] hostName]);
	cell.textLabel.text = [[hosts objectAtIndex:k] name];
    cell.detailTextLabel.text =  [maps objectAtIndex:k];
	return cell;
}

-(id)initWithStyle:(UITableViewStyle)s{
	if(self = [super initWithStyle:s]){
		NSLog(@"HERE");
		currentBrowser= [[NSNetServiceBrowser alloc] init];
		[currentBrowser setDelegate:self];
		[currentBrowser searchForServicesOfType:@"_PDK._tcp." inDomain:@""];
		hosts = [[NSMutableArray alloc] init];
        maps = [[NSMutableArray alloc] init];
		[self setTitle:@"Friends"];
 
        currentNet = nil;
	}
	return self;
}





- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing{
	if(![[netService name] isEqualToString:[[Networking getService]name]]){
		[netService retain];
   
		[hosts addObject: netService];
        [maps addObject:@"Unknown Map"];
        [netService resolveWithTimeout:5];
        [netService setDelegate:self];
		NSLog(@"Getting cell %d ",[hosts count]);
		[self.tableView reloadData];
	}
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent{
	NSLog(@"shf");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    	int k = [indexPath indexAtPosition:1];
    if([[maps objectAtIndex:k] isEqualToString:mapNameID]){
        NSNetService* n = [hosts objectAtIndex:k];
    	[[[self navigationController] view]removeFromSuperview];
        for(int i = 0 ; i < [hosts count]; i++){
            [[hosts objectAtIndex:i] setDelegate:nil];
        }
        [currentBrowser setDelegate:nil];
        [currentBrowser release];
        
       
        [Networking connect:n];
    }
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing{
	NSLog(@"removing it");
    //[maps objectAtIndex:[hosts indexOfObject:netService]];
	[hosts removeObject:netService];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSLog(@"Getting cell count %d",[hosts count]);
	int k =[hosts count];
	return k;	
}




- (void)netServiceDidResolveAddress:(NSNetService *)sender{
    if(currentNet == sender){

	}else{

        NSDictionary * dictionary  = [NSNetService dictionaryFromTXTRecordData:[sender TXTRecordData] ];
     
        NSString * mapString2 =    [[NSString alloc] initWithData:[dictionary objectForKey:@"MapName"] encoding:NSASCIIStringEncoding];
        [maps replaceObjectAtIndex:[hosts indexOfObject:sender] withObject:mapString2];
        [self.tableView reloadData];
        
        [mapString2 release];
    }
}



@end
