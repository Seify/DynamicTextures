
//
//  MKStoreManager.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//  mugunthkumar.com
//

#import "MKStoreManager.h"
#import "KidsPaintAppDelegate.h"

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;
@synthesize delegate;

// all your features should be managed one and only by StoreManager
//static NSString *featureAId = @"com.luxuryecards.test2";

//BOOL featureAPurchased;

static MKStoreManager* _sharedStoreManager; // self

- (NSMutableDictionary *) prices
{
    if (!prices) {
        prices = [[NSMutableDictionary alloc] init];
    }
    return prices;
}

- (void)dealloc {
	
	[_sharedStoreManager release];
	[storeObserver release];
	[purchasableObjects release];
	
	[featureAId release];
	[localSet release];
	 
	[super dealloc];
}

- (BOOL)isBookBought:(int)booknumber
{
    return YES;
    
    if (booknumber == 0) return YES; //книга "Герои сказок" бесплатна
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"ru.aplica.kidspaint.books.book%d", booknumber];
        BOOL bookIsBought = [defaults boolForKey:key];
//        if (bookIsBought) NSLog(@"%@ : %@ book %d IsBought", self, NSStringFromSelector(_cmd), booknumber);
//        if (!bookIsBought) NSLog(@"%@ : %@ book %d Is NOT Bought", self, NSStringFromSelector(_cmd), booknumber);
        return bookIsBought;
    }
}

- (BOOL) isProductAvaibleForSale:(NSString *)identificator
{
    NSString *key = [identificator stringByAppendingString:@"isValidID"];
    BOOL retValue = [[NSUserDefaults standardUserDefaults] boolForKey:key];

    return retValue;
}


- (BOOL) isFeatureAPurchased {
	
	return featureAPurchased;
}

+ (MKStoreManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
//			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
//			[_sharedStoreManager requestProductData];
			
//			[MKStoreManager loadPurchases];
//			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
//			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}

- (id)initWithFeatureSet:(NSArray *)featureArray {
	if([self init]) {
		localSet = [[NSSet alloc] initWithArray:featureArray];
		featureAId = [[NSString alloc] initWithString:@" "];
		purchasableObjects = [[NSMutableArray alloc] init];
        
//        productAvaible = [NSMutableArray arrayWithCapacity:[featureArray count]];
        
		[self requestProductData];
		
		storeObserver = [[MKStoreObserver alloc] init];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:storeObserver];
		
	}
	return self;	
}

#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            _sharedStoreManager = [super allocWithZone:zone];			
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}


- (void) requestProductData
{
//    NSLog(@"localSet is %@", localSet);							 
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:localSet];
//	NSLog(@"SKProductsRequest *request is %@", request);							 
	request.delegate = self;
	[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
//    NSLog(@"MKStore: productsRequest: didReceiveResponse:");
    
	[purchasableObjects addObjectsFromArray:response.products];
	// populate your UI Controls here
    
//    NSLog(@"found %d products", [purchasableObjects count]);
    
    NSArray *invalids = response.invalidProductIdentifiers;
    for (int i=0; i<invalids.count; i++)
    {
        NSString *productID = [invalids objectAtIndex:i];
        NSLog(@"invalid identifier: %@", productID);
//        [productAvaible setValue:NO forKey:productID];
        NSString *key = [productID stringByAppendingString:@"isValidID"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
        
	for(int i=0;i<[purchasableObjects count];i++)
	{		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		
//		NSString *costValue = [NSString stringWithFormat:@"%f", [[product price] doubleValue]];

		NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:product.priceLocale];
		NSString *formattedString = [numberFormatter stringFromNumber:product.price];

        [self.prices setValue:formattedString forKey:product.productIdentifier];
        NSString *key = [product.productIdentifier stringByAppendingString:@"isValidID"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [productAvaible setValue:YES forKey:product.productIdentifier];

//        NSLog(@"prices is %@", self.prices);

		//save localized cost
		//...................
//        NSLog(@"---------------------------------------");
//        NSLog(@"valid product %d is %@", i+1, product.productIdentifier);
//        NSLog(@"price is %@", product.price);
////        NSLog(@"localizedDescription is %@", product.localizedDescription);
////        NSLog(@"localizedTitle is %@", product.localizedTitle);
//        NSLog(@"priceLocale is %@", product.priceLocale);
////        NSLog(@"---------------------------------------");
	}
	
	[request autorelease];
}

- (NSString *)priceForIdentifier:(NSString *)identifier
{
    return [self.prices valueForKey:identifier];
}

- (void) buyFeatureA
{
	[self buyFeature:featureAId];
}

- (void) buyBook:(int)booknumber
{
    NSString *bookID = [NSString stringWithFormat:@"ru.aplica.kidspaint.books.book%d", booknumber]; 
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:bookID];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wishing Well" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (void) buyFeature:(NSString*) featureId
{
	featureAId = [[NSString alloc] initWithString:featureId];
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wishing Well" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

-(void)paymentCanceled
{
	NSLog(@"paymentCanceled");
	if([delegate respondsToSelector:@selector(failed)])
		[delegate failed];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if([delegate respondsToSelector:@selector(failed)])
		[delegate failed];
	
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

-(void) provideContent: (NSString*) productIdentifier
{
    
    
//	if([productIdentifier isEqualToString:featureAId])
//	{
//		featureAPurchased = YES;
//		if([delegate respondsToSelector:@selector(productAPurchased)])
//			[delegate productAPurchased];
//	}

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:productIdentifier];    
    if (![defaults synchronize]) NSLog(@"ERROR: Failed to synchronize book purchase in [MKStoreManager provideContent:]");
    
//    NSLog(@"MKStoreManager provideContent: setBool:YES forKey:%@",productIdentifier);
    
    KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
	[app goBack];
    
    
    
//        }
//             
//    }

//	[self updatePurchases];
}


- (void) loadPurchases 
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	featureAPurchased = [userDefaults boolForKey:featureAId]; 	
}

- (void) updatePurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:featureAPurchased forKey:featureAId];
}

+ (BOOL)isCurrentItemPurchased: (NSString *)itemID {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	BOOL isPurchased = [userDefaults boolForKey:itemID];
	return isPurchased;
}

@end
