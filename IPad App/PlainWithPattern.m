//
//  PlainWithPattern.m
//  Wall Painting Prototipe
//
//  Created by Roman Smirnov on 16.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlainWithPattern.h"

#import "ModelDataStructures.h"
#import "matrix.h"
//#import "sphereTex5.h"
//#import "funkyCube.h"
#import "plain.h"
//#import "snow_obsidian.h"

#define degreeToRadians M_PI/180*

@implementation PlainWithPattern

@synthesize movingPoint;
@synthesize texture;
@synthesize name, imageName;
@synthesize scale;

- (vec3)center
{
    vec3 resVec;
//    resVec.x = plain[1].vertex.x + (plain[2].vertex.x - plain[1].vertex.x)/2;
//    resVec.y = plain[0].vertex.y + (plain[1].vertex.y - plain[0].vertex.y)/2;
    resVec.x = (plain[0].vertex.x + plain[1].vertex.x + plain[2].vertex.x + plain[5].vertex.x)/4;
    resVec.y = (plain[0].vertex.y + plain[1].vertex.y + plain[2].vertex.x + plain[5].vertex.x)/4;
    resVec.z = 0.0f;
    
    return resVec;
}

- (PlainWithPattern *) init
{
    if (nil != (self = [super init]) ) {
        
        
    plain[0].vertex.x = 1.000000;
    plain[0].vertex.y = 1.000000;
    plain[0].vertex.z = 0.000000;

    plain[0].normal.x = 0.000000;
    plain[0].normal.y = 0.000000;
    plain[0].normal.z = 1.000000;
    
    plain[0].texCoord.u = 0.000000;
    plain[0].texCoord.v = 0.000000;

    
    plain[1].vertex.x = 1.000000;
    plain[1].vertex.y = -1.000000;
    plain[1].vertex.z = 0.000000;
    
    plain[1].normal.x = 0.000000;
    plain[1].normal.y = 0.000000;
    plain[1].normal.z = 1.000000;
    
    plain[1].texCoord.u = 1.000000;
    plain[1].texCoord.v = 0.000000;

        
    plain[2].vertex.x = -1.000000;
    plain[2].vertex.y = -1.000000;
    plain[2].vertex.z = 0.000000;
    
    plain[2].normal.x = 0.000000;
    plain[2].normal.y = 0.000000;
    plain[2].normal.z = 1.000000;
    
    plain[2].texCoord.u = 1.000000;
    plain[2].texCoord.v = 1.000000;
    
    plain[3].vertex.x = 1.000000;
    plain[3].vertex.y = 1.000000;
    plain[3].vertex.z = 0.000000;
    
    plain[3].normal.x = 0.000000;
    plain[3].normal.y = 0.000000;
    plain[3].normal.z = 1.000000;
    
    plain[3].texCoord.u = 0.000000;
    plain[3].texCoord.v = 0.000000;
    

    plain[4].vertex.x = -1.000000;
    plain[4].vertex.y = -1.000000;
    plain[4].vertex.z = 0.000000;
    
    plain[4].normal.x = 0.000000;
    plain[4].normal.y = 0.000000;
    plain[4].normal.z = 1.000000;
    
    plain[4].texCoord.u = 1.000000;
    plain[4].texCoord.v = 1.000000;
    
    plain[5].vertex.x = -1.000000;
    plain[5].vertex.y = 1.000000;
    plain[5].vertex.z = 0.000000;
    
    plain[5].normal.x = 0.000000;
    plain[5].normal.y = 0.000000;
    plain[5].normal.z = 1.000000;
    
    plain[5].texCoord.u = 0.000000;
    plain[5].texCoord.v = 1.000000; 
    }
    
//    self.texture = pattern;
    scale.x = 1.0f;
    scale.y = 1.0f;
    scale.z = 1.0f;
    
    
    return self;
  
}
@end
