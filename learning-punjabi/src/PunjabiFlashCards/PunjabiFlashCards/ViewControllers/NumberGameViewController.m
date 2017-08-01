//
//  NumberGameViewController.m
//  PunjabiFlashCards
//
//  Created by Home on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumberGameViewController.h"
#import "DebugMacro.h"
#import "FlashCardResources.h"

static NSString *ImageKey = @"imageKey";


@implementation NumberGameViewController

@synthesize NumberImage;
@synthesize apple1;
@synthesize apple2;
@synthesize apple3;
@synthesize apple4;
@synthesize apple5;
@synthesize apple6;
@synthesize apple7;
@synthesize apple8;
@synthesize apple9;
@synthesize apple10;
@synthesize basket;
@synthesize applePicked;
@synthesize currentApple;
@synthesize appleCount;

@synthesize startPoint;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    applePicked = 0;
    appleCount = 0;
    [super loadView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
        [super viewDidLoad];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self.view];
    
    DebugLog(@"touches began");

    
    if (CGRectContainsPoint(apple1.frame, touchLocation))
    {
        DebugLog(@"apple1 touched");
        applePicked = 1;
        currentApple = apple1;
        return;
    }
    if (CGRectContainsPoint(apple2.frame, touchLocation))
    {
        DebugLog(@"apple2 touched");
        applePicked = 2;
        currentApple = apple2;
        return;

    }
    if (CGRectContainsPoint(apple3.frame, touchLocation))
    {
        DebugLog(@"apple3 touched");
        applePicked = 3;
        currentApple = apple3;
        return;
        
    }
    if (CGRectContainsPoint(apple4.frame, touchLocation))
    {
        DebugLog(@"apple4 touched");
        applePicked = 4;        
        currentApple = apple4;
        return;
        
    }
    if (CGRectContainsPoint(apple5.frame, touchLocation))
    {
        DebugLog(@"apple5 touched");
        applePicked = 5;
        currentApple = apple5;
        return;
        
    }
    if (CGRectContainsPoint(apple6.frame, touchLocation))
    {
        DebugLog(@"apple6 touched");
        applePicked = 6;
        currentApple = apple6;
        return;
        
    }
    if (CGRectContainsPoint(apple7.frame, touchLocation))
    {
        NSLog(@"apple7 touched");
        applePicked = 7;
        currentApple = apple7;
        return;
        
    }
    if (CGRectContainsPoint(apple8.frame, touchLocation))
    {
        NSLog(@"apple8 touched");
        applePicked = 8;
        currentApple = apple8;
        return;
        
    }
    if (CGRectContainsPoint(apple9.frame, touchLocation))
    {
        DebugLog(@"apple9 touched");
        applePicked = 9;
        currentApple = apple9;
        return;
        
    }
    if (CGRectContainsPoint(apple10.frame, touchLocation))
    {
        DebugLog(@"apple10 touched");
        applePicked = 10;
        currentApple = apple10;
        return;
        
    }
    applePicked = 0;

    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UIImageView * apple;

    
    if ( applePicked == 1 ) {
        apple = apple1;
        
    } else if (applePicked == 2 ) {
        apple = apple2;
        
    } else if ( applePicked == 3 ) {
        apple = apple3;
    } else if ( applePicked == 4 ) {
        apple = apple4;
    } else if ( applePicked == 5 ) {
        apple = apple5;
    } else if ( applePicked == 6 ) {
        apple = apple6;
    } else if ( applePicked == 7 ) {
        apple = apple7;
    } else if ( applePicked == 8 ) {
        apple = apple8;
    } else if ( applePicked == 9 ) {
        apple = apple9;
    } else if ( applePicked == 10 ) {
        apple = apple10;
    } else {
        return;
    }
    
    
    UITouch *myTouch = [touches anyObject];
    startPoint = [myTouch locationInView:self.view];

    apple.center = CGPointMake(startPoint.x, startPoint.y);
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    DebugLog(@"touchesEnded");
    int currentCard = [FlashCardResources sharedFlashCardResources].currentCardNumber;


    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if ( applePicked != 0 ) {
        if (CGRectContainsPoint(basket.frame, touchLocation))
        {
            appleCount = appleCount + 1;
            
            DebugLog(@"apple %d applet in basket",applePicked);
            [UIView beginAnimations:nil context:@"flipTransitionToBack"];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.currentApple cache:YES];
            
            
            [UIView commitAnimations];
            currentApple.hidden = YES;
            
            if ( appleCount == currentCard ) {
                DebugLog(@"!!!!!!!!!!!! DONE !!!!!!!!!!");
                
                [UIView beginAnimations:nil context:@"flipTransitionToBack"];
                [UIView setAnimationDuration:1.0];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.basket cache:YES];
                
                
                [UIView commitAnimations];

            }
        }
    }
    
}



- (void)viewDidUnload
{
    [self setNumberImage:nil];
    [self setApple1:nil];
    [self setApple2:nil];
    [self setApple3:nil];
    [self setApple4:nil];
    [self setApple5:nil];
    [self setApple6:nil];
    [self setApple7:nil];
    [self setApple8:nil];
    [self setApple9:nil];
    [self setApple10:nil];
    [self setBasket:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation != UIInterfaceOrientationPortrait);
}

@end
