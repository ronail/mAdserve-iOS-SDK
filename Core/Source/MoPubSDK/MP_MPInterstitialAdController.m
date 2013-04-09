//
//  MPInterstitialAdController.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPInterstitialAdController.h"
#import "MPInterstitialAdManager+DeprecatedCustomEvents.h"

#import "MPLogging.h"

@interface MP_MPInterstitialAdController ()

+ (NSMutableArray *)sharedInterstitials;
- (id)initWithAdUnitId:(NSString *)adUnitId;

@end

@implementation MP_MPInterstitialAdController

@synthesize delegate = _delegate;
@synthesize ready = _ready;
@synthesize adUnitId = _adUnitId;
@synthesize keywords = _keywords;
@synthesize location = _location;
@synthesize locationEnabled = _locationEnabled;
@synthesize locationPrecision = _locationPrecision;
@synthesize testing = _testing;
@synthesize adWantsNativeCloseButton = _adWantsNativeCloseButton;

- (id)initWithAdUnitId:(NSString *)adUnitId
{
    if (self = [super init]) {
        _manager = [[MP_MPInterstitialAdManager alloc] init];

        // TODO: Consolidate these references.
        _manager.interstitialAdController = self;
        _manager.delegate = self;

        _adUnitId = [adUnitId copy];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    _parent = nil;

    [_manager setInterstitialAdController:nil];
    [_manager setDelegate:nil];
    [_manager release];

    [_adUnitId release];
    [_keywords release];
    [_location release];

    [super dealloc];
}

#pragma mark - Public

+ (MP_MPInterstitialAdController *)interstitialAdControllerForAdUnitId:(NSString *)adUnitId
{
    NSMutableArray *interstitials = [[self class] sharedInterstitials];

    @synchronized(self) {
        // Find the correct ad controller based on the ad unit ID.
        MP_MPInterstitialAdController *interstitial = nil;
        for (MP_MPInterstitialAdController *currentInterstitial in interstitials) {
            if ([currentInterstitial.adUnitId isEqualToString:adUnitId]) {
                interstitial = currentInterstitial;
                break;
            }
        }

        // Create a new ad controller for this ad unit ID if one doesn't already exist.
        if (!interstitial) {
            interstitial = [[[[self class] alloc] initWithAdUnitId:adUnitId] autorelease];
            [interstitials addObject:interstitial];
        }

        return interstitial;
    }
}

- (void)loadAd
{
    [_manager loadInterstitial];
}

- (void)showFromViewController:(UIViewController *)controller
{
    if (_parent) {
        MPLogWarn(@"The `parent` property of MPInterstitialAdController is deprecated. "
                  @"Use the `delegate` property instead.");
    }

    if (!controller) {
        MPLogWarn(@"The interstitial could not be shown: "
                  @"a nil view controller was passed to -showFromViewController:.");
        return;
    }

    [_manager presentInterstitialFromViewController:controller];
}

#pragma mark - Internal

+ (NSMutableArray *)sharedInterstitials
{
    static NSMutableArray *sharedInterstitials;

    @synchronized(self) {
        if (!sharedInterstitials) {
            sharedInterstitials = [[NSMutableArray array] retain];
        }
    }

    return sharedInterstitials;
}

#pragma mark - MP_MPInterstitialAdManagerDelegate

- (void)managerDidLoadInterstitial:(MP_MPInterstitialAdManager *)manager
{
    _ready = YES;

    if ([self.delegate respondsToSelector:@selector(interstitialDidLoadAd:)]) {
        [self.delegate interstitialDidLoadAd:self];
    }
}

- (void)manager:(MP_MPInterstitialAdManager *)manager
        didFailToLoadInterstitialWithError:(NSError *)error
{
    _ready = NO;

    if ([self.delegate respondsToSelector:@selector(interstitialDidFailToLoadAd:)]) {
        [self.delegate interstitialDidFailToLoadAd:self];
    }
}

- (void)managerWillPresentInterstitial:(MP_MPInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialWillAppear:)]) {
        [self.delegate interstitialWillAppear:self];
    }
}

