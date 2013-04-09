//
//  MPMraidInterstitialAdapter.m
//  MoPub
//
//  Created by Andrew He on 12/11/11.
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPMraidInterstitialAdapter.h"

#import "MP_MPAdConfiguration.h"
#import "MP_MPInterstitialAdController.h"
#import "MP_MPInterstitialAdManager.h"
#import "MPLogging.h"

@implementation MP_MPMRAIDInterstitialAdapter

- (void)getAdWithConfiguration:(MP_MPAdConfiguration *)configuration
{
    _interstitial = [[MP_MPMRAIDInterstitialViewController alloc]
                     initWithAdConfiguration:configuration];
    _interstitial.delegate = self;
    [_interstitial setCloseButtonStyle:MPInterstitialCloseButtonStyleAdControlled];
    [_interstitial startLoading];
}

- (void)dealloc
{
    _interstitial.delegate = nil;
    [_interstitial release];

    [super dealloc];
}

- (void)showInterstitialFromViewController:(UIViewController *)controller
{
    [_interstitial presentInterstitialFromViewController:controller];
}

#pragma mark - MPMRAIDInterstitialViewControllerDelegate

- (void)interstitialDidLoadAd:(MP_MPMRAIDInterstitialViewController *)interstitial
{
    [self.manager adapterDidFinishLoadingAd:self];
}

- (void)interstitialDidFailToLoadAd:(MP_MPMRAIDInterstitialViewController *)interstitial
{
    [self.manager adapter:self didFailToLoadAdWithError:nil];
}

- (void)interstitialWillAppear:(MP_MPMRAIDInterstitialViewController *)interstitial
{
    [self.manager interstitialWillAppearForAdapter:self];
}

- (void)interstitialDidAppear:(MP_MPMRAIDInterstitialViewController *)interstitial
{
    [self.manager interstitialDidAppearForAdapter:self];
}

- (void)interstitialWillDisappear:(MP_MPMRAIDInterstitialViewController *)interstitial
{
    [self.manager interstitialWillDisappearForAdapter:self];
}

- (void)interstitialDidDisappear:(MP_MPMRAIDInterstitialViewController *)interstitial
{
    [self.manager interstitialDidDisappearForAdapter:self];
}

// TODO: Tapped callback.

@end
