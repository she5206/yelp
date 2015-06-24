//
//  BusinessCell.h
//  yelp
//
//  Created by Man-Chun Hsieh on 6/19/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
