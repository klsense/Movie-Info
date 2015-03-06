//
//  MainViewController.m
//  MovieInfo
//
//  Created by Pat Law on 7/28/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//


#import "MainViewController.h"
#import "CenterViewController.h"
#import "LeftPanelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GenreViewController.h"
#import "TVShowViewController.h"

#define SLIDE_TIMING .25
#define PANEL_WIDTH 80 //100
#define CORNER_RADIUS 4
#define LEFT_PANEL_TAG 2
#define CENTER_TAG 1
#define GENRE_TAG 3
#define TVSHOW_TAG 5

@interface MainViewController () <UIGestureRecognizerDelegate,CenterViewControllerDelegate,GenreViewControllerDelegate,LeftPanelViewControllerDelegate,TVShowViewControllerDelegate>

@property (nonatomic, strong) CenterViewController *centerViewController;


@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic, strong) LeftPanelViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, strong) GenreViewController *pGenreViewController;
@property (nonatomic, assign) BOOL showingGenrePanel;
@property (nonatomic, strong) TVShowViewController *pTvShowVC;

@end

@implementation MainViewController


#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
    }
    
    [self setupView];
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

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

#pragma mark -
#pragma mark Setup View

- (void)setupView
{
    self.centerViewController = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:_centerViewController];
    [_centerViewController didMoveToParentViewController:self];
    
    self.pGenreViewController = [[GenreViewController alloc] initWithNibName:@"GenreViewController" bundle:nil];
    self.pGenreViewController.view.tag = GENRE_TAG;
    [_pGenreViewController setDelegate:self];
    
    self.pTvShowVC = [[TVShowViewController alloc] initWithNibName:@"TVShowViewController" bundle:nil];
    self.pTvShowVC.view.tag = TVSHOW_TAG;
    [_pTvShowVC setDelegate:self];
    
    [self setupGestures];
    
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
    {
        [_centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerViewController.view.layer setShadowOpacity:0.8];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        [_centerViewController.view.layer setShadowPath: [UIBezierPath bezierPathWithRect:_centerViewController.view.bounds].CGPath];
        [_centerViewController.view.layer setDrawsAsynchronously:YES];
        
    }
    else
    {
        [_centerViewController.view.layer setCornerRadius:0.0f];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        [_centerViewController.view.layer setShadowPath: [UIBezierPath bezierPathWithRect:_centerViewController.view.bounds].CGPath];
        [_centerViewController.view.layer setDrawsAsynchronously:YES];
    }
    
}

