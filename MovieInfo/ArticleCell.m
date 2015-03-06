//
//  ArticleCell.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

- (NSString *)reuseIdentifier
{
    return @"ArticleCell";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,92,122)]; //81
    //self.thumbnail.opaque = YES;
    
    
    [self.contentView addSubview:self.thumbnail];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 110, 40)];
    self.titleLabel.opaque = YES;
    //[self.titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9]];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    self.titleLabel.numberOfLines = 2;
    [self.thumbnail addSubview:self.titleLabel];
    
    //self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.thumbnail.frame] ;
    //self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
    
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
