//
//  Model.m
//  Weather application
//
//  Created by Danil Kleshchin on 02.12.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//

#import "Model.h"

@implementation Model


- (void)loadCitiesList {
    
    self.citiesList = [[NSMutableArray alloc]init];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"txt"];
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:path];
    NSString * line = nil;
    while ((line = [reader readLine])) {
        [self.citiesList addObject:line];
    }
}

@end
