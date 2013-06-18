//
//  MPGlobal.m
//  MoPub
//
//  Created by Andrew He on 5/5/11.
//  Copyright 2011 MoPub, Inc. All rights reserved.
//

#import "MPGlobal.h"
#import "MPConstants.h"
#import <CommonCrypto/CommonDigest.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= MP_IOS_6_0
#import <AdSupport/AdSupport.h>
#endif

BOOL MP_MPViewHasHiddenAncestor(UIView *view);
BOOL MP_MPViewIsDescendantOfKeyWindow(UIView *view);
BOOL MP_MPViewIntersectsKeyWindow(UIView *view);
NSString *MP_MPSHA1Digest(NSString *string);

UIInterfaceOrientation MP_MPInterfaceOrientation()
{
	return [UIApplication sharedApplication].statusBarOrientation;
}

UIWindow *MP_MPKeyWindow()
{
    return [UIApplication sharedApplication].keyWindow;
}

CGFloat MP_MPStatusBarHeight() {
    if ([UIApplication sharedApplication].statusBarHidden) return 0.0;

    UIInterfaceOrientation orientation = MP_MPInterfaceOrientation();

    return UIInterfaceOrientationIsLandscape(orientation) ?
        CGRectGetWidth([UIApplication sharedApplication].statusBarFrame) :
        CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

CGRect MP_MPApplicationFrame()
{
    CGRect frame = MP_MPScreenBounds();

    frame.origin.y += MP_MPStatusBarHeight();
    frame.size.height -= MP_MPStatusBarHeight();

    return frame;
}

CGRect MP_MPScreenBounds()
{
	CGRect bounds = [UIScreen mainScreen].bounds;
	if (UIInterfaceOrientationIsLandscape(MP_MPInterfaceOrientation()))
	{
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = width;
	}
	return bounds;
}

CGFloat MP_MPDeviceScaleFactor()
{
	if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
		[[UIScreen mainScreen] respondsToSelector:@selector(scale)])
	{
		return [[UIScreen mainScreen] scale];
	}
	else return 1.0;
}

NSString *MP_MPUserAgentString()
{
	static NSString *userAgent = nil;
    if (!userAgent) {
        UIWebView *webview = [[UIWebView alloc] init];
        userAgent = [[webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] copy];
    }
    return userAgent;
}

NSDictionary *MP_MPDictionaryFromQueryString(NSString *query) {
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
	NSArray *queryElements = [query componentsSeparatedByString:@"&"];
	for (NSString *element in queryElements) {
		NSArray *keyVal = [element componentsSeparatedByString:@"="];
		NSString *key = [keyVal objectAtIndex:0];
		NSString *value = [keyVal lastObject];
		[queryDict setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
					  forKey:key];
	}
	return queryDict;
}

NSString *MP_MPAdvertisingIdentifier()
{
    // In iOS 6, the advertisingIdentifier property of ASIdentifierManager can be used to uniquely
    // identify a device for advertising purposes. Note: devices running OS versions prior to iOS 6
    // will not be identifiable unless the MOPUB_ENABLE_UDID preprocessor constant is set.

    // Cache the identifier for the lifetime of the process.
    static NSString *cachedIdentifier = nil;

    if (cachedIdentifier) {
        return cachedIdentifier;
    }

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= MP_IOS_6_0
    NSString *identifier;
    if (NSClassFromString(@"ASIdentifierManager")) {
        identifier = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
        cachedIdentifier = [NSString stringWithFormat:@"ifa:%@", [identifier uppercaseString]];
    }
    #if MOPUB_ENABLE_UDID
    else {
        identifier = MP_MPSHA1Digest([[UIDevice currentDevice] identifierForVendor]);
        cachedIdentifier = [NSString stringWithFormat:@"sha:%@", [identifier uppercaseString]];
    }
    #endif
#elif MOPUB_ENABLE_UDID
    NSString *identifier = MPSHA1Digest([[UIDevice currentDevice] identifierForVendor]);
    cachedIdentifier = [NSString stringWithFormat:@"sha:%@", [identifier uppercaseString]];
#endif

    return cachedIdentifier;
}

BOOL MP_MPAdvertisingTrackingEnabled()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= MP_IOS_6_0
    if (NSClassFromString(@"ASIdentifierManager")) {
        return [ASIdentifierManager sharedManager].advertisingTrackingEnabled;
    }
#endif

    return YES;
}

NSString *MP_MPSHA1Digest(NSString *string)
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    CC_SHA1([data bytes], [data length], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

BOOL MP_MPViewIsVisible(UIView *view)
{
    // In order for a view to be visible, it:
    // 1) must not be hidden,
    // 2) must not have an ancestor that is hidden,
    // 3) must be a descendant of the key window, and
    // 4) must be within the frame of the key window.
    //
    // Note: this function does not check whether any part of the view is obscured by another view.

    return (!view.hidden &&
            !MP_MPViewHasHiddenAncestor(view) &&
            MP_MPViewIsDescendantOfKeyWindow(view) &&
            MP_MPViewIntersectsKeyWindow(view));
}

BOOL MP_MPViewHasHiddenAncestor(UIView *view)
{
    UIView *ancestor = view.superview;
    while (ancestor) {
        if (ancestor.hidden) return YES;
        ancestor = ancestor.superview;
    }
    return NO;
}

BOOL MP_MPViewIsDescendantOfKeyWindow(UIView *view)
{
    UIView *ancestor = view.superview;
    UIWindow *keyWindow = MP_MPKeyWindow();
    while (ancestor) {
        if (ancestor == keyWindow) return YES;
        ancestor = ancestor.superview;
    }
    return NO;
}

BOOL MP_MPViewIntersectsKeyWindow(UIView *view)
{
    UIWindow *keyWindow = MP_MPKeyWindow();

    // We need to call convertRect:toView: on this view's superview rather than on this view itself.
    CGRect viewFrameInWindowCoordinates = [view.superview convertRect:view.frame toView:keyWindow];

    return CGRectIntersectsRect(viewFrameInWindowCoordinates, keyWindow.frame);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation AdSdk_CJSONDeserializer (MPAdditions)

+ (AdSdk_CJSONDeserializer *)deserializerWithNullObject:(id)obj
{
    AdSdk_CJSONDeserializer *deserializer = [AdSdk_CJSONDeserializer deserializer];
    deserializer.nullObject = obj;
    return deserializer;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSString (MPAdditions)

- (NSString *)URLEncodedString
{
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
																		   (CFStringRef)self,
																		   NULL,
																		   (CFStringRef)@"!*'();:@&=+$,/?%#[]<>",
																		   kCFStringEncodingUTF8));
	return result;
}

@end
