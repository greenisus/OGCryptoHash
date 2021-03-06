//
//  NSString+OGCryptoHash.m
//
//  Created by Jesper <jesper@orangegroove.net>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import <CommonCrypto/CommonCrypto.h>
#import "NSString+OGCryptoHash.h"

@interface NSString (OGCryptoHashPrivate)

- (int)digestLengthForCryptoHashFunction:(OGCryptoHashFunction)function;
- (CCHmacAlgorithm)hmacAlgorithmForCryptoHashFunction:(OGCryptoHashFunction)function;

@end
@implementation NSString (OGCryptoHash)

#pragma mark - Public

- (NSData *)dataUsingCryptoHashFunction:(OGCryptoHashFunction)function
{
	int len = [self digestLengthForCryptoHashFunction:function];
	unsigned char buffer[len];
	
	if (len < 0)
		return nil;
	
	switch (function) {
		case OGCryptoHashFunctionMD5:
			CC_MD5(self.UTF8String, self.length, buffer);
			break;
		case OGCryptoHashFunctionSHA1:
			CC_SHA1(self.UTF8String, self.length, buffer);
			break;
		case OGCryptoHashFunctionSHA224:
			CC_SHA224(self.UTF8String, self.length, buffer);
			break;
		case OGCryptoHashFunctionSHA256:
			CC_SHA256(self.UTF8String, self.length, buffer);
			break;
		case OGCryptoHashFunctionSHA384:
			CC_SHA384(self.UTF8String, self.length, buffer);
			break;
		case OGCryptoHashFunctionSHA512:
			CC_SHA512(self.UTF8String, self.length, buffer);
			break;
	}
	
	return [NSData dataWithBytes:buffer length:len];
}

- (NSData *)dataUsingCryptoHashFunction:(OGCryptoHashFunction)function hmacSignedWithKey:(NSString *)key
{
	int len					= [self digestLengthForCryptoHashFunction:function];
	CCHmacAlgorithm algo	= [self hmacAlgorithmForCryptoHashFunction:function];
	unsigned char buffer[len];
	
	if (len < 0 || algo == UINT32_MAX)
		return nil;
	
	CCHmac(algo, key.UTF8String, key.length, self.UTF8String, self.length, buffer);
	return [NSData dataWithBytes:buffer length:len];
}

#pragma mark - Private

- (int)digestLengthForCryptoHashFunction:(OGCryptoHashFunction)function
{
	switch (function) {
		case OGCryptoHashFunctionMD5:
			return CC_MD5_DIGEST_LENGTH;
		case OGCryptoHashFunctionSHA1:
			return CC_SHA1_DIGEST_LENGTH;
		case OGCryptoHashFunctionSHA224:
			return CC_SHA224_DIGEST_LENGTH;
		case OGCryptoHashFunctionSHA256:
			return CC_SHA256_DIGEST_LENGTH;
		case OGCryptoHashFunctionSHA384:
			return CC_SHA384_DIGEST_LENGTH;
		case OGCryptoHashFunctionSHA512:
			return CC_SHA512_DIGEST_LENGTH;
		default:
			return -1;
	}
}

- (CCHmacAlgorithm)hmacAlgorithmForCryptoHashFunction:(OGCryptoHashFunction)function
{
	switch (function) {
		case OGCryptoHashFunctionMD5:
			return kCCHmacAlgMD5;
		case OGCryptoHashFunctionSHA1:
			return kCCHmacAlgSHA1;
		case OGCryptoHashFunctionSHA224:
			return kCCHmacAlgSHA224;
		case OGCryptoHashFunctionSHA256:
			return kCCHmacAlgSHA256;
		case OGCryptoHashFunctionSHA384:
			return kCCHmacAlgSHA384;
		case OGCryptoHashFunctionSHA512:
			return kCCHmacAlgSHA512;
		default:
			return UINT32_MAX;
	}
}

@end
