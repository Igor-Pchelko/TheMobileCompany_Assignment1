//
//  RestaurantModel.m
//  Assignment1
//
//  Created by Igor Pchelko on 20/02/16.
//  Copyright © 2016 Igor Pchelko. All rights reserved.
//

#import "RestaurantModel.h"

@implementation RestaurantModel

- (NSString*)description
{
    return [NSString stringWithFormat:@"title: %@; details:%@; coord:%f, %f;",
            self.title, self.details, self.coord.latitude, self.coord.longitude];
}

@end
