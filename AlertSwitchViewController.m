//
//  AlertSwitchViewController.m
//  AlertSwitchViewController
//
//  Created by Ken M. Haggerty on 5/11/15.
//  Copyright (c) 2015 Eureka Valley Co. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "AlertSwitchViewController.h"
#import "AKDebugger.h"
#import "AKGenerics.h"
#import "SystemInfo.h"
#import "AKSwitchView.h"

#pragma mark - // DEFINITIONS (Private) //

#define ANIMATION_DURATION 0.225
#define DEFAULT_ON NO
#define ROW_HEIGHT 50.0
#define MAX_HEIGHT_PERCENTAGE 50.0

@interface AlertSwitchViewController ()
@property (nonatomic, strong, readwrite) NSMutableArray *textForSwitches;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) NSMutableArray *switchViews;
- (void)setup;
- (void)teardown;
- (void)layoutSwitchViews:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)updatePreferredContentSizeWithSize:(CGSize)size;
- (AKSwitchView *)createSwitchAtIndex:(NSUInteger)index withText:(NSString *)text on:(BOOL)on;
- (void)addTarget:(id)target selector:(SEL)selector forAllSwitchesWithControlEvents:(UIControlEvents)events;
- (void)removeTarget:(id)target selector:(SEL)selector forAllSwitchesWithControlEvents:(UIControlEvents)events;
@end

@implementation AlertSwitchViewController

#pragma mark - // SETTERS AND GETTERS //

@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize textForSwitches = _textForSwitches;
@synthesize viewController = _viewController;
@synthesize switchViews = _switchViews;

- (void)setDelegate:(id<SwitchDelegate>)delegate
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    if ([delegate isEqual:_delegate] || (!delegate && !_delegate)) return;
    
    [self removeTarget:_delegate selector:@selector(actionSwitchDidToggle:) forAllSwitchesWithControlEvents:UIControlEventValueChanged];
    _delegate = delegate;
    [self addTarget:delegate selector:@selector(actionSwitchDidToggle:) forAllSwitchesWithControlEvents:UIControlEventValueChanged];
}

- (UIScrollView *)scrollView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    if (_scrollView) return _scrollView;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.viewController.view.bounds];
    [self.viewController.view addSubview:_scrollView];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = NSDictionaryOfVariableBindings(_scrollView);
    NSMutableArray *customConstraints = [[NSMutableArray alloc] init];
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[%@]|", stringFromVariable(_scrollView)] options:0 metrics:nil views:views]];
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[%@]|", stringFromVariable(_scrollView)] options:0 metrics:nil views:views]];
    [self.viewController.view addConstraints:customConstraints];
    [self.viewController.view setNeedsUpdateConstraints];
    [_scrollView setContentSize:CGSizeMake(self.viewController.view.bounds.size.width, ROW_HEIGHT*self.switchViews.count)];
    for (int i = 0; i < self.switchViews.count; i++)
    {
        [_scrollView addSubview:[self.switchViews objectAtIndex:i]];
    }
    return _scrollView;
}

- (NSMutableArray *)textForSwitches
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    if (_textForSwitches) return _textForSwitches;
    
    _textForSwitches = [[NSMutableArray alloc] init];
    return _textForSwitches;
}

- (UIViewController *)viewController
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    if (_viewController) return _viewController;
    
    _viewController = [[UIViewController alloc] init];
    [_viewController.view setBounds:((UIViewController *)[self valueForKey:@"contentViewController"]).view.bounds];
    return _viewController;
}

- (NSMutableArray *)switchViews
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    if (_switchViews) return _switchViews;
    
    _switchViews = [[NSMutableArray alloc] initWithCapacity:self.textForSwitches.count];
    for (int i = 0; i < self.textForSwitches.count; i++)
    {
        [_switchViews addObject:[self createSwitchAtIndex:i withText:[self.textForSwitches objectAtIndex:i] on:DEFAULT_ON]];
    }
    [self layoutSwitchViews:NO completion:nil];
    return _switchViews;
}

#pragma mark - // INITS AND LOADS //

- (void)viewDidLoad
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewWillAppear:animated];
    
    [self updatePreferredContentSizeWithSize:[SystemInfo screenSize]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewDidAppear:animated];
    
    [self.scrollView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    CGRect rect = CGRectMake(self.scrollView.contentInset.left, self.scrollView.contentInset.top, self.scrollView.frame.size.width, 1.0);
    [self.scrollView scrollRectToVisible:rect animated:NO];
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [self teardown];
}

#pragma mark - // PUBLIC METHODS //

- (UISwitch *)switchAtIndex:(NSUInteger)index
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    if (index >= self.switchViews.count) return nil;
    
    return ((AKSwitchView *)[self.switchViews objectAtIndex:index]).buttonSwitch;
}

- (NSNumber *)indexForSwitch:(UISwitch *)buttonSwitch
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeGetter tags:@[AKD_UI] message:nil];
    
    for (int i = 0; i < self.switchViews.count; i++)
    {
        if ([buttonSwitch isEqual:((AKSwitchView *)[self.switchViews objectAtIndex:i]).buttonSwitch])
        {
            return [NSNumber numberWithInteger:i];
        }
    }
    
    return nil;
}

