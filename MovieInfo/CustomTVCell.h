//
//  CustomTVCell.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTVCellDelegate <NSObject>

@optional
- (void)pushBiographyView:(int)num;
- (void)pushMovieView:(int)num poster:(NSString *)posterString;

@end

@interface CustomTVCell : UITableViewCell <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableViewInsideCell;
    NSArray *data;
}
@property (retain, nonatomic) IBOutlet UITableView *tableViewInsideCell;
@property (nonatomic, retain) NSArray *data;
@property(nonatomic, readonly, retain) UINavigationController *navigationController;
@property (nonatomic, assign) id<CustomTVCellDelegate> delegate;
@property (nonatomic, assign) BOOL isMovie;




@end
