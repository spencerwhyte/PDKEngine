//
//  HUD.h
//  MC
//
//  Created by spencer whyte on 23/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Loader.h"

//#import "Medal.h"


#include <mach/mach.h>
#include <mach/mach_time.h>


@interface HUD : NSObject {

}
+ (void)loadData;
+(void)draw;
+(void)setHealth: (float)h;
+(void)setLoaded: (bool)l;
+(void)setPrimaryWeapon:(id)weapon;
+(void)setSecondaryWeapon:(id)weapon;
+(id)getPrimaryWeapon;
+(id)getSecondaryWeapon;
+(void)awardMedal:(int)medalID;
+(void)enemyInSight;
+(void)enemyOutOfSight;
+(void)friendlyInSight;
+(void)friendlyOutOfSight;
+(void)saveReferenceToLocalPlayer;
+(void)postMessage:(NSString*)message;
+(void)setControlStickLocationX:(float)x LocationY:(float)y;
+(void)setControlStickDown:(bool)down;
+(void)setLookStickLocationX:(float)x LocationY:(float)y;
+(void)setLookStickDown:(bool)down;
@end
HUD *delegateO;