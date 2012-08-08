//
//  PaintImageView.h
//  DynamicTextures
//
//  Created by naceka on 20.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Flooder.h"

// UIImageView с поддержкой рисования (для карандаша)
@interface PaintImageView : UIImageView {
	UIColor* paintColor;
	CGPoint currentPoint;
//	Flooder* flooder;
	
	CGPoint lastPoint;
	BOOL mouseSwiped;	
}

-(void) fillArea;

-(void) setPaintColor:(UIColor*)color;
-(void) initDefaults: (UIImage*) initialImage;
-(void) releaseData;

@end
