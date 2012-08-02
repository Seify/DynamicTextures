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
    // т.к. текстура 1024*1024, а нам нужна 560*800, вычисляем новые текстурные координаты
    fTexCoords = vec2(texCoords.x * 0.546875, texCoords.y * 0.78125); // 560.0/1024.0, 800.0/1024.0
    
    vec4 postmp = vec4(position.xyz, 1.0);
    gl_Position = modelViewProjectionMatrix * postmp;

}
