//
//  Stroke.h
//  PunjabiFlashCards
//
//  Created by Home on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class PointLocation;

@interface Stroke : NSObject

@property(nonatomic, retain) NSMutableArray * points;  // Contain PointLocation objects, which contain CGPoints
@property(nonatomic, retain) UIBezierPath *trackPath;
@property(nonatomic, retain) PointLocation *startPoint;
@property(nonatomic, retain) PointLocation *endPoint;
@property(nonatomic, assign) int startRotation;
@property(nonatomic, assign) int endRotation;


@end
