//
//  PNNote.h
//  PodcastNote
//
//  Created by Tomas Horacek on 19.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class PNMusicItem;

@interface PNNote :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * timeAdded;
@property (nonatomic, retain) NSDate * timeEdited;
@property (nonatomic, retain) NSNumber * playbackTime;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) PNMusicItem * musicItem;

@end



