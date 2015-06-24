//
//  ViewController.m
//  yelp
//
//  Created by Man-Chun Hsieh on 6/19/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "ViewController.h"
#import "YelpClient.h"
#import "BusinessCell.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

@property (weak, nonatomic) IBOutlet UITableView *yelpTableView;

@end

@implementation ViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
//        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
//        // get response data from yelp
//        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
//            self.business = response[@"businesses"];
//            NSLog(@"business: %@", self.business);
//            self.yelpTableView = response[@"businesses"];
//            [self.yelpTableView reloadData];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"error: %@", [error description]);
//        }];
//    }
//    return self;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.yelpTableView.dataSource = self;
    self.yelpTableView.delegate = self;
    
    [self loadDataFromAPI];
}


- (void) loadDataFromAPI{
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    // get response data from yelp
    [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
        self.businesses = response[@"businesses"];
        [self.yelpTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.textLabel.text=[NSString stringWithFormat:@"Row %1d", indexPath.row];
    NSDictionary *business = self.businesses[indexPath.row];
    cell.nameLabel.text=business[@"name"];
//    cell.synopsisLabel.text=movie[@"synopsis"];
//    NSString *imageURL= [movie valueForKeyPath:@"posters.thumbnail"];
//    [cell.poster setImageWithURL:[NSURL URLWithString:imageURL]];
//    
//    //NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
//    //cell.poster.image = [UIImage imageWithData: imageData];
//    [SVProgressHUD dismiss];
    return cell;
}

@end
