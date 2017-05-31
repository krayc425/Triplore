//
//  TriploreTests.m
//  TriploreTests
//
//  Created by 宋 奎熹 on 2017/5/31.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DBManager.h"
#import "FMDatabase.h"

@interface TriploreTests : XCTestCase

@end

@implementation TriploreTests

- (void)setUp {
    [super setUp];
    
    [[DBManager shareInstance] establishDB];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[DBManager shareInstance] closeDB];
}

- (void)testInsertDictIntoDB {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSDictionary *testDict = @{@"playid" : @"123456"};
    NSData *testDictData = [NSKeyedArchiver archivedDataWithRootObject:testDict];
    
    FMDatabase *db = [[DBManager shareInstance] getDB];
    BOOL result = [db executeUpdate:@"INSERT INTO t_video (videoid, dict) VALUES (?, ?);", @(1), testDictData];
    XCTAssertTrue(result);
}

- (void)testFetchDictFromDB {
    FMDatabase *db = [[DBManager shareInstance] getDB];
    FMResultSet *resultSet = [db executeQuery:@"SELECT * from t_video;"];
    while ([resultSet next]){
        NSData *testData = [resultSet dataForColumn:@"dict"];
        NSDictionary *testDict = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:testData];
        XCTAssert([testDict[@"playid"] isEqualToString:@"123456"] == TRUE);
        NSLog(@"%@", testDict[@"playid"]);
    }
}

- (void)testInsertViewIntoDB {
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    [label1 setText:@"Test 1"];
    [label1 sizeToFit];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    [label2 setText:@"Test 2"];
    [label2 sizeToFit];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    [label3 setText:@"Test 3"];
    [label3 sizeToFit];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    [label4 setText:@"Test 4"];
    [label4 sizeToFit];
    UIImage *image = [UIImage imageNamed:@"TEST_PNG"];
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [imgView1 setImage:image];
    [imgView1 setContentMode:UIViewContentModeScaleAspectFit];
    
    NSArray *viewArray = @[label1, label2, label3, imgView1, label4];
    
    NSData *testArrayData = [NSKeyedArchiver archivedDataWithRootObject:viewArray];
    
    FMDatabase *db = [[DBManager shareInstance] getDB];
    BOOL result = [db executeUpdate:@"INSERT INTO t_note (noteid, videoid, views, createTime, title) VALUES (?, ?, ?, ?, ?);", @(1), @(1), testArrayData, [NSDate date], @"TestTitle"];
    XCTAssertTrue(result);
}

- (void)testFetchViewFromDB {
    FMDatabase *db = [[DBManager shareInstance] getDB];
    FMResultSet *resultSet = [db executeQuery:@"SELECT * from t_note;"];
    while ([resultSet next]){
        NSData *testData = [resultSet dataForColumn:@"views"];
        NSArray *testArr = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:testData];
        
        XCTAssert(testArr.count == 5);
        
        NSLog(@"%@, %d, %d, %@",
              [resultSet stringForColumn:@"title"],
              [resultSet intForColumn:@"noteid"],
              [resultSet intForColumn:@"videoid"],
              [resultSet dateForColumn:@"createTime"]);
    }
}

- (void)testCountNote{
    int count = 0;
    FMResultSet *resultSet = [[[DBManager shareInstance] getDB] executeQuery:@"SELECT * FROM t_note;"];
    while([resultSet next]){
        count++;
    }
    NSLog(@"Count : %d", count);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
