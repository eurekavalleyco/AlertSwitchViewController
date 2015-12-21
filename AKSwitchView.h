//
//  AKSwitchView.h
//  Sandbox
//
//  Created by Ken M. Haggerty on 7/10/15.
//  Copyright (c) 2015 MCMDI. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // PROTOCOLS //

#pragma mark - // DEFINITIONS (Public) //

@interface AKSwitchView : UIView
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UISwitch *buttonSwitch;
@end
