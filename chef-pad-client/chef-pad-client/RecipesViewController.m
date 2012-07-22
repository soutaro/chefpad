//
//  RecipesViewController.m
//  chef-pad-client
//
//  Created by 松本 宗太郎 on 2012/07/16.
//  Copyright (c) 2012年 Soutaro Matsumoto. All rights reserved.
//

#import "RecipesViewController.h"
#import "AppDelegate.h"
#import "RecipeTableViewCell.h"

@interface RecipesViewController ()

@end

@implementation RecipesViewController {
	NSArray* recipes_;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		recipes_ = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.appDelegate loadRecipe];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(recipeWillLoad:) name:RecipeWillLoadNotification object:self.appDelegate];
	[center addObserver:self selector:@selector(recipeDidLoad:) name:RecipeDidLoadNotification object:self.appDelegate];
	[center addObserver:self selector:@selector(recipeDidFailToLoad:) name:RecipeDidFailToLoadNotification object:self.appDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RecipeTableViewCell *cell = (RecipeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"RecipeTableViewCell" owner:nil options:nil] objectAtIndex:0];
	}
    
	NSDictionary* recipe = [recipes_ objectAtIndex:indexPath.row];
	
	cell.titleTextLabel.text = [recipe objectForKey:@"title"];
	cell.bodyTextView.text = [recipe objectForKey:@"body"];
	
	cell.accessibilityLabel = [NSString stringWithFormat:@"recipe_at_%d", indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	RecipeTableViewCell* cell = (RecipeTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	
	UILabel* textView = cell.bodyTextView;
	
	CGSize size = CGSizeMake(textView.bounds.size.width, 1000);
	CGSize textSize = [textView.text sizeWithFont:textView.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
	
	float computedHeight = textSize.height;
	
	float height = cell.bodyTextView.frame.origin.y + computedHeight + 20;
	
	return height;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark -

- (void)recipeWillLoad:(NSNotification*)notification {
	
}

- (void)recipeDidLoad:(NSNotification*)notification {
	recipes_ = [notification.userInfo objectForKey:@"recipes"];
	[self.tableView reloadData];
}

- (void)recipeDidFailToLoad:(NSNotification*)notification {
	
}

#pragma mark - Actions

- (IBAction)logoutButtonTap:(id)sender {
	self.appDelegate.authToken = nil;
	[self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
