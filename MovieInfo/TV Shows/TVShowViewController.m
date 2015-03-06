//
//  TVShowViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "TVShowViewController.h"
#import "TVOnAirViewController.h"
#import "AFNetworkReachabilityManager.h"
//#import "AFNetworking/Reachability.h"


@interface TVShowViewController ()

@end

@implementation TVShowViewController
//@synthesize tabController;

- (IBAction)btnMovePanelRight:(id)sender {
    NSLog(@"hello");
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition:3];
            break;
        }
            
        case 1: {
            [_delegate movePanelRight:3];
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
    [self setUpTableView];
}


- (BOOL)connected {
    NSLog(@"REACHABILITY CALLED");
    return [AFNetworkReachabilityManager sharedManager].reachable;
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
