uniform mat4 modelViewProjectionMatrix;
uniform float rotation;

attribute mediump vec3 position;
//attribute lowp vec3 normal;
attribute mediump vec2 texCoords;

varying mediump vec2 fTexCoords;
varying lowp vec4 computed_color;

void main()
{ 
    fTexCoords = texCoords;

    vec4 postmp = vec4(position.xyz, 1.0);
    vec4 newposition = modelViewProjectionMatrix * postmp;
    gl_Position = newposition;

    vec3 ambient_color = vec3(0.6, 0.6, 0.6);
    //    vec3 ambient_color = vec3 (0.35, 0.35, 0.35);

    vec3 norm = vec3(sin(rotation), 0.0, cos(rotation));
    
    vec3 light_position1 = vec3(15.0, 0.0, 20.0);
    vec3 light_direction1 = normalize( vec3 (0.2, 0.0, 1.0) );
    vec4 light_diffuse_color1 = vec4 (0.4, 0.4, 0.4, 1.0);
    float ndotl1 = max(0.0, dot(light_direction1, norm));
    vec4 temp_color1 = ndotl1 * light_diffuse_color1 * 15.0 / (length(light_position1 - newposition.xyz));
    
    vec3 light_position2 = vec3(-30.0, 0.0, 25.0);
    vec3 light_direction2 = normalize( vec3(-0.2, 0.0, 1.0) );
    vec4 light_diffuse_color2 = vec4 (0.5, 0.5, 0.5, 1.0);
    float ndotl2 = max(0.0, dot(light_direction2, norm));
    vec4 temp_color2 = ndotl2 * light_diffuse_color2 * 15.0 / (length(light_position2 - newposition.xyz));
    
    computed_color = vec4(temp_color1.rgb + temp_color2.rgb + ambient_color, 1.0);
//    computed_color = vec4(1.0, 1.0, 1.0, 1.0);
}
