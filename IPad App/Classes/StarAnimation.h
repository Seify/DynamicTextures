//
//  StarAnimation.h
//  DynamicTextures
//
//  Created by Roman Smirnov on 17.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "Animation.h"

@interface StarAnimation : Animation
{
    float angle;
    float startAngle;
    float endAngle;
    
    double opaqueEndTime;
}
@property float angle;
@property float startAngle;
@property float endAngle;
@property double opaqueEndTime;
@end
