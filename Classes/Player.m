//
//  Player.m
//  PDKEngine
//
//  Created by Spencer Whyte on 11-01-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


const float scaleFactor = 26.0f;
const float baseHeight = -2.0f;
const float compressionFactor = 35.0f;
const float speedFactor = 100.0f;

@implementation Player
-(id)initWithName:(NSString*)pn{
	if(self = [super init]){
		name = pn;
		networkData[0]=0.0f;
		networkData[1]=0.0f;
		networkData[2]=0.0f;
        
        
        networkData[3] = 0.0f;
		networkData[4] = 0.0f;
		networkData[5] = -1.0f;
        
	}
	return self;
}
-(GLfloat*)getNetworkData{
	return networkData;	
}

-(void)draw{
 
    glPushMatrix();
    glScalef(1.0f, 1.0f, 1.0f);
    glTranslatef(networkData[0], networkData[1], networkData[2]);
   
    float irt =  sqrt((networkData[3]-networkData[0])*(networkData[3]-networkData[0]) + (networkData[5]-networkData[2])*(networkData[5]-networkData[2]));
    
    float rotationer =270 - (180.0 / 3.141592) * atan2f(  (networkData[5]-networkData[2])   /irt, (networkData[3]-networkData[0])/irt);


    glRotatef(rotationer, 0.0f, rotationer, 0.0f);
    
	glBindTexture(GL_TEXTURE_2D, texture);
	glVertexPointer(3, GL_FLOAT, sizeof(GLVertexElement),data);
	glTexCoordPointer(2, GL_FLOAT, sizeof(GLVertexElement), (data)->texCoord);
	glDrawArrays(GL_TRIANGLES, 0,triangleCount3*3);
    
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
    glPopMatrix();
    
    
    
}


+(void)load{
    
    

	NSString *filePath3 = [[NSBundle mainBundle] pathForResource: @"MKVI2" ofType:@"gldata"];

	NSFileHandle *handle3 = [NSFileHandle fileHandleForReadingAtPath:filePath3];


	[[handle3 readDataOfLength:sizeof(int)] getBytes:&vertexCount3];
	

	[[handle3 readDataOfLength:sizeof(unsigned short)] getBytes:&triangleCount3];

	data = malloc(sizeof(GLVertexElement) * triangleCount3 * 3);
	
    
	[[handle3 readDataOfLength:sizeof(GLVertexElement) * triangleCount3 * 3] getBytes: data];

	[handle3 closeFile];
	
	texture = [Loader loadImageWithName: @"MKVI.png"]; 

    
    
}


double mind(double a, double b){
	if(a<b){
		return a;
	}
	return b;	
}
float ffabs(float a){
	if(a<0){
		return a *-1;
	}
	return a;
}




