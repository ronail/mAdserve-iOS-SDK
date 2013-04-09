//
//  MPHTMLInterstitialAdapter.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPHTMLInterstitialAdapter.h"

#import "MP_MPAdConfiguration.h"
#import "MP_MPInterstitialAdController.h"
#import "MPLogging.h"

@implementation MP_MPHTMLInterstitialAdapter

- (void)getAdWithConfiguration:(MP_MPAdConfiguration *)configuration
{
    MPLogTrace(@"Loading HTML interstitial with source: %@", [configuration adResponseHTMLString]);

    _interstitial = [[MP_MPHTMLInterstitialViewController alloc] init];
    _interstitial.delegate = self;
    _interstitial.orientationType = configuration.orientationType;
    [_interstitial setCustomMethodDelegate:[self.interstitialAdController delegate]];
    [_interstitial loadConfiguration:configuration];
}

- (void)dealloc
{
    [_interstitial setDelegate:nil];
    [_interstitial setCustomMethodDelegate:nil];
    [_interstitial release];
    [super dealloc];
}

- (void)showInterstitialFromViewController:(UIViewController *)controller
{
    [_interstitial presentInterstitialFromViewController:controller];
}

#pragma mark - MPHTMLInterstitialViewControllerDelegate

- (void)interstitialDidLoadAd:(MP_MPHTMLInterstitialViewController *)interstitial
{
    [self.manager adapterDidFinishLoadingAd:self];
}

- (void)interstitialDidFailToLoadAd:(MP_MPHTMLInterstitialViewController *)interstitial
{
    [self.manager adapter:self didFailToLoadAdWithError:nil];
}

- (void)interstitialWillAppear:(MP_MPHTMLInterstitialViewController *)interstitial
{
    [self.manager interstitialWillAppearForAdapter:self];
}

- (void)interstitialDidAppear:(MP_MPHTMLInterstitialViewController *)interstitial
{
    [self.manager interstitialDidAppearForAdapter:self];
}

- (void)interstitialWillDisappear:(MP_MPHTMLInterstitialViewController *)interstitial
{
    [self.manager interstitialWillDisappearForAdapter:self];
}

- (void)interstitialDidDisappear:(MP_MPHTMLInterstitialViewController *)interstitial
{
    [self.manager interstitialDidDisappearForAdapter:self];
}

- (void)interstitialWasTapped:(MP_MPHTMLInterstitialViewController *)interstitial
{
    [self.manager interstitialWasTappedForAdapter:self];
}

- (void)interstitialWillLeaveApplication:(MP_MPHTMLInterstitialViewController *)interstitial
{
    [self.manager interstitialWillLeaveApplicationForAdapter:self];
}

@end
