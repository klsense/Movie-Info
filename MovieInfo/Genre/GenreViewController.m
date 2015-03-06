//
//  GenreViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/29/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "GenreViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "GenreList.h"
#import "NetworkError.h"

@interface GenreViewController ()

@end

@implementation GenreViewController
@synthesize pGenreTable, pGenreArray,delegate;

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
    [self setUpTableView];
    self.pGenreNC.visibleViewController.title = @"Genres";
    self.pGenreNC.visibleViewController.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.pGenreNC.visibleViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.pGenreNC.visibleViewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.pGenreNC.visibleViewController.navigationController.navigationBar.translucent = YES;
    
    self.pGenreArray = [[NSArray alloc] init];
    [self loadGenresAsynchroniously];
    [self.pGenreTable setSeparatorColor:[self colorFromHexString:@"#999999"]];
    
    
    
    
}


- (IBAction)openButtonPressed:(id)sender
{
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [delegate movePanelToOriginalPosition:2];
            break;
        }
            
        case 1: {
            [delegate movePanelRight:2];
            break;
        }
            
        default:
            break;
    }
}

- (void)setUpTableView
{
    self.pGenreNC.delegate = self;
    //    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed:)];
    //    openItem.tag = 1;
    //    self.pGenreNC.visibleViewController.navigationItem.leftBarButtonItem = openItem;
    [self.view addSubview:self.pGenreNC.view];
    //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"OPEN" style:UIBarButtonSystemItemDone target:self action:@selector(openButtonPressed:)]];
    
}

-(void) loadGenresAsynchroniously
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://api.themoviedb.org/3/genre/list?api_key=c7dbad2bd6e90365dd9a822e201bf107" parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //NSLog(@"upcoming response object: %@", responseObject);
             pGenreArray = [responseObject objectForKey:@"genres"];
             //NSLog(@"now playing movies array response object: %@", nowPlayingMoviesArray);
             NSLog(@"Asynch - Genre");
             
             [self.pGenreTable reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 NetworkError *networkError = [[NetworkError alloc] initWithFrame:self.pGenreTable.frame];
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
    [self loadGenresAsynchroniously];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [pGenreArray count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Main Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Main Cell"];
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [self colorFromHexString:@"#FF0000"];
        cell.selectedBackgroundView = bgView;
    }
    cell.textLabel.text = [[pGenreArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.textColor = [self colorFromHexString:@"#FFFFFF"];
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
    NSNumber *movieID = [[pGenreArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    int mID = [movieID intValue];
    GenreList *pGenreList = [[GenreList alloc] initWithNibName:@"GenreList" bundle:nil];
    //GenreList *pGenreList = [[GenreList alloc] init];
    pGenreList.sURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/genre/%i/movies?api_key=c7dbad2bd6e90365dd9a822e201bf107", mID];
    pGenreList.title = [[pGenreArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSLog(@"%@",self.navigationController);
    
    //clutch line, was using self.navigationController at first but that was not grabbing the intended NC properly
    [self.pGenreNC.visibleViewController.navigationController pushViewController:pGenreList animated:YES];
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

