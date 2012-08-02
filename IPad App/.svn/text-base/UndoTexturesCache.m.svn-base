//
//  UndoTexturesCache.m
//  KidsPaint
//
//  Created by Roman Smirnov on 02.03.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "UndoTexturesCache.h"

@implementation UndoTexturesCache

- (int)countOfUndoAvaible 
{
    return countOfUndoAvaible;
}

- (BOOL)canUndoPainting 
{
    return (countOfUndoAvaible > 0);
}

- (id)initWithCapacity:(int)capacity
{
    if (self == [super init]) {    
        drawingTextures = malloc(capacity * sizeof(GLuint));
        
        glGenTextures(capacity, &drawingTextures[0]);
        for (int i=0; i<capacity; i++) {
            glBindTexture(GL_TEXTURE_2D, drawingTextures[i]);           
            
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1024, 1024, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
        }
    }
    return self;
}

//- (void)copyToFreeCellTexture:(GLuint)newTexture
//{
//    
//}
//
//- (GLuint)mostRecentTexture
//{
//    return
//}

- (void)dealloc {
    free(drawingTextures);
    [super dealloc];
}

@end
