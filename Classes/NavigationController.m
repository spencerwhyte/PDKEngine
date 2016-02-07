//
//  NavigationController.m
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NavigationController.h"


@implementation NavigationController

-(void)viewDidLoad{
    [Networking setTBR:[self view]];
}

@end
