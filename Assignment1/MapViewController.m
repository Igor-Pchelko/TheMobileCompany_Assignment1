//
//  MapViewController.m
//  Assignment1
//
//  Created by Igor Pchelko on 20/02/16.
//  Copyright © 2016 Igor Pchelko. All rights reserved.
//

#import "MapViewController.h"
#import "FourSquareKit.h"
#import "RestaurantListModel.h"
#import "RestaurantModel.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *navigationMode;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) BOOL isManualNavigation;
@property (copy, nonatomic) CLLocation *lastLocation;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestAlwaysAuthorization];
    }

    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)updateRestaurants:(id)sender
{
    [[RestaurantListModel sharedInstance] updateRestaurantsNearCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restaurantListModelDidUpdate:) name:kRestaurantListModelDidUpdate object:nil];
    [self addRestaurantsAnnotations];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRestaurantListModelDidUpdate object:nil];
}

- (void)restaurantListModelDidUpdate:(NSNotification *) notification
{
    [self addRestaurantsAnnotations];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:@"Failed to Get Your Location"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                         }];
    [alert addAction:okAction]; // add action to uialertcontroller
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    bool isNeedUpdate = NO;
    
    if (self.lastLocation == nil)
    {
        self.lastLocation = newLocation;
        isNeedUpdate = YES;
    }
    else
    {
        const float kSignificantMoveDistance = 100; // distance in meters
        if ([self.lastLocation distanceFromLocation:newLocation] > kSignificantMoveDistance)
        {
            self.lastLocation = newLocation;
            isNeedUpdate = YES;
        }
    }
    
    if (isNeedUpdate)
    {
        [[RestaurantListModel sharedInstance] updateRestaurantsNearCurrentLocation];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.isManualNavigation)
        return;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.isManualNavigation)
        return;
    
    CLLocationCoordinate2D coord = [self.mapView centerCoordinate];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];

    [[RestaurantListModel sharedInstance] updateRestaurantsWithtLocation:location];
}

- (void)addRestaurantsAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];

    for (RestaurantModel *model in [RestaurantListModel sharedInstance].restaurants)
    {
        // Add an annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = model.coord;
        point.title = model.title;
        point.subtitle = model.details;
        
        [self.mapView addAnnotation:point];
    }
}

- (IBAction)navigationModeDidChange:(id)sender
{
    self.isManualNavigation = self.navigationMode.selectedSegmentIndex == 1;
}

@end
