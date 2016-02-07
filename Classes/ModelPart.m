//
//  ModelPart.m
//  x
//
//  Created by Spencer Whyte on 10-11-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ModelPart.h"


@implementation ModelPart
-(void)write:(NSMutableData*)data{
	[data appendBytes:&vertexCount length:4];
	[data appendBytes:mesh length:sizeof(Vertex)*vertexCount];
	int lengthOfImageAssetName = [[texture getID] length];
	[data appendBytes:&lengthOfImageAssetName length:4];
	[data appendBytes:[[texture getID] UTF8String] length:[[texture getID] length]];
}

-(ModelAsset*)getParent{
	return parentAsset;	
}

-(id)initWithData:(NSMutableData*)data andParent:(ModelAsset *)parent{
	if(self = [super init]){
		drawingMode=2;
		parentAsset = parent;
		long offset = 0;
		[data getBytes:&vertexCount range:NSMakeRange(offset, 4)];
		offset+=4;
		mesh = malloc(sizeof(Vertex)*vertexCount);
		NSLog(@"Vertex count%d", vertexCount);
		[data getBytes:mesh range:NSMakeRange(offset, sizeof(Vertex)*vertexCount)];
		offset+=sizeof(Vertex)*vertexCount;
		int lengthOfImageAssetName;
		
		
		[data getBytes:&lengthOfImageAssetName range:NSMakeRange(offset, 4)];
		offset+=4;
		char imageAssetName[lengthOfImageAssetName+1];
		[data getBytes:imageAssetName range:NSMakeRange(offset, lengthOfImageAssetName)];
		imageAssetName[lengthOfImageAssetName] = '\0';
		offset+=lengthOfImageAssetName;
		NSString *textureName = [NSString stringWithUTF8String:imageAssetName];
       // NSLog(@"PARSLEY %@", textureName);
        
       // [Environment getMap];
        
		NSMutableArray *imageAssets = [[Environment getMap] getImageAssets];
        
		texture = nil;
		int i;
		for(i = 0; i < [imageAssets count]; i++){
            NSLog(@"\n\n\n\n\n\n\n\n\n\n FIXED \n\n\n\n\n\n\n\n\n\n\n");
			if([[[imageAssets objectAtIndex:i] getID] isEqualToString:textureName]){
				texture = [imageAssets objectAtIndex:i];
               
				break;
			}
		}
		[data replaceBytesInRange:NSMakeRange(0, offset) withBytes:NULL length:0];
	}
	return self;
}


-(id)initWithPointer:(Vertex*)pointer vertexCount:(int)count imageAsset:(ImageAsset*)a andParent:(ModelAsset*)pa{
	if(self = [super init]){
		parentAsset=pa;
		drawingMode=2;
		vertexCount=count;
		mesh = pointer;
		if(a!=NULL){
			texture=a;
		}else{
			texture=[[[Environment getMap] getImageAssets] objectAtIndex:0];	
		}
	}
	return self;
}



-(void)draw{

	glEnableClientState(GL_VERTEX_ARRAY);
	
	glVertexPointer(3, GL_FLOAT, sizeof(Vertex), mesh->coordiante);

	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);

	
	

		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBindTexture(GL_TEXTURE_2D, [texture getImage]);

		glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), mesh->texCoord);
		glDrawArrays(GL_TRIANGLES, 0, vertexCount); 
	

	
}

-(void)newDrawingMode:(int)dm{
	drawingMode=dm;
}

-(void)setDrawingMode:(float)dm{
	drawingMode*=dm;
}

-(Vertex*)getMeshData{
	return mesh;	
}
-(int)getVertexCount{
	return vertexCount;
}

-(void)scaleMesh:(float)factor{
	int i;
	for(i=0; i < vertexCount*sizeof(Vertex); i+=sizeof(Vertex)){
	//	(Vertex)(mesh+i).coordiante.x= (Vertex)(mesh+i).coordiante.x*factor;
	//	(Vertex)(mesh+i).coordiante.y= (Vertex)(mesh+i).coordiante.y*factor;
	///	(Vertex)(mesh+i).coordiante.z= (Vertex)(mesh+i).coordiante.z*factor;
	}
}

@end
