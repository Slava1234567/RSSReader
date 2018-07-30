//
//  DownloadTaskWithData.h
//  MyRSSReader
//
//  Created by Slava on 7/27/18.
//  Copyright © 2018 Slava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadTaskWithData : NSObject

@property (strong, nonatomic) NSURLSessionDownloadTask* downloadTask;
@property (strong, nonatomic) NSData* data;


@end