-(void)collision{
	
	
	//NSLog(@"%f,%f", x,z);
	
	
	
	if(sqrt(mind(movementFB/speedFactor,0.01)*mind(movementFB/speedFactor,0.01) + mind(movementLR/speedFactor,0.01)  *mind(movementLR/speedFactor,0.01)) > 0.01f){
		movementFB /=  100*sqrt(mind(movementFB/speedFactor,0.01)*mind(movementFB/speedFactor,0.01) + mind(movementLR/speedFactor,0.01)  *mind(movementLR/speedFactor,0.01) );
		movementLR /=  100*sqrt(mind(movementFB/speedFactor,0.01)*mind(movementFB/speedFactor,0.01) + mind(movementLR/speedFactor,0.01)  *mind(movementLR/speedFactor,0.01) );
	}
    
    
	if(turnLeft){ // Turn left
		//GLfloat vector[3];
		//vector[0] = networkData[3] - x;
		//vector[2] = networkData[5] - z;
		//networkData[3] = x + cos(-0.05)*vector[0] - sin(-0.05)*vector[2];
		//networkData[5] = z + sin(-0.05)*vector[0] + cos(-0.05)*vector[2];
	}
    
	//if(turnRight){ // Turn right
	GLfloat vector[3];
    
	vector[0] = networkData[3] - networkData[0];
	vector[1] = networkData[4] - networkData[1];
	vector[2] = networkData[5] - networkData[2];
	networkData[3] = networkData[0] +cos(5*mind(turnLR/speedFactor,0.01))*vector[0] - sin(5*mind(turnLR/speedFactor,0.01))*vector[2];
	networkData[4] += 2* sqrt(1+fabs(networkData[1]-networkData[4]))*turnUD;
    
	turnUD = 0.0f;
	 networkData[5] = networkData[2]+sin(5*mind(turnLR/speedFactor,0.01))*vector[0] + cos(5*mind(turnLR/speedFactor,0.01))*vector[2];
	turnLR = 0.0f;
	//	}

	if(forward){ // Forwards
        
        
    //    NSLog(@"CURRENT INITIAL X %f", networkData[0]);
        
		GLfloat vector[3];
		vector[0] = networkData[3] - networkData[0];
		vector[2] = networkData[5] - networkData[2];
		GLfloat tempX;
		GLfloat tempZ;
		if(speedY == 0.0f){
			tempX = networkData[0] + 1000*vector[0]  * mind(movementFB/speedFactor,0.01);
			tempZ = networkData[2] +  1000*vector[2] * mind(movementFB/speedFactor,0.01);
		}else{
			tempX = networkData[0] + 1000*vector[0] * mind(movementFB/speedFactor,0.005);
			tempZ = networkData[2] + 1000* vector[2] * mind(movementFB/speedFactor,0.005);
			networkData[0]= tempX;
			networkData[3]= networkData[0] + vector[0];
			networkData[2] = tempZ;
	networkData[5]= networkData[2] + vector[2];
		}
        
        networkData[0]= tempX;
        networkData[3]= networkData[0] + vector[0];
        networkData[2] = tempZ;
       networkData[5]= networkData[2] + vector[2];
        
		
     //   NSLog(@"final INITIAL X %f", networkData[0]);
        

		
	}
    
	if(backward){ // Backwards
		GLfloat vector[3];
		vector[0] = networkData[3] - networkData[0];
		//	vector[1] = networkData[4] - y;
		vector[2] = networkData[5] - networkData[2];
		GLfloat tempX;
		GLfloat tempZ;
		if(speedY == 0.0f){
			tempX  = networkData[0] - 1000*vector[0] * mind(movementFB/speedFactor,0.01);
			tempZ = networkData[2] - 1000*vector[2] * mind(movementFB/speedFactor,0.01);
		}else{
			tempX  = networkData[0] -1000* vector[0] * mind(movementFB/speedFactor,0.005);
			tempZ = networkData[2] - 1000*vector[2] * mind(movementFB/speedFactor,0.005);
			networkData[0]= tempX;
			networkData[3]= networkData[0] + vector[0];
			networkData[2] = tempZ;
			networkData[5]= networkData[2] + vector[2];
		}
        
        networkData[0]= tempX;
        networkData[3]= networkData[0] + vector[0];
        networkData[2] = tempZ;
        networkData[5]= networkData[2] + vector[2];
		
	}
    
	if(moveLeft){ // Move left
		GLfloat leftVector[3];
		GLfloat vector[3];
		vector[0] = networkData[3] - networkData[0];
		vector[2] = networkData[5] - networkData[2];
		leftVector[0] = -vector[2];
		leftVector[2] = vector[0];
		GLfloat tempX;
		GLfloat tempZ;
		if(speedY == 0.0f){
			tempX = networkData[0] - 1000*leftVector[0] *  mind(movementLR/speedFactor,0.01) ;
			tempZ  = networkData[2] - 1000*leftVector[2] * mind(movementLR/speedFactor,0.01);
		}else{
			tempX = networkData[0] - 1000*leftVector[0] *  mind(movementLR/speedFactor,0.005);
			tempZ  = networkData[2] - 1000*leftVector[2] *  mind(movementLR/speedFactor,0.005);
			networkData[0]= tempX;
			networkData[3]= networkData[0] + vector[0];
			networkData[2] = tempZ;
			networkData[5]= networkData[2] + vector[2];
		}
        
        networkData[0]= tempX;
        networkData[3]= networkData[0] + vector[0];
        networkData[2] = tempZ;
        networkData[5]= networkData[2] + vector[2];
    }
    
    
    if(moveRight){ // Move right
        GLfloat rightVector[3];
        GLfloat vector[3];
        vector[0] = networkData[3] - networkData[0];
        vector[2] = networkData[5] - networkData[2];
        rightVector[0] = vector[2];
        rightVector[2] = -vector[0];
        GLfloat tempX;
        GLfloat tempZ;
        if(speedY == 0.0f){
            tempX = networkData[0] - 1000*rightVector[0] *  mind(movementLR/speedFactor,0.01);
            tempZ = networkData[2] - 1000*rightVector[2] *  mind(movementLR/speedFactor,0.01);
        }else{
            tempX = networkData[0] -1000* rightVector[0] *  mind(movementLR/speedFactor,0.005);
            tempZ = networkData[2] - 1000*rightVector[2] *  mind(movementLR/speedFactor,0.005);
            networkData[0]= tempX;
            networkData[3]= networkData[0] + vector[0];
            networkData[2] = tempZ;
            networkData[5]= networkData[2] + vector[2];
        }

            networkData[0]= tempX;
            networkData[3]= networkData[0] + vector[0];
            networkData[2] = tempZ;
            networkData[5]= networkData[2] + vector[2];
        
    }
    
    
    
    
}








@synthesize speedY;
@synthesize moveRight;
@synthesize moveLeft;
@synthesize forward;
@synthesize backward;
@synthesize turnLeft;
@synthesize turnRight;
@synthesize turnDown;
@synthesize turnUp;
@synthesize teamID;
@synthesize movementFB;
@synthesize movementLR;
@synthesize turnLR;
@synthesize turnUD;
@end
