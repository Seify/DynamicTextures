
#import "ThreeDAnimation.h"

@implementation ThreeDAnimation

@synthesize startTranslationX;
@synthesize translationX;
@synthesize endTranslationX;

@synthesize startTranslationY;
@synthesize translationY;
@synthesize endTranslationY;

@synthesize startTranslationZ;
@synthesize translationZ;
@synthesize endTranslationZ;

@synthesize startRotationX;
@synthesize rotationX;
@synthesize endRotationX;

@synthesize startRotationY;
@synthesize rotationY;
@synthesize endRotationY;

@synthesize startRotationZ;
@synthesize rotationZ;
@synthesize endRotationZ;

@synthesize startScaleX;
@synthesize scaleX;
@synthesize endScaleX;

@synthesize startScaleY;
@synthesize scaleY;
@synthesize endScaleY;

@synthesize startScaleZ;
@synthesize scaleZ;
@synthesize endScaleZ; 

@synthesize delegate;

- (void)updatePhysicsAtTime:(double)currtime{
    
    if (self.startTime <= currtime && currtime < self.endTime) {
        
        self.state = ANIMATION_STATE_PLAYING;
        
        double timescale = (currtime - self.startTime)/(self.endTime - self.startTime);
        
        double deltaX = self.endPosition.origin.x - self.startPosition.origin.x;
        double deltaY = self.endPosition.origin.y - self.startPosition.origin.y;
        double deltaWidth = self.endPosition.size.width - self.startPosition.size.width;
        double deltaHeight = self.endPosition.size.height - self.startPosition.size.height;
        
        self.position = CGRectMake(
                                   self.startPosition.origin.x + timescale * deltaX,
                                   self.startPosition.origin.y + timescale * deltaY,
                                   self.startPosition.size.width + timescale * deltaWidth,
                                   self.startPosition.size.height + timescale * deltaHeight);
        
        self.alpha = self.startAlpha + timescale * (self.endAlpha - self.startAlpha);


        self.translationX = self.startTranslationX + timescale * (self.endTranslationX - self.startTranslationX);
        self.translationY = self.startTranslationY + timescale * (self.endTranslationY - self.startTranslationY);
        self.translationZ = self.startTranslationZ + timescale * (self.endTranslationZ - self.startTranslationZ);
        
        self.rotationX = self.startRotationX + timescale * (self.endRotationX - self.startRotationX);
        self.rotationY = self.startRotationY + timescale * (self.endRotationY - self.startRotationY);
        self.rotationZ = self.startRotationZ + timescale * (self.endRotationZ - self.startRotationZ);
        
        self.scaleX = self.startScaleX + timescale * (self.endScaleX - self.startScaleX);
        self.scaleY = self.startScaleY + timescale * (self.endScaleY - self.startScaleY);
        self.scaleZ = self.startScaleZ + timescale * (self.endScaleZ - self.startScaleZ);
        
//        NSLog(@"%@ : %@ .animation.translationX = %f", self, NSStringFromSelector(_cmd), self.translationX );
//        NSLog(@"%@ : %@ .animation.translationZ = %f", self, NSStringFromSelector(_cmd), self.translationZ );
//        NSLog(@"%@ : %@ .animation.rotationY    = %f", self, NSStringFromSelector(_cmd), self.rotationY );
        
    } else if (currtime >= self.endTime){
        
//        NSLog(@"%@ : %@ currtime = %f, self.endTime = %f", self, NSStringFromSelector(_cmd), currtime, self.endTime);

        self.position = self.endPosition;
        self.alpha = self.endAlpha;
        
        self.translationX = self.endTranslationX;
        self.translationY = self.endTranslationY;
        self.translationZ = self.endTranslationZ;
        
        self.rotationX = self.endRotationX;
        self.rotationY = self.endRotationY;
        self.rotationZ = self.endRotationZ;
        
        self.scaleX = self.endScaleX;
        self.scaleY = self.endScaleY;
        self.scaleZ = self.endScaleZ;
        
        if (self.state == ANIMATION_STATE_PLAYING){
            [self.delegate animationEnded];
        }
        
        self.state = ANIMATION_STATE_STOPPED;
    }

}
@end
