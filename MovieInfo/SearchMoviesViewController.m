//
//  SearchMoviesViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "SearchMoviesViewController.h"
#import "MovieInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "BiographyTable.h"
#import "SeasonsViewController.h"
#import "NetworkError.h"
#import "Reachability.h"

@interface SearchMoviesViewController ()<CenterViewControllerDelegate>

@end

@implementation SearchMoviesViewController
//@synthesize searchList;//, pushedSearchString;
@synthesize theSearchBar;
@synthesize theTableView;
@synthesize tableData;
@synthesize disableViewOverlay;
@synthesize urlForSearch, searchString, bMovie, bPeople, bTVShow;
@synthesize pMovies,pPeople,pTvShows;
@synthesize firstSearchClicked;
@synthesize spinner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Initialize tableData and disabledViewOverlay
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    
    self.tableData =[[NSMutableArray alloc]init];
    self.pMovies =[[NSMutableArray alloc]init];
    self.pPeople =[[NSMutableArray alloc]init];
    self.pTvShows =[[NSMutableArray alloc]init];
    
    self.disableViewOverlay = [[UIView alloc]
                               initWithFrame:CGRectMake(0.0f,108.0f,320.0f,416.0f)];
    self.disableViewOverlay.backgroundColor=[UIColor blackColor];
    self.disableViewOverlay.alpha = 0;
    self.title = @"Search";
    self.searchString = @"http://api.themoviedb.org/3/search/movie?api_key=c7dbad2bd6e90365dd9a822e201bf107&query=";
    self.bMovie = TRUE;
    self.bTVShow = FALSE;
    self.bPeople = FALSE;
    NSArray * array = [NSArray arrayWithObjects:@"Movies",@"TV Shows",@"People", nil];
    UISegmentedControl * sc = [[UISegmentedControl alloc] initWithItems:array];
    sc.frame = CGRectMake(0, 0, 230, 25);
    [sc addTarget:self action:@selector(mySegmentedControlAction:) forControlEvents: UIControlEventValueChanged];
    sc.selectedSegmentIndex = 0;
    [self.navigationItem setTitleView:sc];
    self.firstSearchClicked = FALSE;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    [self.theTableView setSeparatorColor:[self colorFromHexString:@"#999999"]];

    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 90, 90)];
    spinner.layer.cornerRadius = 5;
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    spinner.opaque = NO;
    spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];

}


- (void) dismissKeyboard
{
    // add self
    if (self.theTableView.allowsSelection == FALSE) {
        theSearchBar.text=@"";
        [self searchBar:theSearchBar activate:NO];
    }
    
}

// Since this view is only for searching give the UISearchBar
// focus right away
- (void)viewDidAppear:(BOOL)animated {
    [self.theSearchBar becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self searchBar:controller.searchBar activate:NO];
    
    //[self.searchDisplayController setActive:NO animated:YES];
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
    [self searchBar:searchBar activate:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    searchBar.text=@"";
    [self searchBar:searchBar activate:NO];
}

- (void)mySegmentedControlAction:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        // NSString *searchNoSpaces = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        self.bMovie = TRUE;
        self.bTVShow = FALSE;
        self.bPeople = FALSE;
        if (firstSearchClicked) {
            self.tableData = pMovies;
            [self.theTableView reloadData];
        }
        
    }
    if (segment.selectedSegmentIndex == 1) {
        
        self.bMovie = FALSE;
        self.bTVShow = TRUE;
        self.bPeople = FALSE;
        if (firstSearchClicked) {
            self.tableData = pTvShows;
            [self.theTableView reloadData];
        }
        
    }
    if (segment.selectedSegmentIndex == 2) {
        
        self.bMovie = FALSE;
        self.bTVShow = FALSE;
        self.bPeople = TRUE;
        if (firstSearchClicked) {
            self.tableData = pPeople;
            [self.theTableView reloadData];
        }
        
    }
}

- (void) loadSearchAsynchroniously
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"ARE YOU THEREeeeeee");
    
    [manager GET:@"www.google.com" parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [self dismissKeyboard];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"No internet connection."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }];
    
}

- (void)refresh {
    UIView *removeView = [self.view viewWithTag:300];
    [removeView removeFromSuperview];
    UIView *removeView2 = [self.view viewWithTag:301];
    [removeView2 removeFromSuperview];
    [self searchBar:theSearchBar activate:YES];
    
}

