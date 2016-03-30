//
//  Popover.h
//  presentingViewController

#import <UIKit/UIKit.h>

@interface PopoverViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *colorArray;
@property (strong, nonatomic) NSString *popText;
@property (strong, nonatomic) UIColor *popBackgroundColor;
@property (strong, nonatomic) UIColor *popTextColor;

@end
