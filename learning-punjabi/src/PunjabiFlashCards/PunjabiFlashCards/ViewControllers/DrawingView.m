//
//  DrawingView.m
//  FingerDrawing
//
//

#import "DrawingView.h"
#import "PointLocation.h"
#import "DebugMacro.h"
#import "LetterDrawingViewController.h"
#import "FlashCardResources.h"
#import "Letter.h"
#import "LetterPoint.h"
#import "PointLocation.h"
#import "Constants.h"
#import "Stroke.h"
#import <AudioToolbox/AudioToolbox.h>


#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI * x / 180.0)
#define P(x,y) CGPointMake(x, y)


// CAR States
#define CAR_ANIMATED                1
#define CAR_START                   2
#define CAR_END                     3



//                       Red  Gr   Blu  Alpha
CGFloat greenColor[4] = {0.0, 1.0, 0.0, 1.0};
CGFloat redColor[4] = {1.0, 0.0, 0.0, 1.0};
CGFloat blueColor[4] = {0.0, 0.0, 1.0, 1.0};
CGFloat blackColor[4] = {0.0, 0.0, 0.0, 1.0};
CGFloat whiteColor[4] = {1.0, 1.0, 1.0, 1.0};
CGFloat yellowColor[4] = {1.0, 1.0, 0.0, 1.0};
CGFloat *currentLineColor = yellowColor;

NSString *greenCar = @"greenCar.png";
NSString *redCar = @"redCar.png";
NSString *blueCar = @"blueCar.png";
NSString *yellowCar = @"yellowCar.png";
NSString *currentCarColor;

CALayer *car;


@implementation DrawingView

//@synthesize pointArray;

@synthesize point;
@synthesize previousPoint;
@synthesize linePoint;
@synthesize previousLinePoint;
@synthesize letterImage;
@synthesize parentViewController;
@synthesize offScreenBuffer;
@synthesize currentStroke;
@synthesize previousStroke;
@synthesize carImageView;

@synthesize letterPoints;

@synthesize carStatus;

@synthesize done;


- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupVariables];
       
    }
    

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupVariables];
    }
    
     [self drawCar];
    DebugLog(@"Initializeing letterPoints");

    self.letterPoints = [[NSMutableArray alloc] init];

    [self drawLetterPoints:@"redRadioButton.png"];
        
    self.linePoint = [[PointLocation alloc] init];
    self.previousLinePoint = [[PointLocation alloc] init];

    self.currentStroke = 0;
    DebugLog(@"currentStroke set to 0");
    
    return self;
     
}

