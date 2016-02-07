//
//  Loader.h
//  TD
//
//  Created by Spencer Whyte on 11-02-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface Loader : NSObject {
@private
    
}

+(GLuint)loadImageWithName:(NSString*)path;

@end
