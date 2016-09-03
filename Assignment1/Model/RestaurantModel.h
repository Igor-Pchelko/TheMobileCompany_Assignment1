//
//  RestaurantModel.h
//  Assignment1
//
//  Created by Igor Pchelko on 20/02/16.
//  Copyright © 2016 Igor Pchelko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>B

@interface RestaurantModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *details;
@property (assign, nonatomic) CLLocationCoordinate2D coord;

@end
