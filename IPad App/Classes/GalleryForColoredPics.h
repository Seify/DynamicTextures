//
//  GalleryForColoredPics.h
//  KidsPaint
//
//  Created by Roman Smirnov on 14.05.12.
//  Copyright (c) 2012 Aplica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SheetColored.h"
#import "AcceleratedAnimation.h"
#import "GalleryForColoredPicsConstants.h"

@protocol GalleryForColoredPicsDelegate

- (int)howManyColoredSheetsInGallery:(id)sender;

- (void)newActiveColoredSheetNumber:(int)sheetNumber
                          InGallery:(id)sender; 

- (void)userDidSelectSheetNumber:(int)sheetNumber InGallery:(id)sender;

- (void)coloredSheetWillAnimateToPaintingPage:(int)sheetNumber
                                    InGallery:(id)sender;

- (void)coloredSheetDidAnimateToPaintingPage:(int)sheetNumber
                                   InGallery:(id)sender;

- (void)coloredGallery:(id)sender WillStabilizeToSheetNumber:(int)sheetNumber 
             StartTime:(double)startTime
               EndTime:(double)endTime;

- (void)coloredGallery:(id)sender DidStabilizedToSheetNumber:(int)newColoredSheetNumber;

- (void)coloredSheetDidAnimateToGallery:(id)sender;

- (BOOL)shouldAnimateSelectedSheetInGallery:(id)sender;

@end

@interface GalleryForColoredPics : NSObject
{
    id <GalleryForColoredPicsDelegate> delegate;
    NSMutableArray *sheets;
    galleryColoredState state;
}

@property (assign) id <GalleryForColoredPicsDelegate> delegate;
@property (readonly) NSMutableArray *sheets;
@property galleryColoredState state;
@property BOOL shouldChangeEdgeSheetsZ;  // перемещаются ли листы вглубь экрана при промотке
@property float startPositionShiftLeft;

- (id)initWithType:(galleryType)galType;

- (void)changeStateTo:(galleryColoredState)newstate AtTime:(double)currtime;

- (void)touchBeganAtLocation:(CGPoint)location;
- (void)touchMovedAtLocation:(CGPoint)location 
            PreviousLocation:(CGPoint)previousLocation
               InsideGallery:(BOOL)inside;
- (void)touchEndedAtLocation:(CGPoint)location 
               InsideGallery:(BOOL)inside;
- (void)touchesCancelledLocation:(CGPoint)location;

- (void)updateSheets:(double)currtime;

- (BOOL)shouldDrawSheet: (SheetColored *)sh;

- (void)scrollToSheetNumber:(int)sheetNumber 
                  StartTime:(double)startTime 
                    EndTime:(double)endTime;

- (void)addEmptySheetInTheEnd;

@end
