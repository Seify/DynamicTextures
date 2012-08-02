//
//  UndoTexturesCache.h
//  KidsPaint
//
//  Created by Roman Smirnov on 02.03.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLView.h"

@interface UndoTexturesCache : NSObject
{
    GLuint *drawingTextures;
    int countOfUndoAvaible;
}
- (id)initWithCapacity:(int)capacity;
@property int countOfUndoAvaible;
@property (readonly) BOOL canUndoPainting;
@end
