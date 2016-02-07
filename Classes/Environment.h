//
//  Environment.h
//  PDKEngine
//
//  Created by Spencer Whyte on 11-04-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
@class Map;
static Map * map;
@interface Environment : NSObject {
@private


}

+(Map*)getMap;
+(void)setMap:(Map*)m;
@end
