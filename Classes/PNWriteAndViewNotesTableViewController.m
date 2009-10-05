//
//  PNWriteAndViewNotesTableViewController.m
//  PodcastNote
//
//  Created by Tomas Horacek on 3.7.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PNWriteAndViewNotesTableViewController.h"
#import "PNNoteTableViewCell.h"
#import "PNMusicItem.h"
#import "PNNote.h"

@implementation PNWriteAndViewNotesTableViewController

@synthesize notesArray=_notesArray;
@synthesize mediaItem=_mediaItem;

@synthesize delegate=_delegate;

static NSString *kNoteCellIdentifier = @"NoteCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self == nil) {
        return nil;
    }
	
	_isEditingNote = NO;
	
    return self;
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
}


- (void)dealloc {
	[_notesArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewController methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	PNNoteTableViewCell *cell = (PNNoteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kNoteCellIdentifier];
	
	if (cell == nil) {
		cell = [[[PNNoteTableViewCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:kNoteCellIdentifier] autorelease];
	}
	
	cell.timeText = [NSString stringWithFormat:@"[1:00:%02d]", row + 1];
	cell.noteText = [NSString stringWithFormat:@"Item %d", row];
	
	return cell;
}

#pragma mark -
#pragma mark Adding note

- (void)startEditingAddNote {
	_isEditingNote = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	_addNoteTextView.text = @"";
	_addNoteTextViewWithControls.alpha = 0.0;
	[self.view addSubview:_addNoteTextViewWithControls];
	[_addNoteTextView becomeFirstResponder];
}

- (void)stopEditingAddNote {
	_isEditingNote = NO;
	[_addNoteTextView resignFirstResponder];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	[_addNoteTextViewWithControls removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	if (_isEditingNote) {
		[self stopEditingAddNote];
	}
}

- (void)autosetPlaybackTimeAndItsButtonLabel {
	_playbackTime = [_delegate getPlaybackTime];
	
	int intPlaybecTime = rint(_playbackTime);
	int hours = intPlaybecTime / (60 * 60);
	int minutes = (intPlaybecTime / 60) % 60;
	int seconds = intPlaybecTime % 60;
	
	NSString *stringPlaibackTime;
	if (hours != 0) {
		stringPlaibackTime = [NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds];
	} else {
		stringPlaibackTime = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
	}
	
	[_addNoteSetPlaybackTime setTitle:[NSString stringWithFormat:@"[%@]", stringPlaibackTime] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark button actions

- (IBAction)addNoteSetPlaybackTimeAction:(id)sender {
	[self autosetPlaybackTimeAndItsButtonLabel];
}

- (IBAction)addNoteButtonAction:(id)sender {
	self.mediaItem = [_delegate getNowPlayingMediaItem];
	[self autosetPlaybackTimeAndItsButtonLabel];
	[self startEditingAddNote];
}

- (IBAction)doneEditingButtonaAction:(id)sender {
	[self stopEditingAddNote];
	
	[self noteAddedToMediaItem:_mediaItem atPlaybackTime:_playbackTime withText:_addNoteTextView.text];
}

- (PNMusicItem *)getOrCreatePNMusicItemFromMediaItem:(MPMediaItem *)mediaItem {
	NSManagedObjectContext *moc = [_delegate managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription 
											  entityForName:@"PNMusicItem"
											  inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSNumber *persistentID = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"persistentID == %@", persistentID];
	[request setPredicate:predicate];
	
	[request setFetchLimit:1];
	
	PNMusicItem *pnMusicItem = nil;
	
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if (array == nil || [array count] == 0) {
		pnMusicItem = (PNMusicItem *)[NSEntityDescription
									  insertNewObjectForEntityForName:@"PNMusicItem"
									  inManagedObjectContext:moc];
		pnMusicItem.persistentID = persistentID;
	} else {
		pnMusicItem = [array objectAtIndex:0];
	}
	
	return pnMusicItem;
}

- (void)noteAddedToMediaItem:(MPMediaItem *)mediaItem atPlaybackTime:(NSTimeInterval)playbackTime withText:(NSString *)text {
	NSLog(@"add note '%@' at time: %f", text, playbackTime);
	
	PNNote *note = (PNNote *)[NSEntityDescription insertNewObjectForEntityForName:@"PNNote" inManagedObjectContext:[_delegate managedObjectContext]];
	note.musicItem = [self getOrCreatePNMusicItemFromMediaItem:mediaItem];
	note.text = text;
	note.timeAdded = [NSDate date];
	note.playbackTime = [NSNumber numberWithDouble:playbackTime];
	
	NSError *error;
	if (![[_delegate managedObjectContext] save:&error]) {
		// Handle the error.
		NSLog(@"Error while saving note: %@, %@", error, [error userInfo]);
	}
	// TODO: reload data
}

#pragma mark -

- (void)keyboardWillShow:(NSNotification *)aNotification {
	// the keyboard is showing so resize the table's height
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.size.height -= keyboardRect.size.height;
    
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
	_addNoteTextViewWithControls.alpha = 1.0;
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    // the keyboard is hiding reset the table's height
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.size.height += keyboardRect.size.height;
	
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
	_addNoteTextViewWithControls.alpha = 0.0;
    self.view.frame = frame;
    [UIView commitAnimations];
}

@end
