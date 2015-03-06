//
//  listMoviesViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/28/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@class GADBannerView, GADRequest;

@interface listMoviesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, GADBannerViewDelegate>
{
    IBOutlet UITableView* mainTableView;
    NSArray* nowPlayingMoviesArray;
    
    NSArray* news;
    NSMutableData* data;
    GADBannerView *bannerView_;
    
}

@property (nonatomic, strong) GADBannerView *bannerView;
-(GADRequest*)createRequest;

@property (nonatomic,retain) IBOutlet UITableView* mainTableView;
@property (nonatomic, strong)NSArray *nowPlayingMoviesArray;
- (UIColor *)colorFromHexString:(NSString *)hexString;

@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@end

