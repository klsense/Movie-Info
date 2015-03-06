//
//  SeasonsViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeasonsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) IBOutlet UITableView* mainTableView;
@property (nonatomic, strong)NSArray *pSeasonsArray;
@property (nonatomic, retain) NSString* fullInfoURL;
@property (nonatomic, retain) UIImage* poster;
@property (nonatomic, assign) int seasonID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSDictionary* fullInfo;
@property (nonatomic, retain) NSMutableArray* otherList;
@property (nonatomic, assign) BOOL youTubeLinkNull;


@end
