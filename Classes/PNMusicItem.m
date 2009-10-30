// 
//  PNMusicItem.m
//  PodcastNote
//
//  Created by Tomas Horacek on 19.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PNMusicItem.h"


@implementation PNMusicItem 

@dynamic composer;
@dynamic isCompilation;
@dynamic albumArtist;
@dynamic title;
@dynamic albumTrackCount;
@dynamic playbackDuration;
@dynamic persistentID;
@dynamic discCount;
@dynamic albumTitle;
@dynamic lastPlayedDate;
@dynamic lyrics;
@dynamic playCount;
@dynamic mediaType;
@dynamic podcastTitle;
@dynamic artwork;
@dynamic albumTrackNumber;
@dynamic artist;
@dynamic discNumber;
@dynamic skipCount;
@dynamic genre;
@dynamic rating;
@dynamic notes;

+ (PNMusicItem *)musicItemFromMediaItem:(MPMediaItem *)mediaItem inManagedObjectContext:(NSManagedObjectContext *)moc {
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
	
	return [pnMusicItem autorelease];
}

@end
