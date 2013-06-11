//
//  MPAdConfiguration.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MP_MPAdConfiguration.h"

#import "MPConstants.h"
#import "MPGlobal.h"

#import "AdSdk_CJSONDeserializer.h"

NSString * const k_kAdTypeHeaderKey = @"X-Adtype";
NSString * const k_kClickthroughHeaderKey = @"X-Clickthrough";
NSString * const k_kCustomSelectorHeaderKey = @"X-Customselector";
NSString * const k_kCustomEventClassNameHeaderKey = @"X-Custom-Event-Class-Name";
NSString * const k_kCustomEventClassDataHeaderKey = @"X-Custom-Event-Class-Data";
NSString * const k_kFailUrlHeaderKey = @"X-Failurl";
NSString * const k_kHeightHeaderKey = @"X-Height";
NSString * const k_kImpressionTrackerHeaderKey = @"X-Imptracker";
NSString * const k_kInterceptLinksHeaderKey = @"X-Interceptlinks";
NSString * const k_kLaunchpageHeaderKey = @"X-Launchpage";
NSString * const k_kNativeSDKParametersHeaderKey = @"X-Nativeparams";
NSString * const k_kNetworkTypeHeaderKey = @"X-Networktype";
NSString * const k_kRefreshTimeHeaderKey = @"X-Refreshtime";
NSString * const k_kScrollableHeaderKey = @"X-Scrollable";
NSString * const k_kWidthHeaderKey = @"X-Width";

NSString * const k_kInterstitialAdTypeHeaderKey = @"X-Fulladtype";
NSString * const k_kOrientationHeaderKey = @"X-Orientation";

NSString * const k_kAdTypeHtml = @"html";
NSString * const k_kAdTypeInterstitial = @"interstitial";
NSString * const k_kAdTypeMraid = @"mraid";

@interface MP_MPAdConfiguration ()

@property (nonatomic, copy) NSString *adResponseHTMLString;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MP_MPAdConfiguration

@synthesize headers = _headers;
@synthesize adType = _adType;
@synthesize networkType = _networkType;
@synthesize adSize = _adSize;
@synthesize preferredSize = _preferredSize;
@synthesize clickTrackingURL = _clickTrackingURL;
@synthesize impressionTrackingURL = _impressionTrackingURL;
@synthesize failoverURL = _failoverURL;
@synthesize interceptURLPrefix = _interceptURLPrefix;
@synthesize shouldInterceptLinks = _shouldInterceptLinks;
@synthesize scrollable = _scrollable;
@synthesize refreshInterval = _refreshInterval;
@synthesize adResponseData = _adResponseData;
@synthesize adResponseHTMLString = _adResponseHTMLString;
@synthesize nativeSDKParameters = _nativeSDKParameters;
@synthesize orientationType = _orientationType;
@synthesize customEventClass = _customEventClass;
@synthesize customEventClassData = _customEventClassData;

- (id)init
{
    self = [super init];
    if (self) {
        _adType = MPAdTypeUnknown;
        _networkType = @"";
        _shouldInterceptLinks = YES;
        _scrollable = NO;
    }
    return self;
}

