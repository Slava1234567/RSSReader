//
//  ContentParseHTML.h
//  MyRSSReader
//
//  Created by Slava on 7/26/18.
//  Copyright © 2018 Slava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentParseHTML : NSObject <NSCopying>

@property (copy, nonatomic) NSString* mainTitle;
@property (copy, nonatomic) NSArray* elements;

- (id) copyWithZone:(NSZone *)zone;

@end
