//
//  GenreList.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
@class GADBannerView, GADRequest;

@interface GenreList : UIViewController <UITableViewDelegate,UITableViewDataSource, GADBannerViewDelegate> {
    GADBannerView *bannerView_;
    
}

@property (nonatomic, strong) GADBannerView *bannerView;
-(GADRequest*)createRequest;


@property (nonatomic,retain) IBOutlet UITableView *pGenreTV;

@property (nonatomic,strong) NSArray *pGenreArray;
@property (nonatomic,retain) NSString *sURL;
- (UIColor *)colorFromHexString:(NSString *)hexString;

@end