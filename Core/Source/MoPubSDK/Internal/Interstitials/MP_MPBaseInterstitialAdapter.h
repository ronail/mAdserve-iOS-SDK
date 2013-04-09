//
//  MPBaseInterstitialAdapter.h
//  MoPub
//
//  Created by Nafis Jamal on 4/27/11.
//  Copyright 2011 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MP_MPInterstitialAdController;
@class MP_MPInterstitialAdManager;
@class MP_MPAdConfiguration;

@interface MP_MPBaseInterstitialAdapter : NSObject 
{
	MP_MPInterstitialAdController *_interstitialAdController;
    MP_MPInterstitialAdManager *_manager;
}

@property (nonatomic, readonly) MP_MPInterstitialAdController *interstitialAdController;
@property (nonatomic, assign) MP_MPInterstitialAdManager *manager;

/*
 * Creates an adapter with a reference to an MPAdView.
 */
- (id)initWithInterstitialAdController:(MP_MPInterstitialAdController *)interstitialAdController;

/*
 * Sets the adapter's delegate to nil.
 */
- (void)unregisterDelegate;

/*
 * -getAdWithParams: needs to be implemented by adapter subclasses that want to load native ads.
 * -getAd simply calls -getAdWithParams: with a nil dictionary.
 */
- (void)getAd;
- (void)getAdWithParams:(NSDictionary *)params;
- (void)_getAdWithParams:(NSDictionary *)params;

- (void)getAdWithConfiguration:(MP_MPAdConfiguration *)configuration;
- (void)_getAdWithConfiguration:(MP_MPAdConfiguration *)configuration;

/*
 * Presents the interstitial from the specified view controller.
 */
- (void)showInterstitialFromViewController:(UIViewController *)controller;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPBaseInterstitialAdapterDelegate

@required
/*
 * These callbacks notify you that the adapter (un)successfully loaded an ad.
 */
- (void)adapterDidFinishLoadingAd:(MP_MPBaseInterstitialAdapter *)adapter;
- (void)adapter:(MP_MPBaseInterstitialAdapter *)adapter didFailToLoadAdWithError:(NSError *)error;

/*
 *
 */
- (void)interstitialWillAppearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter;
- (void)interstitialDidAppearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter;
- (void)interstitialWillDisappearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter;
- (void)interstitialDidDisappearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter;

- (void)interstitialWasTappedForAdapter:(MP_MPBaseInterstitialAdapter *)adapter;
- (void)interstitialDidExpireForAdapter:(MP_MPBaseInterstitialAdapter *)adapter;

- (void)interstitialWillLeaveApplicationForAdapter:(MP_MPBaseInterstitialAdapter *)adapter;

@end
