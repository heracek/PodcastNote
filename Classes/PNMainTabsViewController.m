//
//  PNMainTabsViewController.m
//  PodcastNote
//
//  Created by Tomas Horacek on 12.6.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PNMainTabsViewController.h"


@implementation PNMainTabsViewController

@synthesize nowPlayingBarButtonItem=_nowPlayingBarButtonItem;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize musicItemsTableViewController=_musicItemsTableViewController;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"MainTabs";
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"PNMainTabsViewController viewDidLoad");
    [super viewDidLoad];
	
//	UINavigationController *vc = [self.viewControllers objectAtIndex:0];
//	vc.topViewController.navigationItem.rightBarButtonItem = _nowPlayingBarButtonItem;
	
	_musicItemsTableViewController.managedObjectContext = _managedObjectContext;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.musicItemsTableViewController = nil;
}

#pragma mark getters and setters

- (void)setManagedObjectContext:(NSManagedObjectContext *)newManagedObjectContext {
	[newManagedObjectContext retain];
	[_managedObjectContext release];
	_managedObjectContext = newManagedObjectContext;
	
	if (_musicItemsTableViewController) {
		_musicItemsTableViewController.managedObjectContext = newManagedObjectContext;
	}
}

#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}


@end
