//
//  GameLogic.h
//  PDKEngine
//
//  Created by Spencer Whyte on 11-01-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Game : NSObject {
	Player *localPlayer;
	NSMutableArray *otherPlayers;
}
-(id)init;
-(void)addPlayer:(Player*)p;
-(NSMutableArray*)getOtherPlayers;
-(Player*)getLocalPlayer;
@end
