//
//  WeatherCellTableViewCell.m
//  Weather app
//
//  Created by Danil Kleshchin on 09.12.16.
//  Copyright © 2016 DaO. All rights reserved.
//

#import "WeatherCell.h"

@implementation WeatherCell


@synthesize name;
@synthesize temperature;
@synthesize discription;

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


@end
