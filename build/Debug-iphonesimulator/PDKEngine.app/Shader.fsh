//
//  Shader.fsh
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
