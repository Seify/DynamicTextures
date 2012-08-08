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
    
//    gl_FragColor = vec4 (brushColor.rgb, brushTextureColor.a) * step(abs(bgImageColor.a-currentArea), 0.0001);

    gl_FragColor = vec4 (brushColor.rgb, brushTextureColor.a);
    
    // Dynamic texture depending on brush tex coords
    gl_FragColor = vec4 (fTexCoords.x, fTexCoords.y, 0.0, brushTextureColor.a);
    
    // Dynamic texture depending on picture tex coords
    gl_FragColor = vec4 (areaTexCoords.x, areaTexCoords.y, 0.0, brushTextureColor.a);

    
}
