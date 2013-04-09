//
//  MPInterstitialAdManager.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <objc/runtime.h>

#import "MP_MPInterstitialAdManager.h"

#import "MP_MPAdapterMap.h"
#import "MP_MPAdServerURLBuilder.h"
#import "MP_MPInterstitialAdController.h"
#import "MP_MPInterstitialCustomEventAdapter.h"

@interface MP_MPInterstitialAdManager ()

@property (nonatomic, readwrite, copy) NSURL *failoverURL;

- (void)requestInterstitialFromAdapter:(MP_MPBaseInterstitialAdapter *)adapter
                      forConfiguration:(MP_MPAdConfiguration *)configuration;

- (NSString *)adUnitID;
- (NSString *)keywords;
- (CLLocation *)location;
- (BOOL)isTesting;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MP_MPInterstitialAdManager

@synthesize loading = _loading;
@synthesize interstitialAdController = _interstitialAdController;
@synthesize delegate = _delegate;
@synthesize failoverURL = _failoverURL;

- (id)init
{
    self = [super init];
    if (self) {
        _request = [[NSMutableURLRequest alloc] init];
        [_request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [_request setValue:MP_MPUserAgentString() forHTTPHeaderField:@"User-Agent"];

        _communicator = [[MP_MPAdServerCommunicator alloc] init];
        _communicator.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [_request release];

    [_communicator cancel];
    [_communicator setDelegate:nil];
    [_communicator release];

    [_currentAdapter unregisterDelegate];
    [_currentAdapter release];
    [_nextAdapter unregisterDelegate];
    [_nextAdapter release];

    [super dealloc];
}

#pragma mark - Public

- (void)loadAdWithURL:(NSURL *)URL
{
    if (_loading) {
        MPLogWarn(@"Interstitial controller is already loading an ad. "
                  @"Wait for previous load to finish.");
        return;
    }

    URL = (URL) ? URL : [MP_MPAdServerURLBuilder URLWithAdUnitID:[self adUnitID]
                                                     keywords:[self keywords]
                                                     location:[self location]
                                                      testing:[self isTesting]];

    MPLogInfo(@"Interstitial controller is loading ad with MoPub server URL: %@", URL);

    [_communicator loadURL:URL];
    _loading = YES;
}

- (void)loadInterstitial
{
    if (_isReady) {
        // If there's already an ad that hasn't yet been shown, there's no need to ask for another.
        [self.delegate managerDidLoadInterstitial:self];
    } else {
        [self loadAdWithURL:nil];
    }
}

- (void)presentInterstitialFromViewController:(UIViewController *)controller
{
    [_currentAdapter showInterstitialFromViewController:controller];
}

- (BOOL)isHandlingCustomEvent
{
    return ([_currentAdapter isKindOfClass:[MP_MPInterstitialCustomEventAdapter class]] ||
            [_nextAdapter isKindOfClass:[MP_MPInterstitialCustomEventAdapter class]]);
}

- (void)reportClickForCurrentInterstitial
{
    if (!_hasRecordedClickForCurrentInterstitial) {
        _hasRecordedClickForCurrentInterstitial = YES;

        [_request setURL:[_currentConfiguration clickTrackingURL]];
        [NSURLConnection connectionWithRequest:_request delegate:nil];
    } else {
    }
}

- (void)reportImpressionForCurrentInterstitial
{
    if (!_hasRecordedImpressionForCurrentInterstitial) {
        _hasRecordedImpressionForCurrentInterstitial = YES;

        [_request setURL:[_currentConfiguration impressionTrackingURL]];
        [NSURLConnection connectionWithRequest:_request delegate:nil];
    } else {
    }
}

- (BOOL)interstitialDelegateRespondsToSelector:(SEL)selector
{
    return [_interstitialAdController.delegate respondsToSelector:selector];
}

- (void)performSelectorOnInterstitialDelegate:(SEL)selector
{
    [_interstitialAdController.delegate performSelector:selector];
}

- (void)performSelector:(SEL)selector onInterstitialDelegateWithObject:(id)arg
{
    [_interstitialAdController.delegate performSelector:selector withObject:arg];
}

#pragma mark - Request data

- (NSString *)adUnitID
{
    return [self.interstitialAdController adUnitId];
}

- (NSString *)keywords
{
    return [self.interstitialAdController keywords];
}

- (CLLocation *)location
{
    return [self.interstitialAdController location];
}

- (BOOL)isTesting
{
    return [self.interstitialAdController isTesting];
}

#pragma mark - MPAdServerCommunicatorDelegate

- (void)communicatorDidReceiveAdConfiguration:(MP_MPAdConfiguration *)configuration
{
    self.failoverURL = [configuration failoverURL];

    _nextConfiguration = [configuration retain];

    MPLogInfo(@"Ad view is fetching ad network type: %@", configuration.networkType);

    if ([_nextConfiguration.networkType isEqualToString:@"clear"]) {
        MPLogInfo(@"Ad server response indicated no ad available.");
        _loading = NO;
        [_interstitialAdController.delegate interstitialDidFailToLoadAd:_interstitialAdController];
        return;
    }

    Class adapterClass = [[MP_MPAdapterMap sharedAdapterMap] interstitialAdapterClassForNetworkType:
                          _nextConfiguration.networkType];
    MP_MPBaseInterstitialAdapter *adapter = [[[adapterClass alloc] initWithInterstitialAdController:
                                           _interstitialAdController] autorelease];

    if (!adapter) {
        [self adapter:nil didFailToLoadAdWithError:nil];
        return;
    }

    _nextAdapter = [adapter retain];
    _nextAdapter.manager = self;
    [self requestInterstitialFromAdapter:_nextAdapter forConfiguration:_nextConfiguration];
}

- (void)communicatorDidFailWithError:(NSError *)error
{
    _isReady = NO;
    _loading = NO;

    if ([self.interstitialAdController.delegate respondsToSelector:@selector(interstitialDidFailToLoadAd:)]) {
        [self.interstitialAdController.delegate interstitialDidFailToLoadAd:self.interstitialAdController];
    }
}

- (void)requestInterstitialFromAdapter:(MP_MPBaseInterstitialAdapter *)adapter
                      forConfiguration:(MP_MPAdConfiguration *)configuration;
{
    BOOL adapterIsValid = NO;
    BOOL adapterIsLegacy = NO;

    unsigned int adapterMethodCount = 0;
    Method *adapterMethodList = class_copyMethodList([adapter class], &adapterMethodCount);
    for (unsigned int i = 0; i < adapterMethodCount; i++) {
        SEL selector = method_getName(adapterMethodList[i]);
        if (sel_isEqual(selector, @selector(getAdWithConfiguration:))) {
            adapterIsValid = YES;
        } else if (sel_isEqual(selector, @selector(getAdWithParams:))) {
            adapterIsValid = YES;
            adapterIsLegacy = YES;
        }
    }
    free(adapterMethodList);

    if (adapterIsValid && adapterIsLegacy) {
        [adapter _getAdWithParams:[configuration headers]];
    } else if (adapterIsValid) {
        [adapter _getAdWithConfiguration:configuration];
    } else {
        [self adapter:nil didFailToLoadAdWithError:nil];
    }
}

#pragma mark - MPBaseInterstitialAdapterDelegate

- (void)adapterDidFinishLoadingAd:(MP_MPBaseInterstitialAdapter *)adapter
{
    _isReady = YES;
    _loading = NO;
    _hasRecordedImpressionForCurrentInterstitial = NO;
    _hasRecordedClickForCurrentInterstitial = NO;

    [_currentAdapter unregisterDelegate];
    [_currentAdapter release];
    _currentAdapter = _nextAdapter;
    _nextAdapter = nil;

    _currentConfiguration = _nextConfiguration;
    _nextConfiguration = nil;

    [self.delegate managerDidLoadInterstitial:self];
}

- (void)adapter:(MP_MPBaseInterstitialAdapter *)adapter didFailToLoadAdWithError:(NSError *)error
{
    _isReady = NO;
    _loading = NO;

    if (adapter == _nextAdapter) {
        [_nextAdapter unregisterDelegate];
        [_nextAdapter release];
        _nextAdapter = nil;
        _nextConfiguration = nil;
        [self loadAdWithURL:self.failoverURL];
    } else if (adapter == _currentAdapter) {
        [_currentAdapter unregisterDelegate];
        [_currentAdapter release];
        _currentAdapter = nil;
        _currentConfiguration = nil;
        [self.delegate manager:self didFailToLoadInterstitialWithError:error];
    }
}

- (void)interstitialWillAppearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [self.delegate managerWillPresentInterstitial:self];
}

- (void)interstitialDidAppearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [self reportImpressionForCurrentInterstitial];
    [self.delegate managerDidPresentInterstitial:self];
}

- (void)interstitialWillDisappearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [self.delegate managerWillDismissInterstitial:self];
}

- (void)interstitialDidDisappearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    _isReady = NO;
    [self.delegate managerDidDismissInterstitial:self];
}

- (void)interstitialDidExpireForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [self.delegate managerDidExpireInterstitial:self];
}

- (void)interstitialWasTappedForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [self reportClickForCurrentInterstitial];
    [self.delegate managerDidReceiveTapEventForInterstitial:self];
}

- (void)interstitialWillLeaveApplicationForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    // TODO: Signal to delegate.
}

@end
