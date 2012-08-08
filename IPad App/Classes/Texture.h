//
//  Texture.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 21.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourcesConstants.h"

@interface Texture : NSObject
{
    GLuint texturePointer;
    textureState state;
}
@property GLuint texturePointer;
@property textureState state;
@end
