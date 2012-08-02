//
//  Shader.fsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

precision lowp float;

varying lowp vec2 fTexCoords;

uniform sampler2D originalImageTexture; // ч/б изображение, которое раскрашиваем + номер зоны в альфа-канале
uniform sampler2D drawingTexture; // то, что намалевал пользователь
uniform sampler2D paperTexture;

uniform float currentArea;

uniform mediump float discoloringCoefficient;
uniform mediump float highlightCoefficient;

void main()
{
    vec4 bgImageColor = texture2D(originalImageTexture, fTexCoords);    
    vec4 drawingColor = texture2D(drawingTexture, fTexCoords);
    vec4 paperColor = texture2D(paperTexture, fTexCoords);
        
    float areaCoefficient = 1.0 - step(abs(bgImageColor.a-currentArea), 0.0001);

//    float areaCoefficient;
//    if (abs(bgImageColor.a-currentArea) < 0.0001) {
//        areaCoefficient = 1.0;
//    }
//    else
//    {
//        areaCoefficient = 0.0;
//    }
    
    float shadingMultCoefficient = 1.0 - discoloringCoefficient * areaCoefficient;
    float shadingAddCoefficient = highlightCoefficient * areaCoefficient;
    
    gl_FragColor = vec4(vec3(paperColor.rgb * bgImageColor.rgb - drawingColor.rgb) * shadingMultCoefficient + shadingAddCoefficient, 1.0);
}
