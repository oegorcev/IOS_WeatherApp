//
//  SearchCountry.h
//  Weather application
//
//  Created by Danil Kleshchin on 05.12.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


@protocol senddataProtocol <NSObject>

-(void)sendIdCityToStartPage:(NSString *)idCity;

@end

@interface SearchCountry : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    IBOutlet UITableView * tableView;
    IBOutlet UISearchBar * searchBar;
    NSMutableArray * displayItems;
    NSMutableArray * idCountries;
    NSString *idCityForSend;

}
@property(nonatomic, weak)id <senddataProtocol>delegate;
@property (nonatomic, strong) Model *model;
@end
