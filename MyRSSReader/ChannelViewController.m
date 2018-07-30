//
//  ChannelViewController.m
//  MyRSSReader
//
//  Created by Slava on 7/27/18.
//  Copyright © 2018 Slava. All rights reserved.
//

#import "ChannelViewController.h"
#import "DownloadTaskWithData.h"

static NSString* const identifier1 = @"identifier1";

@interface ChannelViewController () <UITableViewDelegate, UITableViewDataSource,NSXMLParserDelegate,NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (strong,nonatomic) NSXMLParser* parser;
@property (strong,nonatomic) NSMutableArray* fields;
@property (strong, nonatomic) NSMutableDictionary* item;
@property (strong, nonatomic) NSMutableString* titleC;
@property (strong, nonatomic) NSMutableString* linkC;
@property (strong,nonatomic) NSMutableString* enclosureC;
@property (strong, nonatomic) NSMutableString* pubDateC;
@property (copy, nonatomic) NSString* element;
@property (strong, nonatomic) NSMutableDictionary* pathItem;

@property (strong, nonatomic) NSURLSession* session;
@property (strong, nonatomic) NSMutableArray* arrayDownloadTask;

@end

@implementation ChannelViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _arrayDownloadTask = [[NSMutableArray alloc] init];
        _fields = [[NSMutableArray alloc] init];
        _pathItem = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//MARK: - Getters

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (NSURLSession*)session {
    if (!_session) {
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

//MARK: - Funcs

- (void) addUITableViewWithConstrant {
    
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* top = [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    NSLayoutConstraint* bottom = [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    NSLayoutConstraint* leading = [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint* trailing = [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[top,bottom,leading,trailing]];
}

- (void) resumeNextDownload:(NSIndexPath*) indexPath {
    
    if (indexPath.row >= 12) {
        NSInteger index = indexPath.row + 4;
        if (!(index >= [self.fields count])) {
        if ([self.arrayDownloadTask count] == (index - 1)) {
            DownloadTaskWithData* task = [[DownloadTaskWithData alloc] init];
            NSString* nameUrl = [self.fields[index] objectForKey:@"url"];
            NSURL* url = [NSURL URLWithString:nameUrl];
            task.downloadTask = [self.session downloadTaskWithURL:url];
            [task.downloadTask resume];
            [self.arrayDownloadTask addObject:task];
        }
//        DownloadTaskWithData* task = self.arrayDownloadTask[index];
//        if ( task.downloadTask.state == NSURLSessionTaskStateSuspended ) {
//            [task.downloadTask resume];
//        }
        }
    }
}


- (void) addDownloadTaskInArray {
    if ([self.arrayDownloadTask count] == 0) {
        for (int i = 0; i < 16; i++ ) {
            DownloadTaskWithData* task = [[DownloadTaskWithData alloc] init];
            NSString* nameUrl = [self.fields[i] objectForKey:@"url"];
            NSURL* url = [NSURL URLWithString:nameUrl];
            task.downloadTask = [self.session downloadTaskWithURL:url];
            [task.downloadTask resume];
            [self.arrayDownloadTask addObject:task];
        }
  
//    for (int i = 0; i < [self.fields count]; i++) {
//        DownloadTaskWithData* task = [[DownloadTaskWithData alloc] init];
//        NSString* nameUrl = [self.fields[i] objectForKey:@"url"];
//        NSURL* url = [NSURL URLWithString:nameUrl];
//        task.downloadTask = [self.session downloadTaskWithURL:url];
//        task.data = [[NSData alloc] init];
//        if (i < 16) {
//            [task.downloadTask resume];
//        }
//        [self.arrayDownloadTask addObject:task];
    }
  
}

- (void) resumeNextDownloadTask:(NSIndexPath*) indexPath {
    
    NSInteger index = indexPath.row + 15;
    if (index < [self.arrayDownloadTask count]) {
        DownloadTaskWithData* task = self.arrayDownloadTask[index];
        if ( task.downloadTask.state == NSURLSessionTaskStateSuspended ) {
            [task.downloadTask resume];
        }
    }
}

//MARK: - LifiCycleViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUITableViewWithConstrant];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSURL* url = [NSURL URLWithString:self.url];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self.parser setDelegate:self];
    [self.parser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//MARK: - UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleHeader;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.fields count];;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
       
    }
    
    [self resumeNextDownload:indexPath];
    
    cell.textLabel.text = [self.fields[indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [self.fields[indexPath.row] objectForKey:@"pubDate"];
    
    NSString* path = [self.pathItem objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    NSData* data = [NSData dataWithContentsOfFile:path];
    cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}

//MARK: - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80.0;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

   // [self resumeNextDownloadTask:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

//MARK: - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    self.element = elementName;
    
    if ([self.element isEqualToString:@"item"]) {
        
        self.item = [[NSMutableDictionary alloc] init];
        self.titleC = [[NSMutableString alloc] init];
        self.linkC = [[NSMutableString alloc] init];;
        self.enclosureC = [[NSMutableString alloc] init];;
        self.pubDateC = [[NSMutableString alloc] init];;
    }
    
    if ([self.element isEqualToString:@"enclosure"]) {
        NSString* string = [attributeDict objectForKey:@"url"];
        [self.enclosureC appendString: string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        [self.item setObject:self.titleC forKey:@"title"];
        [self.item setObject:self.linkC forKey:@"link"];
        [self.item setObject:self.enclosureC forKey:@"url"];
        [self.item setObject:self.pubDateC forKey:@"pubDate"];
        
        [self.fields addObject:[self.item copy]];
        [self.tableView reloadData];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.element isEqualToString:@"title"]) {
        [self.titleC appendString:string];
    } else if ([self.element isEqualToString:@"link"]) {
        [self.linkC appendString:string];
    } else if ([self.element isEqualToString:@"pubDate"]) {
        [self.pubDateC appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
//    for (int i = 0; i < 15; i++) {
//        NSString* path = self.pathItem[i]
//        if ()
//    }
    
    [self addDownloadTaskInArray];
}

//MARK: - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSInteger index = downloadTask.taskIdentifier - 1;
    NSLog(@"locatin - %@",location);
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* dirDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dirTitleHandler = [dirDoc stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/",self.titleHeader]];
    
    
    
    if (![fileManager fileExistsAtPath:dirTitleHandler]) {
        [fileManager createDirectoryAtPath:dirTitleHandler withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString* dirApp = [dirTitleHandler stringByAppendingPathComponent:[NSString stringWithFormat:@"/Foto@%ld/",(long)index]];
    if (![fileManager fileExistsAtPath:dirApp]) {
        [fileManager createDirectoryAtPath:dirApp withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    dirApp = [dirApp stringByAppendingFormat:@"/%@",[[downloadTask response] suggestedFilename]];
    
    if ([fileManager fileExistsAtPath:dirApp]) {
        [fileManager removeItemAtPath:dirApp error:nil];
    }
    [fileManager moveItemAtPath:[location path] toPath:dirApp error:nil];
 //   [fileManager removeItemAtPath:[location path] error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        DownloadTaskWithData* task = self.arrayDownloadTask[index];
        task.downloadTask = nil;
        
        [self.pathItem setObject:dirApp forKey:[NSString stringWithFormat:@"%ld", (long)index]];
        
        NSIndexPath* indexPath = [[NSIndexPath alloc] init];
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];

    });
}

@end