-(void)drawLetterPoints:(NSString *) pointPng {
    
    self.done = NO;
    return;
    
    // Remove the reference to the old views
    
    if ( [self.letterPoints count] > 0 ) {
        DebugLog(@"Removing all drawingLetterPointObjects");
        [self.letterPoints removeAllObjects];
        
    }
    
    self.letterPoints = nil;
    
    self.letterPoints = [[NSMutableArray alloc] init ];
    
    // Remove all previous points
    for(UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:[FlashCardResources sharedFlashCardResources].currentLetter];
    
    DebugLog(@"Number of Points for Letter = %d",[letter.points count]);
    

    
    for ( int i = 0; i < [letter.points count]; i++ ) {
        
        
        PointLocation * pointLocation = [letter.points objectAtIndex:i];
        
        // DebugLog(@"   Card %d - Setting Points x=%f, y=%f",[FlashCardResources sharedFlashCardResources].currentLetter,pointLocation.location.x,pointLocation.location.y);
        
        UIImageView * pointView;
        
        UIImage * image;
        if ( i == 0) {
            pointView = [[UIImageView alloc] initWithFrame:CGRectMake(pointLocation.location.x, pointLocation.location.y, 25, 25)];
            image =  [UIImage imageNamed:@"startButton.png"]; 
            self.previousLinePoint.location = pointLocation.location;
        } else {
            if ( i == 1 ) {
                self.linePoint.location = pointLocation.location;
            }
            pointView = [[UIImageView alloc] initWithFrame:CGRectMake(pointLocation.location.x, pointLocation.location.y, 15, 15)];
            image =  [UIImage imageNamed:pointPng]; 
        }

        
        
        
        if ( i >= 2 ) { // Only make visible the first two points.
        
            pointView.hidden = YES;
        } 
        
        
    
        
        [pointView setImage:image];
        
        [self addSubview:pointView];
        
        LetterPoint * letterPoint = [[LetterPoint alloc] init]; 
        letterPoint.pointImageView = pointView;
        letterPoint.pointStatus = NOT_DRAWN_OVER;
        
        if ( i == 0 ) {
            letterPoint.drawOverNext = true;
        } else {
            letterPoint.drawOverNext = false;
        }
        
        [letterPoints addObject:letterPoint];
        
        image = nil;
        
        
    }
    
    DebugLog(@"letterPoints count after redraw = %d",[letterPoints count]);
    
   
    [self setDone:NO];
    
    
    

    
}
-(void)setDrawColor:(int) color {
    if ( color == 1 ) { currentLineColor = greenColor; currentCarColor = greenCar;}
    else if (color == 2 ) {currentLineColor = redColor; currentCarColor = redCar; }
    else if (color == 3 ) {currentLineColor = blueColor; currentCarColor = blueCar;}
    else {currentLineColor = yellowColor; currentCarColor = yellowCar;}
    
    [self drawCar];
    

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    
    CGImageRef cgImage = CGBitmapContextCreateImage(offScreenBuffer);
    UIImage *uiImage = [[UIImage alloc] initWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    [uiImage drawInRect:self.bounds];
    uiImage = nil;
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    

    if ([self done] == TRUE ) {
        return;
    }

    NSArray *allTouches = [[event allTouches] allObjects];
    
    if ([allTouches count] > 1) {
        return;
    }
    else {
        [self drawPoint:[allTouches objectAtIndex:0]];
    }
    
    CGPoint touchLocation = [[allTouches objectAtIndex:0] locationInView:self];
    DebugLog(@"!!!!!touch = %f %f",touchLocation.x,touchLocation.y);

    [self checkCarTouches:touches withEvent:event];

       
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if ([self done] == TRUE ) {
        return;
    }
    
    NSArray *allTouches = [[event allTouches] allObjects];
    
    if ([allTouches count] > 1) {
        return;
    }
    else {
        [self drawPoint:[allTouches objectAtIndex:0]];
        
        self.previousPoint = nil;
        self.point = nil;
    }    
    
        
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if ([self done] == TRUE ) {
        return;
    }
    
    NSArray *allTouches = [[event allTouches] allObjects];
    
    if ([allTouches count] > 1) {
        return;
    }
    else {
        [self drawPoint:[allTouches objectAtIndex:0]];
        
        self.previousPoint = nil;
        self.point = nil;
    }        
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
       
    NSArray *allTouches = [[event allTouches] allObjects];
    
    if ([allTouches count] > 1) {
        return;
    }
    
    if ([self done] == TRUE ) {
        return;
    }
    


    
    [self drawPoint:[allTouches objectAtIndex:0]];
    
    [self checkCarTouches:touches withEvent:event];

    // [self checkCarTouches:touches withEvent:event];

   /* 
    
    int pointCnt;
    for ( pointCnt = 0; pointCnt < [letterPoints count]; pointCnt++){
        LetterPoint * letterPoint = [letterPoints objectAtIndex:pointCnt];

        UIImageView * pointImageView = letterPoint.pointImageView;
        
        // If this point is hidden, or already drawn over or not the next to be drawn over, then don't change the icon.
        if ( pointImageView.hidden == YES || letterPoint.pointStatus == DRAWN_OVER) {
            continue;
        }
        
        if (letterPoint.drawOverNext == true && CGRectContainsPoint(pointImageView.frame, touchLocation) ) {
            
            // Set this as drawn over
            letterPoint.drawOverNext = false;
            letterPoint.pointStatus = DRAWN_OVER;
            // Set the next drawOverPoint
            if ( (pointCnt + 1) < [letterPoints count] ) {
                LetterPoint * nextLetterPoint = [letterPoints objectAtIndex:pointCnt+1];
                nextLetterPoint.drawOverNext = true;
                nextLetterPoint.pointImageView.hidden = NO;
                
                self.previousLinePoint.location = self.linePoint.location;                

                self.linePoint.location = nextLetterPoint.pointImageView.frame.origin;

            }
            
            UIImage *image =  [UIImage imageNamed:@"greenRadioButton.png"]; 
            [pointImageView setImage:image];
            
            // [pointImageView setTag:LETTER_POINT_TAG];
            
            image = nil;
            
            
            
            break;
        }

    }
    
    int cnt = 0;
    for (int i = 0; i < [letterPoints count]; i++ ) {
        LetterPoint * letterPoint = [letterPoints objectAtIndex:i];
        if (letterPoint.pointStatus == NOT_DRAWN_OVER ) {
            cnt++;
            break;
        }

    }
    if ( cnt == 0 ) {
        DebugLog(@"All points touched");
        
        UIImage *image =  [UIImage imageNamed:@"Done.png"]; 
        
        
        UIView *parent = self.superview;
        
        
        
        UIImageView *testDoneView = [[UIImageView alloc] initWithFrame:CGRectMake(102, 46, 265, 243)];  
        [testDoneView setImage:image];
        
        testDoneView.tag = DONE_TAG;
        image = nil;

        
        
        [parent addSubview:testDoneView];
        //parentViewController.doneImage.hidden = NO;
        
        
        self.hidden = NO;
    }
    
   */ 
    
    //
    //
    // !!!!!!!!!!!!! new code with animation points !!!!!!!!!!!
    // 
    //
    
    // This code should be changed to grab the current letter at the first, so you don't need to grab it from current resources each time.
        
    
    // DebugLog(@"!!!!!!! currentStroke = %d, previousStroke = %d",self.currentStroke,self.previousStroke);
    
    
 


}

-(void)checkCarTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSArray *allTouches = [[event allTouches] allObjects];

    CGPoint touchLocation = [[allTouches objectAtIndex:0] locationInView:self];

    
    Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:[FlashCardResources sharedFlashCardResources].currentLetter];
 
    Stroke * stroke = [letter.strokes objectAtIndex:self.currentStroke];
    
    if ( self.currentStroke != self.previousStroke && self.carStatus != CAR_ANIMATED ) {
        
        
        self.previousStroke = self.currentStroke ;
        
        [self drawCar];
              
        
    }
    
    //DebugLog(@"CarImageFrame = %f %f size=%d %d, touch = %f %f",carImageView.frame.origin.x,carImageView.frame.origin.y,
    //         carImageView.frame.size.height,carImageView.frame.size.width,touchLocation.x,touchLocation.y);
    
    
    if ( self.carStatus != CAR_ANIMATED ) {
        if (CGRectContainsPoint(carImageView.frame, touchLocation) ) {
            
            
            if ( self.carStatus == CAR_END ) {
                
                if ( (self.currentStroke + 1) >= [letter.strokes count] ) {
                    
                    // DebugLog(@"!!!!!!!!! Final Car Touched !!!!!!!!");
                    UIImage *image =  [UIImage imageNamed:@"Done.png"]; 
                    
                    
                    UIView *parent = self.superview;
                    
                    
                    
                    UIImageView *testDoneView = [[UIImageView alloc] initWithFrame:CGRectMake(207,239, 66, 61)];
                    // UIImageView *testDoneView = [[UIImageView alloc] initWithFrame:CGRectMake(102, 46, 265, 243)];  
                    [testDoneView setImage:image];
                    
                    testDoneView.tag = DONE_TAG;
                    image = nil;
                    
                    
                    
                    [parent addSubview:testDoneView];
                    //parentViewController.doneImage.hidden = NO;
                    
                    
                    self.hidden = NO;
                    
                    
                    return;
                }
                
                
                
                self.currentStroke = self.currentStroke + 1;
                
                self.carStatus = CAR_START;
                
                [self drawCar];
                
                return;
            } 
            
            // Must be on CAR_START
            
           
            [self playCarSound];
            
            [self animateCar:stroke];
            
            
        }
    }
    
    

    
}

