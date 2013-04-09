//
//  MPHTMLInterstitialViewController.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MP_MPAdWebView.h"
#import "MP_MPInterstitialViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPHTMLInterstitialViewControllerDelegate;
@class MP_MPAdConfiguration;

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MP_MPHTMLInterstitialViewController : MP_MPInterstitialViewController <MPAdWebViewDelegate>
{
    id<MPHTMLInterstitialViewControllerDelegate> _delegate;
    MP_MPAdWebView *_interstitialView;
}

@property (nonatomic, assign) id<MPHTMLInterstitialViewControllerDelegate> delegate;

- (id)customMethodDelegate;
- (void)setCustomMethodDelegate:(id)delegate;
- (void)loadConfiguration:(MP_MPAdConfiguration *)configuration;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPHTMLInterstitialViewControllerDelegate <NSObject>

- (void)interstitialDidLoadAd:(MP_MPHTMLInterstitialViewController *)interstitial;
- (void)interstitialDidFailToLoadAd:(MP_MPHTMLInterstitialViewController *)interstitial;
- (void)interstitialWillAppear:(MP_MPHTMLInterstitialViewController *)interstitial;
- (void)interstitialDidAppear:(MP_MPHTMLInterstitialViewController *)interstitial;
- (void)interstitialWillDisappear:(MP_MPHTMLInterstitialViewController *)interstitial;
- (void)interstitialDidDisappear:(MP_MPHTMLInterstitialViewController *)interstitial;
- (void)interstitialWasTapped:(MP_MPHTMLInterstitialViewController *)interstitial;
- (void)interstitialWillLeaveApplication:(MP_MPHTMLInterstitialViewController *)interstitial;

@end