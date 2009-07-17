//
//  PNWriteAndViewNotesTableViewController.h
//  PodcastNote
//
//  Created by Tomas Horacek on 3.7.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PNWriteAndViewNotesTableViewControllerDelegate

@required
- (NSTimeInterval)getPlaybackTime;
- (void)noteAddedAtPlaybackTime:(NSTimeInterval)playbackTime withText:(NSString *)text;

@end


@interface PNWriteAndViewNotesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UIView *_addNoteTextViewWithControls;
	IBOutlet UIButton *_addNoteButton;
	IBOutlet UIButton *_addNoteSetPlaybackTime;
	IBOutlet UITextView *_addNoteTextView;
	
	BOOL _isEditingNote;
	NSTimeInterval _playbackTime;
	
	id<PNWriteAndViewNotesTableViewControllerDelegate> _delegete;
}

@property (nonatomic, retain) id<PNWriteAndViewNotesTableViewControllerDelegate> delegate;

- (IBAction)addNoteButtonAction:(id)sender;
- (IBAction)addNoteSetPlaybackTimeAction:(id)sender;
- (IBAction)doneEditingButtonaAction:(id)sender;

@end
