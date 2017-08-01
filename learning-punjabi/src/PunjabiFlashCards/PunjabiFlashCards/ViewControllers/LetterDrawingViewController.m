//
//  LetterDrawingViewController.m
//  PunjabiFlashCards
//
//  Created by Home on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LetterDrawingViewController.h"
#import "DrawingView.h"
#import "DebugMacro.h"
#import "FlashCardResources.h"
#import "Letter.h"
#import "Constants.h"
#import "FlurryAnalytics.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI * x / 180.0)
#define P(x,y) CGPointMake(x, y)

@implementation LetterDrawingViewController
@synthesize drawView;
@synthesize letterImage;
@synthesize letterText;
@synthesize letterDropView;
@synthesize allButtons;
@synthesize dropDownTabText;
@synthesize doneImage;

CALayer *car;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    
    // Record where the image is located, so the draw view can change the image
    

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
    [FlashCardResources sharedFlashCardResources].currentLetter = 0;


    [super loadView];
    
    [FlurryAnalytics logEvent:@"Letters"];


    // Start out with the first letter loaded
    // NEED TO ADD CODE THAT TELL WHICH LETTER WE'RE CURRENTLY ON
    
    DebugLog(@"Loading View - setting current card = 0");


     Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:0];
     NSString * imageFile = letter.imageFile;
     
     
     UIImage *image =  [UIImage imageNamed:imageFile]; 
     //UIImage *image =  [UIImage imageNamed:@"letter1.png"]; 
     
     
    //UIImage *image =  [UIImage imageNamed:@"letter1.png"]; 
    
    // NOTE: THIS IS IF WE WANT TO USE AN IMAGE AND NOT A CHARACTER
    [letterImage setImage:image];
    [drawView setLetterImage:image];
    
    UIFont * fnt = [UIFont fontWithName:@"GurbaniAkharThick" size:210];
    
    letterText.font = fnt;
    letterText.text = letter.letterString;

    
    fnt = [UIFont fontWithName:@"GurbaniAkharThick" size:25];
    
    dropDownTabText.font = fnt;

     
    
    fnt = [UIFont fontWithName:@"GurbaniAkharThick" size:35];
    
    
    int col = 0;
    int row = 0;
    
    for ( int i = 0; i < [[FlashCardResources sharedFlashCardResources].letters count]; i++) {
        
        
        
        Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:i];
        
        int pos;
        pos = 12 + (col * (468/10));
        
    
        //UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(pos,16+(row*42),40,40); // position in the parent view and set the size of the button
        [myButton setTitle:letter.letterString forState:UIControlStateNormal];         myButton.tag = i+1;
        myButton.titleLabel.font = fnt;
        myButton.titleLabel.textColor = [UIColor blackColor];
        myButton.showsTouchWhenHighlighted = NO;
        myButton.adjustsImageWhenHighlighted = NO;
        myButton.adjustsImageWhenDisabled = NO;
        myButton.multipleTouchEnabled = NO;
        myButton.titleLabel.highlightedTextColor = [UIColor blackColor];
        
        // myButton.titleLabel.backgroundColor = [UIColor redColor];
        myButton.titleLabel.shadowColor = [UIColor greenColor];

        [myButton addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlStateHighlighted];

        [myButton addTarget:self action:@selector(letterSelected:) forControlEvents:UIControlEventTouchUpInside];
         // add to a view
         [letterDropView addSubview:myButton];
        
        if ( i == 0 ) {
            allButtons = [[NSMutableArray alloc] init];
        }
        [allButtons addObject:myButton];
                
        if ( col == 9 ) {
            col = 0;
            row ++;
        } else {
            col++;
        }

     }
    
    

    
    fnt = nil;

     image = nil;
    
    letterDropView.frame = CGRectMake(0,-100,480,148);


 
     



}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{ 
    

    [super viewDidLoad];
    
    self.drawView.parentViewController = self;
    
    
    
}