-(void)threadStartAnimating:(id)data
{
    [spinner startAnimating];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [self dismissKeyboard];
        NetworkError *networkError = [[NetworkError alloc] initWithFrame:CGRectMake(0, 60, 320, 460)];
        networkError.backgroundColor = [UIColor grayColor];
        networkError.tag = 300;
        [self.view addSubview:networkError];
        
        UIButton *refresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [refresh addTarget:self
                    action:@selector(refresh)
          forControlEvents:UIControlEventTouchUpInside];
        [refresh setTitle:@"OK" forState:UIControlStateNormal];
        [refresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        refresh.frame = CGRectMake(80.0, 310.0, 160.0, 40.0);
        refresh.layer.cornerRadius = 4;
        refresh.layer.borderWidth = 1;
        refresh.layer.borderColor = [UIColor blackColor].CGColor;
        refresh.tag = 301;
        [self.view addSubview:refresh];
    } else {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

        NSLog(@"There IS internet connection");
        NSString *searchNoSpaces = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSLog(@"%@",[NSString stringWithFormat:@"%@%@", searchString, searchNoSpaces]);
        /////////////////////movies////////////////
        urlForSearch = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?api_key=c7dbad2bd6e90365dd9a822e201bf107&query=%@", searchNoSpaces];
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlForSearch]];
        NSDictionary* searchResults = [[NSDictionary alloc] init];
        searchResults = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        pMovies = [[searchResults objectForKey:@"results"] mutableCopy];
        //[NSMutableDictionary dictionaryWithDictionary:[searchResults objectForKey:@"results"]];
        
        
        /////////////////////tv shows///////////////
        urlForSearch = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/tv?api_key=c7dbad2bd6e90365dd9a822e201bf107&query=%@", searchNoSpaces];
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlForSearch]];
        searchResults = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        pTvShows = [[searchResults objectForKey:@"results"] mutableCopy];
        
        
        /////////////////////people///////////////
        urlForSearch = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/person?api_key=c7dbad2bd6e90365dd9a822e201bf107&query=%@", searchNoSpaces];
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlForSearch]];
        searchResults = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        pPeople = [[searchResults objectForKey:@"results"] mutableCopy];
        
        [self searchBar:searchBar activate:NO];
        
        [self.tableData removeAllObjects];
        if (!bTVShow && !bPeople) {
            self.tableData = self.pMovies;
        }
        if (!bMovie && !bPeople) {
            self.tableData = self.pTvShows;
        }
        if (!bTVShow && !bMovie) {
            self.tableData = self.pPeople;
        }
        [spinner stopAnimating];
        [self.theTableView reloadData];
        firstSearchClicked = TRUE;
    }
    
}

