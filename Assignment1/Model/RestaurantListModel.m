//
//  RestaurantListModel.m
//  Assignment1
//
//  Created by Igor Pchelko on 20/02/16.
//  Copyright © 2016 Igor Pchelko. All rights reserved.
//

#import "RestaurantListModel.h"
#import "RestaurantModel.h"
#import "FourSquareKit.h"
#import "UXRFourSquareRestaurantModel+Validations.h"


@interface RestaurantListModel()

@property (strong, nonatomic) UXRFourSquareNetworkingEngine *fourSquareEngine;

@end

@implementation RestaurantListModel

+ (instancetype)sharedInstance
{
    static RestaurantListModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self != nil)
    {
        self.restaurants = [NSMutableArray arrayWithCapacity:10];
        
        NSString *yourClientId = @"0MNP2PYP4J4GNOE0WMJH3P1MOAVLCNWX5543CXDSTGAL24K3";
        NSString *yourClientSecret = @"P5GGP3CPXVLTJYCUADX2CXJG3YGW3KTAXV033YIWVBL0SP2K";
        NSString *yourCallbackURl = @"assignment1://foursquare";
        
        [UXRFourSquareNetworkingEngine registerFourSquareEngineWithClientId:yourClientId andSecret:yourClientSecret andCallBackURL:yourCallbackURl];
        self.fourSquareEngine = [UXRFourSquareNetworkingEngine sharedInstance];
    }

    return self;
}

- (void)updateRestaurantsWithtLocation:(CLLocation *)location
{
    [self.fourSquareEngine getRestaurantsNearLocation:location withCompletionBlock:^(NSArray *restaurants) {
        
        [self.restaurants removeAllObjects];
        
        for (UXRFourSquareRestaurantModel *restaurantModel in restaurants)
        {
            BOOL isValid = [restaurantModel isValid];
            if (isValid
                && restaurantModel.location != nil
                && restaurantModel.location.lat != nil
                && restaurantModel.location.lat != nil)
            {
                RestaurantModel *model = [[RestaurantModel alloc] init];
                model.title = restaurantModel.name;
                model.details = @""; //restaurantModel.description;
                if (restaurantModel.location.address != nil)
                {
                    model.details = restaurantModel.location.address;
                }
                
                model.coord = CLLocationCoordinate2DMake([restaurantModel.location.lat doubleValue],
                                                         [restaurantModel.location.lng doubleValue]);
                
                [self.restaurants addObject:model];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRestaurantListModelDidUpdate
                                                            object:self
                                                          userInfo:@{}];
    } failureBlock:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRestaurantListModelDidUpdate
                                                            object:self
                                                          userInfo:@{@"error": error}];
    }];
}

- (void)updateRestaurantsNearCurrentLocation
{
    CLLocation *location = [CLLocation locationInSeattle];
    [self updateRestaurantsWithtLocation:location];
}

@end