- (id)initWithHeaders:(NSDictionary *)headers data:(NSData *)data
{
    self = [self init];
    if (self) {
        _headers = headers;
        _adType = [self adTypeFromHeaders:headers];

        _networkType = [[self networkTypeFromHeaders:headers] copy];
        _preferredSize = CGSizeMake([[headers objectForKey:k_kWidthHeaderKey] floatValue],
                                    [[headers objectForKey:k_kHeightHeaderKey] floatValue]);
        _clickTrackingURL = [self URLFromHeaders:headers forKey:k_kClickthroughHeaderKey];
        _impressionTrackingURL = [self URLFromHeaders:headers forKey:k_kImpressionTrackerHeaderKey];
        _failoverURL = [self URLFromHeaders:headers forKey:k_kFailUrlHeaderKey];
        _interceptURLPrefix = [self URLFromHeaders:headers forKey:k_kLaunchpageHeaderKey];
        _shouldInterceptLinks = [headers objectForKey:k_kInterceptLinksHeaderKey] ?
            [[headers objectForKey:k_kInterceptLinksHeaderKey] boolValue] : YES;

        _scrollable = [[headers objectForKey:k_kScrollableHeaderKey] boolValue];
        _refreshInterval = [self refreshIntervalFromHeaders:headers];
        _adResponseData = [data copy];
        _nativeSDKParameters = [self dictionaryFromHeaders:headers
                                                     forKey:k_kNativeSDKParametersHeaderKey];
        _customSelectorName = [[headers objectForKey:k_kCustomSelectorHeaderKey] copy];

        NSString *orientationTemp = [headers objectForKey:k_kOrientationHeaderKey];
        if ([orientationTemp isEqualToString:@"p"]) {
            _orientationType = MPInterstitialOrientationTypePortrait;
        } else if ([orientationTemp isEqualToString:@"l"]) {
            _orientationType = MPInterstitialOrientationTypeLandscape;
        } else {
            _orientationType = MPInterstitialOrientationTypeAll;
        }

        NSString *className = [headers objectForKey:k_kCustomEventClassNameHeaderKey];
        _customEventClass = NSClassFromString(className);

        NSString *customEventJSONString = [headers objectForKey:k_kCustomEventClassDataHeaderKey];
        NSData *customEventJSONData = [customEventJSONString dataUsingEncoding:NSUTF8StringEncoding];
        AdSdk_CJSONDeserializer *deserializer = [AdSdk_CJSONDeserializer deserializerWithNullObject:NULL];
        _customEventClassData = [deserializer deserializeAsDictionary:customEventJSONData
                                                                 error:NULL];
    }
    return self;
}


- (MPAdType)adTypeFromHeaders:(NSDictionary *)headers
{
    NSString *adTypeString = [headers objectForKey:k_kAdTypeHeaderKey];

    if ([adTypeString isEqualToString:@"interstitial"]) {
        return MPAdTypeInterstitial;
    } else if ([adTypeString isEqualToString:@"mraid"] &&
               [headers objectForKey:k_kOrientationHeaderKey]) {
        return MPAdTypeInterstitial;
    } else if (adTypeString) {
        return MPAdTypeBanner;
    } else {
        return MPAdTypeUnknown;
    }
}

- (NSString *)networkTypeFromHeaders:(NSDictionary *)headers
{
    NSString *adTypeString = [headers objectForKey:k_kAdTypeHeaderKey];
    if ([adTypeString isEqualToString:@"interstitial"]) {
        return [headers objectForKey:k_kInterstitialAdTypeHeaderKey];
    } else {
        return adTypeString;
    }
}

- (NSURL *)URLFromHeaders:(NSDictionary *)headers forKey:(NSString *)key
{
    NSString *URLString = [headers objectForKey:key];
    return URLString ? [NSURL URLWithString:URLString] : nil;
}

- (NSDictionary *)dictionaryFromHeaders:(NSDictionary *)headers forKey:(NSString *)key
{
    NSData *data = [(NSString *)[headers objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding];
    AdSdk_CJSONDeserializer *deserializer = [AdSdk_CJSONDeserializer deserializerWithNullObject:NULL];
    return [deserializer deserializeAsDictionary:data error:NULL];
}

- (NSTimeInterval)refreshIntervalFromHeaders:(NSDictionary *)headers
{
    NSString *intervalString = [headers objectForKey:k_kRefreshTimeHeaderKey];
    NSTimeInterval interval = -1;
    if (intervalString) {
        interval = [intervalString doubleValue];
        if (interval < MINIMUM_REFRESH_INTERVAL) {
            interval = MINIMUM_REFRESH_INTERVAL;
        }
    }
    return interval;
}

- (BOOL)hasPreferredSize
{
    return (self.preferredSize.width > 0 && self.preferredSize.height > 0);
}

- (NSString *)adResponseHTMLString
{
    if (!_adResponseHTMLString) {
        _adResponseHTMLString = [[NSString alloc] initWithData:self.adResponseData
                                                      encoding:NSUTF8StringEncoding];
    }

    return _adResponseHTMLString;
}

@end
