//
//  MPBannerAdapterManager.m
//  MoPub
//
//  Copyright (c) 2012 MoPub. All rights reserved.
//

#import <objc/runtime.h>

#import "MP_MPBannerAdapterManager.h"

#import "MP_MPAdapterMap.h"
#import "MP_MPBannerCustomEventAdapter.h"
#import "MP_MPError.h"

@interface MP_MPBannerAdapterManager ()
{
    UIView *_requestedAd;
}

@property (nonatomic, retain) UIView *requestedAd;
@property (nonatomic, readwrite, retain) MP_MPBaseAdapter *requestingAdapter;
@property (nonatomic, readwrite, retain) MP_MPBaseAdapter *currentOnscreenAdapter;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MP_MPBannerAdapterManager

@synthesize delegate = _delegate;
@synthesize requestedAd = _requestedAd;
@synthesize requestingAdapter = _requestingAdapter;
@synthesize currentOnscreenAdapter = _currentOnscreenAdapter;

- (id)initWithDelegate:(id<MPBannerAdapterManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;

    [_requestedAd release];

    [_requestingAdapter unregisterDelegate];
    [_requestingAdapter release];

    [_currentOnscreenAdapter unregisterDelegate];
    [_currentOnscreenAdapter release];

    [super dealloc];
}

#pragma mark - Public

- (void)loadAdapterForConfig:(MP_MPAdConfiguration *)config
{
    [self.requestingAdapter unregisterDelegate];
    self.requestingAdapter = nil;

    if ([[config networkType] isEqualToString:@"clear"]) {
        MPLogInfo(@"No inventory available for banner.");
        MP_MPError *noInventoryError = [MP_MPError errorWithCode:MPErrorNoInventory];
        [_delegate adapterManager:self didFailToLoadAdWithError:noInventoryError];
        return;
    }

    MPLogInfo(@"Fetching banner ad network type: %@", [config networkType]);

    Class adapterClass = [[MP_MPAdapterMap sharedAdapterMap] bannerAdapterClassForNetworkType:
                          [config networkType]];
    MP_MPBaseAdapter *adapter = [[[adapterClass alloc] initWithAdapterDelegate:self] autorelease];

    if (!adapter) {
        MPLogInfo(@"Could not create adapter for banner network type: %@.", [config networkType]);
        MP_MPError *adapterNotFoundError = [MP_MPError errorWithCode:MPErrorAdapterNotFound];
        [_delegate adapterManager:self didFailToLoadAdWithError:adapterNotFoundError];
        return;
    }

    self.requestingAdapter = adapter;
    [self requestBannerFromAdapter:self.requestingAdapter forConfiguration:config];
}

- (void)requestBannerFromAdapter:(MP_MPBaseAdapter *)adapter
                forConfiguration:(MP_MPAdConfiguration *)configuration
{
    BOOL adapterIsValid = NO;
    BOOL adapterIsLegacy = NO;

    unsigned int adapterMethodCount = 0;
    Method *adapterMethodList = class_copyMethodList([adapter class], &adapterMethodCount);
    for (unsigned int i = 0; i < adapterMethodCount; i++) {
        SEL selector = method_getName(adapterMethodList[i]);
        if (sel_isEqual(selector, @selector(getAdWithConfiguration:))) {
            adapterIsValid = YES;
            break;
        } else if (sel_isEqual(selector, @selector(getAdWithParams:))) {
            adapterIsValid = YES;
            adapterIsLegacy = YES;
        }
    }
    free(adapterMethodList);

    if (adapterIsValid && adapterIsLegacy) {
        [adapter setImpressionTrackingURL:[configuration impressionTrackingURL]];
        [adapter setClickTrackingURL:[configuration clickTrackingURL]];
        [adapter _getAdWithParams:[configuration headers]];
    }
    else if (adapterIsValid) {
        [adapter _getAdWithConfiguration:configuration];
    } else {
        MP_MPError *adapterInvalidError = [MP_MPError errorWithCode:MPErrorAdapterInvalid];
        [_delegate adapterManager:self didFailToLoadAdWithError:adapterInvalidError];
    }
}

- (void)requestedAdDidBecomeVisible
{
    [self.currentOnscreenAdapter unregisterDelegate];
    self.currentOnscreenAdapter = self.requestingAdapter;
    self.requestingAdapter = nil;
    self.requestedAd = nil;

    [self.currentOnscreenAdapter trackImpression];
}

#pragma mark - Rotation

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation
{
    [self.currentOnscreenAdapter rotateToOrientation:orientation];
}

#pragma mark - MPAdapterDelegate

- (MP_MPAdView *)adView
{
    return [_delegate adView];
}

- (id<MPAdViewDelegate>)adViewDelegate
{
    return [_delegate adViewDelegate];
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return [_delegate rootViewController];
}

