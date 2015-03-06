//
//  SearchMoviesViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"

@interface SearchMoviesViewController : UIViewController <UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CenterViewControllerDelegate>
{
    
    //NSString *pushedSearchString;
    //IBOutlet UISearchBar *homeSearchBar;
    IBOutlet UITableView *theTableView;
    IBOutlet UISearchBar * theSearchBar;
    NSMutableArray* tableData;
    UIView * disableViewOverlay;
    //NSURL* urlForSearch;
    NSString *urlForSearch;
}


//@property (strong) NSString *pushedSearchString;
//@property (nonatomic,strong) IBOutlet UISearchBar *homeSearchBar;

@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UISearchBar * theSearchBar;
@property (retain) NSMutableArray* tableData;
@property (retain) UIView* disableViewOverlay;
//@property (nonatomic, retain) NSURL* urlForSearch;
@property (nonatomic, copy) NSString* urlForSearch;

@property(nonatomic,copy) NSString *searchString;
@property (assign) BOOL bMovie;
@property (assign) BOOL bTVShow;
@property (assign) BOOL bPeople;


@property (retain) NSMutableArray* pMovies;
@property (retain) NSMutableArray* pTvShows;
@property (retain) NSMutableArray* pPeople;

@property (assign) BOOL firstSearchClicked;

- (UIColor *)colorFromHexString:(NSString *)hexString;
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;


@end
