//
//  LetterPoint.m
//  PunjabiFlashCards
//
//  Created by Home on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LetterPoint.h"

@implementation LetterPoint

@synthesize pointImageView;
@synthesize pointStatus;
@synthesize drawOverNext;
-(id)init {
    
    pointImageView = nil;
    pointStatus = NOT_DRAWN_OVER;
    drawOverNext = false;
    return self;
}

@end
