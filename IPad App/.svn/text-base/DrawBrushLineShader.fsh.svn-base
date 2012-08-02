//
//  Shader.fsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

precision lowp float;

uniform sampler2D brushTexture;
uniform vec4 brushColor;

uniform float currentArea;
uniform sampler2D texture; // ч/б изображение, которое раскрашиваем + номер зоны в альфа-канале

varying vec2 fTexCoords;
varying vec2 areaTexCoords;

void main()
{
    vec4 bgImageColor = texture2D(texture, areaTexCoords);
    vec4 brushTextureColor = texture2D(brushTexture, fTexCoords);
//    if (brushTextureColor.a == 0.0) discard; //дорогая операция, понижает fps
//    if (fTexCoords.x < 0.05 || fTexCoords.x > 0.95 || fTexCoords.y < 0.05 || fTexCoords.y > 0.95 ) {
//        gl_FragColor = vec4 (1.0, 0.0, 0.0, 1.0);
//    } else {
    
        gl_FragColor = vec4 (brushColor.rgb, brushTextureColor.a) * step(abs(bgImageColor.a-currentArea), 0.0001);
//        gl_FragColor = vec4 (brushColor.rgb, brushTextureColor.a);

    
    //    }
    
}
