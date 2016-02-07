//
//  EAGLView.m
//  MC
//
//  Created by spencer whyte on 11/07/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"

#define USE_DEPTH_BUFFER 1
#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)
void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez, GLfloat centerx,
			   GLfloat centery, GLfloat centerz, GLfloat upx, GLfloat upy,
			   GLfloat upz);
// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation EAGLView
@synthesize textureMapping;
@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    printf("Before everything is loaded\n\n\n\n");
    if ((self = [super initWithCoder:coder])) {
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
		[self setupView];
        
        
        
        
        
        
		animationInterval = 1.0 / 40.0;
        //	[Audio initAudio];
        //	[Menu loadData];
		UIAccelerometer *uia = [UIAccelerometer sharedAccelerometer];
		uia.delegate = self;
		uia.updateInterval = 1/50;
		loaded = 0;
		self.multipleTouchEnabled = YES;
		gameState = 5;
		accelerometerControls = false;
        
        [HUD loadData];
        [Player load];
        
        
        
        //   [self addSubview:navigationController.view];
        
        
		//mpc = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"preMenu" ofType:@"m4v"]]];
		//mpc.movieControlMode = MPMovieControlModeHidden;
		//mpc.scalingMode = MPMovieScalingModeAspectFill;
	    //[[NSNotificationCenter defaultCenter]addObserver: self selector: @selector(preMenuFinished)name: MPMoviePlayerPlaybackDidFinishNotification object: mpc];
		//[mpc play];
	    //	ap = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menuMusic" ofType:@"mp3"]] error:NULL];
		
        //	controlMethodSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50.0f, 50.0f, 0.0f, 0.0f)];
        //	controlMethodSwitch.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(3.1415926535/2.0f), CGAffineTransformMakeTranslation(0,480));
        //	controlMethodSwitch.on = true;
        //	controlMethodSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 45.0f, 0.0f, 0.0f)];
        //	[controlMethodSwitchLabel setTextAlignment:UITextAlignmentCenter];
        //	[controlMethodSwitchLabel setText: @"Use on screen controls for movement" ];
        //	controlMethodSwitchLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(3.1415926535/2.0f), CGAffineTransformMakeTranslation(0,0));
        //	controlMethodSwitchLabel.textColor= [UIColor whiteColor] ;
        //	[self addSubview:controlMethodSwitch];
        //	[self addSubview:controlMethodSwitchLabel];
        //   [self addSubview:<#(UIView *)#>];
        currentLocalPlayer= nil;
    }
	NSLog(@"%f, %f", self.frame.size.width, self.bounds.size.width);
    return self;
}

