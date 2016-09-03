//
//  FourSquareKitTests.m
//  Assignment1
//
//  Created by Igor Pchelko on 20/02/16.
//  Copyright © 2016 Igor Pchelko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FourSquareKit.h"
#import "UXRAsyncTesting.h"
#import "UXRFourSquareRestaurantModel+Validations.h"
#import "UXRFourSquarePhotoModel+Validation.h"

@interface FourSquareKitTests : XCTestCase

@property (strong, nonatomic) UXRFourSquareNetworkingEngine *fourSquareEngine;

@end

@implementation FourSquareKitTests

- (void)setUp
{
    [super setUp];
    NSString *yourClientId = @"0MNP2PYP4J4GNOE0WMJH3P1MOAVLCNWX5543CXDSTGAL24K3";
    NSString *yourClientSecret = @"P5GGP3CPXVLTJYCUADX2CXJG3YGW3KTAXV033YIWVBL0SP2K";
    NSString *yourCallbackURl = @"assignment1://foursquare"; //yourapp://foursquare
    
    [UXRFourSquareNetworkingEngine registerFourSquareEngineWithClientId:yourClientId andSecret:yourClientSecret andCallBackURL:yourCallbackURl];
    self.fourSquareEngine = [UXRFourSquareNetworkingEngine sharedInstance];
}


- (void)testRestaurantsNearLocationQuery
{
    StartBlock();
    CLLocation *location = [CLLocation locationInSeattle];
    
    [self.fourSquareEngine getRestaurantsNearLocation:location withCompletionBlock:^(NSArray *restaurants) {
        for (UXRFourSquareRestaurantModel *restaurantModel in restaurants)
        {
            BOOL isValid = [restaurantModel isValid];
            XCTAssertEqual(isValid, YES, @"Model was not valid");
            NSLog(@"restaurantModel: %@", restaurantModel);
        }
        EndBlock();
    } failureBlock:^(NSError *error) {
        XCTAssertNil(error, @"Error should be nil");
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

@end
