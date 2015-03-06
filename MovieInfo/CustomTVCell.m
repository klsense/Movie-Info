//
//  CustomTVCell.m
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

//
//  CustomTVCell.m
//  TWTSideMenuViewController-Sample
//
//  Created by Pat Law on 4/23/14.
//  Copyright (c) 2014 Two Toasters. All rights reserved.
//

#import "CustomTVCell.h"
#import "UIImageView+AFNetworking.h"
#import "ArticleCell.h"
#import "BiographyTable.h"

@implementation CustomTVCell
@synthesize tableViewInsideCell;
@synthesize data;
@synthesize navigationController;
@synthesize isMovie;


-(NSString *) reuseIdentifier
{
    return @"Cell";
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.tableViewInsideCell = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        self.tableViewInsideCell.showsVerticalScrollIndicator = NO;
        self.tableViewInsideCell.showsHorizontalScrollIndicator = NO;
        self.tableViewInsideCell.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self.tableViewInsideCell setFrame:CGRectMake(0,0,320,180)];
        
        self.tableViewInsideCell.rowHeight = 300;
        self.tableViewInsideCell.backgroundColor = [UIColor clearColor];
        
        self.tableViewInsideCell.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableViewInsideCell.separatorColor = [UIColor clearColor];
        
        self.tableViewInsideCell.dataSource = self;
        self.tableViewInsideCell.delegate = self;
        [self addSubview:self.tableViewInsideCell];
    }
    
    return self;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [data count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ArticleCell";
    __block ArticleCell *cell = (ArticleCell*)[self.tableViewInsideCell dequeueReusableCellWithIdentifier:CellIdentifier];
    if (isMovie) {
        if (cell == nil) {
            cell = [[ArticleCell alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
            
        }
        
        __weak ArticleCell *weakCell = cell;
        [cell.thumbnail setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w150%@", [[data objectAtIndex:indexPath.row] objectForKey:@"poster_path"]]]]
                              placeholderImage:[UIImage imageNamed:@"movie_list2.png"] //loading
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               [weakCell.thumbnail setImage:[self resizeImage:image newSize:CGSizeMake(92, 122)]];
                                           
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"Error: %@", error);
                                            //[cell.thumbnail setImage:[self resizeImage:[UIImage imageNamed:@"movie_list2"] newSize:CGSizeMake(92, 122)]];
                                       }
         ];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ \n%@", [[data objectAtIndex:indexPath.row] objectForKey:@"title"],[[data objectAtIndex:indexPath.row] objectForKey:@"release_date"]];
        cell.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.titleLabel.textAlignment = UITextAlignmentCenter;
        //    cell.textLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
    }
    else {
        if (cell == nil) {
            cell = [[ArticleCell alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
            
        }
        
        __weak ArticleCell *weakCell = cell;
        [cell.thumbnail setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w150%@", [[data objectAtIndex:indexPath.row] objectForKey:@"profile_path"]]]]
                              placeholderImage:[UIImage imageNamed:@"star_list.png"] //loading
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               NSLog(@"Async - Now Playing - Image");
                                               [weakCell.thumbnail setImage:[self resizeImage:image newSize:CGSizeMake(92, 122)]];
                                           
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"Error: %@", error);
                                       }
         ];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ \n%@", [[data objectAtIndex:indexPath.row] objectForKey:@"name"],[[data objectAtIndex:indexPath.row] objectForKey:@"character"]];
        cell.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.titleLabel.textAlignment = UITextAlignmentCenter;
        //    cell.textLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
    }
    
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isMovie) {
        NSNumber *pMovieID = [[data objectAtIndex:indexPath.row] objectForKey:@"id"];
        int mID = [pMovieID intValue];
        [_delegate pushMovieView:mID poster:[[data objectAtIndex:indexPath.row] objectForKey:@"poster_path"]];
    } else {
        NSNumber *pBioID = [[data objectAtIndex:indexPath.row] objectForKey:@"id"] ;
        int mID = [pBioID intValue];
        [_delegate pushBiographyView:mID];
    }
}

#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


@end
