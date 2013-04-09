//
//  MPInterstitialCustomEventAdapter.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPInterstitialCustomEventAdapter.h"

#import "MP_MPAdConfiguration.h"
#import "MP_MPInterstitialAdManager.h"
#import "MPLogging.h"

@implementation MP_MPInterstitialCustomEventAdapter

- (void)dealloc
{
    _interstitialCustomEvent.delegate = nil;
    [_interstitialCustomEvent release];

    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)getAdWithConfiguration:(MP_MPAdConfiguration *)configuration
{
    Class customEventClass = configuration.customEventClass;

    MPLogInfo(@"Looking for custom event class named %@.", configuration.customEventClass);

    if (customEventClass) {
        [self loadAdFromCustomClass:customEventClass configuration:configuration];
        return;
    }

    MPLogInfo(@"Looking for custom event selector named %@.", configuration.customSelectorName);

    SEL customEventSelector = NSSelectorFromString(configuration.customSelectorName);
    if ([_manager interstitialDelegateRespondsToSelector:customEventSelector]) {
        [_manager performSelectorOnInterstitialDelegate:customEventSelector];
        return;
    }

    NSString *oneArgumentSelectorName = [configuration.customSelectorName
                                         stringByAppendingString:@":"];

    MPLogInfo(@"Looking for custom event selector named %@.", oneArgumentSelectorName);

    SEL customEventOneArgumentSelector = NSSelectorFromString(oneArgumentSelectorName);
    if ([_manager interstitialDelegateRespondsToSelector:customEventOneArgumentSelector]) {
        [_manager performSelector:customEventOneArgumentSelector
                  onInterstitialDelegateWithObject:self.interstitialAdController];
        return;
    }

    MPLogInfo(@"Could not handle custom event request.");

    [self.interstitialAdController adapter:self didFailToLoadAdWithError:nil];
}

- (void)showInterstitialFromViewController:(UIViewController *)controller
{
    [_interstitialCustomEvent showInterstitialFromRootViewController:controller];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadAdFromCustomClass:(Class)customClass configuration:(MP_MPAdConfiguration *)configuration
{
    _interstitialCustomEvent = [[customClass alloc] init];
    _interstitialCustomEvent.delegate = self;
    [_interstitialCustomEvent requestInterstitialWithCustomEventInfo:configuration.customEventClassData];
}

#pragma mark - MPInterstitialCustomEventDelegate

- (void)interstitialCustomEvent:(MP_MPInterstitialCustomEvent *)customEvent
                      didLoadAd:(id)ad
{
    [self.manager adapterDidFinishLoadingAd:self];
}

- (void)interstitialCustomEvent:(MP_MPInterstitialCustomEvent *)customEvent
       didFailToLoadAdWithError:(NSError *)error
{
    [self.manager adapter:self didFailToLoadAdWithError:error];
}

- (void)interstitialCustomEventWillAppear:(MP_MPInterstitialCustomEvent *)customEvent
{
    [self.manager interstitialWillAppearForAdapter:self];
    [self.manager interstitialDidAppearForAdapter:self];
}

- (void)interstitialCustomEventWillDisappear:(MP_MPInterstitialCustomEvent *)customEvent
{
    [self.manager interstitialWillDisappearForAdapter:self];
    [self.manager interstitialDidDisappearForAdapter:self];
}

- (void)interstitialCustomEventDidDisappear:(MP_MPInterstitialCustomEvent *)customEvent
{
    [self.manager interstitialDidDisappearForAdapter:self];
}

- (void)interstitialCustomEventWillLeaveApplication:(MP_MPInterstitialCustomEvent *)customEvent
{
    [self.manager interstitialWillLeaveApplicationForAdapter:self];
}

@end
