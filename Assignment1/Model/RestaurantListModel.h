//
//  RestaurantListModel.h
//  Assignment1
//
//  Created by Igor Pchelko on 20/02/16.
//  Copyright © 2016 Igor Pchelko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString* kRestaurantListModelDidUpdate = @"RestaurantListModelDidUpdate";

@interface RestaurantListModel : NSObject

@property (strong, nonatomic) NSMutableArray *restaurants;

+ (instancetype)sharedInstance;
- (void)updateRestaurantsWithtLocation:(CLLocation *)location;
- (void)updateRestaurantsNearCurrentLocation;

@end
