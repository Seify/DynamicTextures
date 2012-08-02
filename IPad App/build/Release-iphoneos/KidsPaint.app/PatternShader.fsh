//
//  Shader.fsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//precision highp float;
//
//varying highp vec2 fTexCoords;
//
//uniform sampler2D texture;

void main()
{
//        gl_FragColor = texture2D(texture, fTexCoords);
    gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
}
