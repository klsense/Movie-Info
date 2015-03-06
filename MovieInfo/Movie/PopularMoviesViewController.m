//
//  PopularMoviesViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/28/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "PopularMoviesViewController.h"
#import "MovieInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "appID.h"
#import "NetworkError.h"
@interface PopularMoviesViewController ()

@end

@implementation PopularMoviesViewController

@synthesize popularMoviesTable, popularMoviesArray, dictionaryForMovieInfo, spinner;
@synthesize bannerView = bannerView_;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Popular";
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    
    self.popularMoviesArray = [[NSMutableArray alloc] init];
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 90, 90)];
    spinner.layer.cornerRadius = 5;
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    spinner.opaque = NO;
    spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    self.bannerView.adUnitID = MyAdUnitID;
    self.bannerView.delegate = self;
    [self.bannerView setRootViewController:self];
    //    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
    
    [self loadPopularMoviesAsynchroniously:@"http://api.themoviedb.org/3/movie/popular?api_key=c7dbad2bd6e90365dd9a822e201bf107" ];
    [self.popularMoviesTable setSeparatorColor:[self colorFromHexString:@"#999999"]];
    [spinner stopAnimating];
    
    
}

-(GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    return request;
    
}

-(void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Ad Recieved");
    [UIView animateWithDuration:0.0 animations:^{
        adView.frame = CGRectMake(0.0, 60.0, adView.frame.size.width, adView.frame.size.height);
    }];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to recieve ad due to: %@", [error localizedFailureReason]);
}

- (void) loadPopularMoviesAsynchroniously: (NSString *) jsonUrl {
    NSURL *url = [NSURL URLWithString:@"http://api.themoviedb.org/3/movie/popular?api_key=c7dbad2bd6e90365dd9a822e201bf107"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"ARE YOU THEREeeeeee");
    
    [manager GET:jsonUrl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *fullInfo = [[NSDictionary alloc] init];
             fullInfo = responseObject;
             NSLog(@"asynch performed: %@", fullInfo);
             
             
             //NSLog(@"response object: %@", responseObject);
             popularMoviesArray = [responseObject objectForKey:@"results"];
             //NSLog(@"popular movies array response object: %@", popularMoviesArray);
             
             [self.popularMoviesTable reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);

             dispatch_async(dispatch_get_main_queue(), ^{
                 NetworkError *networkError = [[NetworkError alloc] initWithFrame:CGRectMake(0, 60, 320, 460)];
                 networkError.backgroundColor = [UIColor grayColor];
                 networkError.tag = 300;
                 [self.view addSubview:networkError];
                 
                 UIButton *refresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                 [refresh addTarget:self
                             action:@selector(refresh)
                   forControlEvents:UIControlEventTouchUpInside];
                 [refresh setTitle:@"Refresh" forState:UIControlStateNormal];
                 [refresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 refresh.frame = CGRectMake(80.0, 310.0, 160.0, 40.0);
                 refresh.layer.cornerRadius = 4;
                 refresh.layer.borderWidth = 1;
                 refresh.layer.borderColor = [UIColor blackColor].CGColor;
                 refresh.tag = 301;
                 [self.view addSubview:refresh];
             });
         }];
    
}

-(void)refresh {
    UIView *removeView = [self.view viewWithTag:300];
    UIView *removeView2 = [self.view viewWithTag:301];
    [removeView removeFromSuperview];
    [removeView2 removeFromSuperview];
    [self loadPopularMoviesAsynchroniously:@"http://api.themoviedb.org/3/movie/popular?api_key=c7dbad2bd6e90365dd9a822e201bf107" ];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int count = [popularMoviesArray count];
    NSLog(@"List Count: %i", count);
    return [popularMoviesArray count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Main Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Main Cell"];
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [self colorFromHexString:@"#FF0000"];
        cell.selectedBackgroundView = bgView;
    }
    //NSLog(@"cellforrow: %@", popularMoviesArray);
    
    cell.textLabel.text = [[popularMoviesArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.textColor = [self colorFromHexString:@"#FFFFFF"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Release: %@", [[popularMoviesArray objectAtIndex:indexPath.row] objectForKey:@"release_date"]];
    cell.detailTextLabel.textColor = [self colorFromHexString:@"#B2B2B2"];
    
    //poster
    NSString* posterPrefix = @"http://image.tmdb.org/t/p/w154";
    NSString* posterSuffix = [[popularMoviesArray objectAtIndex:indexPath.row] objectForKey:@"poster_path"];
    __weak UITableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]] placeholderImage:[UIImage imageNamed:@"movie_list.png"] //loading
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       NSLog(@"Async: cell for row image set");
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Error: %@", error);
                                   }
     ];
    
    cell.backgroundColor = [self colorFromHexString:@"#FF0000"];
    return cell;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    NSNumber *movieID = [[popularMoviesArray objectAtIndex:indexPath.row] objectForKey:@"id"] ;
    int mID = [movieID intValue];
    NSString * urlMovieInfo = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=casts,trailers", mID];
    NSLog(@"GOT HEREEEEE: DIDSELECTROWFORROWATINDEXPATH: url: %@", urlMovieInfo);
    NSLog(@"dictionaryForMovieInfo is: %@" , dictionaryForMovieInfo);
    MovieInfoViewController* movieDetail = [[MovieInfoViewController alloc] initWithNibName:@"MovieInfoViewController" bundle:nil];
    movieDetail.fullInfoURL = urlMovieInfo;
    
    //poster setup
    NSString* posterPrefix = @"http://image.tmdb.org/t/p/w300";
    NSString* posterSuffix = [[popularMoviesArray objectAtIndex:indexPath.row] objectForKey:@"poster_path"];
    
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

-(void)threadStartAnimating:(id)data
{
    [spinner startAnimating];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