-(void)playCarSound 
{
    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"car_pass" withExtension: @"wav"];
    //NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"indycar" withExtension: @"wav"];
    //NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"passing" withExtension: @"wav"];
    //NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"cargoby" withExtension: @"wav"];
    
    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;
    // Store the URL as a CFURLRef instance
    soundFileURLRef = (__bridge CFURLRef) tapSound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
                                      
                                      soundFileURLRef,
                                      &soundFileObject
                                      );
    
    AudioServicesPlaySystemSound (soundFileObject);

}

-(void)animateCar: (Stroke *) stroke
{
    CAShapeLayer *centerline = [CAShapeLayer layer];
    centerline.path = stroke.trackPath.CGPath;
    centerline.strokeColor = [UIColor whiteColor].CGColor;
    centerline.fillColor = [UIColor clearColor].CGColor;
    centerline.lineWidth = 2.0;
    centerline.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:2], nil];
    [self.layer addSublayer:centerline];
    
    
    
    carImageView.hidden = YES;
    // carImageView = nil;
    carStatus = CAR_ANIMATED;
    
    // DebugLog(@"!!!!!!!!! touched on Car!!!!!!!!! = animating letter #%d, stroke %d",[FlashCardResources sharedFlashCardResources].currentLetter,self.currentStroke);
    
    car = [CALayer layer];
    
    
    //car.bounds = CGRectMake(0, 0, 20.0, 20.0);
    // car.bounds = CGRectMake(0, 0, 44.0, 20.0);
    
    
    //car.bounds = CGRectMake(0, 0, 32.0, 16.0);
    car.bounds = CGRectMake(0, 0, 40.0, 20.0);
    // car.position = P(stroke.startPoint.location.x, stroke.startPoint.location.y);
    
    car.position = stroke.endPoint.location;
    
    //car.contents = (id)([UIImage imageNamed:@"redRadioButton.png"].CGImage);
    // car.contents = (id)([UIImage imageNamed:@"carmodel.png"].CGImage);
    car.contents = (id)([UIImage imageNamed:currentCarColor].CGImage);
    // [self.view.layer addSublayer:car];
    [self.layer addSublayer:car];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim.path = stroke.trackPath.CGPath;
    anim.rotationMode = kCAAnimationRotateAuto;
    //anim.repeatCount = HUGE_VALF;
    anim.repeatCount = 1;
    anim.duration = 1.0;
    anim.delegate = self;
    
    
    
    
    [car addAnimation:anim forKey:@"race"];

    
}

