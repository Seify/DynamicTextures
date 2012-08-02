uniform mat4 modelViewProjectionMatrix;

attribute vec3 position;
attribute vec2 texCoords;

//varying vec2 fTexCoords;
varying vec2 areaTexCoords;

void main()
{ 
    // т.к. текстура 1024*1024, а нам нужна 560*800, вычисляем новые текстурные координаты
    areaTexCoords = vec2(texCoords.x * 0.546875, texCoords.y * 0.78125); // 560.0/1024.0, 800.0/1024.0
    
    vec4 postmp = vec4(position.xyz, 1.0);
    gl_Position = modelViewProjectionMatrix * postmp;
    //    gl_Position = postmp;
    
//    fTexCoords = texCoords;
//    
//    vec4 postmp = vec4(position.xy, 0.5, 1.0);
//    vec4 temppos = modelViewProjectionMatrix * postmp;
//    gl_Position = vec4(temppos.xy, 0.5, 1.0);
//    
//    areaTexCoords = (temppos.xy + 1.0) * 0.5; 
}
