//
//  MPHTMLBannerAdapter.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPHTMLBannerAdapter.h"

#import "MP_MPAdConfiguration.h"

@implementation MP_MPHTMLBannerAdapter

- (void)getAdWithConfiguration:(MP_MPAdConfiguration *)configuration
{
    MPLogTrace(@"Loading banner with HTML source: %@", [configuration adResponseHTMLString]);

    // XXX: Passing CGRectZero as the frame can cause divide-by-zero.
    _banner = [[MP_MPAdWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _banner.delegate = self;
    _banner.customMethodDelegate = [self.delegate adViewDelegate];
    [_banner loadConfiguration:configuration];
}

- (void)dealloc
{
    _banner.delegate = nil;
    _banner.customMethodDelegate = nil;
    [_banner release];

    [super dealloc];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation
{
    [_banner rotateToOrientation:newOrientation];
}

#pragma mark - MPAdWebViewDelegate

- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)adDidFinishLoadingAd:(MP_MPAdWebView *)ad
{
    [self.delegate adapter:self didFinishLoadingAd:ad shouldTrackImpression:NO];
}

- (void)adDidFailToLoadAd:(MP_MPAdWebView *)ad
{
    [self.delegate adapter:self didFailToLoadAdWithError:nil];
}

- (void)adDidClose:(MP_MPAdWebView *)ad
{

}

- (void)adActionWillBegin:(MP_MPAdWebView *)ad
{
    [self.delegate userActionWillBeginForAdapter:self];
}

- (void)adActionDidFinish:(MP_MPAdWebView *)ad
{
    [self.delegate userActionDidFinishForAdapter:self];
}

- (void)adActionWillLeaveApplication:(MP_MPAdWebView *)ad
{
    [self.delegate userWillLeaveApplicationFromAdapter:self];
}

#pragma mark - Metrics

- (void)trackImpression
{
    // HTML banners perform their own impression tracking.
}

- (void)trackClick
{
    // HTML banners perform their own click tracking.
}

@end
