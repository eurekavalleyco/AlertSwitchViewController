//
//  AKSwitchView.m
//  Sandbox
//
//  Created by Ken M. Haggerty on 7/10/15.
//  Copyright (c) 2015 MCMDI. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "AKSwitchView.h"
#import "AKDebugger.h"
#import "AKGenerics.h"

#pragma mark - // DEFINITIONS (Private) //

@interface AKSwitchView ()
@property (nonatomic, strong) UIView *containerView;
- (void)setup;
- (void)teardown;
@end

@implementation AKSwitchView

#pragma mark - // SETTERS AND GETTERS //

@synthesize label = _label;
@synthesize buttonSwitch = _buttonSwitch;
@synthesize containerView = _containerView;

- (void)setContainerView:(UIView *)containerView
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetter customCategories:@[AKD_UI] message:nil];
    
    if ([containerView isEqual:_containerView] || (!containerView && !_containerView)) return;
    
    _containerView = containerView;
    
    if (![self.subviews containsObject:containerView]) [self addSubview:containerView];
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = NSDictionaryOfVariableBindings(containerView);
    NSMutableArray *customConstraints = [[NSMutableArray alloc] init];
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[%@]|", stringFromVariable(containerView)] options:0 metrics:nil views:views]];
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[%@]|", stringFromVariable(containerView)] options:0 metrics:nil views:views]];
    [self addConstraints:customConstraints];
    [self setNeedsUpdateConstraints];
}

#pragma mark - // INITS AND LOADS //

- (id)initWithFrame:(CGRect)frame
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    self = [super initWithFrame:frame];
    if (!self)
    {
        [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeCritical methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:[NSString stringWithFormat:@"Could not initialize %@", stringFromVariable(self)]];
        return nil;
    }
    
    [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    self = [super initWithCoder:aDecoder];
    if (!self)
    {
        [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeCritical methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:[NSString stringWithFormat:@"Could not initialize %@", stringFromVariable(self)]];
        return nil;
    }
    
    [self setup];
    return self;
}

- (void)awakeFromNib
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    [super awakeFromNib];
    [self setup];
}

- (void)dealloc
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    [self teardown];
}

#pragma mark - // PUBLIC METHODS //

#pragma mark - // DELEGATED METHODS //

#pragma mark - // OVERWRITTEN METHODS //

#pragma mark - // PRIVATE METHODS //

- (void)setup
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
    
    UIView *view;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in objects)
    {
        if ([object isKindOfClass:[UIView class]])
        {
            view = object;
            break;
        }
    }
    if (!view) return;
    
    [self setContainerView:view];
}

- (void)teardown
{
    [AKDebugger logMethod:METHOD_NAME logType:AKLogTypeMethodName methodType:AKMethodTypeSetup customCategories:@[AKD_UI] message:nil];
}

@end