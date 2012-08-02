#import "GalleryAsInPaper.h"

@interface GalleryAsInPaper()
{
    BOOL draggingOn;        // пользователь листает галерею
    Sheet *sheetToScale;    // лист, который анимируется в/из экран(а) рисования
}
- (Sheet *)findNearestSheet;
@end

@implementation GalleryAsInPaper

@synthesize state;
@synthesize delegate;

// создаем массив листов
-(NSArray *)sheets{
    if (!sheets){
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (int i = 0; i < [self.delegate howManySheets]; i++) {
            Sheet *shright = [[Sheet alloc] initWithType:SHEET_TYPE_RIGHT];
            shright.state = SHEET_STATE_SHOWING_PICS;
            shright.translationX = i * HACK_CONSTANT;
            shright.number = i;
            shright.scaleX = SHEET_SCALE_X;
            shright.scaleY = SHEET_SCALE_Y;
            shright.scaleZ = SHEET_SCALE_Z;
            [tempArray addObject:shright];
            [shright release];
            Sheet *shleft = [[Sheet alloc] initWithType:SHEET_TYPE_LEFT];
            shleft.state = SHEET_STATE_SHOWING_PICS;
            shleft.translationX = i * HACK_CONSTANT;
            shleft.number = i;
            shleft.scaleX = SHEET_SCALE_X;
            shleft.scaleY = SHEET_SCALE_Y;
            shleft.scaleZ = SHEET_SCALE_Z;
            [tempArray addObject:shleft];
            [shleft release];
        }
        
        sheets = [NSArray arrayWithArray:tempArray];
        [sheets retain];
        
    }
    return sheets;
}

// находим лист ближайший к центру экрана (у него минимальное отклонение translationX от нуля)
//
- (Sheet *)findNearestSheet{
    
    Sheet *nearestSheet = [self.sheets lastObject];
    
    for (Sheet *currentSheet in self.sheets){
//        if (currentSheet.type == SHEET_TYPE_LEFT)
        if (currentSheet.type == SHEET_TYPE_RIGHT) // левый или правый зависит от того, на каком листе будет раскрашенный образец, а на каком - чб картинка
            if (fabs(nearestSheet.translationX) >= fabs(currentSheet.translationX)){
                nearestSheet = currentSheet;
            }
    }
    
    return nearestSheet;
}

// нужно ли рисовать лист
// не нужно если он повернут более чем на 90 градусов (и его заслоняет другой лист)
// либо если он находится далеко от центра, либо он скрыт
//
- (BOOL)shouldDrawSheet:(Sheet *)sh{
    
    BOOL retValue;
    
    switch (sh.state) {
        case SHEET_STATE_SHOWING_PICS:
        case SHEET_STATE_STABILIZING:
        {
            
            switch (sh.type) {
                case SHEET_TYPE_LEFT:{
                    retValue = (sh.rotationY < 90.0 && abs(sh.translationX) < 3 * HACK_CONSTANT);
                    break;
                }
                    
                case SHEET_TYPE_RIGHT:{
                    retValue = (sh.rotationY > -90.0 && abs(sh.translationX) < 3 * HACK_CONSTANT);
                    break;
                }
                    
                default:{
                    NSLog(@"%@ : %@ Unexpected sheet type: %d", self, NSStringFromSelector(_cmd), sh.type);
                    break;
                }
            }
            break;
        }
            
        case SHEET_STATE_SCALING_TO_PAINTING_AREA:        
        {
            retValue = YES;
            break;
        }
            
        case SHEET_STATE_UNSCALING_FROM_PAINTING_AREA:
        {
            if (sh == sheetToScale){
                retValue = YES;
            } 
            else {
                switch (sh.type) {
                    case SHEET_TYPE_LEFT:{
                        retValue = (sh.rotationY < 90.0 && abs(sh.translationX) < 3 * HACK_CONSTANT);
                        break;
                    }
                        
                    case SHEET_TYPE_RIGHT:{
                        retValue = (sh.rotationY > -90.0 && abs(sh.translationX) < 3 * HACK_CONSTANT);
                        break;
                    }
                        
                    default:{
                        NSLog(@"%@ : %@ Unexpected sheet type: %d", self, NSStringFromSelector(_cmd), sh.type);
                        break;
                    }
                }
            }
            break;
        }

        case SHEET_STATE_HIDING:{
            retValue = NO;
            break;
        }
        case SHEET_STATE_HIDDEN:{
            retValue = NO;
            break;
        }
            
        default:{
            NSLog(@"%@ : %@  Unexpected sheet state: %d", self, NSStringFromSelector(_cmd), sh.state);
            break;
        }
    }
    return retValue;
}


