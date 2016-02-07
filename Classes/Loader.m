//
//  Loader.m
//  TD
//
//  Created by Spencer Whyte on 11-02-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Loader.h"


@implementation Loader

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}


+(GLuint)loadImageWithName:(NSString*)path{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    GLuint texture;
    
	CGImageRef textureImage = [UIImage imageNamed:path].CGImage;
    
	NSInteger texWidth = CGImageGetWidth(textureImage);
	NSInteger texHeight = CGImageGetHeight(textureImage);
	GLubyte *textureData = (GLubyte *)malloc(texWidth * texHeight * 4);
	memset(textureData, 0, texWidth*texHeight*4);
	CGContextRef textureContext = CGBitmapContextCreate(textureData,texWidth, texHeight,8, texWidth * 4,CGImageGetColorSpace(textureImage),kCGImageAlphaPremultipliedLast);
	CGContextTranslateCTM(textureContext, 0, texHeight);
	CGContextScaleCTM(textureContext, 1.0, -1.0);
	CGContextDrawImage(textureContext, CGRectMake(0.0, 0.0, (float)texWidth, (float)texHeight), textureImage);
	CGContextRelease(textureContext);
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
	free(textureData);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
     
    [pool drain];
    return texture;
    
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
