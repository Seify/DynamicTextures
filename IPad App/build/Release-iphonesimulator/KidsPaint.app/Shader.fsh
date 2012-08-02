//
//  Shader.fsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

precision highp float;

varying lowp vec4 colorVarying;
varying highp vec2 fTexCoords;

uniform float currentArea;
uniform sampler2D texture;

void main()
{
    vec2 areaTexCoords = vec2(fTexCoords.x * 560.0/1024.0, fTexCoords.y * 800.0/1024.0); 
    vec4 newColor = texture2D(texture, areaTexCoords);
    float area = newColor.a;
    
//    vec4 testcolor = vec4(1.0, 1.0, 1.0, 1.0);

//    if (area == 10.0/255.0) { 
//        testcolor = vec4(1.0, 0.0, 0.0, 1.0);
//    } 
//    if (area == 11.0/255.0) { 
//        testcolor = vec4(0.0, 1.0, 0.0, 1.0);
//    } 
//    if ( abs(currentArea - 12.0)/255.0 < 0.001) { 
//        testcolor = vec4(0.0, 0.0, 1.0, 1.0);
//    } 
//
//    
//    gl_FragColor = testcolor;


     
    if ( abs(area - 1.0) < 0.001) { 
        gl_FragColor = vec4(newColor.rgb, 1.0);
    } 
    else if ( abs(area-currentArea/255.0) < 0.001 ) { 
        gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); 
    } 
    else {
        gl_FragColor = vec4(newColor.rgb, 1.0) * vec4(0.2, 0.2, 0.2, 1.0);        
    }
}
