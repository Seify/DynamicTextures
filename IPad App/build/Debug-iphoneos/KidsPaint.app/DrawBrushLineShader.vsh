//precision lowp float;

uniform mat4 modelViewProjectionMatrix;

attribute vec2 position;
attribute vec2 texCoords;

varying vec2 fTexCoords;
varying vec2 areaTexCoords;

void main()
{ 
    fTexCoords = texCoords;
    
    vec4 postmp = vec4(position.xy, 0.5, 1.0);
    vec4 temppos = modelViewProjectionMatrix * postmp;
    gl_Position = vec4(temppos.xy, 0.5, 1.0);
    
    areaTexCoords = (temppos.xy + 1.0) * 0.5;   
}
