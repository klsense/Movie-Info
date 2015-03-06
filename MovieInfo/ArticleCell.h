//
//  ArticleCell.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell
{
    UIImageView *_thumbnail;
    UILabel *_titleLabel;
}

@property (nonatomic, retain) UIImageView *thumbnail;
@property (nonatomic, retain) UILabel *titleLabel;


@end

