//
//  GameLogic.h
//  PDKEngine
//
//  Created by Spencer Whyte on 11-01-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

static 	Game *currentGame;
static BOOL gameInProgress;
@interface GameLogic : NSObject {

}
+(Game*)getCurrentGame;
+(void)startGame;
+(void)endGame;
+(BOOL)getGameInProgress;
@end
