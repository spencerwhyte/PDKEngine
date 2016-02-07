//
//  EAGLView.h
//  MC
//
//  Created by spencer whyte on 11/07/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <Foundation/Foundation.h>
#import <time.h>
#import "Map.h"
#import "HUD.h"
#import "NavigationController.h"
#import "Networking.h"

#import "GameLogic.h"
#import "Player.h"
@class NavigationController;
@class Map;
//#import "Oddball.h"
/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
static int fer;

int gameState;
NSString * mapNameID;
NSString * pathToMap;

@interface EAGLView : UIView <UIAccelerometerDelegate> {
bool textureMapping;
	int loaded;
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    bool autoRotate;
    EAGLContext *context;
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    float rotation;
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
    //MasterChief *masterChief[8];
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	
    
    Player * currentLocalPlayer;
    GLfloat * currentLocalPlayerPositionPointer;

	float modifier;

	Map * map;
	int first;
    //int gameState; // 0 For normal game play, 2 for menu, 1 for loading

	NSMutableArray *networkPlayers;


	float menuRotation;
	float previousStickLocationX;
	float previousStickLocationY;
	bool movementTouchDown;

	float previousLookLocationX;
	float previousLookLocationY;
	bool lookTouchDown;
	
	bool accelerometerControls;
    
 IBOutlet   NavigationController * navigationController;
	
}
@property bool textureMapping;
@property NSTimeInterval animationInterval;
//@property int gameState;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;
-(void)loadEverything;
-(void)setupView;
- (void)loadTexture:(NSString *)fileName forIndex:(int)index;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration;
-(void)loadMap;
-(void)unloadMap;
-(void)preMenuFinished;
@end
