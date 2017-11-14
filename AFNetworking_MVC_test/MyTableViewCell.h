//
//  MyTableViewCell.h
//  AFNetworking_MVC_test
//
//  Created by Derek on 05/11/17.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *producetPic;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productSite;
@property (weak, nonatomic) IBOutlet UILabel *productMadeIn;
@property (weak, nonatomic) IBOutlet UILabel *productPublishTime;

@end
