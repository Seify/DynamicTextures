//
//  Shader.fsh
//  OpenGL Test
//
//  Created by Roman Smirnov on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

precision highp float;
//precision highp vec2;
//precision highp vec3;
//precision highp vec4;


varying lowp vec4 colorVarying;
varying highp vec2 fTexCoords;

varying highp vec2 v_position;
varying highp vec2 v_point0;
varying highp vec2 v_point1;
varying highp vec2 v_point2;
varying highp vec2 v_point5;
varying highp vec2 v_pointU;
varying highp vec2 v_pointV;

uniform highp vec4 wallColor;

uniform sampler2D texture;
uniform sampler2D areaTexture;
uniform sampler2D roomtexture;

uniform float textureScaleFactor;
uniform vec2 areaTextureScaleFactor;


vec3 AMDRGBtoHSL (vec3 color)
{    float  r, g, b, delta;
    float  colorMax, colorMin;
    float  h=0.0, s=0.0, v=0.0;
    vec4 hsv=vec4(0.0, 0.0, 0.0, 0.0);
    r = color.r;
    g = color.g;
    b = color.b;
    colorMax = max (r,g);
    colorMax = max (colorMax,b);
    colorMin = min (r,g);
    colorMin = min (colorMin,b);
    v = colorMax;               // this is value
    if (colorMax != 0.0)
    {
        s = (colorMax - colorMin) / colorMax;
    }
    if (s != 0.0) // if not achromatic
    {
        delta = colorMax - colorMin;
        if (r == colorMax)
        {
            h = (g-b)/delta;
        }
        else if (g == colorMax)
        {
            h = 2.0 + (b-r) / delta;
        }
        else // b is max
        {
            h = 4.0 + (r-g)/delta;
        }
        h *= 60.0;
        if (h < 0.0)
        {
            h += 360.0; 
        }
        hsv.x = h / 360.0;
        hsv.y = s;
        hsv.z = v;
    }
    return hsv.xyz; 
}



//vec4 RGBToHSL(vec4 color)
//{
//	vec3 hsl; // init to 0 to avoid warnings ? (and reverse if + remove first part)
//	
//	float fmin = min(min(color.r, color.g), color.b);    //Min. value of RGB
//	float fmax = max(max(color.r, color.g), color.b);    //Max. value of RGB
//	float delta = fmax - fmin;             //Delta RGB value
//    
//	hsl.z = (fmax + fmin) / 2.0; // Luminance
//    
//	if (delta == 0.0)		//This is a gray, no chroma...
//	{
//		hsl.x = 0.0;	// Hue
//		hsl.y = 0.0;	// Saturation
//	}
//	else                                    //Chromatic data...
//	{
//		if (hsl.z < 0.5)
//        hsl.y = delta / (fmax + fmin); // Saturation
//		else
//        hsl.y = delta / (2.0 - fmax - fmin); // Saturation
//		
//		float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
//		float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
//		float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;
//        
//		if (color.r == fmax )
//        hsl.x = deltaB - deltaG; // Hue
//		else if (color.g == fmax)
//        hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
//		else if (color.b == fmax)
//        hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue
//        
//		if (hsl.x < 0.0)
//        hsl.x += 1.0; // Hue
//		else if (hsl.x > 1.0)
//        hsl.x -= 1.0; // Hue
//	}
//    
//	return hsl;
//}
//

highp vec2 intersection(highp vec2 p1, highp vec2 p2, highp vec2 p3, highp vec2 p4)
{
    highp float x1 = p1.x; highp float y1 = p1.y;
    highp float x2 = p2.x; highp float y2 = p2.y;
    highp float x3 = p3.x; highp float y3 = p3.y;
    highp float x4 = p4.x; highp float y4 = p4.y;
    
    highp float A1 = y1-y2;
    highp float B1 = x2-x1;
    highp float C1 = x1*y2-x2*y1;
    highp float A2 = y3-y4;
    highp float B2 = x4-x3;
    highp float C2 = x3*y4-x4*y3;
    
    highp float x = (B1*C2-B2*C1)/(A1*B2-A2*B1);
    highp float y = (C1*A2-C2*A1)/(A1*B2-A2*B1);
    
    return highp vec2(x, y);
}

void main()
{
    highp vec2 textureCoordModified;
    
    highp vec2 pointU1 = intersection(v_point5, v_point2, v_pointU, v_position);
    textureCoordModified.x = length(v_point5-pointU1) / length(v_point5-v_point2) * textureScaleFactor;
    
    highp vec2 pointV1 = intersection(v_point0, v_point5, v_pointV, v_position);
    textureCoordModified.y = length(v_point0-pointV1) / length(v_point0-v_point5) * textureScaleFactor;   
    
    if (textureCoordModified.x > textureScaleFactor - 0.01 || textureCoordModified.x < 0.01 || textureCoordModified.y > textureScaleFactor - 0.01 || textureCoordModified.y < 0.01) 
    {
        gl_FragColor =  vec4(1.0, 0.0, 0.0, 1.0);
    } 
    else 
    {
        
//                    gl_FragColor = wallColor; 
        
        
        highp vec2 roomTexCoords;
        roomTexCoords.y = 1.0 - ((v_position.x/5.0) + 1.0)/2.0;
        roomTexCoords.x = 1.0 - ((v_position.y/5.0) + 1.0)/2.0;
        
        highp vec4 areacolor = texture2D(roomtexture, roomTexCoords);
                
        vec4 fragmentvisible = texture2D(areaTexture, vec2 (roomTexCoords.x * areaTextureScaleFactor.x, (1.0-roomTexCoords.y) * areaTextureScaleFactor.y) );

        highp vec4 color = texture2D(texture, textureCoordModified);
        
//        vec3 areahsl = AMDRGBtoHSL(areacolor.xyz);
//        vec3 wallhsl = AMDRGBtoHSL(wallColor.xyz);
//
////        gl_FragColor =  vec4(wallhsl.x, 0.0, 0.0, 1.0);
//        
////        if ( abs (areahsl.x - wallhsl.x) < 0.1 ) 
//        if ( abs (areacolor.x - wallColor.x) < 0.3  &&   abs (areacolor.y - wallColor.y) < 0.3 &&   abs (areacolor.z - wallColor.z) < 0.3) 
//        {
            gl_FragColor =  vec4(color.rgb, fragmentvisible.w);
//        gl_FragColor = vec4(fragment_visible.xyz, 1.0);
//        } else {
//            gl_FragColor =  vec4(0.0, 0.0, 0.0, 0.0);        
//        }
    }
}
