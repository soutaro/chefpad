//
//  NewRecipeViewController.m
//  chef-pad-client
//
//  Created by 松本 宗太郎 on 2012/07/16.
//  Copyright (c) 2012年 Soutaro Matsumoto. All rights reserved.
//

#import "NewRecipeViewController.h"
#import "AppDelegate.h"

@interface NewRecipeViewController ()

@end

@implementation NewRecipeViewController
@synthesize titleTextField;
@synthesize bodyTextView;
@synthesize loadingView;
@synthesize messageLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
	[self setTitleTextField:nil];
	[self setBodyTextView:nil];
	[self setLoadingView:nil];
	[self setMessageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(recipeWillPost:) name:RecipeWillPostNotification object:self.appDelegate];
	[center addObserver:self selector:@selector(recipeDidPost:) name:RecipeDidPostNotification object:self.appDelegate];
	[center addObserver:self selector:@selector(recipeDidFailToPost:) name:RecipeDidFailToPostNotification object:self.appDelegate];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.titleTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

- (void)recipeWillPost:(NSNotification*)notification {
	[self.titleTextField resignFirstResponder];
	[self.bodyTextView resignFirstResponder];
	
	self.loadingView.hidden = NO;
	self.loadingView.alpha = 0;
	self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	
	self.messageLabel.text = @"Posting new recipe...";
	
	[UIView animateWithDuration:0.3 animations:^{
		self.loadingView.alpha = 1;
	}];
}

- (void)recipeDidPost:(NSNotification*)notification {
	self.messageLabel.text = @"New recipe successfuly posted!";
	
	double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[UIView animateWithDuration:0.3 animations:^{
			self.loadingView.alpha = 0;
		} completion:^(BOOL a) {
			self.loadingView.hidden = YES;
			[self cancelButtonTap:nil];
		}];
	});
}

- (void)recipeDidFailToPost:(NSNotification*)notification {
	self.messageLabel.text = @"Failed to post (;;";
	
	double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[UIView animateWithDuration:0.3 animations:^{
			self.loadingView.alpha = 0;
		} completion:^(BOOL a) {
			self.loadingView.hidden = YES;
		}];
	});
}

#pragma mark - Actions

- (IBAction)cancelButtonTap:(id)sender {
	[self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)doneButtonTap:(id)sender {
	NSString* title = self.titleTextField.text;
	NSString* body = self.bodyTextView.text;
	
	if (!title || !body) {
		return;
	}
	
	[self.appDelegate postRecipeWithTitle:title body:body];
}

@end
