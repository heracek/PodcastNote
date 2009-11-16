//
//  PNWriteAndViewNotesTableViewController.h
//  PodcastNote
//
//  Created by Tomas Horacek on 3.7.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PNMusicItem.h"
#import "PNAddNoteController.h"

@protocol PNWriteAndViewNotesTableViewControllerDelegate

@required
- (NSTimeInterval)playbackTime;
- (UINavigationController*)navigationController;
- (void)dismissModalViewControllerAnimated:(BOOL)animated;
@end


@interface PNWriteAndViewNotesTableViewController : UIViewController <PNAddNoteControllerDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *_tableView;
	IBOutlet UIView *_addNoteTextViewWithControls;
	IBOutlet UIButton *_addNoteButton;
	IBOutlet UIButton *_addNoteSetPlaybackTime;
	IBOutlet UITextView *_addNoteTextView;
	
	NSFetchedResultsController *_fetchedResultsController;
	
	BOOL _isEditingNote;
	NSTimeInterval _playbackTime;
	PNMusicItem *_musicItem;
	MPMusicPlayerController *_musicPlayerController;
	
	NSManagedObjectContext *_managedObjectContext;
	
	id<PNWriteAndViewNotesTableViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) PNMusicItem *musicItem;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayerController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) id<PNWriteAndViewNotesTableViewControllerDelegate> delegate;

- (IBAction)addNoteButtonAction:(id)sender;
- (IBAction)addNoteSetPlaybackTimeAction:(id)sender;
- (IBAction)doneEditingButtonaAction:(id)sender;
- (void)noteAddedToMusicItem:(PNMusicItem *)musicItem atPlaybackTime:(NSTimeInterval)playbackTime withText:(NSString *)text;
- (NSString *)stringFromPlaybackTime:(NSTimeInterval)playbackTime;
- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath;

@end
