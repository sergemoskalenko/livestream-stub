//
//  MSVVideoTableViewCell.h
//  msv-livestream-stub
//
//  Created by Serge Moskalenko on 21.06.17.
//  Copyright © 2017 Serge Moskalenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSVVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic, readonly) IBOutlet UIImageView *imgView;

@end
