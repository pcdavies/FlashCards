//
//  FlashCardResources.h
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LetterDrawingViewController;
@interface FlashCardResources :NSObject;

@property(nonatomic, retain) NSArray * contentList;
@property(nonatomic, retain) NSMutableArray * letters;
@property(nonatomic, assign) int currentCardNumber;
@property(nonatomic, assign) int currentLetter;

// LOAD THESE INTO AN ARRAY SO THAT THERE CAN BE AN UNDETERMINED NUMBER OF POINTS
 


+(FlashCardResources *)sharedFlashCardResources;
-(void)printResources;


@end
