//
//  EpisodeViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "EpisodeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "EpisodeInfo.h"
#import "NetworkError.h"
@interface EpisodeViewController ()

@end

@implementation EpisodeViewController
@synthesize pEpisodeArray, fullInfoURL, mainTableView, name, season, seasonID, spinner;

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
    self.pEpisodeArray = [[NSMutableArray alloc] init];
    
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 90, 90)];
    spinner.layer.cornerRadius = 5;
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    spinner.opaque = NO;
    spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    
    [self loadEpisodes];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.pEpisodeArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    EpisodeInfo* episodeDetail = [[EpisodeInfo alloc] initWithNibName:@"EpisodeInfo" bundle:nil];
    episodeDetail.fullInfoURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/tv/%i/season/%i/episode/%@?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=videos", seasonID, season, [[self.pEpisodeArray objectAtIndex:indexPath.row] objectForKey:@"episode_number"]];
    [spinner stopAnimating];
    [self.navigationController pushViewController:episodeDetail animated:YES];
    
    
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
        bgView.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
        cell.selectedBackgroundView = bgView;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@. %@",[[self.pEpisodeArray objectAtIndex:indexPath.row] objectForKey:@"episode_number"], [[self.pEpisodeArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    //cell.textLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Release: %@", [[self.pEpisodeArray objectAtIndex:indexPath.row] objectForKey:@"air_date"]];
    
    //poster
    NSString* posterPrefix = @"http://image.tmdb.org/t/p/w92";
    NSString* posterSuffix = [[self.pEpisodeArray objectAtIndex:indexPath.row] objectForKey:@"still_path"];
    
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]] placeholderImage:[UIImage imageNamed:@"tv_list.png"] //loading
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       if (weakCell) {
                                           NSLog(@"it worked");
                                           
                                           weakCell.imageView.image = image;
                                           [weakCell setNeedsLayout];
                                       }
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Error: %@", error);
//                                           weakCell.imageView.image = [UIImage imageNamed:@"tv_list.png"];
//                                           [weakCell setNeedsLayout];
                                   }
     ];
    cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
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

- (void)loadEpisodes
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"ARE YOU THEREeeeeee");
    
    [manager GET:fullInfoURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //NSLog(@"upcoming response object: %@", responseObject);
             self.title = self.name;
             self.pEpisodeArray = [responseObject objectForKey:@"episodes"];
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
    [self loadEpisodes];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

