//
//  OHHTTPStubsXCTestLog.m
//  OHHTTPStubs
//
//  Created by Vlado Grancaric on 10/07/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import "OHHTTPStubsXCTestLog.h"

NSString *const kXCTTestCaseArgsFormat = @"%@|%s|%.3f";
NSString *const kOHHTTPStubsArgsSeparator = @"|";
NSString *const kOHHTTPStubsTestCaseFinishFormat = @"Test Case '%@' %s (%.3f seconds).\n";
NSString *const kOHHTTPStubsModifiedTestResultFormat = @"%@: %@ (%@s)\n";

@implementation OHHTTPStubsXCTestLog

+ (void)load
{
    // Register this class as the only XCTestObserver to be used with this target
    [[NSUserDefaults standardUserDefaults] setValue:NSStringFromClass(self)
                                             forKey:XCTestObserverClassKey];
}

- (void)testLogWithFormat:(NSString *)format arguments:(va_list)arguments
{
    if (![format isEqualToString:kOHHTTPStubsTestCaseFinishFormat]) {
        return;
    }
    
    NSArray *args = NSArrayFromArguments(arguments);
    NSString *testCase = args[0];
    NSString *result = [args[1] uppercaseString];
    NSString *duration = args[2];
    
    NSString *formattedLog = [NSString stringWithFormat:kOHHTTPStubsModifiedTestResultFormat, result, testCase, duration];
    
    [self.logFileHandle writeData:[formattedLog dataUsingEncoding:NSUTF8StringEncoding]];
}

NSArray *NSArrayFromArguments(va_list arguments)
{
    NSString *s = [[NSString alloc] initWithFormat:kXCTTestCaseArgsFormat arguments:arguments];
    NSArray *args = [s componentsSeparatedByString:kOHHTTPStubsArgsSeparator];
    
    return args;
}

@end
