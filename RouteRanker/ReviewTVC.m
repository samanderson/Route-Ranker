//
//  ReviewTVC.m
//  RouteRanker
//
//  Created by Mark Whelan on 5/1/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import "ReviewTVC.h"


@interface ReviewTVC () {
    NSMutableArray* compareGroup;
    UIAlertView * compareAlertView;
}


@end

@implementation ReviewTVC

@synthesize NewGroupName = _NewGroupName;
@synthesize ListOfGroups = _ListOfGroups;
@synthesize delegate = _delegate;
@synthesize listOfGroupNames = listOfGroupNames; 
@synthesize listOfRoutes = _listOfRoutes;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    self.listOfGroupNames = [[NSMutableArray alloc] init];
    for (Group* group in self.ListOfGroups) {
        NSString* name = [group getGroupName];
        [self.listOfGroupNames addObject:name];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //routes added as testCode
    self.listOfRoutes = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        Route* routeToAdd = [[Route alloc] init];
        NSString* name = [NSString stringWithFormat:@"%d",i];
        name = [@"Route" stringByAppendingString:name];
        routeToAdd.name = name;
        [self.listOfRoutes addObject:routeToAdd];
    }
    
    //still need code to initialize list of Routes
    
    NewGroupTVC* test = [[NewGroupTVC alloc] init];
    NSMutableArray* copy = [test getNewListOfGroups];
    
    NSInteger copyLength;
    NSInteger listOfGroupsLength;
    
    copyLength = [copy count];
    listOfGroupsLength = [self.ListOfGroups count];
    if (listOfGroupsLength == 0) {
        self.ListOfGroups = [[NSMutableArray alloc] init];        
    }
    else {
        self.ListOfGroups = [copy mutableCopy];
    }
    
    //initialize array of groupNames
    //self.listOfGroupNames = [[NSMutableArray alloc] init];
    
    

    
    //initilize array for how many cells selected
    compareGroup = [[NSMutableArray alloc] init];
    
        
    //Set the title
    self.navigationItem.title = @"Groups";
    
    
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
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger numOfRows = [self.ListOfGroups count];
    return numOfRows + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    UITableViewCell *cell;
    if (indexPath.row == 0)
    {
    cell = [tableView dequeueReusableCellWithIdentifier:@"MakeNewGroupCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MakeNewGroupCell"];
        }
        NSString* cellTitle = @"Make New Group...";
        cell.textLabel.text = cellTitle;
    }
    else {
        [compareGroup addObject:@"NO"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
        }
        NSString* cellText = [self.listOfGroupNames objectAtIndex:indexPath.row - 1];
       
        cell.textLabel.text = cellText;
    }

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

- (IBAction)compareButtonPushed:(id)sender {
    NSInteger numToCompare = 0;
    int locationOfFirst = -1;
    int locationOfSecond = -1;
    for (int i = 0; i < [compareGroup count]; i++) {
        NSString* compare = [compareGroup objectAtIndex:i];
        if ([compare isEqualToString:@"YES"]) {
            if (locationOfFirst == -1) locationOfFirst = i;
            else locationOfSecond = i;
            numToCompare = numToCompare + 1;
        }
    }
    if (numToCompare != 2) { 
        compareAlertView  = [[UIAlertView alloc] initWithTitle:@"Please Select Exactly Two Groups to Compare" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
        compareAlertView.alertViewStyle = UIAlertViewStyleDefault;
            
          //  [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
            
        [compareAlertView show];
        }
    else {
        // set groups to compare
        CompareVC* compare = [[CompareVC alloc] init];
        compare.firstGroup = [self.ListOfGroups objectAtIndex:locationOfFirst];
        compare.secondGroup = [self.ListOfGroups objectAtIndex:locationOfSecond];
        
        
        [self performSegueWithIdentifier:@"toResults" sender:sender];
    }
    
}


#pragma mark - Table view delegate
- (IBAction)EditButtonPushed:(id)sender {
    EditGroupsTVC* editController = [[EditGroupsTVC alloc] initWithStyle:UITableViewStylePlain];
    editController.listOfGroups = self.ListOfGroups;

    editController.listOfRoutes = self.listOfRoutes;
    

    [[self navigationController] pushViewController:editController animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    if (alertView == compareAlertView) { 
        return;
    }
    else {
        self.NewGroupName = [[alertView textFieldAtIndex:0] text];
        for (NSString* groupNames in self.listOfGroupNames) {
            if ([self.NewGroupName isEqualToString:groupNames]) {
                [self MakeNewPathAlert];
                return;
            }
            
        }
        
        NSUInteger titleLength = [self.NewGroupName length];
        if (titleLength == 0) {
            [self MakeNewPathAlert];
            return;
        }
        
    
        //switch view controllers
        NewGroupTVC* newGroupController = [[NewGroupTVC alloc] initWithStyle:UITableViewStylePlain];

        //update name of new group
        newGroupController.nameOfGroup = self.NewGroupName;
        newGroupController.listOfGroups = self.ListOfGroups;
        newGroupController.listOfRoutes = self.listOfRoutes;
    
        [[self navigationController] pushViewController:newGroupController animated:YES];
    }
}

- (void) MakeNewPathAlert {
    //create a pop up so that user can name new group
    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Name Your Group" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [alertView show];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self MakeNewPathAlert];
       
    }
    else {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            [compareGroup replaceObjectAtIndex:indexPath.row - 1 withObject:@"YES"];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            // Reflect selection in data model
        } 
        
        else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [compareGroup replaceObjectAtIndex:indexPath.row -1 withObject:@"NO"];
            // Reflect deselection in data model
        }

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
