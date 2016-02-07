//
//  Player.h
//  PDKEngine
//
//  Created by Spencer Whyte on 11-01-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loader.h"




typedef struct __GLVertexElement {
    GLfloat coordiante[3];
    GLfloat normal[3];
    GLfloat texCoord[2];
} GLVertexElement;


static GLVertexElement * data;
static GLuint texture;
static int vertexCount3;
static unsigned short triangleCount3;

@interface Player : NSObject {
	NSString*name;
	GLfloat networkData[6]; // Position-3 / looking position-3 / 
    
    
	float speedX;
	float speedY;
	float speedZ;
	bool forward;
	bool backward;
	bool turnLeft;
	bool turnRight;
	bool moveRight;
	bool moveLeft;
	bool turnUp;
	bool turnDown;
	float way ;
	bool weaponFired;
	int teamID;
	float movementFB;
	float movementLR;
	float turnLR;
	float turnUD;
	float rotationX;
	float rotationY;
	float currentHeight;
	unsigned char *heightmap;
	int resolution;

    
}
-(id)initWithName:(NSString*)pn;
-(GLfloat*)getNetworkData;
+(void)load;
-(void)draw;
@property float speedY;
@property bool forward;
@property bool backward;
@property bool turnLeft;
@property bool turnRight;
@property bool moveRight;
@property bool moveLeft;
@property bool turnUp;
@property bool turnDown;
@property int teamID;
@property float movementFB;
@property float movementLR;
@property float turnLR;
@property float turnUD;
@property float rotationX;
@property float rotationY;
-(void)physics;
-(void)collision;
-(void)fireWeapon;
-(void)stopFireWeapon;
-(id)init;
+(id)getLocalPlayer;

@end
