//
//  MPAdWebView.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MP_MPAdBrowserController.h"
#import "MP_MPProgressOverlayView.h"

enum {
    MPAdWebViewEventAdDidAppear     = 0,
    MPAdWebViewEventAdDidDisappear  = 1
};
typedef NSUInteger MPAdWebViewEvent;

NSString * const k_kMoPubURLScheme;
NSString * const k_kMoPubCloseHost;
NSString * const k_kMoPubFinishLoadHost;
NSString * const k_kMoPubFailLoadHost;
NSString * const k_kMoPubInAppPurchaseHost;
NSString * const k_kMoPubCustomHost;

@protocol MPAdWebViewDelegate;
@class MP_MPAdConfiguration;

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MP_MPAdWebView : UIView <UIWebViewDelegate, MPAdBrowserControllerDelegate,
    MPProgressOverlayViewDelegate>
{
    UIWebView *_webView;
    id<MPAdWebViewDelegate> _delegate;
    id _customMethodDelegate;

    MP_MPAdConfiguration *_configuration;
    MP_MPAdBrowserController *_browserController;

    // Only used when the MPAdWebView is the backing view for an interstitial ad.
    BOOL _dismissed;
}

@property (nonatomic, readonly, retain) UIWebView *webView;
@property (nonatomic, assign) id<MPAdWebViewDelegate> delegate;
@property (nonatomic, assign) id customMethodDelegate;
@property (nonatomic, readonly, retain) MP_MPAdBrowserController *browserController;
@property (nonatomic, assign, getter=isDismissed) BOOL dismissed;

- (void)loadConfiguration:(MP_MPAdConfiguration *)configuration;
- (void)loadURL:(NSURL *)URL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType
textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;
- (void)invokeJavaScriptForEvent:(MPAdWebViewEvent)event;
- (void)forceRedraw;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPAdWebViewDelegate <NSObject>

@required
- (UIViewController *)viewControllerForPresentingModalView;

@optional
- (void)adDidClose:(MP_MPAdWebView *)ad;
- (void)adDidFinishLoadingAd:(MP_MPAdWebView *)ad;
- (void)adDidFailToLoadAd:(MP_MPAdWebView *)ad;
- (void)adActionWillBegin:(MP_MPAdWebView *)ad;
- (void)adActionWillLeaveApplication:(MP_MPAdWebView *)ad;
- (void)adActionDidFinish:(MP_MPAdWebView *)ad;
- (void)ad:(MP_MPAdWebView *)ad
        didInitiatePurchaseForProductIdentifier:(NSString *)productID;
- (void)ad:(MP_MPAdWebView *)ad
        didInitiatePurchaseForProductIdentifier:(NSString *)productID
        quantity:(NSInteger)quantity;

@end
