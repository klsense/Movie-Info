//
//  LeftPanelViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/29/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Animal;

@protocol LeftPanelViewControllerDelegate <NSObject>

@optional
- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator;
- (void)pushNewView:(int*)num;

@end

@interface LeftPanelViewController : UIViewController

@property (nonatomic, assign) id<LeftPanelViewControllerDelegate> delegate1;

@end