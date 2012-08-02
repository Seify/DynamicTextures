//
//  PlainDetailsTableViewController.m
//  Wall Painting Prototipe
//
//  Created by Roman Smirnov on 19.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlainDetailsTableViewController.h"
#import "TextureSelectTableViewController.h"

@implementation PlainDetailsTableViewController
@synthesize delegate;

- (PlainWithPattern *)plain
{
    if (!plain) {
        plain = [[PlainWithPattern alloc] init];
        [plain retain];
    };
    return plain;
}

- (void)setPlain:(PlainWithPattern *)newPlain
{
    
    if (newPlain != plain){
        [plain release];
        plain = newPlain;
        [plain retain];
        [self.tableView reloadData];
    }
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
    
    self.title = self.plain.name;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Name";
            break;
        case 1:
            return @"Texture";
            break;
        default:
            return @"Unknown section";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
//        UITextField *textview = [[UITextField alloc] initWithFrame:cell.frame];
//        textview.text = self.plain.name;
//        textview.textAlignment = UITextAlignmentCenter;
//        [cell.contentView addSubview:textview];
//        
        cell.textLabel.text = self.plain.name;
    };
//    if (indexPath.section == 1) {cell.textLabel.text = self.plain.imageName;};
    if (indexPath.section == 1) {//cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:plain.imageName]];};
    
        UIImage *cellBgImage = [UIImage imageNamed:plain.imageName];
        UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellBgImage.size.width, cellBgImage.size.height)];
        cellBgView.backgroundColor = [UIColor colorWithPatternImage:cellBgImage];
        [cellBgView setOpaque:NO];
        [[cellBgView layer] setOpaque:NO];
        
        cell.backgroundView = cellBgView;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    TextureSelectTableViewController *detailViewController = [[TextureSelectTableViewController alloc] initWithNibName:@"TextureSelectTableViewController" bundle:nil];
    detailViewController.delegate = self.delegate;
    detailViewController.plain = self.plain;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
     
}

- (void) dealloc {
    [self.plain release];
    [super dealloc];
}

@end
