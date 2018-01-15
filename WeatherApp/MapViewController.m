//
//  MapViewController.m
//  Weather application
//
//  Created by Danil Kleshchin on 28.11.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//

#import "MapViewController.h"

static NSString *const MapViewPin = @"MapViewPin";

@interface MapViewController () <MKMapViewDelegate>
{
    NSMutableArray *tempIconArray;
}

@end

@implementation MapViewController

- (void)loadView {
    self.mapView = [[MKMapView alloc] init];
    self.view = self.mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->myButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self->myButton addTarget:self action:@selector(getWeekInfo:) forControlEvents:UIControlEventTouchUpInside];
    self->pinArray = [[NSMutableArray alloc] init];
    self.mapView.delegate = self;
    self.mapPin = [[MKPointAnnotation alloc] init];
    for(int i = 0; i < self.cityIdArray.count; ++i)
    {
        [self setAnnotation:i];
    }
    tempIconArray = [[NSMutableArray alloc] initWithArray:self.iconArray];
}

- (void)setAnnotation:(int)i {
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.title = [NSString stringWithFormat:@"%@° %@", [self.titleArray objectAtIndex:i], [self.cityArray objectAtIndex:i]];
    pin.subtitle = [self.subtitleArray objectAtIndex:i];
    CLLocationCoordinate2D new_coordinate = { [[self.latArray objectAtIndex:i] doubleValue], [[self.lonArray objectAtIndex:i] doubleValue]};
    [pin setCoordinate:new_coordinate];
    [self->pinArray addObject:pin];
    [self.mapView addAnnotation:[self->pinArray objectAtIndex:i]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)getWeekInfo:(id)sender {
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{
    MKPointAnnotation *ann = (MKPointAnnotation *)view.annotation;
    NSString *cityAnn = ann.title;
    
    NSRange city = [cityAnn rangeOfString:@" "];
    NSRange cityrange = NSMakeRange(city.location + 1, ([cityAnn length]) - (city.location + 1));
    NSString *nameString = [cityAnn substringWithRange:cityrange];
    WeekInfo *weekInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"weekInfoID"];
    weekInfo.cityName = nameString;
    long position = 0;
    for (NSString *str in self.cityArray) {
        if ([str isEqualToString:nameString]) break;
        position++;
    }
    weekInfo.cityId = [NSString stringWithFormat:@"%@", [self.cityIdArray objectAtIndex:position]];
    [self.navigationController pushViewController:weekInfo animated:YES];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pin = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:MapViewPin];
    if(!pin)
    {
        pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MapViewPin];
    }
    pin.rightCalloutAccessoryView = self->myButton;
    pin.canShowCallout = YES;
    NSString *str = annotation.title;
    
    NSRange city = [str rangeOfString:@" "];
    NSRange cityrange = NSMakeRange(city.location + 1, ([str length]) - (city.location + 1));
    NSString *nameString = [str substringWithRange:cityrange];
    
    long position = 0;
    for (NSString *str in self.cityArray) {
        if ([str isEqualToString:nameString]) break;
        position++;
    }
    self.icon = [NSString stringWithFormat:@"%@", [self->tempIconArray objectAtIndex:position]];
    
    pin.image = [UIImage imageNamed:self.icon];

    return pin;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
