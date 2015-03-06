//
//  VideoViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/29/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoViewController : UIViewController {
    
    IBOutlet UIWebView *videoView;
    NSString *videoURL;
    NSString *videoHTML;
    
}

@property(nonatomic, retain) IBOutlet UIWebView *videoView;
@property(nonatomic, retain) NSString *videoURL;
@property(nonatomic, retain) NSString *videoHTML;


- (void) embedYouTube;
- (IBAction) closeModal;

@end