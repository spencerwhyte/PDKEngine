//
//  ModeSelectorController.h
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BonjourPeerPicker.h"
#import "Networking.h"
#import "Map.h"
#import "EAGLView.h"


static UIImageView *defaultImageView;


@interface ModeSelectorController : UIViewController {
	UIImageView *imageView;
}
-(id)initWithPath:(NSString *)path;
+(void)loadDefaultImage;
-(void)join:(id)sender;
-(void)host:(id)sender;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(void)dealloc;
@end
