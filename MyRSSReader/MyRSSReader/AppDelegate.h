//
//  AppDelegate.h
//  MyRSSReader
//
//  Created by Slava on 7/25/18.
//  Copyright © 2018 Slava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