-(void)traceLetter
{
    
    [self playCarSound];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeAnimations) name:@"carAnimation" object:nil];
    self.currentStroke = 0;
    self.previousStroke = -1;
    self.carStatus = CAR_START;
    
    Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:[FlashCardResources sharedFlashCardResources].currentLetter];
    
    Stroke * stroke = [letter.strokes objectAtIndex:self.currentStroke];
    
    [self animateCar:stroke];

    
}
-(void)observeAnimations
{
    
    Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:[FlashCardResources sharedFlashCardResources].currentLetter];

    if ( (self.currentStroke + 1) >= [letter.strokes count] ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"carAnimation" object:nil];
        
        //self.currentStroke = 0;
        //self.previousStroke = -1;
        //self.carStatus = CAR_START;
        
        //[self drawCar];
        
        return;
    }
    
    self.currentStroke = self.currentStroke + 1;
    
    Stroke * stroke = [letter.strokes objectAtIndex:self.currentStroke];
    [self animateCar:stroke];



    
}


-(void)drawCar
{
    
    
    if ( carImageView != nil) {
        [carImageView removeFromSuperview];
        carImageView = nil;
    }
    
    Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:[FlashCardResources sharedFlashCardResources].currentLetter];
    
    Stroke * stroke;
    
    
    stroke = [letter.strokes objectAtIndex:self.currentStroke];
    
    
    
    if ( self.carStatus == CAR_START ) {
        
        //self.carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(stroke.startPoint.location.x, stroke.startPoint.location.y, 32, 16)];
        self.carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(stroke.startPoint.location.x, stroke.startPoint.location.y, 40, 20)];
    } else {
        // CAR_END
        //self.carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(stroke.endPoint.location.x, stroke.endPoint.location.y, 32, 16)];
        self.carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(stroke.endPoint.location.x, stroke.endPoint.location.y, 40, 20)];
        
    }
    
    UIImage * carImage =  [UIImage imageNamed:currentCarColor];            

    
    [self.carImageView setImage:carImage];
    
    
    if ( self.carStatus == CAR_START ) {
        
        self.carImageView.transform = CGAffineTransformMakeRotation(stroke.startRotation* M_PI/180);
        [self.carImageView setCenter:stroke.startPoint.location];
    } else {
        self.carImageView.transform = CGAffineTransformMakeRotation(stroke.endRotation* M_PI/180);
        [self.carImageView setCenter:stroke.endPoint.location];
    }
    
    [self addSubview:self.carImageView];
    
    
    self.carImageView.hidden = NO;
    
    
    

}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    
    
    // self.currentStroke = self.currentStroke + 1;

    
    NSString* value = [theAnimation valueForKey:@"race"];
    
        
    
    self.carStatus = CAR_END;

    
    
    DebugLog(@"Animation did Stop = %s ", value);
    
    car.hidden = YES;
    car = nil;
    
    [self drawCar];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"carAnimation" object:nil userInfo:nil];

    
}

-(void)resetOffScreenBuffer{
    [self viewDidUnload];
    [self setupVariables];
}