// стабилизация галереи
- (void)stabilize {
    
    self.state = GALLERY_STATE_STABILIZING;
    
    Sheet *nearestSheet = [self findNearestSheet];
    double tr = nearestSheet.translationX;
    
    double time = CFAbsoluteTimeGetCurrent();
    
    for (Sheet *sh in self.sheets){
        sh.stabilisation.startTime = time;
        sh.stabilisation.endTime = sh.stabilisation.startTime + STABILIZATION_TIME;
        sh.stabilisation.startPosition = CGRectMake(sh.translationX, 0, 0, 0);
        sh.stabilisation.endPosition = CGRectMake(sh.translationX - tr, 0, 0, 0);
        sh.stabilisation.state = ANIMATION_STATE_PLAYING;
        sh.state = SHEET_STATE_STABILIZING;
    }    
    
//    [self.delegate newActiveSheetNumber:nearestSheet.number];
    [self.delegate galleryWillStabilizeToSheetNumber:nearestSheet.number     
                                           StartTime:nearestSheet.stabilisation.startTime 
                                             EndTime:nearestSheet.stabilisation.endTime];
}

#pragma mark - Gesture handlers

- (void)touchBeganAtLocation:(CGPoint)location{
        
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
}

- (void)touchMovedAtLocation:(CGPoint)location 
            PreviousLocation:(CGPoint)previousLocation
               InsideGallery:(BOOL)inside{
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
    switch (self.state) {
        case GALLERY_STATE_SHOWING_PICS:{
            
            if (inside) {
            
                draggingOn = YES;
                
                double deltaX = (location.x-previousLocation.x) * TRANSLATION_SPEED_FACTOR;
                
                if ([self.sheets count] > 2)
                {
                    Sheet *firstSheet = [self.sheets objectAtIndex:0];
                    Sheet *lastSheet = [self.sheets lastObject];
                        
                    // проверка, не выходит ли положение крайних листов за границы допустимого
                    if( (firstSheet.translationX + deltaX < 0.3 * HACK_CONSTANT) &&
                        (lastSheet.translationX + deltaX > -0.3 * HACK_CONSTANT) )
                    {
                        for (Sheet *sh in self.sheets){
                            sh.translationX += deltaX;
                        }
                    }
                }
            }
            else {
                if (self.state != GALLERY_STATE_STABILIZING){
                    [self stabilize];
                }
            }
                
            break;   
        }
            
        case GALLERY_STATE_STABILIZING:{
            
            break;
        }
            
        case GALLERY_STATE_HIDDEN:{
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected gallery state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

- (void)touchEndedAtLocation:(CGPoint)location
               InsideGallery:(BOOL)inside{
    
//    NSLog(@"%@ : %@", self, NSStringFromSelector(_cmd));
    
        switch (self.state) {
            case GALLERY_STATE_SHOWING_PICS:{
                if (draggingOn){
                    
                    if (self.state != GALLERY_STATE_STABILIZING){
                        self.state = GALLERY_STATE_STABILIZING;
                        [self stabilize];
                    }
                    
                } else {
                    
                    if (inside){
                        
                        [self changeStateTo:GALLERY_STATE_SCALING_TO_PAINTING_AREA AtTime:CFAbsoluteTimeGetCurrent()];


                    }
                    
                }
                draggingOn = NO;
            
                break;
            }
                
            case GALLERY_STATE_SCALING_TO_PAINTING_AREA:
            case GALLERY_STATE_HIDDEN:
            case GALLERY_STATE_UNSCALING_FROM_PAINTING_AREA:
            case GALLERY_STATE_STABILIZING:{
                // do nothing
                break;
            }
                
            default:{
                NSLog(@"%@ : %@ unexpected gallery state: %d", self, NSStringFromSelector(_cmd), self.state);
                break;
            }
        }
}

- (void)touchesCancelledLocation:(CGPoint)location
{
    [self touchEndedAtLocation:location InsideGallery:NO];
};

#pragma mark - State Machine

- (void)changeStateTo:(galleryState)newstate AtTime:(double)currtime{

    switch (newstate) {
            
        case GALLERY_STATE_SCALING_TO_PAINTING_AREA:{
            
            Sheet *nearestSheet = [self findNearestSheet];
            
            sheetToScale = nearestSheet;
            
            [self.delegate sheetWillAnimateToPaintingPage:sheetToScale.number];
            
            
            for (Sheet *sh in self.sheets){
                if (sh != nearestSheet) {
                    sh.state = SHEET_STATE_HIDING;
                }
            }
            
            nearestSheet.state = SHEET_STATE_SCALING_TO_PAINTING_AREA;
            
            sheetToScale.previousScaleX = sheetToScale.scaleX;
            sheetToScale.previousScaleY = sheetToScale.scaleY;
            sheetToScale.previousScaleZ = sheetToScale.scaleZ;
            
            sheetToScale.previousTranslationX = sheetToScale.translationX;
            sheetToScale.previousTranslationY = sheetToScale.translationY;
            sheetToScale.previousTranslationZ = sheetToScale.translationZ;
            
            sheetToScale.previousRotationY = sheetToScale.rotationY;
            
            nearestSheet.animation.startTime = currtime;
            nearestSheet.animation.endTime = nearestSheet.animation.startTime + SCALING_TO_PAINTING_PAGE_DURATION;
            
            nearestSheet.animation.startTranslationX = nearestSheet.translationX;
            nearestSheet.animation.startTranslationY = nearestSheet.translationY;
            nearestSheet.animation.startTranslationZ = nearestSheet.translationZ;
            
            nearestSheet.animation.endTranslationX = SCALING_TO_PAINTING_PAGE_END_TRANSLATION_X;
            nearestSheet.animation.endTranslationY = SCALING_TO_PAINTING_PAGE_END_TRANSLATION_Y;
            nearestSheet.animation.endTranslationZ = SCALING_TO_PAINTING_PAGE_END_TRANSLATION_Z;
            
            nearestSheet.animation.startRotationX = 0.0;
            nearestSheet.animation.startRotationY = nearestSheet.rotationY;
            nearestSheet.animation.startRotationZ = 0.0;
            
            if (nearestSheet.type == SHEET_TYPE_LEFT){
                nearestSheet.animation.endRotationX = SCALING_TO_PAINTING_PAGE_END_ROTATION_X;
                nearestSheet.animation.endRotationY = SCALING_TO_PAINTING_PAGE_END_ROTATION_Y;
                nearestSheet.animation.endRotationZ = SCALING_TO_PAINTING_PAGE_END_ROTATION_Z;
            } else {
                nearestSheet.animation.endRotationX = SCALING_TO_PAINTING_PAGE_END_ROTATION_X - 180;
                nearestSheet.animation.endRotationY = SCALING_TO_PAINTING_PAGE_END_ROTATION_Y - 180;
                nearestSheet.animation.endRotationZ = SCALING_TO_PAINTING_PAGE_END_ROTATION_Z - 180;
            }
            
            nearestSheet.animation.startScaleX = nearestSheet.scaleX;
            nearestSheet.animation.startScaleY = nearestSheet.scaleY;
            nearestSheet.animation.startScaleZ = nearestSheet.scaleZ;
            
            nearestSheet.animation.endScaleX = SCALING_TO_PAINTING_PAGE_END_SCALE_X;
            nearestSheet.animation.endScaleY = SCALING_TO_PAINTING_PAGE_END_SCALE_Y;
            nearestSheet.animation.endScaleZ = SCALING_TO_PAINTING_PAGE_END_SCALE_Z;                    
            
            nearestSheet.animation.state = ANIMATION_STATE_PLAYING;

            break;
        }
        case GALLERY_STATE_UNSCALING_FROM_PAINTING_AREA:
        {
            for (Sheet *sh in self.sheets){
                sh.state = SHEET_STATE_UNSCALING_FROM_PAINTING_AREA;
            }        
            
            sheetToScale.animation.startTime = currtime;
            sheetToScale.animation.endTime = sheetToScale.animation.startTime + SCALING_TO_GALLERY_PAGE_DURATION;
            
            sheetToScale.animation.startTranslationX = sheetToScale.translationX;
            sheetToScale.animation.startTranslationY = sheetToScale.translationY;
            sheetToScale.animation.startTranslationZ = sheetToScale.translationZ;
            
            sheetToScale.animation.endTranslationX = sheetToScale.previousTranslationX;
            sheetToScale.animation.endTranslationY = sheetToScale.previousTranslationY;
            sheetToScale.animation.endTranslationZ = sheetToScale.previousTranslationZ;
            
            sheetToScale.animation.startRotationX = 0.0;
            sheetToScale.animation.startRotationY = sheetToScale.rotationY;
            sheetToScale.animation.startRotationZ = 0.0;
            
//                nearestSheet.animation.endRotationX = SCALING_TO_PAINTING_PAGE_END_ROTATION_X;
            sheetToScale.animation.endRotationY = sheetToScale.previousRotationY;
//                nearestSheet.animation.endRotationZ = SCALING_TO_PAINTING_PAGE_END_ROTATION_Z;
            
            sheetToScale.animation.startScaleX = sheetToScale.scaleX;
            sheetToScale.animation.startScaleY = sheetToScale.scaleY;
            sheetToScale.animation.startScaleZ = sheetToScale.scaleZ;
            
            sheetToScale.animation.endScaleX = sheetToScale.previousScaleX;
            sheetToScale.animation.endScaleY = sheetToScale.previousScaleY;
            sheetToScale.animation.endScaleZ = sheetToScale.previousScaleZ;                    
            
            sheetToScale.animation.state = ANIMATION_STATE_PLAYING;
            
            break;
        }
            
        case GALLERY_STATE_SHOWING_PICS:{
            for (Sheet *sh in self.sheets){
                sh.state = SHEET_STATE_SHOWING_PICS;
            }     
            break;
        }
            
    
        default:{
            NSLog(@"%@ : %@ Warning! Unexpected Gallery's new state: %d", self, NSStringFromSelector(_cmd), newstate);
            break;
        }
    }
    
    self.state = newstate;
}

#pragma mark - Physics

- (void)updateSheets:(double)currtime{
    
    switch (self.state) {
        case GALLERY_STATE_SHOWING_PICS:{
            for (Sheet *sh in self.sheets){
                
                [sh updatePhysicsAtTime:currtime];
            }
            break;
        }
            
        case GALLERY_STATE_SCALING_TO_PAINTING_AREA:{
            if (sheetToScale.animation.state == ANIMATION_STATE_PLAYING){
                [sheetToScale.animation updatePhysicsAtTime:currtime];

                sheetToScale.translationX = sheetToScale.animation.translationX;
                sheetToScale.translationY = sheetToScale.animation.translationY;
                sheetToScale.translationZ = sheetToScale.animation.translationZ;
                
                sheetToScale.rotationY = sheetToScale.animation.rotationY;
                
                sheetToScale.scaleX = sheetToScale.animation.scaleX;
                sheetToScale.scaleY = sheetToScale.animation.scaleY;
                sheetToScale.scaleZ = sheetToScale.animation.scaleZ;                  
            } 
            
            
            else if (sheetToScale.animation.state == ANIMATION_STATE_STOPPED){
                [self.delegate sheetDidAnimateToPaintingPage:sheetToScale.number];
                
                self.state = GALLERY_STATE_HIDDEN;
            }
            
            break;
            
        }
            
        case GALLERY_STATE_STABILIZING:{
                       
            BOOL allSheetsStabilized = YES;
            for (Sheet *sh in self.sheets){
                [sh updatePhysicsAtTime:currtime];
                if (sh.state == SHEET_STATE_STABILIZING) {
                    allSheetsStabilized = NO;
                }
            }
            
            if (allSheetsStabilized){
                self.state = GALLERY_STATE_SHOWING_PICS;
                [self.delegate galleryDidStabilized];
            }
            
            break;
        }
            
        case GALLERY_STATE_UNSCALING_FROM_PAINTING_AREA:{

            if (sheetToScale.animation.state == ANIMATION_STATE_PLAYING){
                [sheetToScale.animation updatePhysicsAtTime:currtime];
                
                sheetToScale.translationX = sheetToScale.animation.translationX;
                sheetToScale.translationY = sheetToScale.animation.translationY;
                sheetToScale.translationZ = sheetToScale.animation.translationZ;
                
                sheetToScale.rotationY = sheetToScale.animation.rotationY;
                
                sheetToScale.scaleX = sheetToScale.animation.scaleX;
                sheetToScale.scaleY = sheetToScale.animation.scaleY;
                sheetToScale.scaleZ = sheetToScale.animation.scaleZ;       
            } 
            
            
            else if (sheetToScale.animation.state == ANIMATION_STATE_STOPPED){
                [self.delegate sheetDidAnimateToGallery];
                
                self.state = GALLERY_STATE_SHOWING_PICS;
            }
            
            break;            
        }
        case GALLERY_STATE_HIDDEN:{
            for (Sheet *sh in self.sheets){
                sh.state = SHEET_STATE_HIDDEN;
            }
            break;
        }
            
        default:{
            NSLog(@"%@ : %@ unexpected gallery state: %d", self, NSStringFromSelector(_cmd), self.state);
            break;
        }
    }
}

- (void)dealloc{
    [self.sheets release];
    [super dealloc];
}

@end
