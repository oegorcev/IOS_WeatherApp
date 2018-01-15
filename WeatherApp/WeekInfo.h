//
//  WeekInfo.h
//  Weather application
//
//  Created by Danil Kleshchin on 05.12.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartPage.h"
#import "City+CoreDataClass.h"

@interface WeekInfo : UIViewController
{
    NSMutableArray* descriptionArray;
    NSMutableArray* descriptionArrayForCoreData;
    NSMutableArray* temperatureArray;
    NSMutableArray* temperatureArrayForCoreData;
    NSMutableArray* dateArray;
    NSMutableArray* dateArrayForCoreData;
    NSMutableArray* iconsArray;
    NSMutableArray* iconsArrayForCoreData;
    __weak IBOutlet UITableView *tableView;
}

@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic, strong) City* city;

@end
