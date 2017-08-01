//
//  LetterPoint.h
//  PunjabiFlashCards
//
//  Created by Home on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define NOT_DRAWN_OVER  0
#define DRAWN_OVER      1

#import <Foundation/Foundation.h>

@interface LetterPoint : NSObject
@property (weak, nonatomic) IBOutlet UIImageView * pointImageView;
@property(nonatomic, assign) int pointStatus;
@property(nonatomic, assign) int drawOverNext;


@end
