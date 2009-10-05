//
//  PNWriteAndViewNotesTableViewController.h
//  PodcastNote
//
//  Created by Tomas Horacek on 3.7.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol PNWriteAndViewNotesTableViewControllerDelegate

@required
- (NSTimeInterval)getPlaybackTime;
- (MPMediaItem *)getNowPlayingMediaItem;
- (NSManagedObjectContext *)managedObjectContext;

@end


@interface PNWriteAndViewNotesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UIView *_addNoteTextViewWithControls;
	IBOutlet UIButton *_addNoteButton;
	IBOutlet UIButton *_addNoteSetPlaybackTime;
	IBOutlet UITextView *_addNoteTextView;
	
	BOOL _isEditingNote;
	NSTimeInterval _playbackTime;
	MPMediaItem *_mediaItem;
	
	NSMutableArray *_notesArray;
	
	id<PNWriteAndViewNotesTableViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *notesArray;
@property (nonatomic, retain) MPMediaItem *mediaItem;

@property (nonatomic, retain) id<PNWriteAndViewNotesTableViewControllerDelegate> delegate;

- (IBAction)addNoteButtonAction:(id)sender;
- (IBAction)addNoteSetPlaybackTimeAction:(id)sender;
- (IBAction)doneEditingButtonaAction:(id)sender;
- (void)noteAddedToMediaItem:(MPMediaItem *)mediaItem atPlaybackTime:(NSTimeInterval)playbackTime withText:(NSString *)text;

@end
