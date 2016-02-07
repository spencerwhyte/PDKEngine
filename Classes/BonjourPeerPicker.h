//
//  BonjourPeerPicker.h
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Networking.h"
#import "EAGLView.h"

@interface BonjourPeerPicker : UITableViewController<NSNetServiceBrowserDelegate, NSNetServiceDelegate, NSStreamDelegate> {
	NSMutableArray *hosts;
    NSMutableArray *maps;
    NSNetService * currentNet;
    NSNetServiceBrowser * currentBrowser;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(id)initWithStyle:(UITableViewStyle)s;
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing;
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing;
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (void)netServiceDidResolveAddress:(NSNetService *)sender;
- (void)netServiceWillResolve:(NSNetService *)sender;
- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data;
- (void)netServiceDidResolveAddress:(NSNetService *)sender;
@end
