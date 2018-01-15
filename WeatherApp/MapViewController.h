//
//  MapViewController.h
//  Weather application
//
//  Created by Danil Kleshchin on 28.11.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WeekInfo.h"
#import "City+CoreDataClass.h"

@interface MapViewController : UIViewController
{
    UIButton* myButton;
    NSMutableArray *pinArray;
}
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *cityIdArray;
@property (nonatomic, strong) NSMutableArray *latArray;
@property (nonatomic, strong) NSMutableArray *lonArray;
@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, strong) NSMutableArray *subtitleArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) MKPointAnnotation *mapPin;
@property (nonatomic, strong) NSString *titleOfAnn;
@property (nonatomic, strong) NSString *subtitleOfAnn;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *icon;
@end
