//
//  CenterViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/28/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpcomingMoviesViewController.h"
#import "PopularMoviesViewController.h"
#import "listMoviesViewController.h"
#import "LeftPanelViewController.h"
#import "GADBannerView.h"

@class GADBannerView, GADRequest;

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight:(int*)num;
- (void)movePanelToOriginalPosition:(int*)num;

@end

@interface CenterViewController : UIViewController <UITabBarControllerDelegate>{
    
}

@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;

- (IBAction)btnMovePanelRight:(id)sender; //for left

@property (retain, nonatomic) IBOutlet UITabBarController *tabController;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton2;
@property (weak, nonatomic) IBOutlet UIButton *leftButton3;
@property (weak, nonatomic) IBOutlet UIButton *leftButton4;

@end
