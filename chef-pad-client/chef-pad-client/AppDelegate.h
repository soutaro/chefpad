//
//  AppDelegate.h
//  chef-pad-client
//
//  Created by 松本 宗太郎 on 2012/07/16.
//  Copyright (c) 2012年 Soutaro Matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LoginWillStartNotification @"LoginDidStartNotification"
#define LoginDidSuccessNotification @"LoginDidSuccessNotification"
#define LoginDidFailureNotification @"LoginDidFailureNotification"

#define RecipeWillLoadNotification @"RecipeWillLoadNotification"
#define RecipeDidLoadNotification @"RecipeDidLoadNotification"
#define RecipeDidFailToLoadNotification @"RecipeDidFailToLoadNotification"

#define RecipeWillPostNotification @"RecipeWillPostNotification"
#define RecipeDidPostNotification @"RecipeDidPostNotification"
#define RecipeDidFailToPostNotification @"RecipeDidFailToPostNotification"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark - Chefpad API

- (void)loginWithEmail:(NSString*)email password:(NSString*)password;
- (void)loadRecipe;
- (void)postRecipeWithTitle:(NSString*)title body:(NSString*)body;

@property (nonatomic, readonly) NSArray* recipes;

#pragma mark -

- (NSURL*)APIURLWithComponents:(NSString*)apiComponents;

@property (strong, nonatomic) NSString* apiEndpoint;
@property (strong, nonatomic) NSString* authToken;

@end

@interface UIViewController (CPC)

@property (readonly, nonatomic) AppDelegate* appDelegate;

@end