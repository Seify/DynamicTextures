//
//  AcceleratedAnimation.h
//  KidsPaint
//
//  Created by Roman Smirnov on 27.04.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import "Animation.h"

@interface AcceleratedAnimation : Animation
{
    double acceleration;
    double startSpeed;
    CGRect previousPosition;
}
//@property double acceleration;
//@property double startSpeed;
//@property CGRect previousPosition;
@end
