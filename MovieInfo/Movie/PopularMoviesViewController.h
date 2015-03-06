//
//  PopularMoviesViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/28/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
@class GADBannerView, GADRequest;


@interface PopularMoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate>
{
    IBOutlet UITableView* popularMoviesTable;
    NSArray* news;
    NSMutableData* data;
    NSArray* popularMoviesArray;
    GADBannerView *bannerView_;
}

@property (nonatomic, strong) GADBannerView *bannerView;
-(GADRequest*)createRequest;


@property (nonatomic, retain) IBOutlet UITableView* popularMoviesTable;
@property (nonatomic, strong)NSArray *popularMoviesArray;
@property (nonatomic, retain) NSDictionary* dictionaryForMovieInfo;
- (UIColor *)colorFromHexString:(NSString *)hexString;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@end
