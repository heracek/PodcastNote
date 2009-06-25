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
	UILabel *_titleLabel;
}

@property (nonatomic, retain) MPMusicPlayerController *musicPlayerController;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@end
