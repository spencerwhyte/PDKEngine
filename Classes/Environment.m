//
//  Environment.m
//  PDKEngine
//
//  Created by Spencer Whyte on 11-04-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Environment.h"


@implementation Environment

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}



+(Map*)getMap{
        NSLog(@"PARMESAN %d", [[map getImageAssets] count]);
    return map;   
}
+(void)setMap:(Map*)m{
    if(map !=nil){
        [map release];
    }
    map = m;
    NSLog(@"PARMESAN2 %d", [[map getImageAssets] count]);
    [map retain];
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