- (void)viewDidUnload
{
    [self setDrawView:nil];

    [self setLetterImage:nil];
    [self setLetterText:nil];
    [self setLetterDropView:nil];
    
    for (int i = 0; i < [allButtons count]; i++ ) {
        UIButton * button = [allButtons objectAtIndex:i];
        button = nil;
        
    }
    [self setAllButtons:nil];
    
    [self setDropDownTabText:nil];
    [self setDoneImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    
    
    NSString* value = [theAnimation valueForKey:@"race"];


    DebugLog(@"Animation did Stop = %s ", value);
    
    car.hidden = YES;
    car = nil;


       

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation != UIInterfaceOrientationPortrait);

}
- (IBAction)buttonHighlighted:(UIButton *)sender {
    DebugLog(@"Button highlighted");
    sender.titleLabel.textColor = [UIColor blackColor];
    sender.highlighted = NO;
    


    

    
}

- (IBAction)traceLetter:(UIButton *)sender {
    
    [drawView traceLetter];
    
    
}
- (IBAction)letterSelected:(UIButton *)sender {
    
    DebugLog(@"Button #%d Pressed!!!!!!!!!!!!",sender.tag);

    
    [UIView beginAnimations:nil  context:NULL];
    [UIView setAnimationDuration:1.0];
    
    // frame.origin.x = 0;
    letterDropView.frame = CGRectMake(0,-100,480,148);
    [UIView commitAnimations];
    self.drawView.hidden = NO;
    

    
    // by setting the currentLetter to the tag, it will be incremented by one. Calling previousCard, will cause the right letter to load
    [FlashCardResources sharedFlashCardResources].currentLetter = sender.tag;

    [self previousCard:nil];

}

- (IBAction)nextCard:(UIButton *)sender {
        

    
    // The drop down view is visible, and draw view hidden, so don't change cards
    if ( drawView.hidden == YES ) {
        return;
    }
    if ( ([FlashCardResources sharedFlashCardResources].currentLetter +1) >= [[FlashCardResources sharedFlashCardResources].letters count] ) {
        return;
    }
    
    // Look to see if the done view has been loaded
    //self.doneImage.hidden = YES;
    
    for(UIView *subview in [self.view subviews]) {
        if ( subview.tag == DONE_TAG ) {
            [subview removeFromSuperview];
        }
    }
     
    
    
   
    
    [FlashCardResources sharedFlashCardResources].currentLetter = [FlashCardResources sharedFlashCardResources].currentLetter + 1;

    DrawingView *imageView = [ [ DrawingView alloc ] initWithFrame:CGRectMake(158.0, 46.0, 168.0, 210.0)];
    imageView.tag = LETTER_POINT_TAG;
    
    imageView.backgroundColor = drawView.backgroundColor;
    
    [drawView removeFromSuperview];
    drawView = nil;
    drawView = imageView;
    
    [self.view addSubview:drawView];
    

    
    Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:[FlashCardResources sharedFlashCardResources].currentLetter];
    NSString * imageFile = letter.imageFile;
    
    DebugLog(@" going to load image file %@",imageFile);
    
    UIImage *image =  [UIImage imageNamed:imageFile]; 
    //UIImage *image =  [UIImage imageNamed:@"letter1.png"]; 
    
    // NOTE: THIS IS IF WE WANT TO USE AN IMAGE AND NOT A CHARACTER
    [letterImage setImage:image];
    [drawView setLetterImage:image];

    
    UIFont * fnt = [UIFont fontWithName:@"GurbaniAkharThick" size:210];
    
    letterText.font = fnt;
    letterText.text = letter.letterString;
    
    
    
    image = nil;
    
    [drawView drawLetterPoints:@"redRadioButton.png"];
    
    [drawView drawCar];

}

