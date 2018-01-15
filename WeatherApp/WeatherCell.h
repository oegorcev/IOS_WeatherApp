//
//  WeatherCellTableViewCell.h
//  Weather app
//
//  Created by Danil Kleshchin on 09.12.16.
//  Copyright © 2016 DaO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell
{
    UILabel *name;
    UILabel *temperature;
    UILabel *discription;

   // UIImageView *photo;
}

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *temperature;
@property (nonatomic, retain) IBOutlet UILabel *discription;

//@property (nonatomic, retain) IBOutlet UIImageView *photo;
@end
