//
//  LeftPanelViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/29/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "GenreViewController.h"
#import "MainViewController.h"

@interface LeftPanelViewController ()

@property (nonatomic, weak) IBOutlet UITableView *myTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;

@end

@implementation LeftPanelViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.myTableView.backgroundColor = [UIColor lightGrayColor];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark UITableView Datasource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Main Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Main Cell"];
    }
    cell.textLabel.textAlignment = UITextAlignmentRight;
    cell.backgroundColor = [UIColor lightGrayColor];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"movie_outer.png"];
        cell.textLabel.text = @"Movies";
    }
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"genre_outer.png"];
        
        cell.textLabel.text = @"Genre";
    }
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"people_outer.png"];
        
        cell.textLabel.text = @"TV Shows";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.delegate1 pushNewView:1];
    }
    if (indexPath.row == 1) {
        [self.delegate1 pushNewView:2];
    }
    if (indexPath.row == 2) {
        [self.delegate1 pushNewView:3];
    }
}


#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
