//
//  ResourceManager.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 23.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDataStructures.h"
#import "ResourcesConstants.h"
#import "Texture.h"
#import "PVRTexture.h"

#define MAX_CACHE_SIZE 1000

@interface ResourceManager : NSObject
{
    dispatch_queue_t GLCommandsQueue;
}
+ (id)sharedInstance;
- (GLuint) getProgram:(programID)pID;
- (vertexDataTextured *) getModel:(modelID)modelid;
- (GLuint) getVertexesCountForModel:(modelID)modelid;

- (GLuint) getTexture:(textureID)textureid
           Parameters:(NSDictionary *)parameters 
            InContext:(EAGLContext *)currentContext 
           ShouldLoad:(BOOL)shouldLoad
                Async:(BOOL)async;

- (GLuint) getCompressedTexture:(textureID)textureid 
                     Parameters:(NSDictionary *)parameters;


- (void) loadResourcesForScene:(sceneID)sceneid
                    Parameters:(NSDictionary *)parameters 
                     InContext:(EAGLContext *)context;

//- (void)markAsUnusedTexturesFarFromSheetNumber:(int)sheetNumber InBookNumber:(int)booknumber;
- (void)markUnusedTexture:(textureID)textureid
               Parameters:(NSDictionary *)parameters;

- (void)deleteAllUnusedTextures;
- (void)deleteAllColorGalleryTexturesParameters:(NSDictionary *)parameters;
- (void)deleteUnusedColorGalleryTexturesForBook:(int)booknumber;
- (void)deleteColorGalleryTexturesForScrollingInBookNumber:(int)booknumber  
                                           FromSheetNumber:(int)numberFrom
                                                   ToSheet:(int)numberTo;
- (void) deleteAllResources;
@end
