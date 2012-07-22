//
//  RecipeTableViewCell.m
//  chef-pad-client
//
//  Created by 松本 宗太郎 on 2012/07/16.
//  Copyright (c) 2012年 Soutaro Matsumoto. All rights reserved.
//

#import "RecipeTableViewCell.h"

@implementation RecipeTableViewCell
@synthesize imageView;
@synthesize titleTextLabel;
@synthesize bodyTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
