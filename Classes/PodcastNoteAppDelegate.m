//
//  PodcastNoteAppDelegate.m
//  PodcastNote
//
//  Created by Tomas Horacek on 12.6.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "PNNowPlayingViewController.h"
#import "PodcastNoteAppDelegate.h"
#import "PNWriteAndViewNotesTableViewController.h"

@implementation PodcastNoteAppDelegate

@synthesize window;
@synthesize musicPlayerController = _musicPlayerController;
@synthesize navigationController = _navigationController;
@synthesize nowPlayingViewController = _nowPlayingViewController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	self.musicPlayerController = [MPMusicPlayerController iPodMusicPlayer];
	
	_tabsController.managedObjectContext = self.managedObjectContext;
	
	_nowPlayingViewController = [[PNNowPlayingViewController alloc] initWithNibName:@"PNNowPlayingViewController" bundle:nil];
	_nowPlayingViewController.managedObjectContext = self.managedObjectContext;
	_nowPlayingViewController.musicPlayerController = _musicPlayerController;
	
	UIBarButtonItem *nowPlayingBarButtonItem = [[UIBarButtonItem alloc]
												initWithTitle:@"Now Playing"
												style:UIBarButtonItemStyleBordered
												target:self
												action:@selector(nowPlayingBarButtonItemAction:)];
	_tabsController.nowPlayingBarButtonItem = nowPlayingBarButtonItem;
	
	UINavigationController *activeNavigationController = [_tabsController.viewControllers objectAtIndex:0];
	activeNavigationController.topViewController.navigationItem.rightBarButtonItem = nowPlayingBarButtonItem;
	[activeNavigationController pushViewController:_nowPlayingViewController animated:NO];
	
	[window addSubview:_tabsController.view];
	
    [window makeKeyAndVisible];
}

-(void) nowPlayingBarButtonItemAction:(id) sender {
	UINavigationController *nc = (UINavigationController *)_tabsController.selectedViewController;
	[nc pushViewController:_nowPlayingViewController animated:YES];
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"PodcastNote.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_tabsController release];
	[_nowPlayingViewController release];
//	[_navigationController release];
	
	[_musicPlayerController release];
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
}


@end

