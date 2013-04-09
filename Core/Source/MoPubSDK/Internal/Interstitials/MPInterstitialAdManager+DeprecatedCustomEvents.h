//
//  MPInterstitialAdManager+DeprecatedCustomEvents.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPInterstitialAdManager.h"

@interface MP_MPInterstitialAdManager (DeprecatedCustomEvents)

- (void)customEventDidLoadAd;
- (void)customEventDidFailToLoadAd;
- (void)customEventActionWillBegin;

@end
