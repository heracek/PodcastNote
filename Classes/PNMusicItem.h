//
//  PNMusicItem.h
//  PodcastNote
//
//  Created by Tomas Horacek on 19.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MediaPlayer/MediaPlayer.h>


@interface PNMusicItem :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * composer;
@property (nonatomic, retain) NSNumber * isCompilation;
@property (nonatomic, retain) NSString * albumArtist;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * albumTrackCount;
@property (nonatomic, retain) NSNumber * playbackDuration;
@property (nonatomic, retain) NSNumber * persistentID;
@property (nonatomic, retain) NSNumber * discCount;
@property (nonatomic, retain) NSString * albumTitle;
@property (nonatomic, retain) NSDate * lastPlayedDate;
@property (nonatomic, retain) NSString * lyrics;
@property (nonatomic, retain) NSNumber * playCount;
@property (nonatomic, retain) NSNumber * mediaType;
@property (nonatomic, retain) NSString * podcastTitle;
@property (nonatomic, retain) NSData * artwork;
@property (nonatomic, retain) NSNumber * albumTrackNumber;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * discNumber;
@property (nonatomic, retain) NSNumber * skipCount;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSSet* notes;

@end


@interface PNMusicItem (CoreDataGeneratedAccessors)

+ (PNMusicItem *)musicItemFromMediaItem:(MPMediaItem *)mediaItem inManagedObjectContext:(NSManagedObjectContext *)moc;

- (void)addNotesObject:(NSManagedObject *)value;
- (void)removeNotesObject:(NSManagedObject *)value;
- (void)addNotes:(NSSet *)value;
- (void)removeNotes:(NSSet *)value;

@end

