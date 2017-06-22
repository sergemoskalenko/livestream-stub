//
//  MSVImageTableViewCell.h
//  msv-livestream-stub
//
//  Created by Serge Moskalenko on 21.06.17.
//  Copyright © 2017 Serge Moskalenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSVImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
