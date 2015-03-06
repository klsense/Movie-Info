//
//  MovieInfoViewController.h
//  MovieInfo
//
//  Created by Pat Law on 7/29/14.
//  Copyright (c) 2014 Patrick Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* movieInfoTable;
}
@property (nonatomic, retain) IBOutlet UITableView* movieInfoTable;
@property (nonatomic, retain) NSString* fullInfoURL;
@property (nonatomic, retain) NSMutableArray* castList;
@property (nonatomic, retain) UIImage* poster;
@property (nonatomic, retain) NSMutableArray* otherList;
@property (nonatomic, assign) BOOL youTubeLinkNull;
@property (nonatomic, assign) NSUInteger characterCount;
@property (nonatomic, assign) int summaryLabelHeight;
@property (nonatomic, copy) NSString* summary;
@property (nonatomic, retain) id customTVCell;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, copy) NSString* movieTitle;
@property (nonatomic, assign) BOOL castListNull;


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;



@end