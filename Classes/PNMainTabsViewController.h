//
//  PNMainTabsViewController.h
//  PodcastNote
//
//  Created by Tomas Horacek on 12.6.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNMusicItemsTableViewController.h"

@interface PNMainTabsViewController : UITabBarController {
	UIBarButtonItem *_nowPlayingBarButtonItem;
	NSManagedObjectContext *_managedObjectContext;
	
	IBOutlet PNMusicItemsTableViewController *_musicItemsTableViewController;
}

@property (nonatomic, retain) UIBarButtonItem *nowPlayingBarButtonItem;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) PNMusicItemsTableViewController *musicItemsTableViewController;

@end
