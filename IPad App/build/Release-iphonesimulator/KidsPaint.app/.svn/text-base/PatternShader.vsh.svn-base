attribute vec3 position;
attribute vec3 normal;
attribute vec2 texCoords;
attribute vec4 color;

varying vec4 colorVarying;
varying vec2 fTexCoords;

varying vec2 v_position;
varying vec2 v_point0;
varying vec2 v_point1;
varying vec2 v_point2;
varying vec2 v_point5;
varying vec2 v_pointU;
varying vec2 v_pointV;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform mat4 normalMatrix44;
uniform vec4 diffuseColor;
uniform vec3 lightPosition;

uniform highp vec4 wallColor;

uniform vec2 point0;
uniform vec2 point1;
uniform vec2 point2;
uniform vec2 point5;

uniform vec2 pointU;
uniform vec2 pointV;


uniform float translate;



vec2 intersection(vec2 p1, vec2 p2, vec2 p3, vec2 p4)
{
    float x1 = p1.x; float y1 = p1.y;
    float x2 = p2.x; float y2 = p2.y;
    float x3 = p3.x; float y3 = p3.y;
    float x4 = p4.x; float y4 = p4.y;
    
    float A1 = y1-y2;
    float B1 = x2-x1;
    float C1 = x1*y2-x2*y1;
    float A2 = y3-y4;
    float B2 = x4-x3;
    float C2 = x3*y4-x4*y3;
    
    float x = (B1*C2-B2*C1)/(A1*B2-A2*B1);
    float y = (C1*A2-C2*A1)/(A1*B2-A2*B1);
    
    return vec2(x, y);
}

void main()
{ 
    
    vec4 postmp = vec4(position.xyz, 1.0);

    vec4 normal4 = vec4(normal, 1.0);
    vec4 rotNormal = normalMatrix44 * normal4;
        
    gl_Position = modelViewProjectionMatrix * postmp;
    
    vec4 rotVert = modelViewMatrix * postmp;
    
    float diff = max (0.0, dot (rotNormal.xyz, normalize (lightPosition - rotVert.xyz) ));

    
    colorVarying.xyz = diffuseColor.xyz * diff;
    colorVarying.a = 1.0;
    
//    fTexCoords = texCoords;

//    fTexCoords.x = texCoords.x * abs(point0.x-point1.x)/abs(point5.x-point2.x);
//    fTexCoords.y = texCoords.y * abs(point1.x-point2.x)/abs(point0.x-point5.x);


//    fTexCoords.x = texCoords.x * length(point0 - point1)/length(point5 - point2);
//    fTexCoords.y = texCoords.y * length(point1 - point2)/length(point0 - point5);

//    fTexCoords.x = length(point0 - point1 - position.xy);
//    fTexCoords.y = length(point0 - point5 - position.xy);
    
//    fTexCoords.x = 1.0 * 
    
//    fTexCoords = ( ( (point0 + point1 + point2 + point5)/4.0 - position.xy ) /  ((point0 + point1 + point2 + point5)/4.0)  );
    
//    fTexCoords = texCoords * mat4x2(point0, point1, point2, point5);
    
//    fTexCoords = position.xy;
    
//    vec4 clip = modelViewProjectionMatrix * postmp; 
//    vec3 ndc = clip.xyz / clip.w; 
//    fTexCoords = 0.5 * (ndc.xy + 1.0);
    
//    fTexCoords.x = texCoords.x;
    
//    vec2 pointU1 = intersection(point5, point2, pointU, position.xy);
//    fTexCoords.y = length(point5-pointU1) / length(point5-point2);
//
//    vec2 pointV1 = intersection(point0, point5, pointV, position.xy);
//    fTexCoords.x = length(point0-pointV1) / length(point0-point5);

    v_position = position.xy;
    v_point0 = point0;
    v_point1 = point1;
    v_point2 = point2;
    v_point5 = point5;
    v_pointU = pointU;
    v_pointV = pointV;
    
}
