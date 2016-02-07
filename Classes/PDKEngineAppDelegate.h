//
//  PDKEngineAppDelegate.h
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EAGLView;
@class PDKEngineViewController;

@interface PDKEngineAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
       EAGLView *glView;
    PDKEngineViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PDKEngineViewController *viewController;

@end

