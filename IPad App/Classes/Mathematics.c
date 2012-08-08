//
//  Math.c
//  DynamicTextures
//
//  Created by Roman Smirnov on 16.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

//#include <stdio.h>
#include "math.h"
#include <CoreGraphics/CoreGraphics.h>
#include "Mathematics.h"
#include "InterfaceConstants.h"

float sectorLength(CGPoint point1, CGPoint point2) {
    return sqrtf( (point1.x-point2.x)*(point1.x-point2.x) + (point1.y-point2.y)*(point1.y-point2.y) );
}

bool isLocationOnPaintingView(CGPoint location) {
    return (location.x > PAINTING_ORIGIN_X && location.x < PAINTING_ORIGIN_X+PAINTING_WIDTH && location.y > PAINTING_ORIGIN_Y && location.y < PAINTING_ORIGIN_Y + PAINTING_HEIGHT);
}

CGPoint convertLocationToPaintingViewLocation(CGPoint location) {
    return CGPointMake(location.x - PAINTING_ORIGIN_X, location.y - PAINTING_ORIGIN_Y);
}

// для текстуры 1024*1024
CGPoint convertPaintingViewPixelsToGLCoords(CGPoint locationOnPaintingView) {
    float minX = -1.0; //минимальное значение X для VertexPosition
    float maxX = (PAINTING_WIDTH - (1024.0/2.0) ) / (1024.0/2.0); //максимальное значение X для VertexPosition. 1024 - ширина текстуры
    float lengthX = maxX - minX; // ширина PaintingView
    
    float minY = -1.0; //минимальное значение X для VertexPosition
    float maxY = (PAINTING_HEIGHT - (1024.0/2.0) ) / (1024.0/2.0); //максимальное значение Y для VertexPosition
    float lengthY = maxY - minY; // высота PaintingView
    
    CGPoint p = CGPointMake(locationOnPaintingView.x / PAINTING_WIDTH * lengthX - 1.0, locationOnPaintingView.y / PAINTING_HEIGHT * lengthY - 1.0);
    return p;
}