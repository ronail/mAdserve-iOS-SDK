//
//  MPGlobal.h
//  MoPub
//
//  Created by Andrew He on 5/5/11.
//  Copyright 2011 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdSdk_CJSONDeserializer.h"

#define MOPUB_DEPRECATED __attribute__((deprecated))

UIInterfaceOrientation MP_MPInterfaceOrientation(void);
UIWindow *MP_MPKeyWindow(void);
CGFloat MP_MPStatusBarHeight(void);
CGRect MP_MPApplicationFrame(void);
CGRect MP_MPScreenBounds(void);
CGFloat MP_MPDeviceScaleFactor(void);
NSString *MP_MPAdvertisingIdentifier(void);
BOOL MP_MPAdvertisingTrackingEnabled(void);
NSString *MP_MPUserAgentString(void);
NSDictionary *MP_MPDictionaryFromQueryString(NSString *query);
BOOL MP_MPViewIsVisible(UIView *view);

////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * Availability constants.
 */

#define MP_IOS_2_0  20000
#define MP_IOS_2_1  20100
#define MP_IOS_2_2  20200
#define MP_IOS_3_0  30000
#define MP_IOS_3_1  30100
#define MP_IOS_3_2  30200
#define MP_IOS_4_0  40000
#define MP_IOS_4_1  40100
#define MP_IOS_4_2  40200
#define MP_IOS_4_3  40300
#define MP_IOS_5_0  50000
#define MP_IOS_5_1  50100
#define MP_IOS_6_0  60000

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface AdSdk_CJSONDeserializer (MPAdditions)

+ (AdSdk_CJSONDeserializer *)deserializerWithNullObject:(id)obj;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSString (MPAdditions)

/* 
 * Returns string with reserved/unsafe characters encoded.
 */
- (NSString *)URLEncodedString;

@end