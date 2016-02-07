//
//  Networking.h
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "EAGLView.h"
static NSNetService * netService;
static UIView* tbr;


@interface Networking : NSObject<NSNetServiceDelegate> {

}
+(void)publishService;
+(void) netServiceWillPublish:(NSNetService *)sender;
+(NSNetService*)getService;
+(void)connect:(NSNetService*)sender;
+(void)setTBR:(UIView*)t;
@end
