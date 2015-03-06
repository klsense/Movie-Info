//
//  EpisodeInfo.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeInfo : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSString* fullInfoURL;
@property (nonatomic, retain) NSDictionary* dictFullInfo;
@property (nonatomic, assign) NSUInteger characterCount;
@property (nonatomic, assign) int summaryLabelHeight;


@end
