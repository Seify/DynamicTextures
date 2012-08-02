uniform mat4 modelViewProjectionMatrix;

attribute vec3 position;
attribute vec2 texCoords;
attribute vec2 circleTexCoords;

varying vec2 fTexCoords;
varying vec2 fCircleTexCoords;

void main()
{ 
    fTexCoords = vec2(texCoords.x, 1.0 - texCoords.y);
    fCircleTexCoords = circleTexCoords;
    vec4 postmp = vec4(position.xyz, 1.0);
    gl_Position = modelViewProjectionMatrix * postmp;
}