- (void)adapter:(MP_MPBaseAdapter *)adapter didFinishLoadingAd:(UIView *)ad
        shouldTrackImpression:(BOOL)shouldTrack
{
    if (adapter != self.requestingAdapter && adapter != self.currentOnscreenAdapter) {
        return;
    }

    if (adapter == self.requestingAdapter) {
        self.requestedAd = ad;
        [_delegate adapterManager:self didLoadAd:ad];
    } else if (adapter == self.currentOnscreenAdapter) {
        [_delegate adapterManager:self didRefreshAd:ad];

        // XXX: Only used for iAd.
        if (shouldTrack) {
            [self.currentOnscreenAdapter trackImpression];
        }
    }
}

- (void)adapter:(MP_MPBaseAdapter *)adapter didFailToLoadAdWithError:(NSError *)error
{
    if (adapter != self.requestingAdapter && adapter != self.currentOnscreenAdapter) {
        return;
    }

    if (adapter == self.requestingAdapter) {
        MPLogError(@"Adapter (%p) failed to load ad. Error: %@", adapter, error);
        [self.requestingAdapter unregisterDelegate];
        self.requestingAdapter = nil;

        MP_MPError *adapterNoInventoryError = [MP_MPError errorWithCode:MPErrorAdapterHasNoInventory];
        [_delegate adapterManager:self didFailToLoadAdWithError:adapterNoInventoryError];
    } else if (adapter == self.currentOnscreenAdapter) {
        [self.currentOnscreenAdapter unregisterDelegate];
        self.currentOnscreenAdapter = nil;

        if (self.requestingAdapter) {
            // The current adapter has failed, but another adapter is already in the process of
            // trying to replace it. As an optimization, we'll choose not to fire off another retry.
            return;
        } else {
            [_delegate adapterManager:self didFailToLoadAdWithError:nil];
            return;
        }
    }
}

- (void)userActionWillBeginForAdapter:(MP_MPBaseAdapter *)adapter
{
    if (adapter != self.currentOnscreenAdapter) {
        // Only handle "click" messages from adapters whose content is currently on-screen.
        return;
    }

    [adapter trackClick];

    [_delegate adapterManagerUserActionWillBegin:self];
}

- (void)userActionDidFinishForAdapter:(MP_MPBaseAdapter *)adapter
{
    if (adapter != self.currentOnscreenAdapter) {
        // Only handle "dismiss" messages from adapters whose content is currently on-screen.
        return;
    }

    [_delegate adapterManagerUserActionDidFinish:self];
}

- (void)userWillLeaveApplicationFromAdapter:(MP_MPBaseAdapter *)adapter
{
    if (adapter != self.currentOnscreenAdapter) {
        // Only handle "leave app" messages from adapters whose content is currently on-screen.
        return;
    }

    [_delegate adapterManagerUserWillLeaveApplication:self];
}

#pragma mark - MPAdapterDelegate (Legacy)

- (CGSize)maximumAdSize
{
    return [[self adView] adContentViewSize];
}

- (MPNativeAdOrientation)allowedNativeAdsOrientation
{
    return [[self adView] allowedNativeAdsOrientation];
}

- (void)pauseAutorefresh
{
    // XXX:
}

- (void)resumeAutorefreshIfEnabled
{
    // XXX:
}

#pragma mark - Custom Events (Deprecated)

- (void)customEventDidLoadAd
{
    if (![self.requestingAdapter isKindOfClass:[MP_MPBannerCustomEventAdapter class]]) {
        MPLogWarn(@"-customEventDidLoadAd should not be called unless a custom event is in "
                  @"progress.");
        return;
    }

    [self requestedAdDidBecomeVisible];
}

- (void)customEventDidFailToLoadAd
{
    if (![self.requestingAdapter isKindOfClass:[MP_MPBannerCustomEventAdapter class]]) {
        MPLogWarn(@"-customEventDidFailToLoadAd should not be called unless a custom event is in "
                  @"progress.");
        return;
    }
    [self.requestingAdapter unregisterDelegate];
    self.requestingAdapter = nil;
}

- (void)customEventActionWillBegin
{
    if (![self.currentOnscreenAdapter isKindOfClass:[MP_MPBannerCustomEventAdapter class]]) {
        MPLogWarn(@"-customEventActionWillBegin should not be called unless a custom event is in "
                  @"progress.");
        return;
    }

    [self userActionWillBeginForAdapter:self.currentOnscreenAdapter];
}

- (void)customEventActionDidEnd
{
    if (![self.currentOnscreenAdapter isKindOfClass:[MP_MPBannerCustomEventAdapter class]]) {
        MPLogWarn(@"-customEventActionDidEnd should not be called unless a custom event is in "
                  @"progress.");
        return;
    }

    [self userActionDidFinishForAdapter:self.currentOnscreenAdapter];
}

@end
