/*!
 * \file MHTabBarController.m
 *
 * Copyright (c) 2011 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHTabBarController.h"
#import "MHTabBarController-Protected.h"

static const float TAB_BAR_HEIGHT = 44.0f;
static const NSInteger TAG_OFFSET = 1000;

@implementation MHTabBarController

@synthesize viewControllers;
@synthesize selectedIndex;
@synthesize delegate;
@synthesize tabButtonsContainerView;
@synthesize contentContainerView;
@synthesize indicatorImageView;

@synthesize tabTitleFont;
@synthesize tabShadowOffset;
@synthesize tabInactiveBackgroundImage;
@synthesize tabActiveBackgroundImage;
@synthesize tabInactiveTitleColor;
@synthesize tabActiveTitleColor;
@synthesize tabInactiveShadowColor;
@synthesize tabActiveShadowColor;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        tabShadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

- (void)centerIndicatorOnButton:(UIButton *)button
{
	CGRect rect = indicatorImageView.frame;
    CGPoint buttonCenter = [[indicatorImageView superview] convertPoint:button.center fromView:button.superview];
	rect.origin.x = buttonCenter.x - floorf(indicatorImageView.frame.size.width/2.0f);
	indicatorImageView.frame = rect;
	indicatorImageView.hidden = NO;
}

- (void)removeTabButtons
{
	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
		[button removeFromSuperview];
}

- (void)addTabButtons
{
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TAG_OFFSET + index;
		[button setTitle:viewController.title forState:UIControlStateNormal];
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
		button.titleLabel.font = tabTitleFont;
		button.titleLabel.shadowOffset = tabShadowOffset;
                
        [button setBackgroundImage:tabInactiveBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:tabActiveBackgroundImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:tabActiveBackgroundImage forState:UIControlStateSelected];
        [button setBackgroundImage:tabActiveBackgroundImage forState:UIControlStateHighlighted | UIControlStateSelected];
        
        [button setTitleColor:tabInactiveTitleColor forState:UIControlStateNormal];
        [button setTitleColor:tabActiveTitleColor forState:UIControlStateHighlighted];
        [button setTitleColor:tabActiveTitleColor forState:UIControlStateSelected];
        [button setTitleColor:tabActiveTitleColor forState:UIControlStateHighlighted | UIControlStateSelected];
        
        [button setTitleShadowColor:tabInactiveShadowColor forState:UIControlStateNormal];
        [button setTitleShadowColor:tabActiveShadowColor forState:UIControlStateHighlighted];
        [button setTitleShadowColor:tabActiveShadowColor forState:UIControlStateSelected];
        [button setTitleShadowColor:tabActiveShadowColor forState:UIControlStateHighlighted | UIControlStateSelected];
        
		[button setSelected:NO];
		[tabButtonsContainerView addSubview:button];

		++index;
	}
}

- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];

	// Force redraw of the previously active tab.
	NSUInteger lastIndex = selectedIndex;
	selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];

	CGRect rect = CGRectMake(0, 0, floorf(tabButtonsContainerView.bounds.size.width / count), tabButtonsContainerView.bounds.size.height);

	indicatorImageView.hidden = YES;

	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
			rect.size.width = tabButtonsContainerView.bounds.size.width - rect.origin.x;

		button.frame = rect;
		rect.origin.x += rect.size.width;

		if (index == self.selectedIndex)
			[self centerIndicatorOnButton:button];

		++index;
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    if (tabButtonsContainerView == nil) {
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, TAB_BAR_HEIGHT);
        tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
        tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:tabButtonsContainerView];
    }

    if (contentContainerView == nil) {
        CGRect rect = CGRectMake(0, tabButtonsContainerView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - tabButtonsContainerView.frame.size.height);
        contentContainerView = [[UIView alloc] initWithFrame:rect];
        contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:contentContainerView];
    }
    
    if (indicatorImageView == nil) {
        indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHTabBarIndicator"]];
        CGRect rect = indicatorImageView.frame;
        rect.origin.y = CGRectGetMaxY(tabButtonsContainerView.frame) - rect.size.height;
        indicatorImageView.frame = rect;
        [self.view addSubview:indicatorImageView];
    }
    
    if (tabTitleFont == nil) {
        tabTitleFont = [UIFont boldSystemFontOfSize:18];
    }
    if (tabActiveBackgroundImage == nil) {
        tabActiveBackgroundImage = [[UIImage imageNamed:@"MHTabBarActiveTab"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    }
    if (tabInactiveBackgroundImage == nil) {
        tabInactiveBackgroundImage = [[UIImage imageNamed:@"MHTabBarInactiveTab"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    }
    if (tabInactiveTitleColor == nil) {
        tabInactiveTitleColor = [UIColor colorWithRed:175/255.0f green:85/255.0f blue:58/255.0f alpha:1.0f];
    }
    if (tabActiveTitleColor == nil) {
        tabActiveTitleColor = [UIColor whiteColor];
    }
    if (tabInactiveShadowColor == nil) {
        tabInactiveShadowColor = [UIColor whiteColor];
    }
    if (tabActiveShadowColor == nil) {
        tabActiveShadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    }
    
	[self reloadTabButtons];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	tabButtonsContainerView = nil;
	contentContainerView = nil;
	indicatorImageView = nil;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Only rotate if all child view controllers agree on the new orientation.
	for (UIViewController *viewController in self.viewControllers)
	{
		if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
			return NO;
	}
	return YES;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
	NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");

	UIViewController *oldSelectedViewController = self.selectedViewController;

	// Remove the old child view controllers.
	for (UIViewController *viewController in viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}

	viewControllers = [newViewControllers copy];

	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		selectedIndex = newIndex;
	else if (newIndex < [viewControllers count])
		selectedIndex = newIndex;
	else
		selectedIndex = 0;

	// Add the new child view controllers.
	for (UIViewController *viewController in viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}

	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");

	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = [self.viewControllers objectAtIndex:newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}

	if (![self isViewLoaded])
	{
		selectedIndex = newSelectedIndex;
	}
	else if (selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;

		if (selectedIndex != NSNotFound)
		{
			UIButton *fromButton = (UIButton *)[tabButtonsContainerView viewWithTag:TAG_OFFSET + selectedIndex];
			fromButton.selected = NO;
			fromViewController = self.selectedViewController;
		}

		NSUInteger oldSelectedIndex = selectedIndex;
		selectedIndex = newSelectedIndex;

		UIButton *toButton;
		if (selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TAG_OFFSET + selectedIndex];
			toButton.selected = YES;
			toViewController = self.selectedViewController;
		}

		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;

			toViewController.view.frame = rect;
			tabButtonsContainerView.userInteractionEnabled = NO;

			[self transitionFromViewController:fromViewController
				toViewController:toViewController
				duration:0.3
				options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
				animations:^
				{
					CGRect rect = fromViewController.view.frame;
					if (oldSelectedIndex < newSelectedIndex)
						rect.origin.x = -rect.size.width;
					else
						rect.origin.x = rect.size.width;

					fromViewController.view.frame = rect;
					toViewController.view.frame = contentContainerView.bounds;
					[self centerIndicatorOnButton:toButton];
				}
				completion:^(BOOL finished)
				{
					tabButtonsContainerView.userInteractionEnabled = YES;

					if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
						[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
				}];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];

			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return [self.viewControllers objectAtIndex:self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender
{
	[self setSelectedIndex:sender.tag - TAG_OFFSET animated:YES];
}

@end
