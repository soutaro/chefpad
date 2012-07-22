//
//  LoginViewController.m
//  chef-pad-client
//
//  Created by 松本 宗太郎 on 2012/07/16.
//  Copyright (c) 2012年 Soutaro Matsumoto. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginContainerView;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize failureMessageLabel;
@synthesize loginActivityIndicator;
@synthesize kawagoeImageView;

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
	
//	self.loginContainerView.hidden = YES;
}

- (void)viewDidUnload
{
	[self setLoginContainerView:nil];
	[self setEmailTextField:nil];
	[self setPasswordTextField:nil];
	[self setFailureMessageLabel:nil];
	[self setLoginActivityIndicator:nil];
    [self setKawagoeImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.failureMessageLabel.hidden = YES;
	[self.loginActivityIndicator stopAnimating];
	
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(loginWillStart:) name:LoginWillStartNotification object:self.appDelegate];
	[center addObserver:self selector:@selector(loginDidSuccess:) name:LoginDidSuccessNotification object:self.appDelegate];
	[center addObserver:self selector:@selector(loginDidFailure:) name:LoginDidFailureNotification object:self.appDelegate];
	
	self.kawagoeImageView.alpha = 1;
	self.loginContainerView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.loginContainerView.hidden = NO;
	self.loginContainerView.alpha = 0;
	
	if (self.appDelegate.authToken) {
		[self performSegueWithIdentifier:@"loginSegue" sender:self];
		return;
	}
	
	[UIView animateWithDuration:0.3 animations:^{
		self.kawagoeImageView.alpha = 0.2;
		self.loginContainerView.alpha = 1;
	} completion:^(BOOL a){}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginButtonTap:(id)sender {
	NSString* email = self.emailTextField.text;
	NSString* password = self.passwordTextField.text;
	
	[self.appDelegate loginWithEmail:email password:password];
}

- (void)loginWillStart:(NSNotification*)notification {
	self.failureMessageLabel.hidden = YES;
	[self.loginActivityIndicator startAnimating];
}

- (void)loginDidSuccess:(NSNotification*)notification {
	[self.loginActivityIndicator stopAnimating];
	
	NSString* token = [notification.userInfo objectForKey:@"token"];
	self.appDelegate.authToken = token;
		
	[self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (void)loginDidFailure:(NSNotification*)notification {
	self.failureMessageLabel.hidden = NO;
	[self.loginActivityIndicator stopAnimating];
}

@end
