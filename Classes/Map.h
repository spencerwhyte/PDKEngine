//
//  Map.h
//  x
//
//  Created by Spencer Whyte on 10-11-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ImageAsset.h"
#import "ModelAsset.h"
#import "Environment.h"
#import "EAGLView.h"
@class Environment;




@interface Map : NSObject {
    NSString *mapPath;
	NSMutableArray *assets;
	

	
	UIImage *descriptiveImage;
	
    
    
	NSMutableArray *imageAssets; // An array containing instances of ImageAsset
	NSMutableArray *modelAssets; // An array containing instances of ModelAsset
	NSMutableArray *audioAssets; // 
	NSMutableArray *animationAssets; 
	NSMutableArray *scriptAssets;
	NSMutableArray *weaponAssets;
	NSMutableArray *allAssets; // An array containing arrays of all of the different types of assets
	
	
	
	
}

-(NSString*)getName;
-(void)setName:(NSString*)namer;

-(NSString*)getDescription;
-(void)setDescription:(NSString*)descriptioner;

-(void)loadMap;
-(void)unloadMap;
-(void)saveMap;
-(void)drawMap;
-(id)initWithURL:(NSString*) filePath;
//-(void)swapImage:(NSImage*)image;
-(NSMutableArray*)getImageAssets;
-(NSMutableArray*)getModelAssets;
-(NSMutableArray*)getAudioAssets;
-(NSMutableArray*)getAnimationAssets;
-(NSMutableArray*)getScriptAssets;
-(NSMutableArray*)getWeaponAssets;
-(NSMutableArray*)getAllAssets;
-(NSString*)getStringForArray:(NSMutableArray*)array;
-(Class)classForArray:(NSMutableArray*)array;
@end
