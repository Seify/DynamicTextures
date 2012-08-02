precision lowp float;

uniform sampler2D texture;
uniform sampler2D paperTexture;

varying mediump vec2 fTexCoords;
varying lowp vec4 computed_color;

void main()
{
    vec4 paperColor = texture2D(paperTexture, fTexCoords);
    gl_FragColor = texture2D(texture, fTexCoords) * paperColor * computed_color;
//    gl_FragColor = texture2D(texture, fTexCoords) * paperColor;
}
