//
//  EpisodeInfo.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "EpisodeInfo.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkError.h"
@interface EpisodeInfo ()

@end



@implementation EpisodeInfo
@synthesize dictFullInfo, fullInfoURL, mainTableView, characterCount, summaryLabelHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dictFullInfo = [NSDictionary new];
    [self loadEpisodeDetails];
}

- (void) loadEpisodeDetails {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:fullInfoURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObjectssss)
     {
         NSLog(@"response object: %@", responseObjectssss);
         dictFullInfo = responseObjectssss;
         self.title = [dictFullInfo objectForKey:@"name"];
         characterCount = [[dictFullInfo objectForKey:@"overview"] length];
         summaryLabelHeight = 0;
         summaryLabelHeight = (characterCount/10)*4 + 50;//3+35;
         
         [self.mainTableView reloadData];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
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
    [self loadEpisodeDetails];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        return 181;
    }
    if (indexPath.row == 3) {
        return summaryLabelHeight;
    }
    else return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if cell == posterpath
    //MoviePictureCell* newCell = [tableView dequeueReusableCellWithIdentifier:nil]
    //meaning don't reuse this cell
    //create a cell
    NSString *ident = @"";
    if (indexPath.row == 0) {ident = @"poster";}
    if (1 <= indexPath.row <= 2) {ident = @"normal";}
    if (indexPath.row == 3) {ident = @"summary";}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        if ([ident isEqual:@"normal"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        } else if ([ident isEqual:@"poster"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        } else if ([ident isEqual:@"summary"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
    }
    
    if (indexPath.row == 0) {
        UIImageView *posterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 181)]; //55,10,200,280
        __weak UIImageView *weakPosterView = posterView;
        NSString* posterPrefix = @"http://image.tmdb.org/t/p/w300";
        NSString* posterSuffix = [dictFullInfo objectForKey:@"still_path"];
        
        
        [posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]]] placeholderImage:[UIImage imageNamed:@"missing_tv_trailer.png"] //loading
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakPosterView.image = image;
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Error: %@", error);
                                   }
         ];
        
        [cell.contentView addSubview:posterView];
    }
    if (indexPath.row == 1) {
        //NSNumber *runTim = [otherList objectAtIndex:0];
        NSDate* airDate = [dictFullInfo objectForKey:@"air_date"];
        cell.textLabel.text = [NSString stringWithFormat:@"Air Date: %@", airDate]; //airtime
        cell.textLabel.textColor = [UIColor blueColor];
    }
    if (indexPath.row == 2) {
        NSString* episode = [[dictFullInfo objectForKey:@"episode_number"] stringValue];
        cell.textLabel.text = [NSString stringWithFormat:@"Episode: %@", episode]; //episode number
        cell.textLabel.textColor = [UIColor blueColor];
    }
    if (indexPath.row == 3) {
        
        [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
        [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[cell textLabel] setFont:[UIFont systemFontOfSize: 14.0]];
        cell.textColor = [UIColor blueColor];
        cell.textLabel.text = [dictFullInfo objectForKey:@"overview"];
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
    //    cell.backgroundColor = [self colorFromHexString:@"00CC66"];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
