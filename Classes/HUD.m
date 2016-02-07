//
//  HUD.m
//  MC
//
//  Created by spencer whyte on 23/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "HUD.h"
#import "EAGLView.h"

static GLuint HUDTexture;
static GLuint medals;
static GLuint text;

static float health;
static bool loaded;
static id primaryWeapon;
static id secondaryWeapon;
static int place;
static int medalx;
static int medaly;
static int hasWaited;

static NSMutableArray * currentMedals;
static NSMutableArray * requestedMedals;
static bool enemyInSight;
static bool friendlyInSight;
static GLuint sweeper;
static float sweeperProgress;
static GLuint radarPlayer;
static GLfloat hasMovedx;
static GLfloat hasMovedy;
static GLfloat hasMovedz;
static int hasMovedTime;
static id lpp;
static int h;
static int textFrame;
static NSMutableArray * currentTextFrame;
static NSMutableArray * currentTextIndex;

static NSMutableArray *currentMedalSounds;

static bool controlStickDown;
static bool lookStickDown;


static float controlStickX;
static float controlStickY;

static float lookStickX;
static float lookStickY;




static uint64_t timed;
static 	GLubyte *textureData8;
static float fadeIn;




float mini(float x, float y){
	if(x < y){
		return (float)x;
	}
	return (float)y;
}

float maxi (float x, float y){
	if(x > y){
		return x;	
	}
	return y;
}

@implementation HUD
+(void)loadData{
	
	timed = mach_absolute_time();
	h = 0;
	textFrame = 0;
    textureData8 = (GLubyte *)malloc(128 * 128 * 4);
	memset(textureData8, 0, 128 * 128 * 4);
	currentTextFrame = [[NSMutableArray alloc] init];
	currentTextIndex = [[NSMutableArray alloc] init];
	health = 0.0f;
	place = 1;
	medalx =0;
	medaly =0;
	currentMedals = [[NSMutableArray alloc] init];
	requestedMedals = [[NSMutableArray alloc] init];
	currentMedalSounds = [[NSMutableArray alloc] init];
	enemyInSight = false;
	HUDTexture = [Loader loadImageWithName: @"HUDTexture.png" ];
	sweeperProgress = 0.0f;
	fadeIn = 1.0f;
}


const GLfloat radarCoords[] = {
	-0.43f, -0.12f,-0.5f,
	-0.43f, -0.26f, -0.5f,
	-0.26f, -0.26f, -0.5f,
	-0.26f, -0.12f, -0.5f
};
const GLfloat radarTexCoords[] = {
	0.75f,0.78f,
	1.0f,0.78f,
	1.0f,1.0f,
	0.75f,1.0f
};
const GLfloat sweeperCoords[] = {
	-0.07f, 0.085f, -0.5f,
	-0.07f, -0.085f, -0.5f,
	0.07f, -0.085f, -0.5f,
	0.07f, 0.085f, -0.5f
};
const GLfloat sweeperTexCoords[] = {
	0.0f,0.0f,
	1.0f,0.0f,
	1.0f,1.0f,
	0.0f,1.0f
};
const GLfloat radarPlayerCoords[] = {
	-0.008f, 0.008f,-0.5f,
	-0.008f, -0.008f, -0.5f,
	0.008f, -0.008f, -0.5f,
	0.008f, 0.008f, -0.5f
};
const GLfloat controlStickCoords[] = {
	-0.05f, 0.05f, -0.5f,
	-0.05f, -0.05f, -0.5f,
	0.05f, -0.05f, -0.5f,
	0.05f, 0.05f, -0.5f
};
const GLfloat controlStickTexCoords[] = {
	0.0f,0.84375f,
	0.15625f,0.84375f,
	0.15625f,1.0f,
	0.0f,1.0f
};

