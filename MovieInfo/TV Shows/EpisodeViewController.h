//
//  EpisodeViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) IBOutlet UITableView* mainTableView;
@property (nonatomic, strong)NSArray *pEpisodeArray;
@property (nonatomic, retain) NSString* fullInfoURL;
@property (nonatomic, retain) NSString* name;
//needs three things: season, season number, episode number
@property (nonatomic, assign) int seasonID;
@property (nonatomic, assign) int season;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;



@end

