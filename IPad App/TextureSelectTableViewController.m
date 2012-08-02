//
//  TextureSelectTableViewController.m
//  Wall Painting Prototipe
//
//  Created by Roman Smirnov on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextureSelectTableViewController.h"

@implementation TextureSelectTableViewController
@synthesize plain, delegate;

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
    self.title = @"Textures";

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSString *texName;
    switch (indexPath.row) {
        case 0:
            texName = @"tile_floor.png";
            break;
        case 1:
            texName = @"item_powerup_fish.png";
            break;
        case 2:
            texName = @"1254.jpg";
            break;
        case 3:
            texName = @"2048.jpg";
            break;
        case 4:
            texName = @"2460.jpg";
            break;
        case 5:
            texName = @"2762.jpg";
            break;
        case 6:
            texName = @"traf1.jpg";
            
        default:
            break;
    }
    
    UIImage *cellBgImage = [UIImage imageNamed:texName];
    UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellBgImage.size.width, cellBgImage.size.height)];
    cellBgView.backgroundColor = [UIColor colorWithPatternImage:cellBgImage];
    [cellBgView setOpaque:NO];
    [[cellBgView layer] setOpaque:NO];
    
    cell.backgroundView = cellBgView;
    
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
    switch (indexPath.row) {
//        case 0:
//            self.plain.imageName = @"tile_floor.png";
//            self.plain.texture = self.delegate->_floorTexture;
//            break;
//        case 1:
//            self.plain.imageName = @"item_powerup_fish.png";
//            self.plain.texture = self.delegate->_fishTexture;
//            break;
//        case 2:
//            self.plain.imageName = @"1254.jpg";
//            self.plain.texture = self.delegate->_1254Texture;
//            break;
//        case 3:
//            self.plain.imageName = @"2048.jpg";
//            self.plain.texture = self.delegate->_2048Texture;
//            break;
//        case 4:
//            self.plain.imageName = @"2460.jpg";
//            self.plain.texture = self.delegate->_2460Texture;
//            break;
//        case 5:
//            self.plain.imageName = @"2762.jpg";
//            self.plain.texture = self.delegate->_2762Texture;
//            break;
//        case 6:
//            self.plain.imageName = @"traf1.jpg";
//            self.plain.texture = self.delegate->_traf1Texture;
//            break;
//            
        default:
            break;

    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
