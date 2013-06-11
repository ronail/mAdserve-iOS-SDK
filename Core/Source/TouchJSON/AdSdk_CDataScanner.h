
#import <Foundation/Foundation.h>

@interface AdSdk_CDataScanner : NSObject {
	NSData *data;

	u_int8_t *start;
	u_int8_t *end;
	u_int8_t *current;
	NSUInteger length;
}

@property (readwrite, nonatomic, strong) NSData *data;
@property (readwrite, nonatomic, assign) NSUInteger scanLocation;
@property (readonly, nonatomic, assign) NSUInteger bytesRemaining;
@property (readonly, nonatomic, assign) BOOL isAtEnd;

- (id)initWithData:(NSData *)inData;

- (unichar)currentCharacter;
- (unichar)scanCharacter;
- (BOOL)scanCharacter:(unichar)inCharacter;

- (BOOL)scanUTF8String:(const char *)inString intoString:(NSString **)outValue;
- (BOOL)scanString:(NSString *)inString intoString:(NSString **)outValue;
- (BOOL)scanCharactersFromSet:(NSCharacterSet *)inSet intoString:(NSString **)outValue;

- (BOOL)scanUpToString:(NSString *)string intoString:(NSString **)outValue;
- (BOOL)scanUpToCharactersFromSet:(NSCharacterSet *)set intoString:(NSString **)outValue;

- (BOOL)scanNumber:(NSNumber **)outValue;
- (BOOL)scanDecimalNumber:(NSDecimalNumber **)outValue;

- (BOOL)scanDataOfLength:(NSUInteger)inLength intoData:(NSData **)outData;

- (void)skipWhitespace;

- (NSString *)remainingString;
- (NSData *)remainingData;

@end
