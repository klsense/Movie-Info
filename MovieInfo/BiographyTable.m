//
//  BiographyTable.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "BiographyTable.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "CustomTVCell.h"
#import "MovieInfoViewController.h"
#import "NetworkError.h"

@interface BiographyTable ()<CustomTVCellDelegate>

@end

@implementation BiographyTable
@synthesize pBiographyArray,
pBiographyTable,
pBiographyURL,
fullInfoDict,
pUtilList,
characterCount,
summaryLabelHeight,
movieArray, movieListNull;

- (void)pushMovieView:(int)num poster:(NSString*)posterString
{
    MovieInfoViewController* pMovieInfoVC = [[MovieInfoViewController alloc] initWithNibName:@"MovieInfoViewController" bundle:nil];
    pMovieInfoVC.fullInfoURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%i?api_key=c7dbad2bd6e90365dd9a822e201bf107&append_to_response=casts,trailers", num];
    //poster setup
    NSString* posterPrefix = @"http://image.tmdb.org/t/p/w500";
    NSString* posterSuffix = posterString;
    
    if ([posterSuffix isKindOfClass:[NSNull class]]) {
        pMovieInfoVC.poster = [UIImage imageNamed:@"movie_list.png"];
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterPrefix, posterSuffix]];
        NSData *data1 = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data1];
        //[movieDetail.castList addObject:image];
        //[castingList addObject:image];
        pMovieInfoVC.poster = image;
    }
    [self.navigationController pushViewController:pMovieInfoVC animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 300;
    else if (indexPath.row == 3)
    {
        if (characterCount < 1000) {
            return summaryLabelHeight;
        } else if (characterCount < 1700) {
            return summaryLabelHeight + 100;
        }
        else return summaryLabelHeight + 150;
    }
    else if (indexPath.row == 4) { if (self.movieListNull) return 40; else return 189;}

    else return 50;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBiographyDetails];
    // Do any additional setup after loading the view from its nib.
    [self.pBiographyTable setSeparatorColor:[self colorFromHexString:@"#999999"]];
    
}


- (void) loadBiographyDetails {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"Biography Info - Load Biography Successful, Link is: %@", pBiographyURL);
    [manager GET:pBiographyURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObjectssss)
     {
         NSLog(@"asynch performed");
         NSLog(@"biography table response object: %@", responseObjectssss);
         self.fullInfoDict = [[NSDictionary alloc] init];
         fullInfoDict = responseObjectssss;
         self.title = [fullInfoDict objectForKey:@"name"];
         self.pUtilList = [[NSMutableArray alloc] init];
         [pUtilList addObject:[fullInfoDict objectForKey:@"profile_path"]];
         [pUtilList addObject:[fullInfoDict objectForKey:@"birthday"]];
         [pUtilList addObject:[fullInfoDict objectForKey:@"place_of_birth"]];
         [pUtilList addObject:[fullInfoDict objectForKey:@"biography"]];
         //         NSDictionary* movieDict = [[NSDictionary alloc] init];
         //         movieDict = [fullInfoDict objectForKey:@"movie_credits"];
         //
         self.movieArray = [[NSMutableArray alloc] init];
         self.movieArray = [[fullInfoDict objectForKey:@"movie_credits"] objectForKey:@"cast"];
         if ([self.movieArray count] == 0) {
             self.movieListNull = YES;
         } else self.movieListNull = NO;
         
         if ([pUtilList objectAtIndex:3] != [NSNull null]){
             characterCount = [[pUtilList objectAtIndex:3] length];
             NSLog(@"Character count: %lu", (unsigned long)characterCount);
             summaryLabelHeight = 0;
             summaryLabelHeight = (characterCount/10)*4 + 50;//3+35;
         } else {
             characterCount = 7;
             summaryLabelHeight = 0;
             summaryLabelHeight = 50;
         }
         
         
         
         [self.pBiographyTable reloadData];
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
    [self loadBiographyDetails];
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = @"";
    if (indexPath.row == 0) {ident = @"pic";}
    if (1 <= indexPath.row <= 3) {ident = @"normal";}
    if (indexPath.row > 3) ident = @"movies";
    
    if (indexPath.row == 4) {
        if (self.movieListNull) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"normal"];
            }
            cell.textLabel.text = @"No available movies";
            cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
            return cell;
        }
        else {
        static NSString *CellIdentifier = @"CustomCell";
        CustomTVCell *cell = (CustomTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CustomTVCell alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
            [cell setDelegate:self];
            cell.isMovie = true;
            
        }
        cell.data = self.movieArray;
        cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
        return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    if (indexPath.row == 0) {
        UIImageView* posterView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 10, 200, 280)];
        __weak UIImageView *weakPosterView = posterView;
        [posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w300%@", [fullInfoDict objectForKey:@"profile_path"]]]] placeholderImage:[UIImage imageNamed:@"star_list.png"] //loading
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakPosterView.image = [self resizeImage:image newSize:CGSizeMake(200, 280)];
                                           //[posterView setNeedsLayout];
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Error: %@", error);
                                   }
         ];
        [cell.contentView addSubview:posterView];
        cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
        return cell;
    }
    
    if (indexPath.row == 1) {
        if ([pUtilList objectAtIndex:1] == [NSNull null]){
            cell.textLabel.text = @"Born: Unknown";
            cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
            return cell;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"Born: %@",[pUtilList objectAtIndex:1]];
        cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
        return cell;
    }
    
    if (indexPath.row == 2) {
        if ([pUtilList objectAtIndex:2] == [NSNull null]){
            cell.textLabel.text = @"Place of birth: Unknown";
            cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
            return cell;
        }
        cell.textLabel.text = [pUtilList objectAtIndex:2];
        cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        if ([pUtilList objectAtIndex:3] == [NSNull null]){
            cell.textLabel.text = @"Unknown";
            return cell;
        }
        [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
        [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[cell textLabel] setFont:[UIFont systemFontOfSize: 14.0]];
        cell.textColor = [UIColor blackColor];
        cell.textLabel.text = [pUtilList objectAtIndex:3];
        cell.backgroundColor = [self colorFromHexString:@"#E6E6E6"];
        
        return cell;
    }
    
    //cell.textLabel.text = [fullInfoDict objectForKey:@"name"];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
