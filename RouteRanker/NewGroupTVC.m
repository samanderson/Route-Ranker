//
//  NewGroupTVC.m
//  RouteRanker
//
//  Created by Mark Whelan on 5/1/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import "NewGroupTVC.h"


@interface NewGroupTVC () <reviewDelegate>
{
    NSMutableArray* includeRoute; //boolean list to include route or not
    UIAlertView* notEnoughSelected; //alert that goes off if no paths are selected at time of saving
}

@end

@implementation NewGroupTVC

@synthesize nameOfGroup = _nameOfGroup;
@synthesize listOfPaths = _listOfPaths;
@synthesize routesInNewGroup = _routesInNewGroup;
@synthesize listOfRoutes = _listOfRoutes;
@synthesize listOfGroups = _listOfGroups;
@synthesize groupToCreate = _groupToCreate;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray*) getNewListOfGroups
{
    return self.listOfGroups; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //routes added as testCode
//    self.listOfRoutes = [[NSMutableArray alloc] init];
    self.listOfPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
  //      Route* routeToAdd = [[Route alloc] init];
        NSString* name = [NSString stringWithFormat:@"%d",i];
        name = [@"Route" stringByAppendingString:name];
    //    routeToAdd.name = name;
        [self.listOfPaths addObject:name];
      //  [self.listOfRoutes addObject:routeToAdd];
     //   NSLog(routeToAdd.name);
     //   NSLog(name);
    }
    
    
   
    //NSLog(self.nameOfGroup);
    self.routesInNewGroup = [[NSMutableArray alloc] init];
    includeRoute = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.listOfPaths count]; i++) { 
        [includeRoute addObject:@"NO"];
    }
    //fetchRequest
    // NSmanagedobject
    
    UIBarButtonItem* createButton = [[UIBarButtonItem alloc] initWithTitle:@"Save Group" style:UIBarButtonItemStylePlain
                                                                    target:self 
                                                                    action:@selector(createGroupButtonPressed:)];
    self.navigationItem.rightBarButtonItem = createButton;
    
    
    self.navigationItem.title = self.nameOfGroup;


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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listOfPaths count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"PathName"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PathName"];
    }
    NSString* cellTitle = [self.listOfPaths objectAtIndex:indexPath.row];
    cell.textLabel.text = cellTitle;

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    if (alertView == notEnoughSelected) { 
        return;
    }
}

#pragma mark - Table view delegate
- (void)createGroupButtonPressed:(id)sender {
    for (int i = 0; i < [includeRoute count]; i++) { 
        NSString* include = [includeRoute objectAtIndex:i];
        if ([include isEqualToString:@"YES"]) {
             //NSString* nameOfPath = [self.listOfPaths objectAtIndex:i];
            Route* routeToAdd = [self.listOfRoutes objectAtIndex:i];
            [self.routesInNewGroup addObject:routeToAdd];
        }
    }
    NSInteger numPaths = [self.routesInNewGroup count];
    
    //throw alert if no paths selected
    if (numPaths == 0) {
        notEnoughSelected  = [[UIAlertView alloc] initWithTitle:@"Please Select at Least One Path to Add" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        notEnoughSelected.alertViewStyle = UIAlertViewStyleDefault;
        
        
        [notEnoughSelected show];
        return; 
    }
    else {
        //add routes to group
        self.groupToCreate = [[Group alloc] initWithName:self.nameOfGroup];
        for (Route* route in self.routesInNewGroup) {
            [self.groupToCreate addRoute:route];
        }
        
        // add group to list of groups
        [self.listOfGroups addObject:self.groupToCreate];
    }
   
    //[self performSegueWithIdentifier:@"goBack" sender:sender];
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toReview"]) {
        [self performSegueWithIdentifier:@"toReview" sender:sender];
    }
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        [includeRoute replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Reflect selection in data model
    } 
    
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [includeRoute replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        // Reflect deselection in data model
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
