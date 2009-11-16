//
//  PNAddNoteController.h
//  PodcastNote
//
//  Created by Tomas Horacek on 28.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PNMusicItem.h"
#import "PNNote.h"

@class PNAddNoteController;

@protocol PNAddNoteControllerDelegate
- (void)addNoteViewController:(PNAddNoteController *)controller didFinishWithSave:(BOOL)save;
@end


@interface PNAddNoteController : UIViewController {
	id <PNAddNoteControllerDelegate> _delegate;
	PNMusicItem *_musicItem;
	NSTimeInterval _markerPlaybackTime;
	MPMusicPlayerController *_musicPlayerController;
	PNNote *_note;
	
	UITextView *_textView;
}

@property (nonatomic, assign) id <PNAddNoteControllerDelegate> delegate;
@property (nonatomic, retain) PNMusicItem *musicItem;
@property (nonatomic, assign) NSTimeInterval markerPlaybackTime;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayerController;
@property (nonatomic, retain) PNNote *note;

@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
