//
//  Shader.vsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __Aplica__. All rights reserved.
//

uniform mat4 modelViewProjectionMatrix;

attribute vec3 position;
attribute vec2 texCoords;

varying vec2 fTexCoords;

void main()
{ 
    fTexCoords = texCoords;
    
    vec4 postmp = vec4(position.xyz, 1.0);
    gl_Position = modelViewProjectionMatrix * postmp;
        

}
