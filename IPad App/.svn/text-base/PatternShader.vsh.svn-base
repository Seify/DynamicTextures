uniform mat4 modelViewProjectionMatrix;
uniform float brushSize;

attribute vec2 position;

varying vec2 fTexCoords;
varying float pointSize;
varying float angle;

void main()
{ 
    
    fTexCoords.x = (position.x + 1.0) / 1.09375 * 560.0 / 1024.0;    
    fTexCoords.y = (position.y + 1.0) / 1.56250 * 800.0 / 1024.0; 
  
//    angle = position.z;
    
    gl_Position = vec4(position.xy, 0.0, 1.0);
    pointSize = brushSize/1024.0;
    gl_PointSize = brushSize;
}
