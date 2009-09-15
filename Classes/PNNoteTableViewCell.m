//
//  PNNoteTableViewCell.m
//  PodcastNote
//
//  Created by Tomas Horacek on 15.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PNNoteTableViewCell.h"

@implementation PNNoteTableViewCell

@synthesize timeText;
@synthesize noteText;

static UIFont *timeTextFont = nil;
static UIFont *noteTextFont = nil;

+ (void)initialize
{
	if(self == [PNNoteTableViewCell class])
	{
		timeTextFont = [[UIFont boldSystemFontOfSize:16] retain];
		noteTextFont = [[UIFont systemFontOfSize:16] retain];
		// this is a good spot to load any graphics you might be drawing in -drawContentView:
		// just load them and retain them here (ONLY if they're small enough that you don't care about them wasting memory)
		// the idea is to do as LITTLE work (e.g. allocations) in -drawContentView: as possible
	}
}

- (void)dealloc
{
	[timeText release];
	[noteText release];
    [super dealloc];
}

// the reason I don't synthesize setters for 'firstText' and 'lastText' is because I need to 
// call -setNeedsDisplay when they change

- (void)setTimeText:(NSString *)s
{
	[timeText release];
	timeText = [s copy];
	[self setNeedsDisplay]; 
}

- (void)setNoteText:(NSString *)s
{
	[noteText release];
	noteText = [s copy];
	[self setNeedsDisplay]; 
}

- (void)drawContentView:(CGRect)r
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor blackColor];
	
	if(self.selected)
	{
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint p;
	p.x = 3;
	p.y = 1;
	
	[textColor set];
	CGSize s = [timeText drawAtPoint:p withFont:timeTextFont];
	
	p.y += s.height + 1; // space between words
	[noteText drawAtPoint:p withFont:noteTextFont];
}

@end
