//
//  MindGamePaintingView.m
//  
//
//  Created by Roman Smirnov on 02.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MindGamePaintingView.h"

@implementation MindGamePaintingView


- (void)touchesBegan:(CGPoint)loc prevLoc:(CGPoint)prevLoc
{
    [super touchesBegan:loc prevLoc:prevLoc];
    location = loc;
	location.y = self.bounds.size.height - location.y;
	 
        int x = loc.x;
        int y = loc.y;
        if ( (loc.x > 0) && (loc.x < 559) && (loc.y > 0) && (loc.y < 799) )
            
            if ((areas[x][y]!=UNPAINTED_AREA_NUMBER) 
                &&(areas[x][y]!=BLACK_AREA_NUMBER)
                )
            {
                NSLog(@"paintingView lastSetRed = %f", lastSetRed);
                NSLog(@"paintingView lastSetGreen = %f", lastSetGreen);
                NSLog(@"paintingView lastSetBlue = %f", lastSetBlue);
                
                [self.delegate processPaintingOfArea: areas[x][y] 
                                             withRed: lastSetRed
                                               Green: lastSetGreen
                                                Blue: lastSetBlue];
            }


}

@end
