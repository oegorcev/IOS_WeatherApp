//
//  SearchCountry.m
//  Weather application
//
//  Created by Danil Kleshchin on 05.12.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//

#import "SearchCountry.h"


@interface SearchCountry ()

@end

@implementation SearchCountry
@synthesize delegate;


-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate sendIdCityToStartPage:self->idCityForSend];
    self->idCityForSend = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.ы
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];    
//    self->displayItems = [[NSMutableArray alloc] init];
//    self->idCountries = [[NSMutableArray alloc] init];
//    
//    for (NSString *str in self.model.citiesList) {
//        NSRange city = [str rangeOfString:@" "];
//        NSRange cityrange = NSMakeRange(city.location + 1, ([str length] - 1) - (city.location + 1));
//        NSRange idrange = NSMakeRange(0, city.location);
//        NSString *nameString = [str substringWithRange:cityrange];
//        NSString *idString = [str substringWithRange:idrange];
//        [displayItems addObject:nameString];
//        [idCountries addObject:idString];
//    }
    displayItems = [[NSMutableArray alloc] initWithArray:self.model.citiesList];
}


//-----------------------------------------------------------------------
//-----------------------------------------------------------------------


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [displayItems count];
}

- (UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
            NSString *str = [displayItems objectAtIndex:indexPath.row];
            NSRange city = [str rangeOfString:@" "];
            NSRange cityrange = NSMakeRange(city.location + 1, ([str length] - 1) - (city.location + 1));
            NSRange idrange = NSMakeRange(0, city.location);
            NSString *nameString = [str substringWithRange:cityrange];
            NSString *idString = [str substringWithRange:idrange];

    
    cell.textLabel.text = nameString;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"ID: %@",idString];
    return cell;
}

- (void)tableView:(UITableView *)myTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [displayItems objectAtIndex:indexPath.row];
    NSRange city = [str rangeOfString:@" "];
    NSRange idrange = NSMakeRange(0, city.location);
    self->idCityForSend = [str substringWithRange:idrange];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length] == 0) {
        [displayItems removeAllObjects];
        [displayItems addObjectsFromArray:self.model.citiesList];
    } else {
        [displayItems removeAllObjects];
        for(NSString * string in self.model.citiesList) {
            NSRange r = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound) {
                [displayItems addObject:string];
            }
        }
    }
    [tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)mySearchBar {
    [mySearchBar resignFirstResponder];
}

@end
