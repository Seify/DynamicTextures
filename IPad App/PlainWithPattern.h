//
//  PlainWithPattern.h
//  Wall Painting Prototipe
//
//  Created by Roman Smirnov on 16.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDataStructures.h"

@interface PlainWithPattern : NSObject
{
    int movingPoint;
    GLuint texture;
    NSString *name;
    vec3 scale;
@public
    vertexDataTextured plain[6];
    
    CGPoint pointU; // точка перечечения 2 сторон четырехугольника с текстурой
    CGPoint pointV; // точка перечечения 2 других сторон четырехугольника с текстурой

}
@property int movingPoint;
@property GLuint texture;
@property (retain) NSString *name;
@property (retain) NSString *imageName;
@property vec3 scale;
@property (readonly) vec3 center;
//- (PlainWithPattern *) initWithTexture:(GLuint) pattern;
@end
