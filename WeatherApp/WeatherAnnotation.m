//
//  WeatherAnnotation.m
//  WeatherApp
//
//  Created by Danil Kleshchin on 13.12.16.
//  Copyright © 2016 DaO. All rights reserved.
//

#import "WeatherAnnotation.h"

@implementation WeatherAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (instancetype)init {
    self = [super init];
    if (self) {
        _title = @"Hello";//self.myTitle;
        _subtitle = @"Hi";//self.mySubtitle;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

@end
