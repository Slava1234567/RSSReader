//
//  HTMLParse.m
//  MyRSSReader
//
//  Created by Slava on 7/26/18.
//  Copyright © 2018 Slava. All rights reserved.
//

#import "HTMLParse.h"
#import "ElementParse.h"
#import "ContentParseHTML.h"

static NSString* const urlName = @"https://news.tut.by/rss.html";

@interface HTMLParse()

@property (copy, nonatomic) NSString* mainTitle;

-(void) createArray: (NSString*) stringHTML;
- (void) getContentForXMLParse;

@end

@implementation HTMLParse

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getContentForXMLParse];
       
    }
    return self;
}

- (void) getContentForXMLParse {
    
NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
NSURLSession* sesion = [NSURLSession sessionWithConfiguration:defaultConfiguration];
NSURL* url = [NSURL URLWithString:urlName];

[[sesion downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSData* data = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (data != nil) {
            NSString* stringHTML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self createArray:stringHTML];
        }
    });
}] resume];
}

-(void) createArray: (NSString*) stringHTML {
    
    NSMutableArray* arrayForXMLParses = [NSMutableArray array];
    
    
    NSString* nameClassStart = @"lists__li lists__li_head";
    NSString* nameClassEnd = @"main-shd";
                                                                               // get necessary data for work
    NSString* copyStringHTML = [NSString stringWithString:stringHTML];
    NSRange startRange = [copyStringHTML rangeOfString:nameClassStart];
    NSRange endRange = [copyStringHTML rangeOfString:nameClassEnd];
    NSInteger lenght = (endRange.location - startRange.location);
    NSInteger location = (startRange.location + startRange.length );

    NSString* workingText = [copyStringHTML substringWithRange:NSMakeRange(location, lenght)];
    
    NSArray* resultForMainTitles = [workingText componentsSeparatedByString:nameClassStart];
    
    for (NSString* str in resultForMainTitles) {                               // get data for section in UITableView
        
        NSArray* tempForTitle = [str componentsSeparatedByString:@"<a href="];
        NSString* contentForMainTitle = tempForTitle[0];
        NSArray* newTempArray = [contentForMainTitle componentsSeparatedByString:@"<"];
        NSString* newTempTitle = newTempArray[0];
        NSString* title = [newTempTitle substringWithRange:NSMakeRange(2, [newTempTitle length] - 2)];
        
        self.mainTitle = title;
        NSMutableArray* arrayElements = [NSMutableArray array];
        
        NSMutableArray* arrayForTitleAndUrl = [NSMutableArray arrayWithArray:tempForTitle];
        [arrayForTitleAndUrl removeObjectAtIndex:0];
        
        for (NSString* str in arrayForTitleAndUrl) {                             // get data for row in UITAbleView
            
            NSArray* tempTitleAndUrl = [str componentsSeparatedByString:@"<"];
            NSString* tempString = tempTitleAndUrl[0];
            NSArray* newTempArray = [tempString componentsSeparatedByString:@">"];
            NSString* title = newTempArray[1];
            NSString* tempUrl = (NSString*)newTempArray[0];
            NSString* url = [tempUrl substringWithRange:NSMakeRange(1, [tempUrl length] - 2)];
            
            ElementParse* element = [[ElementParse alloc] init];
            element.title = title;
            element.url = url;
            [arrayElements addObject:element];
        }
        ContentParseHTML* context = [[ContentParseHTML alloc] init];
        context.mainTitle = self.mainTitle;
        context.elements = [NSArray arrayWithArray:arrayElements];
        [arrayForXMLParses addObject:context];
    }
    self.contentForXMLParse = [NSArray arrayWithArray:arrayForXMLParses];
}

@end
