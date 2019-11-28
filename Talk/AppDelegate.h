//
//  AppDelegate.h
//  Talk
//
//  Created by 홍수혁 on 2019/11/28.
//  Copyright © 2019 홍수혁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

