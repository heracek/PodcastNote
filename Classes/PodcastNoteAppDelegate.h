//
//  PodcastNoteAppDelegate.h
//  PodcastNote
//
//  Created by Tomas Horacek on 12.6.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface PodcastNoteAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
    UIWindow *window;
	
	MPMusicPlayerController *_musicPlayerController;
	
	UINavigationController *_navigationController;
	PNNowPlayingViewController *_nowPlayingViewController;
}

- (IBAction)saveAction:sender;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) MPMusicPlayerController *musicPlayerController;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet PNNowPlayingViewController *nowPlayingViewController;

@end

