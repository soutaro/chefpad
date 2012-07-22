//
//  NewRecipeViewController.h
//  chef-pad-client
//
//  Created by 松本 宗太郎 on 2012/07/16.
//  Copyright (c) 2012年 Soutaro Matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRecipeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (IBAction)cancelButtonTap:(id)sender;
- (IBAction)doneButtonTap:(id)sender;

@end
