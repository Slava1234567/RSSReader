//
//  ChannelViewController.h
//  MyRSSReader
//
//  Created by Slava on 7/27/18.
//  Copyright © 2018 Slava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelViewController : UIViewController

@property (strong, nonatomic) UITableView* tableView;
@property (copy, nonatomic) NSString* url;
@property (copy, nonatomic) NSString* titleHeader;

@end
