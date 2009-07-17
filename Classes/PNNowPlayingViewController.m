//
//  PNNowPlayingViewController.m
//  PodcastNote
//
//  Created by Tomas Horacek on 24.6.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "PNNowPlayingViewController.h"

@implementation PNNowPlayingViewController

@synthesize musicPlayerController = _musicPlayerController;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self == nil) {
        return nil;
    }
	
	self.title = @"Now Playing";
	
    return self;
}

- (void)updateNowPlayingInfo:(id)notification {
	MPMediaItem *nowPlayingItem = [_musicPlayerController nowPlayingItem];
	_artistLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
	_titleLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
	_albumTitleLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	
	UIImage *artworkImage = nil;// = noArtworkImage;
	
	MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty: MPMediaItemPropertyArtwork];	
	if (artwork) {
		artworkImage = [artwork imageWithSize: CGSizeMake (40, 40)];
	}
	
	[_artworkButtonView setBackgroundImage:artworkImage forState:UIControlStateNormal];
}

- (void) registerForMediaPlayerNotifications {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver:self
						   selector:@selector(updateNowPlayingInfo:)
							   name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
							 object:_musicPlayerController];
	
	[_musicPlayerController beginGeneratingPlaybackNotifications];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	_writeAndViewNotesTVC.delegate = self;
	
	UIBarButtonItem *newBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationBackButton];
	self.navigationItem.leftBarButtonItem = newBackButtonItem;
	[newBackButtonItem release];
	
	self.navigationItem.titleView = _navigationItemTitleView;
	
	_artworkButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
	_artworkButtonView.frame = CGRectMake(0, 0, 40, 40);
	UIBarButtonItem *newArtworkItem = [[UIBarButtonItem alloc] initWithCustomView:_artworkButtonView];
	self.navigationItem.rightBarButtonItem = newArtworkItem;
	[newArtworkItem release];
	
	[self updateNowPlayingInfo:nil];
	
	_writeAndViewNotesTVC.view.frame = self.view.bounds;
	[self.view addSubview:_writeAndViewNotesTVC.view];
	
	[self registerForMediaPlayerNotifications];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)viewWillDisappear:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

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
	[_musicPlayerController endGeneratingPlaybackNotifications];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object:_musicPlayerController];
	
	[_nowPlayingBackButton release];
    [super dealloc];
}

- (void)backButtonAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark PNWriteAndViewNotesTableViewControllerDelegate methods

- (NSTimeInterval)getPlaybackTime {
	if (!_musicPlayerController) {
		return 0.0;
	}
	
	return _musicPlayerController.currentPlaybackTime;
}

- (void)noteAddedAtPlaybackTime:(NSTimeInterval)playbackTime withText:(NSString *)text {
	NSLog(@"add note '%@' at time: %f", text, playbackTime);
}
@end
