//
//  FilterViewController.m
//  food
//
//  Created by Man-Chun Hsieh on 6/20/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDegelate>{
    NSDictionary *items;
    NSArray *itemsTitles;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *deals;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *distances;
@property (nonatomic, strong) NSArray *sorts;

@property (nonatomic, strong) NSMutableSet *selectedDeals;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSMutableSet *selectedDistances;
@property (nonatomic, strong) NSMutableSet *selectedSorts;

-(void) initCategories;

@end

@implementation FilterViewController


NSString * const reuseIdentifer = @"MySwitchCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedDeals = [NSMutableSet set];
    self.selectedCategories = [NSMutableSet set];
    self.selectedDistances = [NSMutableSet set];
    self.selectedSorts = [NSMutableSet set];
    [self initCategories];
    
    // Do any additional setup after loading the view from its nib.
    // 左邊 Filter
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onBackButton)];

    // 右邊 Filter
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Search"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onSearchButton)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    items = @{@"": self.deals,
              @"Sort By" :self.sorts,
              @"Distance" :self.distances,
              @"Category" :self.categories,
              };
    //animalSectionTitles = [[animals allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    itemsTitles = [items allKeys];
}

#pragma mark - Private methods
- (NSDictionary *)filters{
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];

    if(self.selectedDeals.count>0){
        NSString *dealFilters = @"true";
        [filters setObject:dealFilters forKey:@"deals_filter"];
    }else{
        NSString *dealFilters = @"false";
        [filters setObject:dealFilters forKey:@"deals_filter"];
    }
    
    if(self.selectedSorts.count>0){
        NSMutableArray *names = [NSMutableArray array];
        for(NSDictionary *category in self.selectedSorts){
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilters = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilters forKey:@"sort"];
    }
    
    if(self.selectedDistances.count>0){
        NSMutableArray *names = [NSMutableArray array];
        for(NSDictionary *distance in self.selectedDistances){
            [names addObject:distance[@"code"]];
        }
        NSString *distancesFilters = [names componentsJoinedByString:@","];
        [filters setObject:distancesFilters forKey:@"radius_filter"];
    }
    
    if(self.selectedCategories.count>0){
        NSMutableArray *names = [NSMutableArray array];
        for(NSDictionary *category in self.selectedCategories){
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilters = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilters forKey:@"category_filter"];
    }
    return filters;
}

- (void) onBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onSearchButton{
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [itemsTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [itemsTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    NSString *sectionTitle = [itemsTitles objectAtIndex:section];
    NSArray *sectionItems = [items objectForKey:sectionTitle];
    return [sectionItems count];

//    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer forIndexPath:indexPath];
    //cell.titleLabel.text = self.categories[indexPath.row][@"name"];
    //cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    cell.delegate = self;
    NSString *sectionTitle = [itemsTitles objectAtIndex:indexPath.section];
    NSArray *sectionItems = [items objectForKey:sectionTitle];
    NSString *item = [sectionItems objectAtIndex:indexPath.row][@"name"];
    cell.titleLabel.text=item;
   // cell.on = [self.selectedCategories containsObject:[sectionItems objectAtIndex:indexPath.row]];
    return cell;
}

-(void) initCategories{
    self.deals = @[@{@"name" : @"Offering a Deal", @"code" : @"true"}];
    self.sorts = @[@{@"name" : @"Best Match", @"code" : @"0"},
                        @{@"name" : @"Distance", @"code" : @"1"},
                        @{@"name" : @"Highest Rated", @"code" : @"2"}];
    self.distances = @[@{@"name" : @"Auto", @"code" : @"5000"},
                        @{@"name" : @"3 miles", @"code" : @"3000"},
                        @{@"name" : @"1 miles", @"code" : @"1000"}];
    self.categories =@[@{@"name" : @"Afghan", @"code" : @"afghani"},
                       @{@"name" : @"African", @"code" : @"african"},
                       @{@"name" : @"American", @"code" : @"newamerican"},
                       @{@"name" : @"Barbeque", @"code" : @"bbq"}];
}


#pragma mark - Switch Cell delegate methods
-(void) switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%d",[indexPath section]);
    if([indexPath section]==0){
        if(value){
            [self.selectedDeals addObject:self.sorts[indexPath.row]];
        }else{
            [self.selectedDeals removeObject:self.sorts[indexPath.row]];
        }
    }else if([indexPath section]==1){
        if(value){
            [self.selectedSorts addObject:self.sorts[indexPath.row]];
        }else{
            [self.selectedSorts removeObject:self.sorts[indexPath.row]];
        }
    }else if ([indexPath section]==2){
        if(value){
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        }else{
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
    }else if ([indexPath section]==3){
        if(value){
            [self.selectedDistances addObject:self.distances[indexPath.row]];
        }else{
            [self.selectedDistances removeObject:self.distances[indexPath.row]];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
