//
//  Model.h
//  Weather application
//
//  Created by Danil Kleshchin on 02.12.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDFileReader.h"

@interface Model : NSObject
@property(nonatomic, strong) NSMutableArray* citiesList;
- (void)loadCitiesList;

@end
