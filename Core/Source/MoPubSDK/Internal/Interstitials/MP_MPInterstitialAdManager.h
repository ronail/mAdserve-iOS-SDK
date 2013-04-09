//
//  MPInterstitialAdManager.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPAdServerCommunicator.h"
#import "MP_MPBaseInterstitialAdapter.h"

@class MP_MPInterstitialAdController;
@protocol MPInterstitialAdManagerDelegate;

@interface MP_MPInterstitialAdManager : NSObject <MPAdServerCommunicatorDelegate,
    MPBaseInterstitialAdapterDelegate>
{
    MP_MPInterstitialAdController *_interstitialAdController;
    id<MPInterstitialAdManagerDelegate> _delegate;

    MP_MPAdServerCommunicator *_communicator;
    BOOL _loading;

    NSURL *_failoverURL;

    MP_MPBaseInterstitialAdapter *_currentAdapter;
    MP_MPBaseInterstitialAdapter *_nextAdapter;

    MP_MPAdConfiguration *_currentConfiguration;
    MP_MPAdConfiguration *_nextConfiguration;

    BOOL _isReady;
    BOOL _hasRecordedImpressionForCurrentInterstitial;
    BOOL _hasRecordedClickForCurrentInterstitial;

    NSMutableURLRequest *_request;
}

@property (nonatomic, assign, getter=isLoading) BOOL loading;
@property (nonatomic, assign) MP_MPInterstitialAdController *interstitialAdController;
@property (nonatomic, assign) id<MPInterstitialAdManagerDelegate> delegate;
@property (nonatomic, readonly, copy) NSURL *failoverURL;

- (void)loadAdWithURL:(NSURL *)URL;
- (void)loadInterstitial;
- (void)presentInterstitialFromViewController:(UIViewController *)controller;
- (BOOL)isHandlingCustomEvent;
- (void)reportClickForCurrentInterstitial;
- (void)reportImpressionForCurrentInterstitial;

- (BOOL)interstitialDelegateRespondsToSelector:(SEL)selector;
- (void)performSelectorOnInterstitialDelegate:(SEL)selector;
- (void)performSelector:(SEL)selector onInterstitialDelegateWithObject:(id)arg;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPInterstitialAdManagerDelegate <NSObject>

- (NSString *)adUnitId;
- (void)managerDidLoadInterstitial:(MP_MPInterstitialAdManager *)manager;
- (void)manager:(MP_MPInterstitialAdManager *)manager
        didFailToLoadInterstitialWithError:(NSError *)error;
- (void)managerWillPresentInterstitial:(MP_MPInterstitialAdManager *)manager;
- (void)managerDidPresentInterstitial:(MP_MPInterstitialAdManager *)manager;
- (void)managerWillDismissInterstitial:(MP_MPInterstitialAdManager *)manager;
- (void)managerDidDismissInterstitial:(MP_MPInterstitialAdManager *)manager;
- (void)managerDidExpireInterstitial:(MP_MPInterstitialAdManager *)manager;
- (void)managerDidReceiveTapEventForInterstitial:(MP_MPInterstitialAdManager *)manager;

@end