//
//  MovieInfoViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/29/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "MovieInfoViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "VideoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CustomTVCell.h"
#import "BiographyTable.h"
#import "NetworkError.h"


@interface MovieInfoViewController () <CustomTVCellDelegate>

@end

@implementation MovieInfoViewController
@synthesize movieInfoTable; //uitableview
@synthesize fullInfoURL; //nsstring
@synthesize castList; //nsmutablearray
@synthesize poster; //uiimage
@synthesize otherList; //nsmutablearray
@synthesize youTubeLinkNull; //bool
@synthesize characterCount; //nsuinteger
@synthesize summaryLabelHeight; //int
@synthesize summary;
@synthesize textView;
@synthesize movieTitle;
@synthesize castListNull;

- (void)pushBiographyView:(int)num;
{
    BiographyTable* pBioTV = [[BiographyTable alloc] initWithNibName:@"BiographyTable" bundle:nil];
    pBioTV.pBiographyURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/person/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=movie_credits", num];;
    [self.navigationController pushViewController:pBioTV animated:YES];
}

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
    [self.movieInfoTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self loadMovieDetails];
}



- (void) loadMovieDetails {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"Movie Info - Load Movie Details Successful Link is: %@", fullInfoURL);
    NSLog(@"%@", [manager class]);
    [manager GET:fullInfoURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObjectssss)
     {
         NSLog(@"asynch performed");
         NSLog(@"response object: %@", responseObjectssss);
         NSDictionary *fullInfoDict = [NSDictionary new];
         fullInfoDict = responseObjectssss;
         self.movieTitle = [fullInfoDict objectForKey:@"title"];
         
         self.title = [fullInfoDict objectForKey:@"title"];
         NSDictionary* casts = [[NSDictionary alloc] init];
         casts = [fullInfoDict objectForKey:@"casts"];
         self.castList = [[NSMutableArray alloc] init];
         self.castList = [casts objectForKey:@"cast"];
         if ([self.castList count] == 0) {
             self.castListNull = YES;
         } else self.castListNull = NO;
         
         self.otherList = [[NSMutableArray alloc] init];
         [otherList addObject:[fullInfoDict objectForKey:@"runtime"]];
         [otherList addObject:[fullInfoDict objectForKey:@"release_date"]];
         [otherList addObject:[fullInfoDict objectForKey:@"poster_path"]];
         NSDictionary* trailers = [[NSDictionary alloc] init];
         trailers = [fullInfoDict objectForKey:@"trailers"];
         NSArray* youTube = [[NSArray alloc] init];
         youTube = [trailers objectForKey:@"youtube"];
         NSLog(@"youTube array count: %i", [youTube count]);
         int positionOfOverviewForLater = 3;
         if ([youTube count] ==  0){
             NSLog(@"Yes, youtubelinknull");
             self.youTubeLinkNull = YES;
         }
         else
         {
             NSLog(@"No, youtubelinknull");
             youTube = [trailers objectForKey:@"youtube"];
             self.youTubeLinkNull = NO;
             positionOfOverviewForLater = 4;
             [otherList addObject: [[youTube objectAtIndex:0] objectForKey:@"source"]];
         }
         [otherList addObject:[fullInfoDict objectForKey:@"overview"]];
         [otherList addObject:[fullInfoDict objectForKey:@"backdrop_path"]];
         
         if ([otherList objectAtIndex:positionOfOverviewForLater] != [NSNull null]){
             characterCount = [[otherList objectAtIndex:positionOfOverviewForLater] length];
             NSLog(@"Character count: %lu", (unsigned long)characterCount);
             summaryLabelHeight = 0;
             summaryLabelHeight = (characterCount/10)*4 + 50;//3+35;
         } else {
             characterCount = 7;
             summaryLabelHeight = 0;
             summaryLabelHeight = 50;
         }
         [self.movieInfoTable reloadData];
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
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
    [self loadMovieDetails];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = @"";
    if (indexPath.section == 0) {ident = @"backdrop";}
    if (indexPath.section == 1) {ident = @"title";}
    if (indexPath.section == 2) {ident = @"poster";}
    if (indexPath.section == 4) {ident = @"summary";}
    
    if (indexPath.section == 3) {
        //if cast list is empty
        if (self.castListNull) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"title"];
            }
            cell.textLabel.text = @"No available cast";
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"CustomCell";
            CustomTVCell *cell = (CustomTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[CustomTVCell alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
                [cell setDelegate:self];
            }
            cell.data = self.castList;
            cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
            return cell;
        }
    }  //if == pages run above code for special table cell else run the bottom code
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        if ([ident isEqual:@"title"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
        } else if ([ident isEqual:@"poster"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
        } else if ([ident isEqual:@"summary"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
        } else if ([ident isEqual:@"backdrop"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
        }
    }

    if (indexPath.section == 0) {
        UIImageView *backdopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        __weak UIImageView *weakBackDropView = backdopView;
        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w500";
        NSString *posterSuffix = [[NSString alloc] init];
        if (youTubeLinkNull) {
            posterSuffix = [otherList objectAtIndex:4];
            
        }else {
            posterSuffix = [otherList objectAtIndex:5];
            
        }
        
        [backdopView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]] placeholderImage:[UIImage imageNamed:@"missing_movie_trailer.png"] //loading
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
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = self.movieTitle;
    }
    
    if (indexPath.section == 2) {
        cell.imageView.image = poster;
        NSString * run = [[otherList objectAtIndex:0] stringValue];
        cell.textLabel.text = [NSString stringWithFormat:@"Runtime: %@ min", run]; //runtime
        cell.textLabel.textColor = [UIColor blackColor];
        
        NSDate* date = [otherList objectAtIndex:1];
        NSLog(@"%@", date);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Release: %@", date]; //release date
        cell.detailTextLabel.font = [UIFont systemFontOfSize:18.0];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
    }
    if (indexPath.section == 4) {
        
        if (youTubeLinkNull) {
            textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 320, 100)];
            textView.text = [otherList objectAtIndex:3];
            
            [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
            [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
            [[cell textLabel] setFont:[UIFont systemFontOfSize: 14.0]];
            cell.textColor = [UIColor blackColor];
            cell.textLabel.text = [otherList objectAtIndex:3];
            
        } else {
            [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
            [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
            [[cell textLabel] setFont:[UIFont systemFontOfSize: 14.0]];
            cell.textColor = [UIColor blackColor];
            cell.textLabel.text = [otherList objectAtIndex:4];
            
        }
    }

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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (youTubeLinkNull == NO) {
            //VideoViewController *videoViewController = [[[VideoViewController alloc] initWithNibName:nil bundle:nil] retain];
            VideoViewController *videoViewController = [[VideoViewController alloc] initWithNibName:nil bundle:nil];
            
            videoViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            NSString* urlString = [otherList objectAtIndex:3];
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
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }
    if (indexPath.section == 3) {
        if (castListNull) return 40; else return 180;
    }
    if (indexPath.section == 2) {
        return 130;
    } else if (indexPath.section == 4) {
        return summaryLabelHeight;
        NSString * text = @"Your very long text";
        CGSize textSize = [summary sizeWithFont:[UIFont systemFontOfSize: 14.0] forWidth:[tableView frame].size.width - 40.0 lineBreakMode:UILineBreakModeWordWrap];
        // return either default height or height to fit the text
        return textSize.height < 44.0 ? 44.0 : textSize.height;
    }
    else return 40;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 3) {return @"Cast";}
    if (section == 4) {return @"OverView";}
    else return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
