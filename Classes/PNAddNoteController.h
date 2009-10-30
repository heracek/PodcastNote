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

@interface PNAddNoteController : UIViewController {
	PNMusicItem *_musicItem;
	MPMusicPlayerController *_musicPlayerController;
	NSManagedObjectContext *_managedObjectContext;
	
	UITextView *_textView;
}

@property (nonatomic, retain) PNMusicItem *musicItem;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayerController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
