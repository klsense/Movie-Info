//
//  GenreViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/29/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GenreViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight:(int*)num; //for left

@required
- (void)movePanelToOriginalPosition:(int*)num;

@end

@interface GenreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *pGenreTable;
@property (nonatomic, strong)NSArray *pGenreArray;
@property (strong, nonatomic) IBOutlet UINavigationController *pGenreNC;
@property (nonatomic, assign) id<GenreViewControllerDelegate> delegate;
@property (weak,nonatomic) IBOutlet UIButton *openButton;


@end
