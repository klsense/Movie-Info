//
//  TVPopularViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
@class GADBannerView, GADRequest;

@interface TVPopularViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate>
{
    GADBannerView *bannerView_;
}

@property (nonatomic, strong) GADBannerView *bannerView;
-(GADRequest*)createRequest;

@property (nonatomic,retain) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong) NSArray *pPopularArray;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;


@end