const GLfloat controlStickOutlineCoords[] = {
	-0.06f, 0.06f, -0.5f,
	-0.06f, -0.06f, -0.5f,
	0.06f, -0.06f, -0.5f,
	0.06f, 0.06f, -0.5f
};
const GLfloat controlStickOutlineTexCoords[] = {
	0.15625f,0.8125f,
	0.3515625,0.8125f,
	0.3515625,1.0f,
	0.15625f,1.0f
};


/*
 The post message method is a static method of the HUD class that allows you to display messages to the user.
 messsage - A NSString that is the message that is to be displayed. 
 */
+(void)postMessage:(NSString*)message{
	
	
	if([message length] < 34){
		int indexer = 0;
		bool complete = false;
		for(int i = 0 ; i < 9; i++){
			if(complete == true){
				break;
			}
			for(int k = 0 ; k < [currentTextIndex count] ; k++){
				if( [(NSNumber*)[currentTextIndex objectAtIndex:k] intValue] == i ){
					break;
				}
				if(k == [currentTextIndex count] - 1){
					indexer = i;
					complete = true;
					break;
				}
			}
			
		}
		CGContextRef textureContext8 = CGBitmapContextCreate(textureData8,128, 128,8, 128 * 4,CGColorSpaceCreateDeviceRGB(),kCGImageAlphaPremultipliedLast);
		CGContextSetRGBFillColor (textureContext8, 1, 1,1, 1); // 6
		CGContextSetRGBStrokeColor (textureContext8, 1, 1, 1, 1); // 7
		CGContextClearRect(textureContext8, CGRectMake( 0 , 128 - indexer * 13- 9, 128,8));
		CGContextSelectFont (textureContext8, "Verdana",7,kCGEncodingMacRoman);
		CGContextSetCharacterSpacing (textureContext8, 0); // 4
		CGContextSetTextDrawingMode (textureContext8, kCGTextFillStroke); // 5
		CGContextSetRGBFillColor (textureContext8, 1, 1,1, 1); // 6
		CGContextSetRGBStrokeColor (textureContext8, 1, 1, 1, 1); // 7
		CGContextTranslateCTM(textureContext8,0, 128);
		CGContextScaleCTM(textureContext8, 1.0, -1.0);
		CGContextShowTextAtPoint (textureContext8, 0, 3  + indexer * 13, [message UTF8String], [message length]); 
		CGContextRelease(textureContext8);
		glGenTextures(1, &text);
		glBindTexture(GL_TEXTURE_2D, text);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 128, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData8);
		//free(textureData8);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		[currentTextFrame addObject:[NSNumber numberWithInt:0]];
		[currentTextIndex addObject:[NSNumber numberWithInt:indexer]];
	}else{

	   // [HUD postMessage:[message substringFromIndex:[message length] - [message length]%33    ]];
		NSMutableArray *aba = [[NSMutableArray alloc] init];
		for(int i = 0 ;  i< [message length]; i+=33){
			if(i + 33 < [message length]){
			 [aba addObject:[message substringWithRange:NSMakeRange(i, 33)]];
			}else{
				[aba addObject:[message substringWithRange:NSMakeRange(i, [message length] %33)]];
			}
		}
	    //for(int k = [aba]){
			
		//}
 
	
	}
}


const GLfloat curtain [] = {
	-0.12f,-0.09,0.0f,
	-0.12f,0.09f,0.0f,
    0.12f, 0.09f,0.0f,
	0.12f, -0.09f,0.0f
};

