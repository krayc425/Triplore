//
//  UserTests.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UserTests : XCTestCase

@end

@implementation UserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSignUp {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    AVUser *user = [AVUser user];
    user.username = @"test";
    user.password = @"123";
    user.email = @"krayc425@gmail.com";
    [user signUp:nil];
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"注册成功");
//            NSLog(@"%@",  [AVUser currentUser].description);
////            [self performSegueWithIdentifier:@"fromSignUpToProducts" sender:nil];
//        } else {
//            NSLog(@"注册失败 %@", error);
//        }
//    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
