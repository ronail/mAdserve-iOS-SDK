//
//  MPBannerAdManager.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPAdBrowserController.h"
#import "MP_MPAdServerCommunicator.h"
#import "MP_MPBannerAdapterManager.h"
#import "MP_MPBaseAdapter.h"
#import "MP_MPProgressOverlayView.h"

extern const CGFloat k_kMoPubRequestRetryInterval;

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPBannerAdManagerDelegate;
@class MP_MPAdView, MP_MPBaseAdapter, MP_MPBannerDelegateHelper, MP_MPTimer, MP_MPTimerTarget;

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MP_MPBannerAdManager : NSObject <MPAdServerCommunicatorDelegate,
    MPBannerAdapterManagerDelegate>
{
    MP_MPAdServerCommunicator *_communicator;
    BOOL _loading;

    MP_MPBannerAdapterManager *_adapterManager;
    MP_MPBannerDelegateHelper *_delegateHelper;

    MP_MPAdView *_adView;

    BOOL _adActionInProgress;
    UIView *_nextAdContentView;

    MP_MPTimer *_autorefreshTimer;
    MP_MPTimerTarget *_timerTarget;
    BOOL _ignoresAutorefresh;
    BOOL _previousIgnoresAutorefresh;
    BOOL _autorefreshTimerNeedsScheduling;
}

@property (nonatomic, assign, getter=isLoading) BOOL loading;

@property (nonatomic, assign) MP_MPAdView *adView;

@property (nonatomic, retain) MP_MPTimer *autorefreshTimer;
@property (nonatomic, assign) BOOL ignoresAutorefresh;

- (void)loadAdWithURL:(NSURL *)URL;
- (void)refreshAd;
- (void)forceRefreshAd;
- (void)cancelAd;

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;
- (void)customEventDidLoadAd;
- (void)customEventDidFailToLoadAd;
- (void)customEventActionWillBegin;
- (void)customEventActionDidEnd;

- (NSTimeInterval)refreshInterval;

@end
