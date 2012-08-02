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


void main()
{
    vec4 bgImageColor = texture2D(originalImageTexture, fTexCoords);    
    vec4 drawingColor = texture2D(drawingTexture, fTexCoords);
    vec4 paperColor = texture2D(paperTexture, fTexCoords);

// вариант без затенения / осветления
    gl_FragColor = vec4(paperColor.rgb * bgImageColor.rgb - drawingColor.rgb, 1.0);
}
