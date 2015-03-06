//
//  NetworkError.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import "NetworkError.h"

@implementation NetworkError
@synthesize networkError;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.networkError = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network.png"]];
        networkError.frame = CGRectMake(0, 50, 320, 160);
        [self addSubview:networkError];
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
