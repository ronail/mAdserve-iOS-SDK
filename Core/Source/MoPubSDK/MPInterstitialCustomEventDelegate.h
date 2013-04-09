//
//  MPInterstitialCustomEventDelegate.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MP_MPInterstitialCustomEvent;

@protocol MPInterstitialCustomEventDelegate <NSObject>

/*
 * Your custom event subclass must call this method when it successfully loads an ad.
 * Failure to do so will disrupt the mediation waterfall and cause future ad requests to stall.
 */
- (void)interstitialCustomEvent:(MP_MPInterstitialCustomEvent *)customEvent
                      didLoadAd:(id)ad;

/*
 * Your custom event subclass must call this method when it fails to load an ad.
 * Failure to do so will disrupt the mediation waterfall and cause future ad requests to stall.
 */
- (void)interstitialCustomEvent:(MP_MPInterstitialCustomEvent *)customEvent
       didFailToLoadAdWithError:(NSError *)error;

/*
 * Your custom event subclass should call this method when it is about to present the interstitial
 * ad. This method is optional; however, if you call it, you must also call either
 * -interstitialCustomEventDidDisappear: or -interstitialCustomEventWillLeaveApplication at a later
 * point.
 */
- (void)interstitialCustomEventWillAppear:(MP_MPInterstitialCustomEvent *)customEvent;

/*
 * Your custom event subclass should call this method when the user has dismissed the interstitial
 * ad. This method is optional.
 */
- (void)interstitialCustomEventDidDisappear:(MP_MPInterstitialCustomEvent *)customEvent;

/*
 * Your custom event subclass should call this method if the ad will cause the user to leave the
 * application (e.g. for the App Store or Safari). This method is optional.
 */
- (void)interstitialCustomEventWillLeaveApplication:(MP_MPInterstitialCustomEvent *)customEvent;

@end
