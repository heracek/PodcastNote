//
//  PNNowPlayingViewController.h
//  PodcastNote
//
//  Created by Tomas Horacek on 24.6.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PNNowPlayingViewController : UIViewController {
	MPMusicPlayerController *_musicPlayerController;
	
	IBOutlet UIButton *_navigationBackButton;
	IBOutlet UIView *_navigationItemTitleView;
	UIButton *_artworkButtonView;
	
	IBOutlet UILabel *_artistLabel;
	IBOutlet UILabel *_titleLabel;
	IBOutlet UILabel *_albumTitleLabel;
	IBOutlet UIBarButtonItem *_nowPlayingBackButton;
}

@property (nonatomic, retain) MPMusicPlayerController *musicPlayerController;

- (IBAction)backButtonAction:(id)sender;

@end
