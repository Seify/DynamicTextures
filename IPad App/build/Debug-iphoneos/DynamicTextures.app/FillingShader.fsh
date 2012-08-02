precision lowp float;

uniform sampler2D areasTexture;

uniform sampler2D circleTexture;
uniform float currentArea;
uniform vec4 brushColor;

varying lowp vec2 fTexCoords;
varying lowp vec2 fCircleTexCoords;

void main()
{
    vec4 bgImageColor = texture2D(areasTexture, fTexCoords);
    vec4 circleColor = texture2D(circleTexture, fCircleTexCoords);
    
    float Alpha = step(abs(bgImageColor.a-currentArea), 0.0001) * circleColor.a;    
//    gl_FragColor = vec4(brushColor.rgb - circleColor.rgb, 1.0) * Alpha;
    gl_FragColor = vec4(brushColor.rgb, 1.0) * Alpha;
    

}