+(void)draw{
	if(health < 1.0){
		health += 0.04f;
	}
	glDisable(GL_DEPTH_TEST);
	
	
	
	
	/*
	// Start of Radar sweeper code
    glPushMatrix();
	glDisable(GL_DEPTH_TEST);
	glTexEnvf(GL_TEXTURE_2D,GL_TEXTURE_ENV_MODE,GL_MODULATE);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	if(sweeperProgress < 1.0){
		glPushMatrix();
		glTranslatef(-0.352, -0.19f, 0.0f);
		glRotatef(-90, 0.0f, 0.0f, 1.0f);
		glColor4f(0.8f, 0.8f, 1.0, 0.5f);
		glScalef(sweeperProgress, sweeperProgress, 1.0f);
		glVertexPointer(3, GL_FLOAT, 0, sweeperCoords);
		glTexCoordPointer(2, GL_FLOAT, 0, sweeperTexCoords);
		glBindTexture(GL_TEXTURE_2D, sweeper);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		glPopMatrix();
	}
	 
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	sweeperProgress += 0.03;
	if(sweeperProgress > 2.5){
		sweeperProgress = 0.0f;
	}
	//  end of Radar sweeper code
	*/
	
	if(!controlStickDown){

		if(controlStickX > 0.1f){
                    [self postMessage:@"Hey What's up?"];
			controlStickX -= 0.05f;
		}
		if(controlStickX < -0.1f){
			controlStickX += 0.05f;
		}
		if(controlStickX < 0.1f && controlStickX > -0.1f){
			controlStickX  = 0.0f;
		}
		if(controlStickY > 0.1f){
			controlStickY -= 0.05f;
		}
		if(controlStickY < -0.1f){
			controlStickY += 0.05f;
		}
		if(controlStickY < 0.1f && controlStickY > -0.1f){
			controlStickY  = 0.0f;
		}
		
	}
	
	
	if(!lookStickDown){
	
		if(lookStickX > 0.1f){
			lookStickX -= 0.05f;
    
		}
		if(lookStickX < -0.1f){
			lookStickX += 0.05f;
		}
		if(lookStickX < 0.1f && lookStickX > -0.1f){
			lookStickX  = 0.0f;
		}
		if(lookStickY > 0.1f){
			lookStickY -= 0.05f;
		}
		if(lookStickY < -0.1f){
			lookStickY += 0.05f;
		}
		if(lookStickY < 0.1f && lookStickY > -0.1f){
			lookStickY  = 0.0f;
		}
		
	}
	
	//NSLog(@"%f", controlStickX);
	//if(controlMethodSwitch.on){
	glEnable(GL_BLEND);
	glColor4f(0.0f, 0.0f, 0.0f, 0.6f);
	glBindTexture(GL_TEXTURE_2D, HUDTexture);
	glPushMatrix();
	glTranslatef(-0.25f, -0.139f, 0.00f);
	glTexCoordPointer(2,GL_FLOAT, 0, controlStickOutlineTexCoords);
	glVertexPointer(3, GL_FLOAT, 0, controlStickOutlineCoords);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glPopMatrix();

	glColor4f(-0.25f, 0.6f, 0.25f, 0.6f);
	glPushMatrix();
	glTranslatef(-0.25f + controlStickX, -0.14f+controlStickY, 0.0f);
	glTexCoordPointer(2,GL_FLOAT, 0, controlStickTexCoords);
	glVertexPointer(3, GL_FLOAT, 0, controlStickCoords);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glPopMatrix();
	//}
	/*
	glColor4f(0.0f, 0.0f, 0.0f, 0.6f);
	glPushMatrix();
	glTranslatef(0.23f, -0.139f, 0.00f);
	glTexCoordPointer(2,GL_FLOAT, 0, controlStickOutlineTexCoords);
	glVertexPointer(3, GL_FLOAT, 0, controlStickOutlineCoords);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glPopMatrix();
	
	
	glColor4f(0.55f, 0.2f, 0.15f, 0.6f);
	glPushMatrix();
	glTranslatef(0.23f + lookStickX, -0.14f+lookStickY, 0.0f);
	glTexCoordPointer(2,GL_FLOAT, 0, controlStickTexCoords);
	glVertexPointer(3, GL_FLOAT, 0, controlStickCoords);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glPopMatrix();
	*/
	
	/*
	if(loaded){
		
		if(enemyInSight){
			glColor4f(1.0f, 0.0f, 0.0f, 1.0f);
		}else if(friendlyInSight){
			glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
		}
		if([primaryWeapon isKindOfClass:[BattleRifle class]]){
			glTexCoordPointer(2, GL_FLOAT, 0, brTexCoords);
			glVertexPointer(3, GL_FLOAT, 0, brCoords);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			
			glTexCoordPointer(2, GL_FLOAT, 0, brTexCoords2);
			glVertexPointer(3,GL_FLOAT, 0, brCoords2);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			
			//glEnable(GL_TEXTURE_2D);
		}else if([primaryWeapon isKindOfClass:[SniperRifle class]]){
			glTexCoordPointer(2, GL_FLOAT, 0, sniperTexCoords);
			glVertexPointer(3, GL_FLOAT, 0, sniperCoords);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			glTexCoordPointer(2, GL_FLOAT, 0, sniperTexCoords2);
			glVertexPointer(3,GL_FLOAT, 0, brCoords2);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			
		}else if([primaryWeapon isKindOfClass:[SMG class]]){
			//glDisable(GL_TEXTURE_2D);
			glTexCoordPointer(2, GL_FLOAT, 0, smgTexCoords);
			glVertexPointer(3, GL_FLOAT, 0, smgCoords);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			
			glTexCoordPointer(2, GL_FLOAT, 0, smgTexCoords2);
			glVertexPointer(3,GL_FLOAT, 0, brCoords2);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			glEnable(GL_TEXTURE_2D);
		}
		glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	}
	
	glColor4f(1.0, 1.0f, 1.0f, 1.0f);
	glTranslatef(-0.2f, 0.2f, 0.0f);
	//Healthbar Outline
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glVertexPointer(3, GL_FLOAT, 0, coords);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	// Healthbar
	glColor4f(1.0f, 1.0f, 1.0f, 0.7f);
	glTexCoordPointer(2, GL_FLOAT, 0, fTexCoords);
	glVertexPointer(3, GL_FLOAT, 0, fCoords);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	//Visor
	//glTexCoordPointer(2, GL_FLOAT, 0, visorTexCoords);
	//glVertexPointer(3, GL_FLOAT, 0, visorCoords);
	//glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	 */
	/*
	//radar
	glTranslatef(0.2f, -0.2f, 0.0f);
	glColor4f(0.1f, 0.4f, 1.0f, 1.0f);
	glTexCoordPointer(2, GL_FLOAT, 0, radarTexCoords);
	glVertexPointer(3, GL_FLOAT, 0, radarCoords);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	
	
	
	// Draw the current player on radar
	LocalPlayer*lp = (LocalPlayer*)lpp;
	if(hasMovedx!=lp.x || hasMovedy!=lp.y || hasMovedz !=lp.z){
		hasMovedTime = 0;
		glColor4f(1.0, 0.85, 0.085, 1.0);
		glPushMatrix();
		glTranslatef(-0.352, -0.19f, 0.0f);
		glBindTexture(GL_TEXTURE_2D, radarPlayer);
		glVertexPointer(3, GL_FLOAT, 0, radarPlayerCoords);
		glTexCoordPointer(2, GL_FLOAT, 0, sweeperTexCoords);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		glPopMatrix();
	}else if(hasMovedTime < 6){
		glColor4f(1.0, 0.85, 0.085, 1.0);
		glPushMatrix();
		glTranslatef(-0.352, -0.19f, 0.0f);
		glBindTexture(GL_TEXTURE_2D, radarPlayer);
		glVertexPointer(3, GL_FLOAT, 0, radarPlayerCoords);
		glTexCoordPointer(2, GL_FLOAT, 0, sweeperTexCoords);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		glPopMatrix();
	}
	hasMovedx = lp.x;
	hasMovedy = lp.y;
	hasMovedz = lp.z;
	hasMovedTime++;
	
	// Draw all of the other people on radar
	for(int i = 0 ; i < [networkPlayers count]; i++){
		NetworkPlayer * current  = [networkPlayers objectAtIndex:i];	
		if(current.living){
			if((current.x-lp.x)*(current.x-lp.x)+(current.z-lp.z)*(current.z-lp.z) < 5000)
			{
				float diffx =  current.x-lp.x;
				float diffz = current.z - lp.z;
				if(current.teamID!=lp.teamID){ // Enemy
					glColor4f(1.0, 0.085, 0.085, 1.0); 
				}else{ // Friendly
					glColor4f(1.0, 0.85, 0.085, 1.0);
				}
				glPushMatrix();
				glTranslatef(-0.352 ,  -0.19f, 0.0f);
				float angle = -atan2(lp.centerX - lp.x,lp.centerZ-lp.z) * (180.0/3.14159265358979);
				glRotatef(angle, 0.0f, 0.0f, 1.0f);		
				glTranslatef( -diffx*0.001,diffz * 0.001, 0.0f);
				glBindTexture(GL_TEXTURE_2D, radarPlayer);
				glVertexPointer(3, GL_FLOAT, 0, radarPlayerCoords);
				glTexCoordPointer(2, GL_FLOAT, 0, sweeperTexCoords);
				glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
				glPopMatrix();
			}
		}
	}
	*/
	
	/*
	while([requestedMedals count] > 0){
		int temp =[requestedMedals count]-1;
		[currentMedals addObject:[requestedMedals objectAtIndex:temp]];
		[requestedMedals removeObjectAtIndex:temp];
		while([currentMedals count] > 3){
			[[currentMedals objectAtIndex:0] release];
			[currentMedals removeObjectAtIndex:0];
		}
	}
	for(int i = [currentMedals count]-1;  i >= 0 ; i--){
		glPushMatrix();
		if(i < ([currentMedals count]-4)){
			Medal*currentMedal = [currentMedals objectAtIndex:i];
			const GLfloat medalCoords[] = {
				-0.05f, -0.05f,-0.5f,	
				-0.05f, 0.05f, -0.5f,
				0.05f, 0.05f,-0.5f,
				0.05f, -0.05f,-0.5f
			};
			int	medalx = (currentMedal.medal%8);
			int medaly = floor(currentMedal.medal/8.0f);
			const GLfloat medalTexCoords[]= {
				0.0f + medalx*0.11718, 0.8828125f+ medaly* -0.11718 ,
				0.0f + medalx*0.11718, 1.0f + medaly* -0.11718 ,
				0.11718f+ medalx*0.11718,1.0f + medaly* -0.11718,
				0.11718f+ medalx*0.11718,0.8828125f + medaly* -0.11718
			};
			if(currentMedal.steps < 49){
				currentMedal.steps+=7;
				glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
				glTranslatef(-0.35  + 0.08*([currentMedals count]-1-i) , 0.0f, 0.0f);
				float computed = (1.0/-800)*(currentMedal.steps)*(currentMedal.steps-64);
				glScalef(computed,computed ,1.0f);
				glRotatef(-98+currentMedal.steps*2, 0.0f, 0.0f, 1.0f);
				glBindTexture(GL_TEXTURE_2D, medals);
				glVertexPointer(3, GL_FLOAT, 0, medalCoords);
				glTexCoordPointer(2,GL_FLOAT, 0, medalTexCoords);
				glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			}else{
				if(([currentMedals count]-1-i) == 0){
					currentMedal.steps+=1;
				}else if(([currentMedals count]-1-i) == 1){
					currentMedal.steps+=2;
				}else{
					currentMedal.steps+=3;
				}
				if(currentMedal.steps > 220){
					[[currentMedals objectAtIndex:i] release];
					[currentMedals removeObjectAtIndex:i];	
				}else if(currentMedal.steps >140){
					glColor4f(1.0f, 1.0f, 1.0f,((6400-(currentMedal.steps-140)*(currentMedal.steps-140)))/6400.0f);
					glTranslatef(-0.35 + 0.08*([currentMedals count]-1-i), 0.0f, 0.0f);
					float computed = (1.0/-800)*(49)*(49-64);
					glScalef(computed,computed ,1.0f);
					glRotatef(-98+49*2, 0.0f, 0.0f, 1.0f);
					glBindTexture(GL_TEXTURE_2D, medals);
					glVertexPointer(3, GL_FLOAT, 0, medalCoords);
					glTexCoordPointer(2,GL_FLOAT, 0, medalTexCoords);
					glDrawArrays(GL_TRIANGLE_FAN, 0, 4);	
				}else{
					glColor4f(1.0f, 1.0f, 1.0f, 1.0);
					glTranslatef(-0.35 + 0.08*([currentMedals count]-1-i), 0.0f, 0.0f);
					float computed = (1.0/-800)*(49)*(49-64);
					glScalef(computed,computed ,1.0f);
					glRotatef(-98+49*2, 0.0f, 0.0f, 1.0f);
					glBindTexture(GL_TEXTURE_2D, medals);
					glVertexPointer(3, GL_FLOAT, 0, medalCoords);
					glTexCoordPointer(2,GL_FLOAT, 0, medalTexCoords);
					glDrawArrays(GL_TRIANGLE_FAN, 0, 4);	
				}
			}
		}else{
			[[currentMedals objectAtIndex:i] release];
			[currentMedals removeObjectAtIndex:i];
		}
		glPopMatrix();
	}
	
	 
	
	
	
	if(timed- mach_absolute_time() < -100000000){
		timed = mach_absolute_time();
		h++;
		NSLog(@"sugsfs");
		
		//	NSLog(@"elapsed");
	}
	
	
	if(rand()%500 == 50){
		// [HUD postMessage:@"Checkpoint......Done."];
	}
	
	*/
	
	
	
	
	for(int i = [currentTextIndex count]-1 ; i >=0 ; i--){
		
		textFrame = [(NSNumber *)[currentTextFrame objectAtIndex:i] intValue];
		
		glPushMatrix();
		
		int cy =  [(NSNumber *)[currentTextIndex objectAtIndex:i]intValue];
		const GLfloat currentTextTexCoords [] = {
			0.00f,0.0f + cy * 0.1f,
			0.00f,0.1f + cy * 0.1f,
			1.0f,0.1f + cy*0.1f,
			1.00f,0.0f + cy*0.1f
		};
		const GLfloat currentTextCoords [] = {
			-0.2f,-0.02f,-0.5f,
			-0.2f,0.02f,-0.5f,
			0.2f,0.02f,-0.5f,
			0.2f,-0.02f,-0.5f
		};
		printf("%f\n",500.0f-textFrame/300.0f );
		glTranslatef(0.0f, ( [currentTextIndex count] - i -1 )* -0.025f, 0.0f);
		glTranslatef(-0.38f + mini(pow(textFrame , 1.1),157)/1000.0f, -0.06f + 0.005*( 1- (mini(textFrame,100)/100.0) ), 0.0f);
		glColor4f(0.6f - 0.6*( 1- (mini(textFrame,70)/70.0) ),     0.549f - ( 1- (mini(textFrame,70)/70.0) ) * 0.949  ,  0.7925f + 0.2075 * ( 1- (mini(textFrame,70)/70.0) )     ,      mini(   ((2000.0f-textFrame)/700.0f)  ,1.0f)  );
		glScalef((mini(textFrame,110)/100.0f) - mini(maxi(maxi((float)textFrame - 110, 0)/450.0f, 0.0),0.1 )    , mini(textFrame*10,120)/100.0f    -  mini(maxi(maxi((float)textFrame - 120, 0)/900.0f, 0.0),0.2 )  , 1.0f);
		glBindTexture(GL_TEXTURE_2D, text);
		glVertexPointer(3, GL_FLOAT, 0, currentTextCoords);
		glTexCoordPointer(2,GL_FLOAT, 0, currentTextTexCoords);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		glPopMatrix();
		[currentTextFrame replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:textFrame+7]];
	}

	for(int i = [currentTextIndex count]-1 ; i >=0 ; i--){
		if([(NSNumber*)[currentTextFrame objectAtIndex:i] intValue] > 2000){
			[currentTextFrame removeObjectAtIndex:i];
			[currentTextIndex removeObjectAtIndex:i];
		}
	}
	
    
    /*
	if(fadeIn > 0.0f){
		glDisable(GL_TEXTURE_2D);
		glDisable(GL_TEXTURE_COORD_ARRAY);
		glPushMatrix();
		glColor4f(0.0f, 0.0f, 0.0f,fadeIn);// 5*(0.1 +scrollWheelTranslation)
		glTranslatef(0.0f, 0.0f, -0.11f);
		glVertexPointer(3, GL_FLOAT, 0, curtain);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		glPopMatrix();
		glEnable(GL_TEXTURE_2D);
		glEnable(GL_TEXTURE_COORD_ARRAY);
		fadeIn -=0.02f;
	}
	*/
    
    
    
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_DEPTH_TEST);
	glDisable(GL_BLEND);
	glPopMatrix();
	
	
	

	
	
}
+(void)setHealth: (float)h{
	health = h;
	if(h > 1.0f){
		health = 1.0f;
	}
}
+(void)setLoaded: (bool)l{
	loaded  = l;
}
+(void)setPrimaryWeapon:(id)weapon{
	primaryWeapon = weapon;
}
+(void)setSecondaryWeapon: (id) weapon{
	secondaryWeapon = weapon;
}
+(id)getPrimaryWeapon{
	return primaryWeapon;
}

