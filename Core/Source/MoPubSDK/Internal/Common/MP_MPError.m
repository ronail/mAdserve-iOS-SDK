//
//  MPAdRequestError.m
//  MoPub
//
//  Copyright (c) 2012 MoPub. All rights reserved.
//

#import "MP_MPError.h"

NSString * const k_kMPErrorDomain = @"com.mopub.iossdk";

@implementation MP_MPError

+ (MP_MPError *)errorWithCode:(MPErrorCode)code
{
    return [self errorWithDomain:k_kMPErrorDomain code:code userInfo:nil];
}

@end
