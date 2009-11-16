//
//  PNAddNoteController.m
//  PodcastNote
//
//  Created by Tomas Horacek on 28.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PNAddNoteController.h"


@implementation PNAddNoteController

@synthesize delegate = _delegate;
@synthesize musicItem = _musicItem;
@synthesize markerPlaybackTime = _markerPlaybackTime;
@synthesize musicPlayerController = _musicPlayerController;
@synthesize note = _note;

@synthesize textView = _textView;
@synthesize markerLabel = _markerLabel;
@synthesize nowPlayingTime = _nowPlayingTime;
@synthesize nowPlayingTimeRemaning = _nowPlayingTimeRemaning;
@synthesize nowPlayingSlider = _nowPlayingSlider;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self == nil) {
        return self;
    }
	
	return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Y"
																   style:UIBarButtonItemStyleDone
																  target:self
																  action:@selector(save:)];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"N"
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(cancel:)];
	
	self.navigationItem.rightBarButtonItem = saveButton;
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	[saveButton release];
	[cancelButton release];
	
	_textView.font = [UIFont systemFontOfSize:16.0];
	CGRect origTextFrame = _textView.frame;
	_textView.frame = CGRectMake(0, 0, origTextFrame.size.width, origTextFrame.origin.y + origTextFrame.size.height);
	_textView.contentSize = _textView.frame.size;
	UIEdgeInsets newTextInsets = {0.0, 0.0, 0.0, 0.0};
	newTextInsets.top = origTextFrame.origin.y;
	_textView.contentInset = newTextInsets;
	_textView.scrollIndicatorInsets = newTextInsets;
	[_textView becomeFirstResponder];
	
	[self refreshNowPlayingTimeViews];
	[self refreshMarkerLabel];
	
	_refreshNowPlayingTimeViewsTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
																		target:self
																	  selector:@selector(refreshNowPlayingTimeViewsTimerAction:)
																	  userInfo:nil
																	   repeats:YES];
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
	
	self.textView = nil;
	self.markerLabel = nil;
	[_refreshNowPlayingTimeViewsTimer invalidate];
	_refreshNowPlayingTimeViewsTimer = nil;
}


- (void)dealloc {
	self.delegate = nil;
	self.musicItem = nil;
	self.musicPlayerController = nil;
	self.note = nil;
	
	[super dealloc];
}

#pragma mark --

- (NSString *)stringFromPlaybackTime:(NSTimeInterval)playbackTime {
	int intPlaybecTime = rint(playbackTime);
	int hours = intPlaybecTime / (60 * 60);
	int minutes = (intPlaybecTime / 60) % 60;
	int seconds = intPlaybecTime % 60;
	
	NSString *stringPlaibackTime;
	if (hours != 0) {
		stringPlaibackTime = [NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds];
	} else {
		stringPlaibackTime = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
	}
	
	return stringPlaibackTime;
}

- (void)refreshMarkerLabel {
	_markerLabel.text = [NSString stringWithFormat:@"Marker: %@",
						 [self stringFromPlaybackTime:_markerPlaybackTime]];
}

- (void)refreshNowPlayingTimeViews {
	NSTimeInterval currentPlaybackTime = [_musicPlayerController currentPlaybackTime];
	NSTimeInterval playbackDuration = [_musicItem.playbackDuration doubleValue];
	
	_nowPlayingTime.text = [self stringFromPlaybackTime:currentPlaybackTime];
	_nowPlayingTimeRemaning.text = [NSString stringWithFormat:@"-%@",
									[self stringFromPlaybackTime:playbackDuration - currentPlaybackTime]];
	_nowPlayingSlider.value = currentPlaybackTime / playbackDuration;
}

#pragma mark --
#pragma mark actions

- (IBAction)save:(id)sender {
	_note.musicItem = _musicItem;
	_note.text = _textView.text;
	_note.playbackTime = [NSNumber numberWithDouble:_markerPlaybackTime];
	_note.timeAdded = [NSDate date];
	_note.timeEdited = _note.timeAdded;
	
	[_delegate addNoteViewController:self didFinishWithSave:YES];
}

- (IBAction)cancel:(id)sender {
	[_delegate addNoteViewController:self didFinishWithSave:NO];
}

- (IBAction)setMarkerAction:(id)sender {
	_markerPlaybackTime = [_musicPlayerController currentPlaybackTime];
	
	[self refreshNowPlayingTimeViews];
	[self refreshMarkerLabel];
}

- (void)refreshNowPlayingTimeViewsTimerAction:(id)sender {
	[self refreshNowPlayingTimeViews];
}

@end
