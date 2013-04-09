//
//  MPMRAIDInterstitialViewController.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPInterstitialViewController.h"

#import "MR_MRAdView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPMRAIDInterstitialViewControllerDelegate;
@class MP_MPAdConfiguration;

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MP_MPMRAIDInterstitialViewController : MP_MPInterstitialViewController <MRAdViewDelegate>
{
    id<MPMRAIDInterstitialViewControllerDelegate> _delegate;
    MR_MRAdView *_interstitialView;
    MP_MPAdConfiguration *_configuration;
    BOOL _advertisementHasCustomCloseButton;
}

@property (nonatomic, assign) id<MPMRAIDInterstitialViewControllerDelegate> delegate;

- (id)initWithAdConfiguration:(MP_MPAdConfiguration *)configuration;
- (void)startLoading;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPMRAIDInterstitialViewControllerDelegate <NSObject>

- (void)interstitialDidLoadAd:(MP_MPMRAIDInterstitialViewController *)interstitial;
- (void)interstitialDidFailToLoadAd:(MP_MPMRAIDInterstitialViewController *)interstitial;
- (void)interstitialWillAppear:(MP_MPMRAIDInterstitialViewController *)interstitial;
- (void)interstitialDidAppear:(MP_MPMRAIDInterstitialViewController *)interstitial;
- (void)interstitialWillDisappear:(MP_MPMRAIDInterstitialViewController *)interstitial;
- (void)interstitialDidDisappear:(MP_MPMRAIDInterstitialViewController *)interstitial;

@end