//
//  MPAdConfiguration.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MP_MPInterstitialViewController.h"

enum {
    MPAdTypeUnknown = -1,
    MPAdTypeBanner = 0,
    MPAdTypeInterstitial = 1
};
typedef NSUInteger MPAdType;

extern NSString * const k_kAdTypeHeaderKey;
extern NSString * const k_kClickthroughHeaderKey;
extern NSString * const k_kCustomSelectorHeaderKey;
extern NSString * const k_kCustomEventClassNameHeaderKey;
extern NSString * const k_kCustomEventClassDataHeaderKey;
extern NSString * const k_kFailUrlHeaderKey;
extern NSString * const k_kHeightHeaderKey;
extern NSString * const k_kImpressionTrackerHeaderKey;
extern NSString * const k_kInterceptLinksHeaderKey;
extern NSString * const k_kLaunchpageHeaderKey;
extern NSString * const k_kNativeSDKParametersHeaderKey;
extern NSString * const k_kNetworkTypeHeaderKey;
extern NSString * const k_kRefreshTimeHeaderKey;
extern NSString * const k_kScrollableHeaderKey;
extern NSString * const k_kWidthHeaderKey;

extern NSString * const k_kInterstitialAdTypeHeaderKey;
extern NSString * const k_kOrientationTypeHeaderKey;

extern NSString * const k_kAdTypeHtml;
extern NSString * const k_kAdTypeInterstitial;
extern NSString * const k_kAdTypeMraid;

@interface MP_MPAdConfiguration : NSObject
{
    NSDictionary *_headers;

    MPAdType _adType;
    NSString *_networkType;
    CGSize _adSize;
    CGSize _preferredSize;
    NSURL *_clickTrackingURL;
    NSURL *_impressionTrackingURL;
    NSURL *_failoverURL;
    NSURL *_interceptURLPrefix;
    BOOL _shouldInterceptLinks;
    BOOL _scrollable;
    NSTimeInterval _refreshInterval;
    NSData *_adResponseData;
    NSString *_adResponseHTMLString;
    NSDictionary *_nativeSDKParameters;
    NSString *_customSelectorName;
    Class _customEventClass;
    NSDictionary *_customEventClassData;
    MPInterstitialOrientationType _orientationType;
}

@property (nonatomic, retain) NSDictionary *headers;
@property (nonatomic, assign) MPAdType adType;
@property (nonatomic, copy) NSString *networkType;
@property (nonatomic, assign) CGSize adSize;
@property (nonatomic, assign) CGSize preferredSize;
@property (nonatomic, retain) NSURL *clickTrackingURL;
@property (nonatomic, retain) NSURL *impressionTrackingURL;
@property (nonatomic, retain) NSURL *failoverURL;
@property (nonatomic, retain) NSURL *interceptURLPrefix;
@property (nonatomic, assign) BOOL shouldInterceptLinks;
@property (nonatomic, assign) BOOL scrollable;
@property (nonatomic, assign) NSTimeInterval refreshInterval;
@property (nonatomic, copy) NSData *adResponseData;
@property (nonatomic, retain) NSDictionary *nativeSDKParameters;
@property (nonatomic, copy) NSString *customSelectorName;
@property (nonatomic, assign) Class customEventClass;
@property (nonatomic, retain) NSDictionary *customEventClassData;
@property (nonatomic, assign) MPInterstitialOrientationType orientationType;

- (id)init;
- (id)initWithHeaders:(NSDictionary *)headers data:(NSData *)data;
- (NSURL *)URLFromHeaders:(NSDictionary *)headers forKey:(NSString *)key;
- (BOOL)hasPreferredSize;
- (NSString *)adResponseHTMLString;

@end
