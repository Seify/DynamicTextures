//
//  StoreManager.h
//  MKSync
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 MK Inc. All rights reserved.
//  mugunthkumar.com

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"


@protocol MKStoreKitDelegate <NSObject>
- (BOOL)isBookBought:(int)booknumber;
@optional
- (void)productAPurchased;
- (void)failed;
@end

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
    NSMutableDictionary *prices;
	MKStoreObserver *storeObserver;	

	id<MKStoreKitDelegate> delegate;
	
	NSString *featureAId;
	NSSet *localSet;
	BOOL featureAPurchased;
    
//    NSMutableDictionary *productAvaible;
}

@property (nonatomic, retain) id<MKStoreKitDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;
@property (retain, readonly) NSMutableDictionary *prices;

+ (MKStoreManager*)sharedManager;

- (id)initWithFeatureSet:(NSArray *)featureSet;

- (void) requestProductData;
- (void) buyFeatureA; // expose product buying functions, do not expose
- (void) buyFeature:(NSString*) featureId;
- (void) buyBook:(int)booknumber;
- (void)paymentCanceled;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) provideContent: (NSString*) productIdentifier;
- (BOOL) isProductAvaibleForSale:(NSString *)identificator;

- (BOOL)isBookBought:(int)booknumber;
- (BOOL) isFeatureAPurchased; //ex +
+ (BOOL)isCurrentItemPurchased: (NSString *)itemID;

- (void) loadPurchases; //+
- (void) updatePurchases; //+

- (NSString *)priceForIdentifier:(NSString *)identifier;

@end
