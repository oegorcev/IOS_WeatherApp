//
//  AppDelegate.h
//  WeatherApp
//
//  Created by Danil Kleshchin on 10.12.16.
//  Copyright © 2016 DaO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;


@property (strong) NSManagedObjectContext *managedObjectContext;

- (void)initializeCoreData;
- (void)saveContext;

@end
