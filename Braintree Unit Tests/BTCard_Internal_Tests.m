#import <XCTest/XCTest.h>
#import "BTCardTokenizationRequest_Internal.h"

// See also BTCard_Tests
@interface BTCardTokenizationRequest_Internal_Tests : XCTestCase

@end

@implementation BTCardTokenizationRequest_Internal_Tests

- (void)testParameters_standardProperties {
    BTCardTokenizationRequest *card = [[BTCardTokenizationRequest alloc] initWithNumber:@"4111111111111111"
                                                                        expirationMonth:@"12"
                                                                         expirationYear:@"2038"
                                                                                    cvv:@"123"];
    BTJSON *parameters = [[BTJSON alloc] initWithValue:card.parameters];
    XCTAssertEqualObjects(parameters[@"number"].asString, @"4111111111111111");
    XCTAssertEqualObjects(parameters[@"expiration_date"].asString, @"12/2038");
    XCTAssertEqualObjects(parameters[@"cvv"].asString, @"123");
    XCTAssertTrue(parameters[@"options"][@"validate"].isFalse);
}

- (void)testParameters_whenShouldValidateIsTrue_encodesParametersCorrectly {
    BTCardTokenizationRequest *card = [[BTCardTokenizationRequest alloc] init];
    card.shouldValidate = YES;
    BTJSON *parameters = [[BTJSON alloc] initWithValue:card.parameters];
    XCTAssertTrue(parameters[@"options"][@"validate"].isTrue);
}

- (void)testParameters_encodesAllParametersIncludingAdditionalParameters {
    BTCardTokenizationRequest *card =
    [[BTCardTokenizationRequest alloc] initWithParameters:@{
                                                            @"billing_address": @{
                                                                    @"street_address": @"724 Evergreen Terrace" }
                                                            }];

    card.number =@"4111111111111111";
    card.expirationMonth = @"12";
    card.expirationYear = @"2038";
    card.postalCode = @"40404";

    BTJSON *parameters = [[BTJSON alloc] initWithValue:card.parameters];
    XCTAssertEqualObjects(parameters[@"number"].asString, @"4111111111111111");
    XCTAssertEqualObjects(parameters[@"expiration_date"].asString, @"12/2038");
    XCTAssertEqualObjects(parameters[@"billing_address"][@"postal_code"].asString, @"40404");
    XCTAssertEqualObjects(parameters[@"billing_address"][@"street_address"].asString, @"724 Evergreen Terrace");
}

@end