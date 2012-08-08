//
//  Math.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 16.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#ifndef DynamicTextures_Math_h
#define DynamicTextures_Math_h

float sectorLength(CGPoint point1, CGPoint point2);
bool isLocationOnPaintingView(CGPoint location);
CGPoint convertLocationToPaintingViewLocation(CGPoint location);
CGPoint convertPaintingViewPixelsToGLCoords(CGPoint locationOnPaintingView);

#endif
