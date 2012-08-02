//
//  Shader.fsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
precision lowp float;

uniform float currentArea;
uniform sampler2D texture;

uniform float alpha;

varying vec2 areaTexCoords;

void main()
{
    vec4 bgImageColor = texture2D(texture, areaTexCoords);

    gl_FragColor = vec4 (0.5, 0.5, 0.5, alpha * (1.0-step(abs(bgImageColor.a-currentArea), 0.0001)) );
}
