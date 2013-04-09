//
//  MPAdRequestError.h
//  MoPub
//
//  Copyright (c) 2012 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const k_kMPErrorDomain;

typedef enum {
    MPErrorNoInventory = 0,
    MPErrorNetworkTimedOut = 4,
    MPErrorServerError = 8,
    MPErrorAdapterNotFound = 16,
    MPErrorAdapterInvalid = 17,
    MPErrorAdapterHasNoInventory = 18
} MPErrorCode;

@interface MP_MPError : NSError

+ (MP_MPError *)errorWithCode:(MPErrorCode)code;

@end
