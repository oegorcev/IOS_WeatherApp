//
//  ViewController.m
//  WeatherApp
//
//  Created by Danil Kleshchin on 10.12.16.
//  Copyright © 2016 DaO. All rights reserved.
//

#import "StartPage.h"
#include "City+CoreDataClass.h"
#import "AppDelegate.h"
#import "SearchCountry.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"


@interface StartPage ()<CLLocationManagerDelegate>
{
    SearchCountry *SearchView;
    NSManagedObjectContext *managedObjectContext;
    BOOL isNew;
}

@property (nonatomic, strong) NSArray<CLLocation *> *locations;

@end

@implementation StartPage


- (NSManagedObjectContext *)managedObjectContextMethod {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isNew = NO;
    self.model = [[Model alloc] init];
    self->cityIdArray = [[NSMutableArray alloc] init];
    self->cityNameArray = [[NSMutableArray alloc] init];
    self->descriptionArray = [[NSMutableArray alloc] init];
    self->temperatureArray = [[NSMutableArray alloc] init];
    self->iconArray = [[NSMutableArray alloc] init];
    self->countryArray = [[NSMutableArray alloc] init];
    self->latArray = [[NSMutableArray alloc] init];
    self->lonArray = [[NSMutableArray alloc] init];
    self->currentLatitude = @-666;
    self->currentLongitude =@-666;
    
    self->managedObjectContext = [self managedObjectContextMethod];
    
    myBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(showMap:)];
    myAddButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddCity:)];
    self.navigationItem.leftBarButtonItem = myBackButton;
    self.navigationItem.rightBarButtonItem = myAddButton;
    
    SearchView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchCountryId"];
    SearchView.model = [[Model alloc] init];
    
    myAddButton.enabled = NO;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [SearchView.model loadCitiesList];
        dispatch_async(dispatch_get_main_queue(), ^{
            myAddButton.enabled = YES;
        });
    });
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    if ([results count] == 0)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)[self.locationManager startUpdatingLocation];
        else {
            
        }
    }
   else{
       for(int i = 0; i < [results count]; ++i)
       {
           City *cityT = (City *)[results objectAtIndex:i];
//           NSString *cityName = cityT.name;
//           [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", cityName]];
//           NSMutableArray* tempCoreDataArrayForName;
//           tempCoreDataArrayForName = [[managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
//           NSManagedObject *name = [tempCoreDataArrayForName objectAtIndex:0];
           self.cityId = [cityT valueForKey:@"idCity"];
           self.city = [cityT valueForKey:@"name"];
           self->currentLatitude = @666;
           [self setData];
       }
    }
}

- (void)setData {
    if (([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable))
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Failed to connect to the Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        return;
    }
    
    City *cityCoreData = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self->managedObjectContext];

    NSError* error;
    NSURLResponse *response;
    NSString *urlString;
   
    if(self.city == nil && ![self->currentLatitude isEqual: @-666])
    {
        isNew = YES;
        urlString = [NSString stringWithFormat:@"%@%@%@%@%@", @"http://api.openweathermap.org/data/2.5/weather?lat=", self->currentLatitude, @"&lon=", self->currentLongitude, @"&APPID=57432abff315a24276715cd1a27b3d18"];
         NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] returningResponse:&response error:&error];
        if (data){
            NSData *jsonData =[NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:&error];
            self.cityId = [NSString stringWithFormat:@"%@",[jsonData valueForKey:@"id"]];
        }
    }
    else
    {
        BOOL isFinded = NO;
        if([self->currentLatitude isEqual: @-666]) isNew = YES;
            
        for (NSString *myId in self->cityIdArray) {
            if ([self.cityId isEqualToString: myId]) isFinded =YES;
        }
        
        if(!isFinded){
            urlString = [NSString stringWithFormat:@"%@%@%@", @"http://api.openweathermap.org/data/2.5/weather?id=", self.cityId, @"&APPID=57432abff315a24276715cd1a27b3d18"];
        }
        else
        {
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Attention!" message:@"This city already added!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
            
            return;
        }
        
    }
    
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] returningResponse:&response error:&error];
    
    if (data){
        NSData *jsonData =[NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:&error];
        NSArray *weatherArrayData = [jsonData valueForKey:@"weather"];
        NSData *weatherDescription = [weatherArrayData objectAtIndex:0];
        NSData *currentData = [jsonData valueForKey:@"main"];
        NSData *countryData = [jsonData valueForKey:@"sys"];
        
        
        [self->cityIdArray addObject:self.cityId];
        self.city = [jsonData valueForKey:@"name"];
        [self->cityNameArray addObject:self.city];
        self.temperature = [currentData valueForKey:@"temp"];
        long temp = self.temperature.longValue - 273;
        self.temperature =[NSNumber numberWithInteger:temp];
        [self->temperatureArray addObject:[NSString stringWithFormat:@"%ld", temp]];
        self.descriptionOfWeather = [weatherDescription valueForKey:@"description"];
        [self->descriptionArray addObject:self.descriptionOfWeather];
        self.icon = [weatherDescription valueForKey:@"icon"];
        [self->iconArray addObject:self.icon];
        self.country = [countryData valueForKey:@"country"];
        [self->countryArray addObject:self.country];
        NSData *coordinate = [jsonData valueForKey:@"coord"];
        self->lat = [coordinate valueForKey:@"lat"];
        [self->latArray addObject:self->lat];
        self->lon = [coordinate valueForKey:@"lon"];
        [self->lonArray addObject:self->lon];
        self->FirstCity = true;
        [self.locationManager stopUpdatingLocation];
        
        //save data in core data
        
        cityCoreData.name = self.city;
        cityCoreData.idCity = self.cityId;
        cityCoreData.latitude = self->lat;
        cityCoreData.longitude = self->lon;
        cityCoreData.currentWeatherIcon = self.icon;
        cityCoreData.country =self.country;
        cityCoreData.currentTemp = [NSString stringWithFormat:@"%ld", self.temperature.longValue];
        cityCoreData.currentDesc = self.descriptionOfWeather;

        if (isNew)  [managedObjectContext save:&error];
        isNew = NO;
        ///////
    }
    else {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Failed to connect to the Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self->currentLongitude = [NSNumber numberWithDouble:[locations objectAtIndex:0].coordinate.longitude];
    self->currentLatitude = [NSNumber numberWithDouble:[locations objectAtIndex:0].coordinate.latitude];
    self.locations = locations;
    if (!(self->FirstCity))  [self setData];
    [self->tableView reloadData];
}

