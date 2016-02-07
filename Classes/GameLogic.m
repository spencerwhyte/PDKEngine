//
//  GameLogic.m
//  PDKEngine
//
//  Created by Spencer Whyte on 11-01-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLogic.h"


@implementation GameLogic

+(void)startGame{
    gameInProgress = YES;
	currentGame = [[Game alloc] init];	
}

+(void)endGame{
    gameInProgress = NO;
	[currentGame release];
}

+(Game*)getCurrentGame{
	return currentGame;	
}
+(BOOL)getGameInProgress{
    return gameInProgress;
}
@end
