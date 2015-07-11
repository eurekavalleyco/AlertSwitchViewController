//
//  AlertSwitchViewController.h
//  AlertSwitchViewController
//
//  Created by Ken M. Haggerty on 6/11/15.
//  Copyright (c) 2015 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // PROTOCOLS //

@protocol SwitchDelegate <NSObject>
@optional
- (IBAction)actionSwitchDidToggle:(UISwitch *)sender;
@end

#pragma mark - // DEFINITIONS (Public) //

@interface AlertSwitchViewController : UIAlertController
@property (nonatomic, strong) id <SwitchDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) NSMutableArray *textForSwitches;
- (UISwitch *)switchAtIndex:(NSUInteger)index;
- (NSNumber *)indexForSwitch:(UISwitch *)buttonSwitch;
- (void)addSwitchWithText:(NSString *)text on:(BOOL)on;
- (void)insertSwitchAtIndex:(NSUInteger)index withText:(NSString *)text on:(BOOL)on animated:(BOOL)animated;
- (void)setText:(NSString *)text forLabelAtIndex:(NSUInteger)index;
- (void)removeSwitchAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)showSwitchAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)hideSwitchAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
@end