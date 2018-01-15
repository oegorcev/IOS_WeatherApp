//
//  WeekInfo.m
//  Weather application
//
//  Created by Danil Kleshchin on 05.12.16.
//  Copyright © 2016 Danil Kleshchin. All rights reserved.
//
#import "AppDelegate.h"
#import "WeekInfo.h"


@implementation WeekInfo
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cityName;
    descriptionArray = [[NSMutableArray alloc] init];
    dateArray = [[NSMutableArray alloc] init];
    temperatureArray = [[NSMutableArray alloc] init];
    iconsArray = [[NSMutableArray alloc] init];
    descriptionArrayForCoreData = [[NSMutableArray alloc] init];
    dateArrayForCoreData = [[NSMutableArray alloc] init];
    temperatureArrayForCoreData = [[NSMutableArray alloc] init];
    iconsArrayForCoreData = [[NSMutableArray alloc] init];
    
   
    [self setData];
}


-(void) setData{
        NSError* error;
        NSURLResponse *response;
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@", @"http://api.openweathermap.org/data/2.5/forecast/city?id=", self.cityId, @"&APPID=57432abff315a24276715cd1a27b3d18"];
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] returningResponse:&response error:&error];
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
        for (int i = 0; i < 100000; i++) {
        
        }
    
        if (data){
            NSData *jsonData =[NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:&error];
            NSArray *list = [jsonData valueForKey:@"list"];
            for(int i = 0; i < list.count; ++i)
            {
                NSData *listDescription = [[list objectAtIndex:i] valueForKey:@"weather"];
                NSData *temperatureDescrition = [[list objectAtIndex:i] valueForKey:@"main"];
                [dateArray addObject:[[list objectAtIndex:i] valueForKey:@"dt_txt"]];
                [descriptionArray addObject:[listDescription valueForKey:@"description"]];
                [temperatureArray addObject:[temperatureDescrition valueForKey:@"temp"]];
                [iconsArray addObject:[listDescription valueForKey:@"icon"]];
            }
           
            for (int i = 0; i < 100000; i++) {
                
            }
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
            
            NSError *error = nil;
            NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
            if (!results) {
                NSLog(@"Error! %@\n%@", [error localizedDescription], [error userInfo]);
                abort();
            }
            
            else{
                for(int i = 0; i < [results count]; ++i)
                {
                    City *cityT = (City *)[results objectAtIndex:i];
                    NSString *cityName = cityT.name;
                    
                    if([self.cityName isEqualToString:cityName])
                    {
                        self.city = cityT;
                        break;
                    }
                }
            }
            

            
            
            
            
            
            self.city.desctiptionForFiveDay = [NSKeyedArchiver archivedDataWithRootObject:descriptionArray];
            self.city.dateForFiveDay = [NSKeyedArchiver archivedDataWithRootObject:dateArray];
            self.city.iconForFiveDay = [NSKeyedArchiver archivedDataWithRootObject:iconsArray];
            self.city.tempForFiveDay = [NSKeyedArchiver archivedDataWithRootObject:temperatureArray];
            
            for (int i = 0; i < 100000; i++) {
                
            }
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"City"];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idCity == %@", _cityId]];
            self->descriptionArrayForCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            for (int i = 0; i < 100000; i++) {
                
            }
            NSManagedObject *description = [self->descriptionArrayForCoreData objectAtIndex:0];
            self->descriptionArrayForCoreData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[description valueForKey:@"desctiptionForFiveDay"]]];
            self->dateArrayForCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            for (int i = 0; i < 100000; i++) {
                
            }
            NSManagedObject *date = [self->dateArrayForCoreData objectAtIndex:0];
            self->dateArrayForCoreData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[date valueForKey:@"dateForFiveDay"]]];
            
            self->iconsArrayForCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            for (int i = 0; i < 100000; i++) {
                
            }
            NSManagedObject *icon = [self->iconsArrayForCoreData objectAtIndex:0];
            self->iconsArrayForCoreData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[icon valueForKey:@"iconForFiveDay"]]];
            
            self->temperatureArrayForCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            for (int i = 0; i < 100000; i++) {
                
            }
            NSManagedObject *temperature = [self->temperatureArrayForCoreData objectAtIndex:0];
            self->temperatureArrayForCoreData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[temperature valueForKey:@"tempForFiveDay"]]];
            
            // [self.managedObjectContext save:&error];
        }
        else
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"City"];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idCity == %@", _cityId]];
            self->descriptionArrayForCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            NSManagedObject *description = [self->descriptionArrayForCoreData objectAtIndex:0];
            self->descriptionArrayForCoreData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[description valueForKey:@"desctiptionForFiveDay"]]];
            self->dateArrayForCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            NSManagedObject *date = [self->dateArrayForCoreData objectAtIndex:0];
            self->dateArrayForCoreData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[date valueForKey:@"dateForFiveDay"]]];
            
            self->iconsArrayForCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            NSManagedObject *icon = [self->iconsArrayForCoreData objectAtIndex:0];
            self->iconsArrayForCoreData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[icon valueForKey:@"iconForFiveDay"]]];
            
            self->temperatureArrayForCoreData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            NSManagedObject *temperature = [self->temperatureArrayForCoreData objectAtIndex:0];
            self->temperatureArrayForCoreData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[temperature valueForKey:@"tempForFiveDay"]]];
        }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [descriptionArray count];
}

- (UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    NSArray *tempDesc = [descriptionArrayForCoreData objectAtIndex:indexPath.row];
    NSString *tempDate = [dateArrayForCoreData objectAtIndex:indexPath.row];
    NSNumber *tempTemp = [temperatureArrayForCoreData objectAtIndex:indexPath.row];
    NSArray *tempIcon = [iconsArrayForCoreData objectAtIndex:indexPath.row];
    long temp = tempTemp.longValue - 273;

    if([[tempIcon objectAtIndex:0] characterAtIndex:[[tempIcon objectAtIndex:0] length] - 1] == 'n')
    {
        cell.backgroundColor = [UIColor lightGrayColor];
        
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld° %@", temp, [tempDesc objectAtIndex:0]];
    cell.detailTextLabel.text = tempDate;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [tempIcon objectAtIndex:0]]];
    return cell;
    for (int i = 0; i < 100000; i++) {
        
    }
}


@end
