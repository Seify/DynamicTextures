//
//  Shader.fsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

precision highp float;

varying highp vec2 fTexCoords;
varying float pointSize;
varying float angle;

uniform sampler2D brushTexture;
uniform float currentArea;
uniform sampler2D texture; // ч/б изображение, которое раскрашиваем + номер зоны в альфа-канале

uniform vec4 brushColor;


void main()
{
//    
    vec2 convertedTexCoords = fTexCoords;
    convertedTexCoords.x += ( (gl_PointCoord.x - 0.5) * pointSize);     
    convertedTexCoords.y += ( (0.5 - gl_PointCoord.y) * pointSize);
    vec4 bgImageColor = texture2D(texture, convertedTexCoords);
    float area = bgImageColor.a;

    if ( abs(area-currentArea) < 0.0001 ) {  
        vec4 brushTextureColor = texture2D(brushTexture, gl_PointCoord);
//        if (brushTextureColor.a == 0.0) discard;

        gl_FragColor = vec4 (brushColor.rgb, brushTextureColor.a);   
    
    } 
    else {
        gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
    }
}
