//
//  GameLogic.m
//  PDKEngine
//
//  Created by Spencer Whyte on 11-01-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"


@implementation Game

-(id)init{
	if(self = [super init]){
		localPlayer = [[Player alloc] initWithName:@"localPlayer"];
		otherPlayers = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)addPlayer:(Player*)p{
	[otherPlayers addObject:p];	
}

-(NSMutableArray*)getOtherPlayers{
	return otherPlayers;	
}

-(Player*)getLocalPlayer{
	return localPlayer;
}

@end
