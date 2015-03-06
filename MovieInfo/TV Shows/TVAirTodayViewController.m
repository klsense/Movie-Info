//
//  TVAirTodayViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "TVAirTodayViewController.h"
#import "SeasonsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "appID.h"
#import "NetworkError.h"

@interface TVAirTodayViewController ()

@end

@implementation TVAirTodayViewController
@synthesize spinner;
@synthesize bannerView = bannerView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Airs Today";
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    
    self.pAirTodayArray = [[NSMutableArray alloc] init];
    
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
    
    [self loadAirTodayAsynchroniously];
    [self.mainTableView setSeparatorColor:[self colorFromHexString:@"#999999"]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    NSNumber *movieID = [[_pAirTodayArray objectAtIndex:indexPath.row] objectForKey:@"id"] ;
    int mID = [movieID intValue];
    SeasonsViewController* movieDetail = [[SeasonsViewController alloc] initWithNibName:@"SeasonsViewController" bundle:nil];
    movieDetail.fullInfoURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/tv/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=trailers", mID];
    movieDetail.seasonID = mID;
    //poster setup
    NSString* posterPrefix = @"http://image.tmdb.org/t/p/w300";
    NSString* posterSuffix = [[_pAirTodayArray objectAtIndex:indexPath.row] objectForKey:@"backdrop_path"];
    
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
    //[movieDetail release];
    
    
}

-(void)threadStartAnimating:(id)data
{
    [spinner startAnimating];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Main Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Main Cell"];
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [self colorFromHexString:@"#00CC66"];
        cell.selectedBackgroundView = bgView;
    }
    cell.textLabel.text = [[_pAirTodayArray objectAtIndex:indexPath.row] objectForKey:@"original_name"];
    cell.textLabel.textColor = [self colorFromHexString:@"#FFFFFF"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Release: %@", [[_pAirTodayArray objectAtIndex:indexPath.row] objectForKey:@"first_air_date"]];
    cell.detailTextLabel.textColor = [self colorFromHexString:@"595959"];
    
    //poster
    NSString* posterPrefix = @"http://image.tmdb.org/t/p/w92";
    NSString* posterSuffix = [[_pAirTodayArray objectAtIndex:indexPath.row] objectForKey:@"poster_path"];
    
    __weak UITableViewCell *weakCell = cell;
    if ([posterSuffix isKindOfClass:[NSNull class]]) {
        cell.imageView.image = [UIImage imageNamed:@"star2.png"];
    }
    else {
        [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]] placeholderImage:[UIImage imageNamed:@"tv_list.png"] //loading
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           if (weakCell) {
                                               NSLog(@"it worked");
                                               
                                               weakCell.imageView.image = image;
                                               [weakCell setNeedsLayout];
                                           }
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"Error: %@", error);
                                           weakCell.imageView.image = [UIImage imageNamed:@"star2.png"];
                                           [weakCell setNeedsLayout];
                                       }
         ];
    }
    cell.backgroundColor = [self colorFromHexString:@"#00CC66"];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int count = [_pAirTodayArray count];
    return [_pAirTodayArray count];
}


- (void)loadAirTodayAsynchroniously
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"ARE YOU THEREeeeeee");
    //@"http://api.themoviedb.org/3/tv/on_the_air?api_key=c7dbad2bd6e90365dd9a822e201bf107"
    
    
    [manager GET:@"http://api.themoviedb.org/3/tv/on_the_air?api_key=c7dbad2bd6e90365dd9a822e201bf107" parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //NSLog(@"upcoming response object: %@", responseObject);
             _pAirTodayArray = [responseObject objectForKey:@"results"];
             //NSLog(@"now playing movies array response object: %@", nowPlayingMoviesArray);
             NSLog(@"asynch performed");
             
             [self.mainTableView reloadData];
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
    [self loadAirTodayAsynchroniously];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
