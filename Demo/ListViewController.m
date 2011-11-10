
#import "ListViewController.h"
#import "MHTabBarController.h"

@implementation ListViewController

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSLog(@"%@ viewDidLoad", self.title);
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	NSLog(@"%@ viewDidUnload", self.title);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSLog(@"%@ viewWillAppear", self.title);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	NSLog(@"%@ viewDidAppear", self.title);
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	NSLog(@"%@ viewWillDisappear", self.title);
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	NSLog(@"%@ viewDidDisappear", self.title);
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
	[super willMoveToParentViewController:parent];
	NSLog(@"%@ willMoveToParentViewController %@", self.title, parent);
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
	[super didMoveToParentViewController:parent];
	NSLog(@"%@ didMoveToParentViewController %@", self.title, parent);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	NSLog(@"%@ willRotateToInterfaceOrientation", self.title);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - Row %d", self.title, indexPath.row];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"%@, parent is %@", self.title, self.parentViewController);

	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	ListViewController *listViewController1 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController2 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	
	listViewController1.title = @"Another Tab 1";
	listViewController2.title = @"Another Tab 2";

	NSArray *viewControllers = [NSArray arrayWithObjects:listViewController1, listViewController2, nil];
	MHTabBarController *tabBarController = [[MHTabBarController alloc] init];
	tabBarController.viewControllers = viewControllers;
	tabBarController.title = @"Modal Screen";
	tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
		initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];

	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
	navController.navigationBar.tintColor = [UIColor colorWithRed:70/255.0f green:80/255.0f blue:90/255.0f alpha:1.0f];
	[self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