+(id)getSecondaryWeapon{
	return secondaryWeapon;	
}
/*
+(void)awardMedal:(int)medalID{
	[requestedMedals addObject:[[Medal alloc]initWithMedal:medalID]];
	
	printf("%d\n", currentMedalSounds.count);
	
	if(medalID == doubleKill){
		[HUD postMessage:@"Double Kill!"];
	}else if(medalID == killingSpree){
		[HUD postMessage:@"Killing Spree!"];
	}else if(medalID == killingFrenzy){
		[HUD postMessage:@"Killing Frenzy!"];
	}else if(medalID == sniperSpree){
		[HUD postMessage:@"Sniper Spree!"];
	}else if(medalID == sharpShooter){
		[HUD postMessage:@"Sharpshooter!"];
	}else if(medalID == runningRiot){
		[HUD postMessage:@"Running Riot!"];
	}else if(medalID == untouchable){
		[HUD postMessage:@"Untouchable!"];
	}else if(medalID == tripleKill){
		[HUD postMessage:@"Tripple Kill"];
	}
	
}
*/

+(void)enemyInSight{
	enemyInSight = true;
}
+(void)enemyOutOfSight{
	enemyInSight = false;
}

+(void)friendlyInSight{
	friendlyInSight = true;
}
+(void)friendlyOutOfSight{
	friendlyInSight  = false;	
}
+(void)saveReferenceToLocalPlayer{
//	lpp = [LocalPlayer getLocalPlayer];	
//	hasMovedx = [lpp x];
//	hasMovedy = [lpp y];
//	hasMovedz = [lpp z];
}

+(void)setControlStickLocationX:(float)x LocationY:(float)y{
	controlStickX = x;
	controlStickY = y;
	
}
+(void)setControlStickDown:(bool)down{
	controlStickDown = down;	
}

+(void)setLookStickLocationX:(float)x LocationY:(float)y{
	lookStickX = x;
	lookStickY = y;
}
+(void)setLookStickDown:(bool)down{
		lookStickDown = down;
}

@end