- (void)managerDidPresentInterstitial:(MP_MPInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidAppear:)]) {
        [self.delegate interstitialDidAppear:self];
    }
}

- (void)managerWillDismissInterstitial:(MP_MPInterstitialAdManager *)manager
{
    if ([self.delegate respondsToSelector:@selector(interstitialWillDisappear:)]) {
        [self.delegate interstitialWillDisappear:self];
    }
}

- (void)managerDidDismissInterstitial:(MP_MPInterstitialAdManager *)manager
{
    _ready = NO;

    if ([self.delegate respondsToSelector:@selector(interstitialDidDisappear:)]) {
        [self.delegate interstitialDidDisappear:self];
    }
}

- (void)managerDidExpireInterstitial:(MP_MPInterstitialAdManager *)manager
{
    _ready = NO;

    if ([self.delegate respondsToSelector:@selector(interstitialDidExpire:)]) {
        [self.delegate interstitialDidExpire:self];
    }
}

- (void)managerDidReceiveTapEventForInterstitial:(MP_MPInterstitialAdManager *)manager
{
    // TODO: Add interstitial 'onClick' delegate method.
}

#pragma mark - Deprecated

+ (NSMutableArray *)sharedInterstitialAdControllers
{
    return [[self class] sharedInterstitials];
}

+ (void)removeSharedInterstitialAdController:(MP_MPInterstitialAdController *)controller
{
    [[[self class] sharedInterstitials] removeObject:controller];
}

- (void)show
{
    MPLogWarn(@"-[MPInterstitialAdController show] is deprecated. "
              @"Use -showFromViewController: instead.");

    if (_parent && !self.delegate) {
        MPLogError(@"Interstitial could not be shown. Call -showFromViewController: instead of"
                   @"-show when using the `delegate` property.");
        return;
    }

    if (_parent && self.delegate) {
        MPLogError(@"Interstitial could not be shown: "
                   @"the `delegate` and `parent` properties should not be both set.");
        return;
    }

    [_manager presentInterstitialFromViewController:_parent];
}

- (void)setAdWantsNativeCloseButton:(BOOL)adWantsNativeCloseButton
{
    _adWantsNativeCloseButton = adWantsNativeCloseButton;
}

- (NSArray *)locationDescriptionPair
{
    // TODO: Generate this.
    return nil;
}

- (void)customEventDidLoadAd
{
    [_manager customEventDidLoadAd];
}

- (void)customEventDidFailToLoadAd
{
    [_manager customEventDidFailToLoadAd];
}

- (void)customEventActionWillBegin
{
    [_manager customEventActionWillBegin];
}

#pragma mark - Deprecated MPBaseInterstitialAdapterDelegate (for compatibility w/ adapters)

- (void)adapterDidFinishLoadingAd:(MP_MPBaseInterstitialAdapter *)adapter
{
    [_manager adapterDidFinishLoadingAd:adapter];
}

- (void)adapter:(MP_MPBaseInterstitialAdapter *)adapter didFailToLoadAdWithError:(NSError *)error
{
    [_manager adapter:adapter didFailToLoadAdWithError:error];
}

- (void)interstitialWillAppearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [_manager interstitialWillAppearForAdapter:adapter];
}

- (void)interstitialDidAppearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [_manager interstitialDidAppearForAdapter:adapter];
}

- (void)interstitialWillDisappearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [_manager interstitialWillDisappearForAdapter:adapter];
}

- (void)interstitialDidDisappearForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [_manager interstitialDidDisappearForAdapter:adapter];
}

- (void)interstitialWasTappedForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [_manager interstitialWasTappedForAdapter:adapter];
}

- (void)interstitialDidExpireForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [_manager interstitialDidExpireForAdapter:adapter];
}

- (void)interstitialWillLeaveApplicationForAdapter:(MP_MPBaseInterstitialAdapter *)adapter
{
    [_manager interstitialWillLeaveApplicationForAdapter:adapter];
}

@end
