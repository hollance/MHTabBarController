
#import "AppDelegate.h"
#import "ListViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	ListViewController *listViewController1 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController2 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController3 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	
	listViewController1.title = @"Tab 1";
	listViewController2.title = @"Tab 2";
	listViewController3.title = @"Tab 3";

	listViewController2.tabBarItem.image = [UIImage imageNamed:@"Taijitu"];
	listViewController2.tabBarItem.imageInsets = UIEdgeInsetsMake(0.0f, -4.0f, 0.0f, 0.0f);
	listViewController2.tabBarItem.titlePositionAdjustment = UIOffsetMake(4.0f, 0.0f);

	NSArray *viewControllers = @[listViewController1, listViewController2, listViewController3];
	MHTabBarController *tabBarController = [[MHTabBarController alloc] init];

	tabBarController.delegate = self;
	tabBarController.viewControllers = viewControllers;

	// Uncomment this to select "Tab 2".
	//tabBarController.selectedIndex = 1;

	// Uncomment this to select "Tab 3".
	//tabBarController.selectedViewController = listViewController3;

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
	return YES;
}

- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);

	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);

	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
}

@end
