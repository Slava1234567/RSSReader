//
//  HandlerViewController.m
//  MyRSSReader
//
//  Created by Slava on 7/25/18.
//  Copyright © 2018 Slava. All rights reserved.
//

#import "HandlerViewController.h"
#import "HTMLParse.h"
#import "ContentParseHTML.h"
#import "ElementParse.h"
#import "ChannelViewController.h"

static NSString* const identifier = @"identifier";

@interface HandlerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) HTMLParse* parse;
@property(copy, nonatomic) NSArray* arrayContextHTMLParse;
@end

@implementation HandlerViewController

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

    }
    return _tableView;
}

//MARK: - funcs

- (void) addUITableViewWithConstant {
    
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* top = [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    NSLayoutConstraint* bottom = [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    NSLayoutConstraint* leading = [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint* trailing = [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[top,bottom,leading,trailing]];
}

//MARK: - LifeCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     [self addUITableViewWithConstant];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.parse = [[HTMLParse alloc] init];
    [self.parse addObserver:self forKeyPath:@"contentForXMLParse" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//MARK: - UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  [self.arrayContextHTMLParse count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ContentParseHTML* context = self.arrayContextHTMLParse[section];
    NSArray* elements = context.elements;
    
    return  [elements count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    ContentParseHTML* context = self.arrayContextHTMLParse[indexPath.section];
    ElementParse* element = context.elements[indexPath.row];
    
    cell.textLabel.text = element.title;
    cell.detailTextLabel.text = element.url;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    ContentParseHTML* content = self.arrayContextHTMLParse[section];
    return content.mainTitle;
}

//MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    ChannelViewController* vc = [[ChannelViewController alloc] init];
    ContentParseHTML* content = self.arrayContextHTMLParse[indexPath.section];
    ElementParse* element = content.elements[indexPath.row];
    vc.title = content.mainTitle;
    vc.titleHeader = [NSString stringWithString:element.title];
    vc.url = [NSString stringWithString:element.url];
    
    [self.navigationController pushViewController:vc animated:true];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [self.parse removeObserver:self forKeyPath:@"contentForXMLParse"];
    self.arrayContextHTMLParse = [NSArray arrayWithArray:self.parse.contentForXMLParse];
    
    [self.tableView reloadData];
}


@end









