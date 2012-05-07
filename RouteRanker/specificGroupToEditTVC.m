//
//  specificGroupToEditTVC.m
//  RouteRanker
//
//  Created by Mark Whelan on 5/2/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import "specificGroupToEditTVC.h"

@interface specificGroupToEditTVC () {
    NSArray* sectionTitles; 
    NSMutableArray* pathsInGroup;
    NSMutableArray* allOtherPaths; 
    NSMutableArray* tableData;
    NSMutableArray* pathsToTakeOut;
    NSMutableArray* pathsToAdd;
    BOOL reload; 
}

@end

@implementation specificGroupToEditTVC

@synthesize listOfRoutes = _listOfRoutes; 
@synthesize groupToEdit = _groupToEdit; 

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    sectionTitles = [[NSArray alloc] initWithObjects:@"Routes in Group", @"All Other Routes", nil];
    
    return sectionTitles; 
}
*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) 
        return @"Paths in Group";    
    else 
        return @"All Other Paths";
}

- (void)viewWillAppear:(BOOL)animated {
    for (Route* route in self.listOfRoutes) {
        if ([self.groupToEdit routeInGroup:route])
            [pathsInGroup addObject:route];
        else {
            [allOtherPaths addObject:route];
        }
    }
    [tableData addObject:pathsInGroup];
    [tableData addObject:allOtherPaths];
    
    pathsToAdd = [pathsInGroup mutableCopy];
    pathsToTakeOut = [allOtherPaths mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pathsInGroup = [[NSMutableArray alloc] init];
    allOtherPaths = [[NSMutableArray alloc] init];
    tableData = [[NSMutableArray alloc] init];
    
    //populate the two sections

    
    //create button
    UIBarButtonItem* button;
    button = [[UIBarButtonItem alloc] initWithTitle:@"Swap Path" style:UIBarButtonItemStylePlain
                                             target:self 
                                             action:@selector(buttonPressed)];
    self.navigationItem.rightBarButtonItem = button;
    
    

        

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[tableData objectAtIndex:section] count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([title isEqualToString:@"Routes in Group"])
        return 0;
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"pathName"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pathName"];
    }
    cell.showsReorderControl = YES;

    Route* route= [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString* cellText = route.name;
    NSLog(cellText);
    cell.textLabel.text = cellText;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// switch array that path is in
-(void) switchArrayforRoute:(Route*) route {
    int i = 0; 
    BOOL PrevioulsyInGroup = NO;
    NSString* routePassed = route.name;
    
    for (Route* route in pathsToAdd) { 
        NSString* routeInArray = route.name;
        if ([routePassed isEqualToString:routeInArray]) {
            PrevioulsyInGroup = YES;
            [pathsToAdd removeObjectAtIndex:i];
            [pathsToTakeOut addObject:route];
            [self.groupToEdit removeRoute:route];
            break;
        }
        i++;
    }
    if (!PrevioulsyInGroup) {
        i = 0;
        for (Route* route in pathsToTakeOut) { 
            NSString* routeInArray = route.name;
            if ([routePassed isEqualToString:routeInArray]) {
                PrevioulsyInGroup = YES;
                [pathsToTakeOut removeObjectAtIndex:i];
                [pathsToAdd addObject:route];
                [self.groupToEdit addRoute:route];
                break;
            }
            i++;
        }
    }
   
}

-(void) buttonPressed {
    [self finalUpdate]; 
    
    [tableData removeAllObjects];
    
    pathsInGroup = [pathsToAdd mutableCopy];
    allOtherPaths = [pathsToTakeOut mutableCopy];
    [tableData addObject:pathsInGroup];
    [tableData addObject:allOtherPaths];
    
    reload = YES;
    [self.tableView reloadData];
        
}

//iterate through cells immediatly before swap button pushed 
-(void) finalUpdate {
    int i , j; 
    /*
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        if (cell.accessoryType = UITableViewCellAccessoryCheckmark) {
            Route* route = [[tableData objectAtIndex:] objectAtIndex:j];
            [self switchArrayforRoute:route];

        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    */
    for (i = 0; i < 2; i++) {
        for (j = 0; j < [self tableView:self.tableView numberOfRowsInSection:i]; j++) {
            UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            NSLog(cell.textLabel.text);
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                Route* route = [[tableData objectAtIndex:i] objectAtIndex:j];
                [self switchArrayforRoute:route];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    //add or remove check marks
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
       // Reflect selection in data model
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } 
    
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        // Reflect deselection in data model
        cell.accessoryType = UITableViewCellAccessoryNone;       
    }
        
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
