//
//  PNNoteTableViewCell.h
//  PodcastNote
//
//  Created by Tomas Horacek on 15.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"

// example table view cell with first text normal, last text bold (like address book contacts)
@interface PNNoteTableViewCell : ABTableViewCell
{
	NSString *timeText;
	NSString *noteText;
}

@property (nonatomic, copy) NSString *timeText;
@property (nonatomic, copy) NSString *noteText;

@end
