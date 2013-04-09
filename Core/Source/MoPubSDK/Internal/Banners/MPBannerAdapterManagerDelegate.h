//
//  MPBannerAdapterManagerDelegate.h
//  MoPub
//
//  Copyright (c) 2012 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MP_MPAdView.h"
#import "MP_MPError.h"

@class MP_MPBannerAdapterManager;

@protocol MPBannerAdapterManagerDelegate <NSObject>

@required

#pragma mark - Helpers for adapters

- (MP_MPAdView *)adView;
- (id<MPAdViewDelegate>)adViewDelegate;
- (UIViewController *)rootViewController;

#pragma mark - Callbacks

- (void)adapterManager:(MP_MPBannerAdapterManager *)manager didLoadAd:(UIView *)ad;
- (void)adapterManager:(MP_MPBannerAdapterManager *)manager didRefreshAd:(UIView *)ad;
- (void)adapterManager:(MP_MPBannerAdapterManager *)manager didFailToLoadAdWithError:(MP_MPError *)error;
- (void)adapterManagerUserActionWillBegin:(MP_MPBannerAdapterManager *)manager;
- (void)adapterManagerUserActionDidFinish:(MP_MPBannerAdapterManager *)manager;
- (void)adapterManagerUserWillLeaveApplication:(MP_MPBannerAdapterManager *)manager;

@end
