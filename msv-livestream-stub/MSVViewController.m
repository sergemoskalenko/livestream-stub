//
//  ViewController.m
//  msv-livestream-stub
//
//  Created by Serge Moskalenko on 21.06.17.
//  Copyright © 2017 Serge Moskalenko. All rights reserved.
//

#import "MSVViewController.h"
#import "MSVTextTableViewCell.h"
#import "MSVLivestreamFeedObject.h"
#import "MSVWaitTableViewCell.h"

@interface MSVViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* items;
@end

@implementation MSVViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getData];    
}

- (void)fetchData {
    NSMutableArray* items = [NSMutableArray new];
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.new.livestream.com/accounts/volvooceanrace/events/leg5"] options:NSDataReadingUncached error:NULL];
    
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    if ([NSJSONSerialization isValidJSONObject:response])
    {
        NSDictionary *feed = response[@"feed"];
        self.items = [NSMutableArray new];
        for (NSDictionary* dic in feed[@"data"]) {
            NSString* type = dic[@"type"];
            if ([type isEqualToString:@"status"]) {
                MSVLivestreamFeedObject* item = [MSVLivestreamFeedObject new];
                item.text = [dic valueForKeyPath:@"data.text"];
                item.date = [dic valueForKeyPath:@"data.updated_at"];
                [items addObject:item];
            }
        }
        _items = items;
    }
}

- (void)getData {
    _items = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self fetchData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 1;
    if (_items)
        count = _items.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identifier = (_items == nil) ? @"waitcell" : @"textcell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (_items == nil) ? [[MSVWaitTableViewCell alloc] init] : [[MSVTextTableViewCell alloc] init];
    }

    if (_items) {
        MSVLivestreamFeedObject* item = _items[indexPath.row];
        ((MSVTextTableViewCell *)cell).text2Label.text = item.text;
        ((MSVTextTableViewCell *)cell).dateLabel.text = item.date;
    }
    
    [cell updateConstraints];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row % 2  == 0)
        cell.contentView.backgroundColor = [UIColor whiteColor];
    else
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
}

@end