- (IBAction)previousCard:(UIButton *)sender {
    
    
    
    
    // The drop down view is visible, and draw view hidden, so don't change cards
    if ( drawView.hidden == YES ) {
        return;
    }
    
    if ( ([FlashCardResources sharedFlashCardResources].currentLetter -1 ) < 0 ) {
        // ONLY on the first card as a test trace it.
        return;   
    }
    // Look to see if the done view has been loaded
    //self.doneImage.hidden = YES;
    
    for(UIView *subview in [self.view subviews]) {
        if ( subview.tag == DONE_TAG ) {
            [subview removeFromSuperview];
        }
    }
     
    
    
    if ( ([FlashCardResources sharedFlashCardResources].currentLetter -1 ) < 0 ) {
        return;
    }
    
    [FlashCardResources sharedFlashCardResources].currentLetter = [FlashCardResources sharedFlashCardResources].currentLetter - 1;
    
    DrawingView *imageView = [ [ DrawingView alloc ] initWithFrame:CGRectMake(158.0, 46.0, 168.0, 210.0)];
    imageView.tag = LETTER_POINT_TAG;
    
    imageView.backgroundColor = drawView.backgroundColor;
    
    [drawView removeFromSuperview];
    drawView = nil;
    drawView = imageView;
    
    [self.view addSubview:drawView];
    
    

    
    
    Letter * letter = [[FlashCardResources sharedFlashCardResources].letters objectAtIndex:[FlashCardResources sharedFlashCardResources].currentLetter];
    NSString * imageFile = letter.imageFile;
    
    DebugLog(@" going to load image file %@",imageFile);
    
    UIImage *image =  [UIImage imageNamed:imageFile]; 
    //UIImage *image =  [UIImage imageNamed:@"letter1.png"]; 
    
    
    //UIImage *image =  [UIImage imageNamed:@"letter1.png"]; 
    
    // NOTE: THIS IS IF WE WANT TO USE AN IMAGE AND NOT A CHARACTER
    [letterImage setImage:image];
    [drawView setLetterImage:image];

    
    UIFont * fnt = [UIFont fontWithName:@"GurbaniAkharThick" size:210];
    
    letterText.font = fnt;
    letterText.text = letter.letterString;
    image = nil;
    
    [drawView drawLetterPoints:@"redRadioButton.png"];
     
    [drawView drawCar];


}


- (IBAction)setRed:(id)sender {
    [drawView setDrawColor:2];
}

- (IBAction)setGreen:(id)sender {
    [drawView setDrawColor:1];

}

- (IBAction)setBlue:(id)sender {
    [drawView setDrawColor:3];

}

- (IBAction)setBlack:(id)sender {
    [drawView setDrawColor:4];

}

- (IBAction)returnHome:(id)sender {
    [self dismissModalViewControllerAnimated:YES];

}

- (IBAction)showLetterDropDown:(UIButton *)sender {
    
    DebugLog(@"show Letter Drop View pressed");
    
    // Look to see if the done view has been loaded
    // self.doneImage.hidden = YES;
    
    for(UIView *subview in [self.view subviews]) {
        if ( subview.tag == DONE_TAG ) {
            [subview removeFromSuperview];
        }
    }
     
    
    

    if ( letterDropView.frame.origin.y < (CGFloat)0) {
        // Need to dropdown the view
        DebugLog(@"y is < 0");

        // Make sure all the text color is black
        for (int i = 0; i < [allButtons count]; i++ ) {
            UIButton * button = [allButtons objectAtIndex:i];
            button.titleLabel.textColor = [UIColor blackColor];
            
        }


           
        // self.letterDropView.hidden = NO;
        self.drawView.hidden = YES;
        

    
        // CGRect frame = letterDropView.frame;
        [UIView beginAnimations:nil  context:NULL];
        [UIView setAnimationDuration:0.5];
    
        // frame.origin.x = 0;
        letterDropView.frame = CGRectMake(0,0,480,148);
        [UIView commitAnimations];
        

    } else {
        DebugLog(@"y is >= 0");

        // Need to hide the dropDown
        // CGRect frame = letterDropView.frame;
        [UIView beginAnimations:nil  context:NULL];
        [UIView setAnimationDuration:0.5];
        
        // frame.origin.x = 0;
        letterDropView.frame = CGRectMake(0,-100,480,148);
        [UIView commitAnimations];
        
        
        self.drawView.hidden = NO;


    }
     

}

- (IBAction)loadNewLetter:(UIButton *)sender {
    
    DebugLog(@"Button #%d pressed - load that card",sender.tag);
}


@end
