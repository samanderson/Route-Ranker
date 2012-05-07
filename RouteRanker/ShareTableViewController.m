//
//  ShareTableViewController.m
//  RouteRanker
//
//  Created by Mark Whelan on 4/28/12.
//  Copyright (c) 2012 Princeton University. All rights reserved.
//

#import "ShareTableViewController.h"
#import "AppDelegate.h"
#import <UIKit/UILocalizedIndexedCollation.h>



@interface ShareTableViewController ()
{
    AppDelegate *delegate;
    NSMutableArray *copyOfFriends;
}

@end

@implementation ShareTableViewController

@synthesize nameOfFriends = _nameOfFriends;
@synthesize tableData = _tableData;
@synthesize FriendToShareWith = _FriendToShareWith;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

-(NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector

{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++)
    {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    //put each object into a section
    NSArray* titles = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    NSInteger index = 0;
    //NSLog([array objectAtIndex:0]);
    for (NSString* name in array)
    {
        NSString* firstLetter = [name substringToIndex:1];
        //NSLog(firstLetter);
        while (index < [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count]) {
            NSString* titleHeader = [titles objectAtIndex:index];
            //NSLog(titleHeader);
            if ([firstLetter isEqualToString:titleHeader]) {
                [[unsortedSections objectAtIndex:index] addObject:name];
                break;
            }
            else {
                index = index + 1;
                [[unsortedSections objectAtIndex:index] addObject:name];  
                break;
            }
        }
    }
    return unsortedSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    copyOfFriends = [[NSMutableArray alloc] init];
    self.nameOfFriends = [[NSMutableArray alloc] init];
    self.tableData = [[NSMutableArray alloc] init];
    self.nameOfFriends = [delegate.friendNames mutableCopy];
    
    self.tableData = [self partitionObjects:self.nameOfFriends collationStringSelector:@selector(name)];

    //Set the title
    self.navigationItem.title = @"Friends";
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
    //we use sectionTitles and not sections
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tableData objectAtIndex:section] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //BOOL showSection = [[self.tableData objectAtIndex:section] count] != 0;
    //only show the section title if there are rows in the section
    //return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    return [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] objectAtIndex:section];
    
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 26;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.nameOfFriends count];
}
*/

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FriendName"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendName"];
    }
    
    NSString* friend = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //NSLog(friend);
        
   
    //NSString* friend = [self.nameOfFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = friend;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.FriendToShareWith = [self.nameOfFriends objectAtIndex:indexPath.row];
    //NSLog(self.FriendToShareWith);

     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PathsTableViewController *trailsController = [[PathsTableViewController alloc] initWithStyle:UITableViewStylePlain];
   // trailsController.selectedRegion = [regions objectAtIndex:indexPath.row];
    [[self navigationController] pushViewController:trailsController animated:YES];

    
    // Navigation logic may go here. Create and push another view controller.
    /*
      *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
