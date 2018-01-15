//
//  ViewController.h
//  Weather application
//
//  Created by Danil Kleshchin on 27.11.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekInfo.h"
#import "SearchCountry.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Model.h"
#import "City+CoreDataClass.h"
#import "SearchCountry.h"



@interface StartPage : UIViewController <senddataProtocol>
{
    NSMutableArray *cityNameArray;
    NSMutableArray *cityIdArray;
    NSMutableArray *temperatureArray;
    NSMutableArray *descriptionArray;
    NSMutableArray *iconArray;
    NSMutableArray *countryArray;
    NSMutableArray *latArray;
    NSMutableArray *lonArray;
    
    UIBarButtonItem *myBackButton;
    UIBarButtonItem *myAddButton;
    NSNumber *currentLatitude;
    NSNumber *currentLongitude;
    NSNumber *lat;
    NSNumber *lon;
    bool FirstCity;
    
    IBOutlet UITableView * tableView;
}

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *descriptionOfWeather;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Model * model;

@end

