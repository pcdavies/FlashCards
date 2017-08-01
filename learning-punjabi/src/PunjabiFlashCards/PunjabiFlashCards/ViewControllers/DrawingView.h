//
//  DrawingView.h
//  FingerDrawing
//
//

#import <UIKit/UIKit.h>

@class PointLocation;
@class LetterDrawingViewController;
@class Letter;
@class Stroke;

@interface DrawingView : UIView {
    
    //NSMutableArray *pointArray;
    
    PointLocation *point;
    PointLocation *previousPoint;
    PointLocation *linePoint; // this is where the starting point of the line is located
    PointLocation *previousLinePoint; // this is where the ending point of the line is located
    CGContextRef offScreenBuffer;
    
}

//@property (nonatomic, retain) NSMutableArray *pointArray;

@property (nonatomic, assign) CGContextRef offScreenBuffer;
@property (nonatomic, retain) PointLocation *point;
@property (nonatomic, retain) PointLocation *previousPoint;
@property (nonatomic, retain) PointLocation *linePoint;
@property (nonatomic, retain) PointLocation *previousLinePoint;
@property (atomic,strong) NSMutableArray * letterPoints;
@property (weak, nonatomic) UIImage *letterImage;
@property (nonatomic, retain  ) LetterDrawingViewController * parentViewController;
@property (nonatomic, retain) UIImageView * carImageView;

@property(nonatomic, assign) int currentStroke;
@property(nonatomic, assign) int previousStroke;

@property (nonatomic, assign) int carStatus; 



@property (nonatomic, assign) BOOL done; 


-(void)setupVariables;
-(CGContextRef)setupBuffer;
-(void)drawToBuffer;
-(void)drawPoint:(UITouch *)touch;
-(void)setDrawColor:(int) color;
-(void)drawLetterPoints:(NSString *) pointPng;

-(void)resetOffScreenBuffer;

- (UIColor *) colorOfPoint:(CGPoint)point;
- (BOOL)isWhitePixel: (UIImage *)image: (int) x :(int) y;
-(BOOL)isPointOnLine: (int)x: (int)y: (int)x1: (int)y1: (int)x2: (int)y2;

-(void)drawCar;
-(void)checkCarTouches:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)animateCar: (Stroke *) stroke;
-(void)traceLetter;
-(void)observeAnimations;
-(void)playCarSound ;



@end
