//
//  Shader.vsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __Aplica__. All rights reserved.
//

attribute vec3 position;
attribute vec3 normal;
attribute vec2 texCoords;
attribute vec4 color;

varying vec4 colorVarying;
varying vec2 fTexCoords;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform mat4 normalMatrix44;
uniform vec4 diffuseColor;
uniform vec3 lightPosition;

uniform float translate;



void main()
{ 
    
    vec4 postmp = vec4(position.xyz, 1.0);

    vec4 normal4 = vec4(normal, 1.0);
    vec4 rotNormal = normalMatrix44 * normal4;
        
    gl_Position = modelViewProjectionMatrix * postmp;
    
    vec4 rotVert = modelViewMatrix * postmp;
    
    float diff = max (0.0, dot (rotNormal.xyz, normalize (lightPosition - rotVert.xyz) ));

    
    colorVarying.xyz = diffuseColor.xyz * diff;
    colorVarying.a = 1.0;
    
    fTexCoords = texCoords;
}
