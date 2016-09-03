//
//  ListViewController.m
//  Assignment1
//
//  Created by Igor Pchelko on 20/02/16.
//  Copyright © 2016 Igor Pchelko. All rights reserved.
//

#import "ListViewController.h"
#import "RestaurantListModel.h"
#import "RestaurantModel.h"
#import "RestaurantModelTableViewCell.h"

@interface ListViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateRestaurants:(id)sender
{
    [[RestaurantListModel sharedInstance] updateRestaurantsNearCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restaurantListModelDidUpdate:) name:kRestaurantListModelDidUpdate object:nil];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRestaurantListModelDidUpdate object:nil];
}

- (void)restaurantListModelDidUpdate:(NSNotification *) notification
{
    [self.tableView reloadData];
}

#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [RestaurantListModel sharedInstance].restaurants.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = NSStringFromClass([RestaurantModelTableViewCell class]);
    RestaurantModelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[RestaurantModelTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    RestaurantModel *model = (RestaurantModel*)[[RestaurantListModel sharedInstance].restaurants objectAtIndex:indexPath.row];
    cell.title.text = model.title;
    cell.details.text = model.details;
    
    return cell;
}

@end
