//
//  SeasonsViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "SeasonsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "EpisodeViewController.h"
#import "VideoViewController.h"
#import "NetworkError.h"
@interface SeasonsViewController ()

@end

@implementation SeasonsViewController
@synthesize fullInfoURL,poster,seasonID,name, spinner, fullInfo, otherList, youTubeLinkNull;


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
    self.pSeasonsArray = [[NSMutableArray alloc] init];
    
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
    if (indexPath.row == 0) {
        return 180;
    }
    else return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    //must use indexPath.row+1 because you have extra backdrop added to beginning of table
    if (indexPath.row == 0) {
        if (youTubeLinkNull == NO) {
            //VideoViewController *videoViewController = [[[VideoViewController alloc] initWithNibName:nil bundle:nil] retain];
            VideoViewController *videoViewController = [[VideoViewController alloc] initWithNibName:nil bundle:nil];
            
            videoViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            NSString* urlString = [[otherList objectAtIndex:indexPath.row] objectForKey:@"id"];
            NSString* youTubeURL = [NSString stringWithFormat:@"http://www.youtube.com/embed/%@", urlString];
            NSLog(@"url string ISSSS: %@",youTubeURL);
            
            videoViewController.videoURL = youTubeURL;
            [self presentModalViewController:videoViewController animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No trailer available."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        NSNumber *movieID = [[_pSeasonsArray objectAtIndex:indexPath.row-1] objectForKey:@"season_number"] ;
        int mID = [movieID intValue];
        EpisodeViewController* episodeDetail = [[EpisodeViewController alloc] initWithNibName:@"EpisodeViewController" bundle:nil];
        episodeDetail.fullInfoURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/tv/%i/season/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=videos", seasonID, mID];
        episodeDetail.name = self.name;
        episodeDetail.seasonID = seasonID;
        episodeDetail.season = mID;
        [self.navigationController pushViewController:episodeDetail animated:YES];
        
    }
    
    [spinner stopAnimating];
    
}

-(void)threadStartAnimating:(id)data
{
    [spinner startAnimating];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return 1;
//    } else {
//        int count = [_pSeasonsArray count];
//        NSLog(@"List Count: %i", count);
//        return count+1;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = @"";
    if (indexPath.row == 0) {ident = @"backdrop";}
    else {ident = @"title";}
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"backdrop"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"backdrop"];
        }
        UIImageView *backdopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        __weak UIImageView *weakBackDropView = backdopView;
        
        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w500";
        NSString *posterSuffix = [fullInfo objectForKey:@"backdrop_path"];
        
        [backdopView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]] placeholderImage:[UIImage imageNamed:@"missing_tv_trailer.png"] //loading
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        weakBackDropView.image = image;
                                        [weakBackDropView setNeedsLayout];
                                        
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        NSLog(@"Error: %@", error);

                                    }
         ];
        [cell.contentView addSubview:backdopView];
        UIImageView *playButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        playButton.image = [UIImage imageNamed:@"lights.png"];
        playButton.alpha = 1;
        [cell.contentView addSubview:playButton];
        return cell;
    } else {
        
        //create a cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident]; //@"Main Cell"
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident]; //@"Main Cell"
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"Season %@",[[self.pSeasonsArray objectAtIndex:indexPath.row-1] objectForKey:@"season_number"]];
        //cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Release: %@", [[self.pSeasonsArray objectAtIndex:indexPath.row-1] objectForKey:@"air_date"]];
        
        //poster
        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w92";
        NSString* posterSuffix = [[self.pSeasonsArray objectAtIndex:indexPath.row-1] objectForKey:@"poster_path"];
        
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
                                           //                                               weakCell.imageView.image = [UIImage imageNamed:@"star2.png"];
                                           //                                               [weakCell setNeedsLayout];
                                       }
         ];
        cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
        return cell;
    }
    
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


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int count = [_pSeasonsArray count];
    NSLog(@"List Count: %i", count);
    return count+1;
}

- (void)loadEpisodes
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"ARE YOU THEREeeeeee");
    
    [manager GET:fullInfoURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //NSLog(@"upcoming response object: %@", responseObject);
             fullInfo = [NSDictionary new];
             fullInfo = responseObject;
             self.name = [responseObject objectForKey:@"name"];
             self.title = [responseObject objectForKey:@"name"];
             
             self.pSeasonsArray = [responseObject objectForKey:@"seasons"];
             
             self.otherList = [NSMutableArray new];
             self.otherList = [[responseObject objectForKey:@"videos"] objectForKey:@"results"];
             //NSLog(@"now playing movies array response object: %@", nowPlayingMoviesArray);
             if ([otherList count] == 0) {
                 youTubeLinkNull = YES;
             } else youTubeLinkNull = NO;
             
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