-(void)viewDidUnload {
    
    DebugLog(@"Removing all drawingLetterPointObjects in viewDidUnload");

    [self.letterPoints removeAllObjects];
    [self setLetterPoints:nil];
    CGContextRelease(offScreenBuffer);
    [self setPoint:nil];
    [self setPreviousPoint:nil];
    [self setLinePoint:nil];
    [self setLetterImage:nil];
    [self setParentViewController:nil];
    [self setCarImageView:nil];
 
}


-(void)setupVariables {
    self.point = nil;
    self.previousPoint = nil;
    self.currentStroke = 0;
    self.previousStroke = -1;
    self.carImageView = nil;
    offScreenBuffer = [self setupBuffer];
    self.carStatus = CAR_START;
    currentCarColor = yellowCar;    

}

-(CGContextRef)setupBuffer {
    
    CGSize size = self.bounds.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width*4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    return context;

    
    
}


-(void)drawToBuffer {
    
    //                  Red  Gr   Blu  Alpha
    //CGFloat color[4] = {0.0, 1.0, 0.0, 1.0};

    if (self.previousPoint != nil) {
        CGContextSetRGBStrokeColor(offScreenBuffer, currentLineColor[0], currentLineColor[1], currentLineColor[2], currentLineColor[3]);
        
        CGContextBeginPath(offScreenBuffer);
        CGContextSetLineWidth(offScreenBuffer, 10.0);
        CGContextSetLineCap(offScreenBuffer, kCGLineCapRound);
        
        CGContextMoveToPoint(offScreenBuffer, previousPoint.location.x, previousPoint.location.y);
        CGContextAddLineToPoint(offScreenBuffer, point.location.x, point.location.y);
        
        CGContextDrawPath(offScreenBuffer, kCGPathStroke);
    }
    
    
}
-(void)drawPoint:(UITouch *)touch {
    
    PointLocation *currentLoc = [[PointLocation alloc] init];
    
    currentLoc.location = [touch locationInView:self];
    
    //DebugLog(@"x=%f, y=%f .... startPoints x=%f, y=%f, nextPoints x=%f, y=%f",currentLoc.location.x,currentLoc.location.y,
    //         self.previousLinePoint.location.x, self.previousLinePoint.location.y,
    //         self.linePoint.location.x, self.linePoint.location.y);   

    
  /*
    DebugLog(@"x=%f, y=%f .... startPoints x=%f, y=%f, nextPoints x=%f, y=%f",currentLoc.location.x,currentLoc.location.y,
             self.previousLinePoint.location.x, self.previousLinePoint.location.y,
             self.linePoint.location.x, self.linePoint.location.y);   
    if ( [self isPointOnLine:currentLoc.location.x :currentLoc.location.y :previousLinePoint.location.x :previousLinePoint.location.y :self.linePoint.location.x :self.linePoint.location.y] ) {
        DebugLog(@"              !!!!!!!!!!!!! In the line !!!!!!!");
        currentLineColor = whiteColor;

    } else {
        currentLineColor = redColor;
    }
   */
    
    // [self isWhitePixel:letterImage: currentLoc.location.x: currentLoc.location.y]; 
    

    
    
    self.previousPoint = self.point;
    
    self.point = currentLoc;
    [self drawToBuffer];
    
    [self setNeedsDisplay];
    
    
    
    currentLoc = nil;
    
    
    
}

-(BOOL)isPointOnLine: (int)x: (int)y: (int)x1: (int)y1: (int)x2: (int)y2
{
    
    int p1Test = (y-y1);
    int p2Test = (y2-y1)*(x-x1);
    if ( (x2-x1) == 0 ) {
        return FALSE;
    } else {
        p2Test = p2Test / (x2-x1);
    }
    
    int p3Test = p1Test - p2Test;
    
    DebugLog(@"                 isPointInLine %d %d....%d",p1Test, p2Test, p3Test);

    if ( (p3Test <= 5) && (p3Test >= -5) ) {
        return TRUE;
    
    } else {
        return FALSE;
    }
}

- (UIColor *) colorOfPoint:(CGPoint)pointParm
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -pointParm.x, -pointParm.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (BOOL)isWhitePixel: (UIImage *)image: (int) x :(int) y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    UInt8 red = data[pixelInfo];         // If you need this info, enable it
    UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
    UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = data[pixelInfo + 3];     // I need only this info for my maze game
    CFRelease(pixelData);
    
    //UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    
    // DebugLog(@"            x=%d,y=%d   red=%ld, green=%ld, blue=%ld",x,y,red,green,blue);
    
    if (alpha||(red && green && blue)) return YES;
    else return NO;
}

@end
