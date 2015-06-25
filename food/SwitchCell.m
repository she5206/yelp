//
//  SwitchCell.m
//  food
//
//  Created by Man-Chun Hsieh on 6/20/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()

@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
- (IBAction)switchValueChanged:(UISwitch *)sender;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on{
    [self setOn:on animated:NO];
}
- (void)setOn:(BOOL)on animated:(BOOL)animated{
    _on =on;
    [self.toggleSwitch setOn:on animated:YES];
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}
@end
