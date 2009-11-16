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

@synthesize textView=_textView;

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
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark --
#pragma mark UINavigationBar items actions

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

@end
