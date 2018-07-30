//
//  ContentParseHTML.m
//  MyRSSReader
//
//  Created by Slava on 7/26/18.
//  Copyright © 2018 Slava. All rights reserved.
//

#import "ContentParseHTML.h"

@implementation ContentParseHTML

- (instancetype)init
{
    self = [super init];
    if (self) {
        _elements = [NSArray array];
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    ContentParseHTML* copy = [[ContentParseHTML allocWithZone:zone] init];
    copy.mainTitle = self.mainTitle;
    copy.elements = self.elements;
    
    return  copy;
}

@end
