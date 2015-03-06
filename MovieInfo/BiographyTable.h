//
//  BiographyTable.h
//  MovieInfo
//
//  Created by Pat Law on 7/30/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiographyTable : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *pBiographyTable;
    NSArray *pBiographyArray;
    
}

@property (nonatomic,retain) IBOutlet UITableView *pBiographyTable;
@property (nonatomic,strong) NSArray *pBiographyArray;
@property (nonatomic, retain) NSString* pBiographyURL;
@property (nonatomic, retain) NSDictionary* fullInfoDict;
@property (nonatomic, retain) NSMutableArray* pUtilList;
@property (nonatomic, assign) NSUInteger characterCount;
@property (nonatomic, assign) int summaryLabelHeight;
@property (nonatomic, retain) NSMutableArray* movieArray;
@property (nonatomic, assign) BOOL movieListNull;

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;

@end
