//
//  DTLayer.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 09.08.12.
//
//

#import <Foundation/Foundation.h>

@interface DTLayer : NSObject
@property GLuint userDrawingTexture;
@property GLuint dynamicTexture;
@property BOOL isVisible;
@property float opacity;
- (void)update:(double)currtime;
- (void)draw;
@end
