//
//  Networking.m
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Networking.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <CFNetwork/CFSocketStream.h>
#include <sys/socket.h>
#include <netinet/in.h>
#import "GameLogic.h"

@implementation Networking


void TCPServerAcceptCallBack2(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) { // Server/Host
	
	if(type == kCFSocketWriteCallBack){
		int socket2 = CFSocketGetNative(socket);
		write(socket2, 	[[[GameLogic getCurrentGame] getLocalPlayer] getNetworkData], sizeof(float)*6);
		CFSocketEnableCallBacks(socket, kCFSocketReadCallBack);

	//	NSLog(@"SERVER WRITE CORRECTLY");
	}
	
	
	if(type ==kCFSocketReadCallBack){
		
		read(CFSocketGetNative(socket), [[[[GameLogic getCurrentGame] getOtherPlayers] objectAtIndex:0] getNetworkData], 6*sizeof(float));
		CFSocketEnableCallBacks(socket, kCFSocketWriteCallBack);

	}
	
    NSLog(@"type %d", type);

}

static void joinCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) { //Client
	
	if(type == kCFSocketAcceptCallBack){
		NSLog(@"ACCEPT JOIN CALLBACK");
	}
	
    
    
	if(type ==kCFSocketReadCallBack){
		
		read(CFSocketGetNative(socket), [[[[GameLogic getCurrentGame] getOtherPlayers] objectAtIndex:0] getNetworkData], 6*sizeof(float));
		CFSocketEnableCallBacks(socket, kCFSocketWriteCallBack);
        
        
	//	NSLog(@"CLIENT READ CORRECTLY");
		
        
	}
	
	if(type ==kCFSocketWriteCallBack){
            int socket2 = CFSocketGetNative(socket);
            write(socket2, 	[[[GameLogic getCurrentGame] getLocalPlayer] getNetworkData], sizeof(float)*6);
            CFSocketEnableCallBacks(socket, kCFSocketReadCallBack);
        
        
		//NSLog(@"CLIENT WRITE PROPERLY");
	}
    NSLog(@"type %d", type);
}

+(void)setTBR:(UIView*)t{
	tbr =t;	
}

void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
	if(type == kCFSocketAcceptCallBack){
		Player *p = [[Player alloc] initWithName:@"OTHER PLAYER"];
		[GameLogic startGame];
		[[[GameLogic getCurrentGame] getOtherPlayers] addObject:p];
		[p release];
		[tbr removeFromSuperview];
		CFSocketNativeHandle nsh = *(CFSocketNativeHandle *)data;

		CFSocketContext socketCtxt = {0, NULL, NULL, NULL, NULL};
		CFSocketRef ct= CFSocketCreateWithNative(kCFAllocatorDefault, nsh , kCFSocketReadCallBack|kCFSocketWriteCallBack, (CFSocketCallBack)&TCPServerAcceptCallBack2, &socketCtxt);
		CFRunLoopRef cfrl = CFRunLoopGetCurrent();
		CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, ct, 0);
		CFRunLoopAddSource(cfrl, source4, kCFRunLoopCommonModes);
		CFRelease(source4);

		NSLog(@"SERVER ACCEPT CALLBACK");
	}if(type ==kCFSocketReadCallBack){
	
		NSLog(@"SERVER READ CALLBACK");
	}
	if(type ==kCFSocketReadCallBack){

	}
	
//	NSLog(@"type %d", type);
}




+(void)publishService{
	NSLog(@"ccs");

	struct sockaddr_in serverAddress;
	int listenfd, connectfd;
	if ( (listenfd = socket( PF_INET, SOCK_STREAM, 0 )) < 0 ) {
		perror( "socket" );
		exit(1);
	}
	
	bzero( &serverAddress, sizeof(serverAddress) );
	serverAddress.sin_family = PF_INET;
	serverAddress.sin_port = htons(12345);
	serverAddress.sin_addr.s_addr = htonl( INADDR_ANY );
	
	if ( bind( listenfd, (struct sockaddr *)&serverAddress, 
			  sizeof(serverAddress) ) < 0 ) {
		perror( "bind" );
		exit(1);
	}
	
	if ( listen( listenfd, 5 ) < 0 ) {
		perror( "listen" );
		exit(1);
	}
	printf("%d\n\n\n", listenfd);
	CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};
	CFSocketRef ct= CFSocketCreateWithNative(kCFAllocatorDefault, listenfd, kCFSocketAcceptCallBack, (CFSocketCallBack)&TCPServerAcceptCallBack, &socketCtxt);
	CFRunLoopRef cfrl = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, ct, 0);
    CFRunLoopAddSource(cfrl, source4, kCFRunLoopCommonModes);
    CFRelease(source4);

	
	netService = [[NSNetService alloc] initWithDomain: @"local." type:@"_PDK._tcp." name:@"" port:12345];
 
    [netService setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:[NSDictionary dictionaryWithObject:mapNameID forKey:@"MapName"]]];
    
	[netService setDelegate:self] ;
	[netService publish];
	
}

+(NSNetService*)getService{
	
	return netService;	
}

+(void) netServiceWillPublish:(NSNetService *)sender{
	NSLog(@"WILL PUBLISH");
}
+(void)connect:(NSNetService*)sender{
	Player *p = [[Player alloc] initWithName:[sender name]];
	[GameLogic startGame];
	[[[GameLogic getCurrentGame] getOtherPlayers] addObject:p];
	[p release];
	
	int sockfd = socket( PF_INET, SOCK_STREAM, 0 );
	CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};
	connect( sockfd, [[[sender addresses] objectAtIndex:0] bytes], [[[sender addresses] objectAtIndex:0] length] );
	//printf("\n%d\n\n\n", sockfd);
	CFSocketRef ct = CFSocketCreateWithNative(kCFAllocatorDefault, sockfd, kCFSocketReadCallBack | kCFSocketWriteCallBack, (CFSocketCallBack)&joinCallBack,  &socketCtxt);
	CFRunLoopRef cfrl = CFRunLoopGetCurrent();
	CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, ct,0);
	CFRunLoopAddSource(cfrl, source4, kCFRunLoopCommonModes);
	CFRelease(source4);
	[netService stop];
}


@end
