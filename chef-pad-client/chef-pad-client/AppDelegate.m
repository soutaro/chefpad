//
//  AppDelegate.m
//  chef-pad-client
//
//  Created by 松本 宗太郎 on 2012/07/16.
//  Copyright (c) 2012年 Soutaro Matsumoto. All rights reserved.
//

#import "AppDelegate.h"

#define IsHttpError(code) (400 <= code && code < 600)

@implementation AppDelegate {
	NSArray* recipes_;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Chefpad API

- (void)loginWithEmail:(NSString *)email password:(NSString *)password {
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
	
	[center postNotificationName:LoginWillStartNotification object:self];
	
	NSData* requestBody = [NSJSONSerialization dataWithJSONObject:@{ @"email": email, @"password": password } options:0 error:nil];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/session", self.apiEndpoint]];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:requestBody];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
		
		if (error || IsHttpError([(NSHTTPURLResponse*)response statusCode])) {
			[center postNotificationName:LoginDidFailureNotification object:self userInfo:nil];
			return;
		}
		
		NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		
		[center postNotificationName:LoginDidSuccessNotification object:self userInfo:dictionary];
	}];
}

- (void)loadRecipe {
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
	
	[center postNotificationName:RecipeWillLoadNotification object:self];
	
	NSURL* url = [self APIURLWithComponents:@"recipes"];
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
		
		if (error || IsHttpError([(NSHTTPURLResponse*)response statusCode])) {
			[center postNotificationName:RecipeDidFailToLoadNotification object:self userInfo:nil];
			return;
		}
		
		NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		[center postNotificationName:RecipeDidLoadNotification object:self userInfo:dictionary];
	}];
}

- (void)postRecipeWithTitle:(NSString *)title body:(NSString *)body {
	NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
	
	[center postNotificationName:RecipeWillPostNotification object:self];
	
	NSDictionary* recipe = @{ @"title":title, @"body":body };
	NSData* data = [NSJSONSerialization dataWithJSONObject:@{ @"recipe": recipe } options:0 error:nil];
	
	NSURL* url = [self APIURLWithComponents:@"/recipes"];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:data];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
		
		if (error || IsHttpError([(NSHTTPURLResponse*)response statusCode])) {
			[center postNotificationName:RecipeDidFailToPostNotification object:self userInfo:nil];
			return;
		}
		
		NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		
		[center postNotificationName:RecipeDidPostNotification object:self userInfo:dictionary];
	}];
}

- (NSArray *)recipes {
	if (!recipes_) {
		recipes_ = [NSArray array];
	}
	
	return recipes_;
}

#pragma mark -

- (NSString *)apiEndpoint {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* defaultEndPoint = @"http://liszt.local:3000";
	NSString* endpoint = [defaults stringForKey:@"api-end-point"];
	
	if (endpoint) {
		return endpoint;
	} else {
		return defaultEndPoint;
	}
	
}

- (void)setApiEndpoint:(NSString *)apiEndpoint {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:apiEndpoint forKey:@"api-end-point"];
}

- (NSString *)authToken {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	return [defaults stringForKey:@"auth-token"];
}

- (void)setAuthToken:(NSString *)authToken {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:authToken forKey:@"auth-token"];
}

- (NSURL *)APIURLWithComponents:(NSString *)apiComponents {
	NSString* string = [NSString stringWithFormat:@"%@/api/%@/%@", self.apiEndpoint, self.authToken, apiComponents];
	return [NSURL URLWithString:string];
}

@end


@implementation UIViewController (CPC)

- (AppDelegate *)appDelegate {
	return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end