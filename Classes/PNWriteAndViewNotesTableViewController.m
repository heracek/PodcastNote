//
//  PNWriteAndViewNotesTableViewController.m
//  PodcastNote
//
//  Created by Tomas Horacek on 3.7.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PNWriteAndViewNotesTableViewController.h"


@implementation PNWriteAndViewNotesTableViewController

@synthesize delegate=_delegete;

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
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewController methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteCellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero 
									   reuseIdentifier:kNoteCellIdentifier] autorelease];
	}
	
	cell.textLabel.text = [NSString stringWithFormat:@"Item %d", row];
	
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
	_playbackTime = [_delegete getPlaybackTime];
	[_addNoteSetPlaybackTime setTitle:[NSString stringWithFormat:@"%f", _playbackTime] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark button actions

- (IBAction)addNoteSetPlaybackTimeAction:(id)sender {
	[self autosetPlaybackTimeAndItsButtonLabel];
}

- (IBAction)addNoteButtonAction:(id)sender {
	[self autosetPlaybackTimeAndItsButtonLabel];
	[self startEditingAddNote];
}

- (IBAction)doneEditingButtonaAction:(id)sender {
	[self stopEditingAddNote];
	
	[_delegete noteAddedAtPlaybackTime:_playbackTime withText:_addNoteTextView.text];
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