-(void)preMenuFinished{
    //	[mpc release];
    //	[ap play];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
    /*
     if(gameState == 0){
     if(!controlMethodSwitch.on){
     if (acceleration.z < -0.92f){
     primaryPlayer.forward = true;
     primaryPlayer.backward = false;
     primaryPlayer.movementFB = (acceleration.z *-1) - 0.92;
     }else if(acceleration.z > -0.88f){
     primaryPlayer.backward = true;
     primaryPlayer.forward = false;
     primaryPlayer.movementFB = 0.88-(acceleration.z *-1);
     }else{
     primaryPlayer.forward = false;
     primaryPlayer.backward = false;
     primaryPlayer.movementFB = 0.0f;
     }
     
     if(acceleration.y > 0.1){
     primaryPlayer.moveLeft = true;
     primaryPlayer.moveRight = false;
     primaryPlayer.movementLR = acceleration.y -0.1;
     }else if(acceleration.y < -0.1){
     primaryPlayer.moveRight = true;
     primaryPlayer.moveLeft = false;
     primaryPlayer.movementLR = (acceleration.y *-1)-0.1;
     }else{
     primaryPlayer.moveRight = false;
     primaryPlayer.moveLeft = false;
     primaryPlayer.movementLR = 0.0f;
     }
     }
     
     
     }
     */
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
	if(gameState == 0&&        [GameLogic getGameInProgress ]){
		
		NSArray* allTouches = [touches allObjects];
		for(int i = 0 ; i < [allTouches count]; i++){
			float x = [[allTouches objectAtIndex:i] locationInView:self].x;
			float y = [[allTouches objectAtIndex:i] locationInView:self].y;
            //NSLog(@"%f,%f",x,y );
			if(x > 220 ){ // Up
				if(y < 360){
                    
					//if(primaryPlayer.speedY == 0){
					//	primaryPlayer.speedY = 0.5f;
					//}
                    
				}else{
					//id temp  =  [HUD getPrimaryWeapon];
					//[HUD setPrimaryWeapon:[HUD getSecondaryWeapon]];
                    //	[HUD setSecondaryWeapon:temp];
                    
					//[HUD awardMedal:rand() % 55];
				}
			}else if(x < 120){ // Down
                //	[[HUD getPrimaryWeapon] fire];
                //	[primaryPlayer fireWeapon];
				//[[PlasmaGrenade alloc] initWithData:primaryPlayer.centerX goingy:primaryPlayer.centerZ startx:primaryPlayer.x starty:primaryPlayer.y startz:primaryPlayer.z];
			}
			if(x > 47 && x < 114 && y > 78 && y < 147){
				movementTouchDown = true;
			    previousStickLocationX = x;
				previousStickLocationY = y;
				//NSLog(@"%f,%f", previousStickLocationX,previousStickLocationY);
				[HUD setControlStickDown:true];
			}
			
			if(x > 0 && x < 214 && y > 180){
				lookTouchDown = true;
			    previousLookLocationX = x;
				previousLookLocationY = y;
                //	NSLog(@"%f,%f", previousLookLocationX,previousLookLocationY);
                //	[HUD setLookStickDown:true];
			}
			
			//else if(y < 250){ // left
			//	primaryPlayer.turnLeft = true;
			//}else if(y > 250){ // Right
			//	primaryPlayer.turnRight = true;
			//}
			
		}
		
	}else if(gameState == 2){
        //	[Menu touchesBegan:touches withEvent:event]; // Forward the event
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(gameState == 0 &&        [GameLogic getGameInProgress ]){
		NSArray* allTouches = [touches allObjects];
		for(int i = 0 ; i < [allTouches count]; i++){
			float x = [[allTouches objectAtIndex:i] locationInView:self].x;
			float y = [[allTouches objectAtIndex:i] locationInView:self].y;
			
			
			if( movementTouchDown && previousStickLocationX == [[allTouches objectAtIndex:i] previousLocationInView:self].x && previousStickLocationY == [[allTouches objectAtIndex:i] previousLocationInView:self].y){
				[HUD setControlStickLocationX:(y - 114)/550.0f LocationY:(x - 80)/550.0f];
				previousStickLocationX=x;
				previousStickLocationY=y;
				
				
				
                 currentLocalPlayer.forward = true;
                 currentLocalPlayer.backward = false;
                 currentLocalPlayer.movementFB =(x - 80)/550.0f;
                 
                 currentLocalPlayer.moveLeft = true;
                 currentLocalPlayer.movementLR =(y - 114)/-550.0f;
                 
				
			}else if( lookTouchDown && previousLookLocationX == [[allTouches objectAtIndex:i] previousLocationInView:self].x && previousLookLocationY == [[allTouches objectAtIndex:i] previousLocationInView:self].y){
				[HUD setLookStickLocationX:(y - 367)/550.0f LocationY:(x - 80.5)/550.0f];
				previousLookLocationX=x;
				previousLookLocationY=y;
				
                
                 currentLocalPlayer.turnRight = true;
                 currentLocalPlayer.turnLR = (y-[[allTouches objectAtIndex:i] previousLocationInView:self].y)/5.0f;
                 currentLocalPlayer.turnUD += (x-[[allTouches objectAtIndex:i] previousLocationInView:self].x)/1000.0f;
                 
                 
                 
			}else if(x > 220){ // Up
				if(y < 360){
					//if(primaryPlayer.speedY == 0){
					//	primaryPlayer.speedY = 2.5f;
					//}
				}else{
					
				}
			}else if(x < 120){ // Down
				//	backward = true;
			}
			
			//else if(y < 250){ // left
			//	primaryPlayer.moveLeft = true;
			//}else if(y > 250){ // Right
			//	primaryPlayer.turnRight = true;
			//}
			
		}
	}else if(gameState == 2){
        //	[Menu touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(gameState == 0&&        [GameLogic getGameInProgress ]){
		NSLog(@"Ended");
		//[[HUD getPrimaryWeapon] stopFire];
		//[primaryPlayer stopFireWeapon];
        //	primaryPlayer.turnLeft = false;
		//primaryPlayer.turnRight = false;
        
		NSArray* allTouches = [touches allObjects];
		for(int i = 0 ; i < [allTouches count]; i++){
			if( previousStickLocationX == [[allTouches objectAtIndex:i]  previousLocationInView:self].x && previousStickLocationY == [[allTouches objectAtIndex:i]  previousLocationInView:self].y){
				
                movementTouchDown = false;
                
				[HUD setControlStickDown:false];
                
                 currentLocalPlayer.forward= false;
                 currentLocalPlayer.backward = false;
                 currentLocalPlayer.moveLeft = false;
                 currentLocalPlayer.moveRight = false;
                 
			}
			if( previousStickLocationX == [[allTouches objectAtIndex:i]  locationInView:self].x && previousStickLocationY == [[allTouches objectAtIndex:i]  locationInView:self].y){
				movementTouchDown = false;
				[HUD setControlStickDown:false];
                
                 currentLocalPlayer.forward= false;
                 currentLocalPlayer.backward = false;
                 currentLocalPlayer.moveLeft = false;
                 currentLocalPlayer.moveRight = false;
                 
			}
			
			
			if(lookTouchDown && previousLookLocationX == [[allTouches objectAtIndex:i] previousLocationInView:self].x && previousLookLocationY == [[allTouches objectAtIndex:i] previousLocationInView:self].y){
				
				lookTouchDown = false;
			    [HUD setLookStickDown:false];
				//primaryPlayer.turnRight = false;
			}
			
			if(lookTouchDown && previousLookLocationX == [[allTouches objectAtIndex:i] locationInView:self].x && previousLookLocationY == [[allTouches objectAtIndex:i] locationInView:self].y){
				
				lookTouchDown = false;
			    [HUD setLookStickDown:false];
                //	primaryPlayer.turnRight = false;
			}
			
			
		}
	}else if(gameState == 2){
		//[Menu touchesEnded:touches withEvent:event];
	}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    /*
     if(gameState == 0&&        [GameLogic getGameInProgress ]){
     [[HUD getPrimaryWeapon] stopFire];
     [primaryPlayer stopFireWeapon];
     primaryPlayer.turnLeft = false;
     primaryPlayer.turnRight = false;
     NSArray* allTouches = [touches allObjects];
     for(int i = 0 ; i < [allTouches count]; i++){
     if(previousStickLocationX == [[allTouches objectAtIndex:i] previousLocationInView:self].x && previousStickLocationY == [[allTouches objectAtIndex:i] previousLocationInView:self].y){
     movementTouchDown = false;
     [HUD setControlStickDown:false];
     primaryPlayer.forward= false;
     primaryPlayer.backward = false;
     primaryPlayer.moveLeft = false;
     primaryPlayer.moveRight = false;
     }
     }
     }else if(gameState == 2){
     [Menu touchesEnded:touches withEvent:event];
     }
     */
	
}


-(void)loadEverything{
	
}



-(void)loadMap:(NSString*)mapName{
    
}

//-(void)unloadMap(NSString*)mapName{

//}

NSDate *startDate;

int frames;
- (void)drawView {
    
	if(gameState == 0){ // Regular game play
        if([GameLogic getGameInProgress ]){
            
            [EAGLContext setCurrentContext:context];
            glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            glViewport(0, 0, backingWidth, backingHeight);
            glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
            glMatrixMode(GL_MODELVIEW);
            //	glEnableClientState(GL_NORMAL_ARRAY);
           // glLoadIdentity();
            glPushMatrix();
            
            
            if(currentLocalPlayer == nil){
                currentLocalPlayer = [[GameLogic getCurrentGame] getLocalPlayer];
                currentLocalPlayerPositionPointer = [[[GameLogic getCurrentGame] getLocalPlayer] getNetworkData];
                NSLog(@"ABABA: %f", currentLocalPlayerPositionPointer[5]);
            }
            
           // NSLog(@"%f %f %f", currentLocalPlayerPositionPointer[3], currentLocalPlayerPositionPointer[4], currentLocalPlayerPositionPointer[5]);
            
            [currentLocalPlayer collision];
            
            
            
            gluLookAt(currentLocalPlayerPositionPointer[0], currentLocalPlayerPositionPointer[1], currentLocalPlayerPositionPointer[2],      currentLocalPlayerPositionPointer[3], currentLocalPlayerPositionPointer[4], currentLocalPlayerPositionPointer[5],      0.0, 100.0, 0.0f);
            
    
            
            [map drawMap];
            
            
            for(Player * p in [[GameLogic getCurrentGame] getOtherPlayers]){
                
                
                [p draw];
            }
            
            
            
            
            
            
            
            
            
            glPopMatrix();
       
            
            [HUD draw];
            glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
            [context presentRenderbuffer:GL_RENDERBUFFER_OES];
        }
        
	}else if(gameState == 2){
		[EAGLContext setCurrentContext:context];
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glViewport(0, 0, backingWidth, backingHeight);
		glMatrixMode(GL_MODELVIEW);
		//[Menu draw];
		//if([Menu done]){
        //gameState = 0;
		//}
		glClearColor(0,0,0, 1.0);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
		[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	}else if(gameState == 1){ // Loading Foundry
        //glLoadIdentity();
        map = [[Map alloc] initWithURL:pathToMap];
        [Environment setMap:map];
        [map loadMap];
        NSLog(@"LOADING MAP");
        gameState = 0;
        
    }
    
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

-(void)setupView{
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glRotatef(-90.0, 0.0, 0.0, 1.0);
	const GLfloat zNear = 0.1, zFar = 2030.0, fieldOfView = 60.0;
    GLfloat size;
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
    CGRect rect = self.frame;
    
	glFrustumf( -size / (rect.size.width / rect.size.height),size / (rect.size.width / rect.size.height), -size, size , zNear, zFar);
    glViewport(0, 0, rect.size.width, rect.size.height);
    glClearColor(0.0, 0.0, 0.0, 0.0);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	
}

- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}





- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}


- (void)dealloc {
    
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}
#pragma mark SGI Copyright Functions

/*
 * SGI FREE SOFTWARE LICENSE B (Version 2.0, Sept. 18, 2008)
 * Copyright (C) 1991-2000 Silicon Graphics, Inc. All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice including the dates of first publication and
 * either this permission notice or a reference to
 * http://oss.sgi.com/projects/FreeB/
 * shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * SILICON GRAPHICS, INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of Silicon Graphics, Inc.
 * shall not be used in advertising or otherwise to promote the sale, use or
 * other dealings in this Software without prior written authorization from
 * Silicon Graphics, Inc.
 */

static void normalize(float v[3])
{
    float r;
	
    r = sqrt( v[0]*v[0] + v[1]*v[1] + v[2]*v[2] );
    if (r == 0.0) return;
	
    v[0] /= r;
    v[1] /= r;
    v[2] /= r;
}

static void __gluMakeIdentityf(GLfloat m[16])
{
    m[0+4*0] = 1; m[0+4*1] = 0; m[0+4*2] = 0; m[0+4*3] = 0;
    m[1+4*0] = 0; m[1+4*1] = 1; m[1+4*2] = 0; m[1+4*3] = 0;
    m[2+4*0] = 0; m[2+4*1] = 0; m[2+4*2] = 1; m[2+4*3] = 0;
    m[3+4*0] = 0; m[3+4*1] = 0; m[3+4*2] = 0; m[3+4*3] = 1;
}

static void cross(float v1[3], float v2[3], float result[3])
{
    result[0] = v1[1]*v2[2] - v1[2]*v2[1];
    result[1] = v1[2]*v2[0] - v1[0]*v2[2];
    result[2] = v1[0]*v2[1] - v1[1]*v2[0];
}

void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez, GLfloat centerx,GLfloat centery, GLfloat centerz, GLfloat upx, GLfloat upy, GLfloat upz)

{
    float forward[3], side[3], up[3];
    GLfloat m[4][4];
	
    forward[0] = centerx - eyex;
    forward[1] = centery - eyey;
    forward[2] = centerz - eyez;
	
    up[0] = upx;
    up[1] = upy;
    up[2] = upz;
	
    normalize(forward);
	
    /* Side = forward x up */
    cross(forward, up, side);
    normalize(side);
	
    /* Recompute up as: up = side x forward */
    cross(side, forward, up);
	
    __gluMakeIdentityf(&m[0][0]);
    m[0][0] = side[0];
    m[1][0] = side[1];
    m[2][0] = side[2];
	
    m[0][1] = up[0];
    m[1][1] = up[1];
    m[2][1] = up[2];
	
    m[0][2] = -forward[0];
    m[1][2] = -forward[1];
    m[2][2] = -forward[2];
	
    glMultMatrixf(&m[0][0]);
    glTranslatef(-eyex, -eyey, -eyez);
}
@end
