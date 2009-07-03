//
//  PNWriteAndViewNotesTableViewController.h
//  PodcastNote
//
//  Created by Tomas Horacek on 3.7.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PNWriteAndViewNotesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UIButton *_addNoteButton;
}

@end
