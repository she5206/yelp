//
//  Business.h
//  yelp
//
//  Created by Man-Chun Hsieh on 6/19/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, assign) NSInteger *numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) CGFloat *distance;

@end