- (void)resetMainView
{
    
    // remove left view and reset variables, if needed
    if (_leftPanelViewController != nil)
    {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        
        _centerViewController.leftButton.tag = 1;
        _centerViewController.leftButton2.tag = 1;
        _centerViewController.leftButton3.tag = 1;
        _centerViewController.leftButton4.tag = 1;
        _pGenreViewController.openButton.tag = 1;
        _pTvShowVC.leftButton.tag = 1;
        _pTvShowVC.leftButton2.tag = 1;
        _pTvShowVC.leftButton3.tag = 1;
        _pTvShowVC.leftButton4.tag = 1;
        
        self.showingLeftPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

// checks if initialized, then pushes movie view, genre view, or tv show view
- (void)pushNewView:(int*)num
{
    if (num == 1) {
        [self movePanelToOriginalPosition:1];
        for (UIView *subview in self.view.subviews) {
            NSLog(@"subviews in uiview: %@",subview);
            if (subview.tag == GENRE_TAG || subview.tag == TVSHOW_TAG) {
                [subview removeFromSuperview];
            }
        }
        [self.view addSubview:_centerViewController.view];
    }
    if (num == 2) {
        if (_pGenreViewController == nil) {
            self.pGenreViewController = [[GenreViewController alloc] initWithNibName:@"GenreViewController" bundle:nil];
            self.pGenreViewController.view.tag = GENRE_TAG;
            [_pGenreViewController setDelegate:self];
            [self setupGestures];
            [self movePanelToOriginalPosition:2];
            for (UIView *subview in self.view.subviews) {
                NSLog(@"subviews in uiview: %@",subview);
                if (subview.tag == CENTER_TAG || subview.tag == TVSHOW_TAG) {
                    [subview removeFromSuperview];
                }
            }
            [self.view addSubview:_pGenreViewController.view];
        }
        else if (_pGenreViewController != nil) {
            [self movePanelToOriginalPosition:2];
            for (UIView *subview in self.view.subviews) {
                NSLog(@"subviews in uiview: %@",subview);
                if (subview.tag == CENTER_TAG || subview.tag == TVSHOW_TAG) {
                    [subview removeFromSuperview];
                }
            }
            [self.view addSubview:_pGenreViewController.view];
        }
    }
    if (num == 3) {
        if (_pTvShowVC == nil) {
            self.pTvShowVC = [[TVShowViewController alloc] initWithNibName:@"TVShowViewController" bundle:nil];
            self.pTvShowVC.view.tag = TVSHOW_TAG;
            [_pTvShowVC setDelegate:self];
            [self setupGestures];
            [self movePanelToOriginalPosition:3];
            for (UIView *subview in self.view.subviews) {
                NSLog(@"subviews in uiview: %@",subview);
                if (subview.tag == CENTER_TAG || subview.tag == GENRE_TAG) {
                    [subview removeFromSuperview];
                }
            }
            [self.view addSubview:_pTvShowVC.view];
        }
        else if (_pTvShowVC != nil) {
            [self movePanelToOriginalPosition:3];
            for (UIView *subview in self.view.subviews) {
                NSLog(@"subviews in uiview: %@",subview);
                if (subview.tag == CENTER_TAG || subview.tag == GENRE_TAG) {
                    [subview removeFromSuperview];
                }
            }
            [self.view addSubview:_pTvShowVC.view];
            
        }
    }
    
}


- (UIView *)getLeftView
{
    // init view if it doesn't already exist
    if (_leftPanelViewController == nil)
    {
        // this is where you define the view for the left panel
        self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate1 = self;
        
        [self.view addSubview:self.leftPanelViewController.view];
        
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        NSLog(@"Width: %f, Height: %f", self.view.frame.size.width, self.view.frame.size.height);

    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftPanelViewController.view;
    return view;
}

- (UIView *)getLeftViewGenre
{
    // init view if it doesn't already exist
    if (_leftPanelViewController == nil)
    {
        // this is where you define the view for the left panel
        self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate1 = self;
        
        [self.view addSubview:self.leftPanelViewController.view];
        
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if (_leftPanelViewController) {
        self.leftPanelViewController.delegate1 = self;
    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftPanelViewController.view;
    return view;
}

- (void)movePanelRight:(int *)num // to show left panel
{

    
    if (num == 1) {
        UIView *childView = [self getLeftView];
        [self.view sendSubviewToBack:childView];
        

        
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                             NSLog(@"Width: %f, Height: %f", self.view.frame.size.width, self.view.frame.size.height);
                             

                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 _centerViewController.leftButton.tag = 0;
                                 _centerViewController.leftButton3.tag = 0;
                                 
                                 _centerViewController.leftButton2.tag = 0;
                                 _centerViewController.leftButton4.tag = 0;
                                 
                             }
                         }];
    }
    if (num == 2) {
        //        UIView *childView = [self getLeftViewGenre];
        UIView *childView = [self getLeftView];
        
        [self.view sendSubviewToBack:childView];
        

        
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _pGenreViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 _pGenreViewController.openButton.tag = 0;
                             }
                         }];
    }
    if (num == 3) {
        //        UIView *childView = [self getLeftViewGenre];
        UIView *childView = [self getLeftView];
        
        [self.view sendSubviewToBack:childView];
        
        
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _pTvShowVC.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 _pTvShowVC.leftButton.tag = 0;
                                 _pTvShowVC.leftButton2.tag = 0;
                                 _pTvShowVC.leftButton3.tag = 0;
                                 _pTvShowVC.leftButton4.tag = 0;
                                 
                             }
                         }];
    }
    
}


#pragma mark - setup

- (void)setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_centerViewController.view addGestureRecognizer:panRecognizer];
    
    UIPanGestureRecognizer *panRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer1 setMinimumNumberOfTouches:1];
    [panRecognizer1 setMaximumNumberOfTouches:1];
    [panRecognizer1 setDelegate:self];
    [_pTvShowVC.view addGestureRecognizer:panRecognizer1];
    
    UIPanGestureRecognizer *panRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer2 setMinimumNumberOfTouches:1];
    [panRecognizer2 setMaximumNumberOfTouches:1];
    [panRecognizer2 setDelegate:self];
    [_pGenreViewController.view addGestureRecognizer:panRecognizer2];
    
}

-(void)movePanel:(id)sender
{
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        
        if(velocity.x > 0) {
            if (!_showingLeftPanel) {
                childView = [self getLeftView];
            }
        }
        
        // Make sure the view you're working with is front and center.
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if(velocity.x > 0) {
            NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
            
        }
        
        if (velocity.x < 0) {
            [self movePanelToOriginalPosition:1];
            [self movePanelToOriginalPosition:2];
            [self movePanelToOriginalPosition:3];
        }
        if (velocity.x > 0) {
            [self movePanelRight:1];
            [self movePanelRight:2];
            [self movePanelRight:3];
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
            //            if(_centerViewController.view.frame.origin.x == 0){
            //                return;
            //            }
        }
        
        // Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
        _showPanel = abs([sender view].center.x - _centerViewController.view.frame.size.width/2) > _centerViewController.view.frame.size.width/2;
        
        // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
        //        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        //        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        CGPoint newCenter = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        if(newCenter.x >= 160 && newCenter.x <= 400){
            [sender view].center = newCenter;
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointZero inView:self.view];
        }
        
        // If you needed to check for a change in direction, you could use this code to do so.
        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
            // NSLog(@"same direction");
        } else {
            // NSLog(@"opposite direction");
        }
        
        _preVelocity = velocity;
    }
}

#pragma mark - Delegate Actions



- (void)movePanelToOriginalPosition:(int *)num
{
    if (num == 1) {
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 [self resetMainView];
                             }
                         }];
    }
    if (num == 2) {
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _pGenreViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 [self resetMainView];
                             }
                         }];
    }
    if (num == 3) {
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _pTvShowVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 [self resetMainView];
                             }
                         }];
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
