//
//  JSONTests.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/6.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface JSONTests : XCTestCase

@end

@implementation JSONTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSON2Plist{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *jsonPath = @"/Users/Kray/Desktop/Site.plist";
    
    NSArray *areaArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:NSJSONReadingMutableContainers error:nil];
    
    [areaArr writeToFile:@"/Users/Kray/Desktop/Site.plist" atomically:YES];
}

- (void)testReadPlist{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Site" ofType:@"plist"];
    NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    //newsTest.plist文件
    NSLog(@"%lu", (unsigned long)data1.count);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
