//
//  CJSONSerialization.m
//  TouchJSON
//
//  Created by Jonathan Wight on 03/04/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "AdSdk_CJSONSerialization.h"

#import "AdSdk_CJSONDeserializer.h"
#import "AdSdk_CJSONSerializer.h"

@implementation AdSdk_CJSONSerialization

+ (BOOL)isValidJSONObject:(id)obj
    {
    AdSdk_CJSONSerializer *theSerializer = [AdSdk_CJSONSerializer serializer];
    return([theSerializer isValidJSONObject:obj]);
    }

+ (NSData *)dataWithJSONObject:(id)obj options:(EJSONWritingOptions)opt error:(NSError **)error
    {
    #pragma unused (opt)

    AdSdk_CJSONSerializer *theSerializer = [AdSdk_CJSONSerializer serializer];
    NSData *theData = [theSerializer serializeObject:obj error:error];
    return(theData);
    }

+ (id)JSONObjectWithData:(NSData *)data options:(EJSONReadingOptions)opt error:(NSError **)error
    {
    AdSdk_CJSONDeserializer *theDeserializer = [AdSdk_CJSONDeserializer deserializer];
    theDeserializer.options = (opt & kCJSONReadingMutableContainers ? 0 : kJSONDeserializationOptions_MutableContainers)
        | (opt & kCJSONReadingMutableLeaves ? 0 : kJSONDeserializationOptions_MutableLeaves);
    id theObject = [theDeserializer deserialize:data error:error];
    return(theObject);
    }

+ (NSInteger)writeJSONObject:(id)obj toStream:(NSOutputStream *)stream options:(EJSONWritingOptions)opt error:(NSError **)error
    {
    // TODO -- this is a quick work around.
    NSInteger theSize = -1;
    NSData *theData = [self dataWithJSONObject:obj options:opt error:error];
    if (theData)
        {
        theSize = [stream write:[theData bytes] maxLength:[theData length]];
        }
    return(theSize);
    }

+ (id)JSONObjectWithStream:(NSInputStream *)stream options:(EJSONReadingOptions)opt error:(NSError **)error
    {
    #pragma unused (stream, opt, error)
    // TODO -- how much to read? Ugh.
    return(NULL);
    }

@end
