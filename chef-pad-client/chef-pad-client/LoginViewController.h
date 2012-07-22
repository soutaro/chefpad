//
//  LoginViewController.h
//  chef-pad-client
//
//  Created by 松本 宗太郎 on 2012/07/16.
//  Copyright (c) 2012年 Soutaro Matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *loginContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *failureMessageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *kawagoeImageView;

- (IBAction)loginButtonTap:(id)sender;

@end
