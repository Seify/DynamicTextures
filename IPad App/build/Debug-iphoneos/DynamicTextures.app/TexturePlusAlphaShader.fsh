precision lowp float;

uniform sampler2D texture;
uniform float alpha;

varying mediump vec2 fTexCoords;

void main()
{
     vec4 tempcolor = texture2D(texture, fTexCoords);
     gl_FragColor = vec4(tempcolor.rgb, tempcolor.a * alpha);
}
