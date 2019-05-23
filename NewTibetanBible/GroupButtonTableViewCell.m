//
//  GroupButtonTableViewCell.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 1/27/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "GroupButtonTableViewCell.h"

@implementation GroupButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.sortBtn.layer.cornerRadius = 10;
    self.sortBtn.layer.borderWidth = 1;
    self.sortBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.editBtn.layer.cornerRadius = 10;
    self.editBtn.layer.borderWidth = 1;
    self.editBtn.layer.borderColor = [UIColor blackColor].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
