//
//  FlashCardResources.m
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlashCardResources.h"
#import "DebugMacro.h"
#import "LetterDrawingViewController.h"
#import "Letter.h"
#import "PointLocation.h"
#import "Stroke.h"
#import <QuartzCore/QuartzCore.h>


static FlashCardResources * shared = NULL;


@implementation FlashCardResources

@synthesize contentList, currentCardNumber, letters, currentLetter;



+(FlashCardResources *)sharedFlashCardResources  
{
	@synchronized(self) {
		if ( !shared || shared == NULL ) {
			shared = [[FlashCardResources alloc] init];
		}
	}
	return shared;
}




-(id) init
{
	if ( self = [super init] ) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"numbers_iPhone" ofType:@"plist"];
        self.contentList = [NSArray arrayWithContentsOfFile:path];
        self.currentCardNumber = 1;
        self.currentLetter = 0;
        
        DebugLog(@"!!!!!!!! Card numbers loaded = %d",[self.contentList count]);
        
        // NSArray * test = [NSArray arrayWithContentsOfFile:path];
        
              
        
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"letters_iPhone" ofType:@"plist"];
        NSArray * list = [NSArray arrayWithContentsOfFile:path2];
        
        
        letters = [[NSMutableArray alloc] init];
        
        DebugLog(@"Size of letters = %d",[list count]);
        
        for ( NSDictionary * letterItem in list) {
            Letter * letter = [[Letter alloc] init];
            
 
            letter.imageFile = [letterItem valueForKey:@"imageKey"];
            letter.soundFile = [letterItem valueForKey:@"soundKey"];
            letter.letterString = [letterItem valueForKey:@"letterKey"];
            
            
            // DebugLog(@"imageFile = %@, soundFile = %@",[letterItem valueForKey:@"imageKey"], letter.soundFile);
            
            
            NSArray *plistStrokes = [letterItem valueForKey:@"strokes"];
                        
           //  DebugLog(@"Stroke Lists = %d",[plistStrokes count]);
            
            letter.strokes = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [plistStrokes count]; i++ ) {
                Stroke *stroke = [[Stroke alloc] init];
                
                NSDictionary *plistStroke = [plistStrokes objectAtIndex:i];
                NSString * str = [plistStroke valueForKey:@"start"];
                int index = [str rangeOfString:@" "].location;
                
                NSString *x = [str substringToIndex:index];
                NSString *y = [str substringFromIndex:index + 1];   
                
                //DebugLog(@" Start x=%@, y=%@",x,y);
                
                
                stroke.startPoint = [[PointLocation alloc] init];
                stroke.endPoint = [[PointLocation alloc] init];
                
                
                stroke.startPoint.location = CGPointMake([x floatValue], [y floatValue]);
                //DebugLog(@" StartLocation x=%f, y=%f",stroke.startPoint.location.x,stroke.startPoint.location.y);

                
                
                str = [plistStroke valueForKey:@"end"];
                index = [str rangeOfString:@" "].location;
                
                x = [str substringToIndex:index];
                y = [str substringFromIndex:index + 1];   
                
                stroke.endPoint.location = CGPointMake([x floatValue], [y floatValue]);

 
                str = [plistStroke valueForKey:@"startRotation"];
                
                
                stroke.startRotation = [str intValue];
                
                str = [plistStroke valueForKey:@"endRotation"];
                
                
                stroke.endRotation = [str intValue];
                
                
                NSArray *plistStrokeArray = [plistStroke valueForKey:@"stroke"];
                
                stroke.points = [[NSMutableArray alloc] init];
                
               
                for (int i = 0; i < [plistStrokeArray count]; i++) { 
                    
                    
                    int index = [[plistStrokeArray objectAtIndex:i] rangeOfString:@" "].location;
                    
                    NSString * str = [plistStrokeArray objectAtIndex:i];
                    
                    NSString * x = [str substringToIndex:index];
                    NSString *y = [str substringFromIndex:index + 1];
                    
                    
                    PointLocation * loc = [[PointLocation alloc] init];
                    
                    
                    loc.location = CGPointMake([x floatValue], [y floatValue]);
                    
                    [stroke.points addObject:loc]; // Add the points
                    
                    
                    //DebugLog(@"    Adding Points x=%f, y=%f",loc.location.x, loc.location.y);
                    
                }
                
                
                stroke.trackPath = [[UIBezierPath alloc] init];
                
                [stroke.trackPath moveToPoint:stroke.startPoint.location];
                
               //DebugLog(@"Setting TrackPath points=%d",[stroke.points count]); 
                
                
                for ( int i = 0; i < [stroke.points count]; i = i+3 ) {// three x,y's used to a UIBezierPath
                    
                    // NOTE: The way that the UIBezier path is setup, is by 3 points.
                    // The previous location of the path is assumed to have been identified.
                    // Next, loc1 equals the next endpoint.
                    // loc2 is a point between the previous point and the endpoint/loc1, but closest to the previous point
                    // loc3 is a point between loc2 and the endpoint/loc1
                    //
                    // For easier readability, when setting the points in the plist, they are entered
                    // as sequential points after the previous point to the endpoint.
                    
                    PointLocation * loc1 = [stroke.points objectAtIndex:i+2];
                    PointLocation * loc2 = [stroke.points objectAtIndex:i];
                    PointLocation * loc3 = [stroke.points objectAtIndex:i+1];
                    
                    //DebugLog(@"  Adding Points %d, %d, %d",i,i+1,i+2);
 
                    
                    [stroke.trackPath addCurveToPoint:loc1.location 
                                        controlPoint1:loc2.location
                                        controlPoint2:loc3.location];
        
                    //DebugLog(@"  Added Points %d, %d, %d",i,i+1,i+2);

                }
                
                
                [letter.strokes addObject:stroke]; 

                
            }

            NSArray *plistPoints = [letterItem valueForKey:@"points"];
            
            letter.points = [[NSMutableArray alloc] init];
            
            // DebugLog(@"   Processing %d points",[plistPoints count]);
            
            for (int i = 0; i < [plistPoints count]; i++ ) {
                
            
               int index = [[plistPoints objectAtIndex:i] rangeOfString:@" "].location;
                
                NSString * str = [plistPoints objectAtIndex:i];
                                               
                NSString * x = [str substringToIndex:index];
                NSString *y = [str substringFromIndex:index + 1];
                                        
                
                PointLocation * loc = [[PointLocation alloc] init];
                                
                
                loc.location = CGPointMake([x floatValue], [y floatValue]);
                
                [letter.points addObject:loc]; // Add the points

                // DebugLog(@"   x=%f, y=%f",loc.location.x, loc.location.y);

            }
            
            
            
            [letters addObject:letter];
        }            

       		
	}
    
    // [self printResources];
    
	
	return self;
}
-(void)printResources {
    
    for (int i = 0; i < [self.letters count]; i++ ) {
        
        Letter * letter = [letters objectAtIndex:i];
        
        DebugLog(@"imageFile = %@, soundFile = %@",letter.imageFile, letter.soundFile);
        
        for (int k = 0; k < [letter.strokes count]; k++ ) {
            Stroke * stroke = [letter.strokes objectAtIndex:k];
            DebugLog(@"    Start = %f, %f, End = %f, %f, rotations =%d %d",stroke.startPoint.location.x, stroke.startPoint.location.y,
                     stroke.endPoint.location.x, stroke.endPoint.location.y ,stroke.startRotation,stroke.endRotation);
            
            for ( int z = 0; z < [stroke.points count]; z++ ) {
                PointLocation * point = [stroke.points objectAtIndex:z];
                DebugLog(@"        x=%f, y=%f",point.location.x, point.location.y);

                
            }

        }
        
    }

    
}
@end
