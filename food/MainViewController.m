//
//  MainViewController.m
//  food
//
//  Created by Man-Chun Hsieh on 6/20/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "UIImageView+AFNetworking.h"
#import "BusinessCell.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";


@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate> //
@property (weak, nonatomic) IBOutlet UITableView *yelpTableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yelpTableView.delegate = self;
    self.yelpTableView.dataSource = self;

    // auto height
    self.yelpTableView.estimatedRowHeight = 100.0;
    self.yelpTableView.rowHeight = UITableViewAutomaticDimension;

    
    // load data from Yelp
    [self loadDataFromAPI];
    
    // do Navigation settings
    [self setNavgationBar];
    
    // add search bar
    [self addSearchBar];
}


-(void) donothing{
}

- (void) addSearchBar{
    // 左邊 Filter
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Filter"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onFilterButton)];
    // 右邊 Search Bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    searchBar.backgroundImage = [[UIImage alloc] init] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
}


- (void) setNavgationBar{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:235/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    self.title=@"Yelp";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDataFromAPI{
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    [self fetchBusinessesWithQuery:@"restaurant" params:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //取消選取
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // reuse
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBusinessCell" forIndexPath: indexPath];
    //cell.nameLabel.text=[NSString stringWithFormat:@"Row %1d", indexPath.row];
    
    // 很簡單就可以抓出來的字串
    NSDictionary *business = self.businesses[indexPath.row];
    NSString *imageURL= business[@"image_url"];
    [cell.imageUrl setImageWithURL:[NSURL URLWithString:imageURL]];
    cell.nameLabel.text=business[@"name"];
    NSString *ratingsimageURL= business[@"rating_img_url"];
    [cell.ratingsImageView setImageWithURL:[NSURL URLWithString:ratingsimageURL]];
    
    // 以下需要一點技巧
    // distance 取int
    float milesPerMeter = 0.000621371;
    cell.distanceLabel.text=[NSString stringWithFormat:@"%.2f miles", [business[@"distance"] integerValue]*milesPerMeter ];
    cell.reviewsLabel.text=[NSString stringWithFormat:@"%d Reviews", [business[@"review_count"] integerValue]];
    
    // category - 雙層array 特殊用法
    NSArray *categories = business[@"categories"];
    NSMutableArray *categoryNames = [NSMutableArray array];
    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [categoryNames addObject:obj[0]];
    }];
    
    cell.categoryLabel.text=[categoryNames componentsJoinedByString:@", "];
    
    // address - 藏在()裡面 要取[0]
    NSString *address= [business valueForKeyPath:@"location.address"][0] ;
    NSString *neighborhoods= [business valueForKeyPath:@"location.neighborhoods"][0] ;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@, %@", address, neighborhoods];
    
    //    [SVProgressHUD dismiss];
    
    return cell;
}


#pragma mark - Filter delegate methods

-(void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters{
    [self fetchBusinessesWithQuery:@"Restaurant" params:filters];
    NSLog(@"%@",filters);
}

#pragma mark - private
-(void) fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params{
    // get response data from yelp
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        self.businesses = response[@"businesses"];
        [self.yelpTableView reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void) onFilterButton{
    FilterViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"FilterView"];  //記得要用storyboard id 傳過去
    
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}


@end