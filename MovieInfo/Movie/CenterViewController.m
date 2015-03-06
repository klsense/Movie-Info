//
//  CenterViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/28/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//


#import "CenterViewController.h"


@interface CenterViewController ()

@end

@implementation CenterViewController
@synthesize tabController;//segmentedControl;

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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return NO;
    
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
#pragma mark Button Actions
//for left
- (IBAction)btnMovePanelRight:(id)sender {
    NSLog(@"hello");
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition:1];
            break;
        }
        case 1: {
            [_delegate movePanelRight:1];
            break;
        }
        default:
            break;
    }
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
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self setUpTableView];
}




- (void)setUpTableView
{
    self.tabController.delegate = self;
    [self.view addSubview: self.tabController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