// We call this when we want to activate/deactivate the UISearchBar
// Depending on active (YES/NO) we disable/enable selection and
// scrolling on the UITableView
// Show/Hide the UISearchBar Cancel button
// Fade the screen In/Out with the disableViewOverlay and
// simple Animations
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active{
    self.theTableView.allowsSelection = !active;
    self.theTableView.scrollEnabled = !active;
    if (!active) {
        [disableViewOverlay removeFromSuperview];
        [searchBar resignFirstResponder];
    } else {
        self.disableViewOverlay.alpha = 0;
        [self.view addSubview:self.disableViewOverlay];
		
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        self.disableViewOverlay.alpha = 0.8;
        [UIView commitAnimations];
    }
    [searchBar setShowsCancelButton:active animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource Methods




-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"HELLOOOOOO: %@", tableData);
    
    if (!bPeople && !bTVShow) {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

        NSNumber *movieID = [[tableData objectAtIndex:indexPath.row] objectForKey:@"id"] ;
        int mID = [movieID intValue];
        NSString * urlMovieInfo = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=casts,trailers", mID];
        NSLog(@"GOT HEREEEEE: DIDSELECTROWFORROWATINDEXPATH: url: %@", urlMovieInfo);
        MovieInfoViewController* movieDetail = [[MovieInfoViewController alloc] initWithNibName:@"MovieInfoViewController" bundle:nil];
        movieDetail.fullInfoURL = urlMovieInfo;
        
        //poster setup
        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w500";
        NSString* posterSuffix = [[tableData objectAtIndex:indexPath.row] objectForKey:@"poster_path"];
        
        if (posterSuffix != [NSNull null]) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]];
            NSData *data1 = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:data1];
            movieDetail.poster = image;
        } else {
            movieDetail.poster = [UIImage imageNamed:@"star2.png"];
            
        }
        [spinner stopAnimating];
        [self.navigationController pushViewController:movieDetail animated:YES];
    }
    
    if (!bMovie && !bPeople) {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

        NSNumber *movieID = [[tableData objectAtIndex:indexPath.row] objectForKey:@"id"] ;
        int mID = [movieID intValue];
        SeasonsViewController* movieDetail = [[SeasonsViewController alloc] initWithNibName:@"SeasonsViewController" bundle:nil];
        movieDetail.fullInfoURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/tv/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107", mID];
        movieDetail.seasonID = mID;
        //poster setup
        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w300";
        NSString* posterSuffix = [[tableData objectAtIndex:indexPath.row] objectForKey:@"poster_path"];
        
        if ([posterSuffix isKindOfClass:[NSNull class]]) {
            movieDetail.poster = [UIImage imageNamed:@"star2.png"];
        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]];
            NSData *data1 = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:data1];
            //[movieDetail.castList addObject:image];
            //[castingList addObject:image];
            movieDetail.poster = image;
        }
        
        
        [spinner stopAnimating];
        [self.navigationController pushViewController:movieDetail animated:YES];
    }
    
    if (!bMovie && !bTVShow) {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

        NSNumber *movieID = [[tableData objectAtIndex:indexPath.row] objectForKey:@"id"] ;
        int mID = [movieID intValue];
        NSString * urlMovieInfo = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=casts,trailers", mID];
        NSLog(@"GOT HEREEEEE: DIDSELECTROWFORROWATINDEXPATH: url: %@", urlMovieInfo);
        BiographyTable* pBioTV = [[BiographyTable alloc] initWithNibName:@"BiographyTable" bundle:nil];
        pBioTV.pBiographyURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/person/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=combined_credits", mID];
        [spinner stopAnimating];
        [self.navigationController pushViewController:pBioTV animated:YES];
    }
    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"SearchResult";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:MyIdentifier];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] ;
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [self colorFromHexString:@"#FF0000"];
        cell.selectedBackgroundView = bgView;
    }
    
    if (!bPeople && !bTVShow) {
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"title"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Release: %@", [[tableData objectAtIndex:indexPath.row] objectForKey:@"release_date"]];
        cell.textLabel.textColor = [self colorFromHexString:@"#FFFFFF"];
        cell.detailTextLabel.textColor = [self colorFromHexString:@"#FFFFFF"];

        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w92";
        NSString* posterSuffix = [[tableData objectAtIndex:indexPath.row] objectForKey:@"poster_path"];
        NSLog(@"Poster Suffix: %@", posterSuffix);
        if (posterSuffix != [NSNull null]) {
            __weak UITableViewCell *weakCell = cell;
            [cell.imageView setImageWithURLRequest:
             [NSURLRequest requestWithURL:
              [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]]
                                  placeholderImage:[UIImage imageNamed:@"movie_list.png"] //loading
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 if (weakCell) {
                     NSLog(@"it worked");
                     
                     weakCell.imageView.image = image;
                     [weakCell setNeedsLayout];
                 }
             }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             {
                 NSLog(@"Error: %@", error);
             }
             ];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"movie_list.png"];
        }
        
        cell.backgroundColor = [self colorFromHexString:@"#FF0000"];
        return cell;
    }
    if (!bMovie && !bPeople) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"name"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Release: %@", [[tableData objectAtIndex:indexPath.row] objectForKey:@"first_air_date"]];
        cell.textLabel.textColor = [self colorFromHexString:@"#FFFFFF"];
        cell.detailTextLabel.textColor = [self colorFromHexString:@"#FFFFFF"];
        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w92";
        NSString* posterSuffix = [[tableData objectAtIndex:indexPath.row] objectForKey:@"poster_path"];
        NSLog(@"Poster Suffix: %@", posterSuffix);
        if (posterSuffix != [NSNull null]) {
            __weak UITableViewCell *weakCell = cell;
            [cell.imageView setImageWithURLRequest:
             [NSURLRequest requestWithURL:
              [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]]
                                  placeholderImage:[UIImage imageNamed:@"tv_list.png"] //loading
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 if (weakCell) {
                     NSLog(@"it worked");
                     
                     weakCell.imageView.image = image;
                     [weakCell setNeedsLayout];
                 }
             }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             {
                 NSLog(@"Error: %@", error);
             }
             ];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"tv_list.png"];
        }
        cell.backgroundColor = [UIColor redColor];
        
        return cell;
    }
    else if (!bMovie && !bTVShow) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"name"]];
        cell.detailTextLabel.text = nil;
        cell.textLabel.textColor = [self colorFromHexString:@"#FFFFFF"];
        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w92";
        NSString* posterSuffix = [[tableData objectAtIndex:indexPath.row] objectForKey:@"profile_path"];
        NSLog(@"Poster Suffix: %@", posterSuffix);
        if (posterSuffix != [NSNull null]) {
            __weak UITableViewCell *weakCell = cell;
            [cell.imageView setImageWithURLRequest:
             [NSURLRequest requestWithURL:
              [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]]
                                  placeholderImage:[UIImage imageNamed:@"star_list.png"] //loading
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 if (weakCell) {
                     NSLog(@"it worked");
                     
                     weakCell.imageView.image = image;
                     [weakCell setNeedsLayout];
                 }
             }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             {
                 NSLog(@"Error: %@", error);
             }
             ];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"star_list.png"];
        }
        cell.backgroundColor = [UIColor redColor];
        
    }        return cell;

    
}

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    //    cell.backgroundColor = [self colorFromHexString:@"00CC66"];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark -
#pragma mark Memory Management Methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {

}

@end