- (void)addSwitchWithText:(NSString *)text on:(BOOL)on
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    [self insertSwitchAtIndex:self.switchViews.count withText:text on:on animated:NO];
}

- (void)insertSwitchAtIndex:(NSUInteger)index withText:(NSString *)text on:(BOOL)on animated:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    AKSwitchView *switchView = [self createSwitchAtIndex:index withText:text on:on];
    if (!switchView) return;
    
    [self.switchViews insertObject:switchView atIndex:index];
    [self showSwitchAtIndex:index animated:animated completion:nil];
}

- (void)setText:(NSString *)text forLabelAtIndex:(NSUInteger)index
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    [self.textForSwitches replaceObjectAtIndex:index withObject:text];
    [((AKSwitchView *)[self.switchViews objectAtIndex:index]).label setText:text];
}

- (void)removeSwitchAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    if (index >= self.switchViews.count) return;
    
    [self hideSwitchAtIndex:index animated:animated completion:^(BOOL finished){
        [self.textForSwitches removeObjectAtIndex:index];
        [self.switchViews removeObjectAtIndex:index];
    }];
}

- (void)showSwitchAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    if (index >= self.switchViews.count) return;
    
    [[self.switchViews objectAtIndex:index] setHidden:NO];
    [self layoutSwitchViews:animated completion:completion];
}

- (void)hideSwitchAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeUnspecified tags:@[AKD_UI] message:nil];
    
    if (index >= self.switchViews.count) return;
    
    [[self.switchViews objectAtIndex:index] setHidden:YES];
    [self layoutSwitchViews:animated completion:completion];
}

#pragma mark - // DELEGATED METHODS //

#pragma mark - // OVERWRITTEN METHODS //

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self updatePreferredContentSizeWithSize:size];
}

#pragma mark - // PRIVATE METHODS //

- (void)setup
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:nil message:nil];
    
    [self setValue:self.viewController forKey:@"contentViewController"];
}

- (void)teardown
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:nil message:nil];
}

- (void)layoutSwitchViews:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    NSMutableArray *hiddenViews = [[NSMutableArray alloc] init];
    CGFloat oldContentHeight = self.scrollView.contentSize.height;
    NSTimeInterval duration = 0.0;
    if (animated) duration = ANIMATION_DURATION;
    [UIView animateWithDuration:duration animations:^{
        AKSwitchView *switchView;
        CGFloat y = 0.0;
        for (int i = 0; i < self.switchViews.count; i++)
        {
            switchView = [self.switchViews objectAtIndex:i];
            if (switchView.hidden)
            {
                [switchView setHidden:NO];
                [hiddenViews addObject:switchView];
                [switchView setAlpha:0.0];
            }
            else
            {
                [switchView setFrame:CGRectMake(0.0, y, self.scrollView.bounds.size.width, ROW_HEIGHT)];
                [switchView setAlpha:1.0];
                y += ROW_HEIGHT;
            }
            if (![self.scrollView.subviews containsObject:switchView]) [self.scrollView addSubview:switchView];
        }
        [self.scrollView setContentSize:CGSizeMake(self.viewController.view.bounds.size.width, y)];
    } completion:^(BOOL finished){
        for (UIView *view in hiddenViews)
        {
            [view setHidden:YES];
        }
        if ((self.scrollView.contentSize.height > self.scrollView.frame.size.height) && (oldContentHeight <= self.scrollView.frame.size.height))
        {
            [self.scrollView flashScrollIndicators];
        }
        if (completion) completion(finished);
    }];
}

- (void)updatePreferredContentSizeWithSize:(CGSize)size
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup tags:@[AKD_UI] message:nil];
    
    CGSize preferredContentSize = self.scrollView.contentSize;
    CGFloat maxHeight = size.height*MAX_HEIGHT_PERCENTAGE/100.0;
    if (preferredContentSize.height > maxHeight) preferredContentSize = CGSizeMake(preferredContentSize.width, maxHeight);
    [self.viewController setPreferredContentSize:preferredContentSize];
}

- (AKSwitchView *)createSwitchAtIndex:(NSUInteger)index withText:(NSString *)text on:(BOOL)on
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeCreator tags:@[AKD_UI] message:nil];
    
    if (index > self.switchViews.count) return nil;
    
    [self.textForSwitches insertObject:text atIndex:index];
    AKSwitchView *switchView = [[AKSwitchView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.scrollView.bounds.size.width, ROW_HEIGHT)];
    [switchView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin)];
    [switchView.label setText:text];
    [switchView.buttonSwitch setOn:on];
    if (self.delegate) [switchView.buttonSwitch addTarget:self.delegate action:@selector(actionSwitchDidToggle:) forControlEvents:UIControlEventValueChanged];
    return switchView;
}

- (void)addTarget:(id)target selector:(SEL)selector forAllSwitchesWithControlEvents:(UIControlEvents)events
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    for (AKSwitchView *switchView in self.switchViews)
    {
        [switchView.buttonSwitch addTarget:target action:selector forControlEvents:events];
    }
}

- (void)removeTarget:(id)target selector:(SEL)selector forAllSwitchesWithControlEvents:(UIControlEvents)events
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter tags:@[AKD_UI] message:nil];
    
    for (AKSwitchView *switchView in self.switchViews)
    {
        [switchView.buttonSwitch removeTarget:target action:selector forControlEvents:events];
    }
}

@end