- (void)showMap:(id)sender {
    if (([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Failed to connect to the Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    
    MapViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"viewStoryboardId"];
    mapView.titleArray = self->temperatureArray;
    mapView.subtitleArray = self->descriptionArray;
    mapView.latArray = self->latArray;
    mapView.lonArray = self->lonArray;
    mapView.cityArray = self->cityNameArray;
    mapView.cityIdArray = self->cityIdArray;
    mapView.iconArray = self->iconArray;    
    [self.navigationController pushViewController:mapView animated:YES];
}

-(void)sendIdCityToStartPage:(NSString *)idCity
{
    if(idCity != nil)
    {
        isNew = YES;
        self.cityId = idCity;
        [self setData];
    }
    [self->tableView reloadData];
}

- (void)showAddCity:(id)sender {
    [SearchView setDelegate:self];
    [self.navigationController pushViewController:SearchView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cityNameArray count];
}

- (UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    if([[self->temperatureArray objectAtIndex:indexPath.row] length] == 3)
        cell.textLabel.text = [NSString stringWithFormat:@"🌡%@° 🏙%@ (%@)",[self->temperatureArray objectAtIndex:indexPath.row], [self->cityNameArray objectAtIndex:indexPath.row], [self->countryArray objectAtIndex:indexPath.row]];
    else
        if([[self->temperatureArray objectAtIndex:indexPath.row] length] == 2)
            cell.textLabel.text = [NSString stringWithFormat:@"🌡%@°   🏙%@ (%@)",[self->temperatureArray objectAtIndex:indexPath.row], [self->cityNameArray objectAtIndex:indexPath.row], [self->countryArray objectAtIndex:indexPath.row]];
        else
            if([[self->temperatureArray objectAtIndex:indexPath.row] length] == 1)
                cell.textLabel.text = [NSString stringWithFormat:@"🌡%@°     🏙%@ (%@)",[self->temperatureArray objectAtIndex:indexPath.row], [self->cityNameArray objectAtIndex:indexPath.row], [self->countryArray objectAtIndex:indexPath.row]];
            else
                cell.textLabel.text = [NSString stringWithFormat:@"🌡%@°  🏙%@ (%@)",[self->temperatureArray objectAtIndex:indexPath.row], [self->cityNameArray objectAtIndex:indexPath.row], [self->countryArray objectAtIndex:indexPath.row]];
    
    cell.detailTextLabel.text = [self->descriptionArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self->iconArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)myTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekInfo *view = [self.storyboard instantiateViewControllerWithIdentifier:@"weekInfoID"];
    view.cityName = [self->cityNameArray objectAtIndex:indexPath.row];
    view.cityId = [self->cityIdArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}
///////////////////////

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSManagedObjectContext *context = self->managedObjectContext;
// 
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
//    [request setPredicate:[NSPredicate predicateWithFormat:@"idCity == %@", [self->cityIdArray objectAtIndex:indexPath.row]]];
//    NSMutableArray* tempCoreDataArrayForName;
//    tempCoreDataArrayForName = [[managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
//    NSManagedObject *name = [tempCoreDataArrayForName objectAtIndex:0];
//
//    [managedObjectContext deleteObject:name];
//    
    
    NSManagedObjectContext *context = self->managedObjectContext;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAllObjects:@"City"];
        
        // Remove device from table view
        [self->cityNameArray removeObjectAtIndex:indexPath.row];
        [self->iconArray removeObjectAtIndex:indexPath.row];
        [self->temperatureArray removeObjectAtIndex:indexPath.row];
        [self->descriptionArray removeObjectAtIndex:indexPath.row];
        [self->countryArray removeObjectAtIndex:indexPath.row];
        [self->cityIdArray removeObjectAtIndex:indexPath.row];
        [self->latArray removeObjectAtIndex:indexPath.row];
        [self->lonArray removeObjectAtIndex:indexPath.row];
        [self->tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        for(int i = 0; i < [self->cityNameArray count]; ++i)
        {
            City *cityCoreData = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self->managedObjectContext];

            cityCoreData.name = [self->cityNameArray objectAtIndex:i];
            cityCoreData.idCity = [self->cityIdArray objectAtIndex:i];
            cityCoreData.latitude = [self->latArray objectAtIndex:i];
            cityCoreData.longitude = [self->lonArray objectAtIndex:i];
            cityCoreData.currentWeatherIcon = [self->iconArray objectAtIndex:i];
            cityCoreData.country = self.country;
            cityCoreData.currentTemp =  [self->temperatureArray objectAtIndex:i];
            cityCoreData.currentDesc = [self->descriptionArray objectAtIndex:i];

            [managedObjectContext save:nil];
        }
        
        
        
//        [self.devices removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
    
 
    
}
///////////
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    
    long i = 0;
    for (NSManagedObject *managedObject in items) {
        /*if ( i == index)*/ [managedObjectContext deleteObject:managedObject];
        i++;
    }
    if (![managedObjectContext save:&error]) {

    }
    
}

@end



