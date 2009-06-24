//
//  PNNowPlayingViewController.m
//  PodcastNote
//
//  Created by Tomas Horacek on 24.6.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PNNowPlayingViewController.h"

@implementation PNNowPlayingViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self == nil) {
        return nil;
    }
	
	self.title = @"Now Playing";
	
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)viewWillDisappear:(BOOL)animated {
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
}

- (void)dealloc {
    [super dealloc];
}


@end
