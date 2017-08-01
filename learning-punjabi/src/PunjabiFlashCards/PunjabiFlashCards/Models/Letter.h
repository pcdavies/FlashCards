//
//  Letter.h
//  PunjabiFlashCards
//
//  Created by Home on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Letter : NSObject

@property(nonatomic, retain) NSString * imageFile;
@property(nonatomic, retain) NSString * soundFile;
@property(nonatomic, retain) NSString * letterString;
@property(nonatomic, retain) NSMutableArray * points;  // Contain PointLocation objects, which contain CGPoints
@property(nonatomic, retain) NSMutableArray * strokes;  // Contains Stork objects



@end
