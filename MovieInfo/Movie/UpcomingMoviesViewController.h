//
//  UpcomingMoviesViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/29/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@class GADBannerView, GADRequest;

@interface UpcomingMoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate>
{
    IBOutlet UITableView * upcomingMoviesTable;
    NSArray* news;
    NSMutableData* data;
    NSArray* upcomingMoviesArray;
    GADBannerView *bannerView_;
}

@property (nonatomic, strong) GADBannerView *bannerView;
-(GADRequest*)createRequest;

@property (nonatomic, retain) IBOutlet UITableView *upcomingMoviesTable;
@property (nonatomic, strong)NSArray *upcomingMoviesArray;
// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;


@end

