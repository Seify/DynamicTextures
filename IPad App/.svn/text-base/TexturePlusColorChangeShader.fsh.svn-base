precision lowp float;

uniform sampler2D texture;
uniform vec4 newColor;

varying mediump vec2 fTexCoords;

void main()
{
     vec4 tempcolor = texture2D(texture, fTexCoords);
     gl_FragColor = vec4(0.5*tempcolor.rgb + newColor.rgb, tempcolor.a);
}
