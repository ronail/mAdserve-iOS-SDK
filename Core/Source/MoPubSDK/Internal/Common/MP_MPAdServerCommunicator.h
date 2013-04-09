//
//  MPAdServerCommunicator.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MP_MPAdConfiguration.h"
#import "MPGlobal.h"

@protocol MPAdServerCommunicatorDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= MP_IOS_5_0
@interface MP_MPAdServerCommunicator : NSObject <NSURLConnectionDataDelegate>
#else
@interface MP_MPAdServerCommunicator : NSObject
#endif
{
    id<MPAdServerCommunicatorDelegate> _delegate;
    NSURL *_URL;
    NSURLConnection *_connection;
    NSMutableData *_responseData;
    NSDictionary *_responseHeaders;
}

@property (nonatomic, assign) id<MPAdServerCommunicatorDelegate> delegate;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSDictionary *responseHeaders;

- (void)loadURL:(NSURL *)URL;
- (void)cancel;

- (NSError *)errorForStatusCode:(NSInteger)statusCode;
- (NSURLRequest *)adRequestForURL:(NSURL *)URL;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPAdServerCommunicatorDelegate <NSObject>

@required
- (void)communicatorDidReceiveAdConfiguration:(MP_MPAdConfiguration *)configuration;
- (void)communicatorDidFailWithError:(NSError *)error;

@end
