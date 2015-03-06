//
//  TVShowViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVShowViewControllerDelegate <NSObject>
@optional
- (void)movePanelRight:(int*)num; //for left
@required
- (void)movePanelToOriginalPosition:(int*)num;
@end


@interface TVShowViewController : UIViewController <UITabBarControllerDelegate>

@property (nonatomic, assign) id<TVShowViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITabBarController *tabController;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton2;
@property (weak, nonatomic) IBOutlet UIButton *leftButton3;
@property (weak, nonatomic) IBOutlet UIButton *leftButton4;

@end

