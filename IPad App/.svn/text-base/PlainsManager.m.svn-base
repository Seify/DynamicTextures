//
//  PlainsManager.m
//  Wall Painting Prototipe
//
//  Created by Roman Smirnov on 18.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlainsManager.h"

@implementation PlainsManager


@synthesize delegate;

- (PlainDetailsTableViewController *)plainDetails
{
    if (!plainDetails) {
        plainDetails = [[PlainDetailsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [plainDetails retain];
        plainDetails.delegate = self.delegate;
    }
    return  plainDetails;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton, self.editButtonItem, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.delegate.plains count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    PlainWithPattern *pl = [self.delegate.plains objectAtIndex:indexPath.row];
    cell.textLabel.text = pl.name;
    cell.imageView.image = [UIImage imageNamed:pl.imageName];
    // Configure the cell...
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.delegate.plains removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)addItem:sender {
    PlainWithPattern *newPlain = [[PlainWithPattern alloc] init];
    [self.delegate.plains addObject:newPlain];
    newPlain.name = [@"wallpaper" stringByAppendingFormat:@"%d", ++self.delegate.numberOfPlain];
//    NSLog(@"[self.delegate.plains count] = %d", [self.delegate.plains count]);
    newPlain.imageName = delegate.defaultImageName;
    newPlain.texture = delegate.defaultTexture;
    [self.tableView reloadData];
    
    self.plainDetails.plain = newPlain;
    [self.navigationController pushViewController:self.plainDetails animated:YES];
    
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
//    перемещаем элемент внутри массива
//    http://www.icab.de/blog/2009/11/15/moving-objects-within-an-nsmutablearray/
    
    if (toIndexPath.row != fromIndexPath.row) {
        id obj = [self.delegate.plains objectAtIndex:fromIndexPath.row];
        [obj retain];
        [self.delegate.plains removeObjectAtIndex:fromIndexPath.row];
        if (toIndexPath.row >= [self.delegate.plains count]) {
            [self.delegate.plains addObject:obj];
        } else {
            [self.delegate.plains insertObject:obj atIndex:toIndexPath.row];
        }
        [obj release];
    }
}


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
    // Navigation logic may go here. Create and push another view controller.
    
    
    self.plainDetails.plain = [delegate.plains objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.plainDetails animated:YES];
    
}

- (void) dealloc
{
    [self.plainDetails release];
    [super dealloc];
}

@end
