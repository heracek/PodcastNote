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

@synthesize tableView=_tableView;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize notesArray=_notesArray;
@synthesize mediaItem=_mediaItem;
@synthesize managedObjectContext=_managedObjectContext;
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




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)viewWillAppear {
	[self.tableView reloadData];
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
	self.fetchedResultsController = nil;
}


- (void)dealloc {
	[_notesArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // iPhone OS 3.0 workaround (not needed on 3.1)
	NSUInteger count = [[_fetchedResultsController sections] count];
	
    if (count == 0) {
        count = 1;
    }
	
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // iPhone OS 3.0 incompatibility workaround (not required on 3.1)
	NSArray *sections = [_fetchedResultsController sections];
    NSUInteger count = 0;
	
    if ([sections count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        count = [sectionInfo numberOfObjects];
    }
	
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// iPhone OS 3.0 incompatibility workaround (not required on 3.1)
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteCellIdentifier];
	
	if (cell == nil) {
		cell = [[[PNNoteTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kNoteCellIdentifier] autorelease];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
	PNNoteTableViewCell *cell = (PNNoteTableViewCell *)aCell;
	
	PNNote* note = (PNNote *)[_fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.timeText = [self stringFromPlaybackTime:[note.playbackTime doubleValue]];
	cell.noteText = note.text;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the managed object.
		[_managedObjectContext deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![_managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }
}

#pragma mark -
#pragma mark Selection and moving

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSManagedObjectContext *moc = _managedObjectContext;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"PNNote" inManagedObjectContext:moc];
	[fetchRequest setEntity:entity];
	
	PNMusicItem *musicItem = (PNMusicItem *)[self getOrCreatePNMusicItemFromMediaItem:_mediaItem];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"musicItem == %@", musicItem];
	[fetchRequest setPredicate:predicate];
	
	// Create the sort descriptors array.
	NSSortDescriptor *playbackTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"playbackTime" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:playbackTimeDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
															 initWithFetchRequest:fetchRequest
															 managedObjectContext:moc
															 sectionNameKeyPath:nil
															 cacheName:nil];
	self.fetchedResultsController = aFetchedResultsController;
	_fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[playbackTimeDescriptor release];
	[sortDescriptors release];
	
	return _fetchedResultsController;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	UITableView *tableView = self.tableView;
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
					 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
					 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.tableView;
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath]
					atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			// Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section]
					 withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
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

- (void)autosetPlaybackTimeAndItsButtonLabel {
	_playbackTime = 0;
	if (_delegate != nil) {
		_playbackTime = [_delegate getPlaybackTime];
	}
	NSString *stringPlaibackTime = [self stringFromPlaybackTime:_playbackTime];
	[_addNoteSetPlaybackTime setTitle:[NSString stringWithFormat:@"[%@]", stringPlaibackTime] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark button actions

- (IBAction)addNoteSetPlaybackTimeAction:(id)sender {
	[self autosetPlaybackTimeAndItsButtonLabel];
}

- (IBAction)addNoteButtonAction:(id)sender {
	self.mediaItem = _mediaItem;
	[self autosetPlaybackTimeAndItsButtonLabel];
	[self startEditingAddNote];
}

- (IBAction)doneEditingButtonaAction:(id)sender {
	[self stopEditingAddNote];
	
	[self noteAddedToMediaItem:_mediaItem atPlaybackTime:_playbackTime withText:_addNoteTextView.text];
}

- (PNMusicItem *)getOrCreatePNMusicItemFromMediaItem:(MPMediaItem *)mediaItem {
	NSManagedObjectContext *moc = _managedObjectContext;
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
	
	pnMusicItem.mediaType = [mediaItem valueForProperty:MPMediaItemPropertyMediaType];
	pnMusicItem.title = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
	pnMusicItem.albumTitle = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	pnMusicItem.artist = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
	pnMusicItem.albumArtist = [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
	pnMusicItem.genre = [mediaItem valueForProperty:MPMediaItemPropertyGenre];
	pnMusicItem.composer = [mediaItem valueForProperty:MPMediaItemPropertyComposer];
	pnMusicItem.playbackDuration = [mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
	pnMusicItem.albumTrackNumber = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
	pnMusicItem.albumTrackCount = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTrackCount];
	pnMusicItem.discNumber = [mediaItem valueForProperty:MPMediaItemPropertyDiscNumber];
	pnMusicItem.discCount = [mediaItem valueForProperty:MPMediaItemPropertyDiscCount];
	
	//pnMusicItem.artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
	
	pnMusicItem.lyrics = [mediaItem valueForProperty:MPMediaItemPropertyLyrics];
	pnMusicItem.isCompilation = [mediaItem valueForProperty:MPMediaItemPropertyIsCompilation];
	
	pnMusicItem.podcastTitle = [mediaItem valueForProperty:MPMediaItemPropertyPodcastTitle];
	
	pnMusicItem.playCount = [mediaItem valueForProperty:MPMediaItemPropertyPlayCount];
	pnMusicItem.skipCount = [mediaItem valueForProperty:MPMediaItemPropertySkipCount];
	pnMusicItem.rating = [mediaItem valueForProperty:MPMediaItemPropertyRating];
	pnMusicItem.lastPlayedDate = [mediaItem valueForProperty:MPMediaItemPropertyLastPlayedDate];
	
	return pnMusicItem;
}

- (void)noteAddedToMediaItem:(MPMediaItem *)mediaItem atPlaybackTime:(NSTimeInterval)playbackTime withText:(NSString *)text {
	NSLog(@"add note '%@' at time: %f for mediaItem: %@", text, playbackTime, mediaItem);
	
	PNNote *note = (PNNote *)[NSEntityDescription insertNewObjectForEntityForName:@"PNNote" inManagedObjectContext:_managedObjectContext];
	note.musicItem = [self getOrCreatePNMusicItemFromMediaItem:mediaItem];
	note.text = text;
	note.timeAdded = [NSDate date];
	note.playbackTime = [NSNumber numberWithDouble:playbackTime];
	
	NSError *error;
	if (![_managedObjectContext save:&error]) {
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
