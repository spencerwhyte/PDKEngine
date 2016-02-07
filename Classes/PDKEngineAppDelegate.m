//
//  PDKEngineAppDelegate.m
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PDKEngineAppDelegate.h"
#import "EAGLView.h"

@implementation PDKEngineAppDelegate

@synthesize window;
@synthesize viewController;



- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	glView.animationInterval = 1.0 / 60.0;
	[glView startAnimation];
    
    
    
    
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    	glView.animationInterval = 1.0 / 5.0;
    [viewController stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    	glView.animationInterval = 1.0 / 60.0;
    [viewController startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [viewController stopAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Handle any foreground procedures not related to animation here.
}

- (void)dealloc
{
    [viewController release];
    [window release];
    
    [super dealloc];
}

@end
