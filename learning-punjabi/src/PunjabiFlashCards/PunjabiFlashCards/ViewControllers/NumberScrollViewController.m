//
//  NumberScrollViewController.m
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumberScrollViewController.h"
#import "NumberViewController.h"
#import "NumberGameViewController.h"
#import "FlashCardResources.h"
#import "DebugMacro.h"
#import "FlurryAnalytics.h"

static NSString *ImageKey = @"imageKey";


@implementation NumberScrollViewController

@synthesize Scroller;
@synthesize viewControllers;
@synthesize numberGameView;
@synthesize numberGameViewController;


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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [FlurryAnalytics logEvent:@"Numbers"];

    
    [Scroller setScrollEnabled:YES];
    
    Scroller.showsHorizontalScrollIndicator = NO;
    Scroller.showsVerticalScrollIndicator = NO;
    Scroller.scrollsToTop = NO;
    Scroller.pagingEnabled = YES;
    Scroller.delegate = self;
    
    Scroller.hidden = NO;
    
    int arraySize = [[FlashCardResources sharedFlashCardResources].contentList count];
    
    //[Scroller setContentSize:CGSizeMake((320*arraySize),460)];
    [Scroller setContentSize:CGSizeMake((480*arraySize),300)];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]; 
    
    
    numberGameViewController = [storyboard instantiateViewControllerWithIdentifier:@"NumberGameViewController"];
    [numberGameView addSubview:numberGameViewController.view];
     

    
   // NSArray * contentList = [FlashCardResources sharedFlashCardResources].contentList;
    
   // NSDictionary *numberItem = [contentList objectAtIndex:0];
    
   // numberGameViewController.NumberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
    
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    
    viewControllers = [[NSMutableArray alloc] init];
    
    DebugLog(@"Setting up View Controllers = Array Size = %d",arraySize);

    
    for (int i = 0; i < arraySize; i++ ) {
        
        
        [FlashCardResources sharedFlashCardResources].currentCardNumber = i + 1;
        
        NumberViewController *mcvc = [storyboard instantiateViewControllerWithIdentifier:@"NumberViewController"];
        [viewControllers addObject:mcvc];
        
        
        //[mcvc.view setFrame:CGRectMake((320*i),0,320,460)];
        [mcvc.view setFrame:CGRectMake((480*i),0,480,300)];
        
        [Scroller addSubview:mcvc.view];
        
        // [controller.Mcvc playSound:nil];
        
    }
    
    // Set at the first card
    [FlashCardResources sharedFlashCardResources].currentCardNumber = 1;
    [ [viewControllers objectAtIndex:0] playSound:nil];
    
    
    
    
    
    
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setScroller:nil];
    [self setNumberGameView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation != UIInterfaceOrientationPortrait);
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    return;

    
    CGFloat pageWidth = Scroller.frame.size.width;
    int page = floor((Scroller.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    // they try and scroll left and they are on the first card, return back to the 
    // main window.
    if ( page < 0 ) {
        
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
    // Don't scroll past the last card
    if ( page >= [[FlashCardResources sharedFlashCardResources].contentList count] ) {
        return;
    }
    
    // When Scrolling, keep track of the current page number for other uses....
    
    if ( [FlashCardResources sharedFlashCardResources].currentCardNumber != (page + 1 )) {
        DebugLog(@"Card number changed to %d",page+1);
        [FlashCardResources sharedFlashCardResources].currentCardNumber = page + 1;
        [ [viewControllers objectAtIndex:page] playSound:nil];
        
    }
    
    
    
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}
 


- (IBAction)scrollLeft:(id)sender
{
    Scroller.hidden = NO;

    int currentCard = [FlashCardResources sharedFlashCardResources].currentCardNumber;

    DebugLog(@"Scroll Right - CurrentCard = %d, count=%d",currentCard,[[FlashCardResources sharedFlashCardResources].contentList count] );

    if ( (currentCard) <= 1 ) {
        [self dismissModalViewControllerAnimated:YES];
        return;
    }

    currentCard = currentCard  - 1;
    
    CGRect frame;

    frame.origin.x = (currentCard - 1) * 480;
    frame.origin.y = 0;
    frame.size = Scroller.frame.size;
    [Scroller scrollRectToVisible:frame animated:YES];    
    
    
    //This code added if not a scrollview delegate. Need to increment card in this code. 
    [ [viewControllers objectAtIndex:(currentCard - 1)] playSound:nil];
    [FlashCardResources sharedFlashCardResources].currentCardNumber = currentCard;
    
    
    // Fix the Hidden View Card Number
    NSArray * contentList = [FlashCardResources sharedFlashCardResources].contentList;
    
    NSDictionary *numberItem = [contentList objectAtIndex:[FlashCardResources sharedFlashCardResources].currentCardNumber - 1];
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // NOTE: Add code here to change the number of apples
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    
    numberGameViewController.NumberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];

}

- (IBAction)scrollRight:(id)sender
{
    
    
    Scroller.hidden = NO;
    

    int currentCard = [FlashCardResources sharedFlashCardResources].currentCardNumber;
    
    DebugLog(@"Scroll Right - CurrentCard = %d, count=%d",currentCard,[[FlashCardResources sharedFlashCardResources].contentList count] );

    
    if ( (currentCard) >= [[FlashCardResources sharedFlashCardResources].contentList count] ) {
        return;
        // Don't go beyound the last card
    }


    CGRect frame;

    frame.origin.x = self.Scroller.frame.size.width * currentCard;
    frame.origin.y = 0;
    frame.size = self.Scroller.frame.size;
    

    [self.Scroller scrollRectToVisible:frame animated:YES];    

    
    //This code added if not a scrollview delegate. Need to increment card in this code.    
    [ [viewControllers objectAtIndex:currentCard] playSound:nil];
    [FlashCardResources sharedFlashCardResources].currentCardNumber = currentCard + 1;
    
    
    // Fix the hidden View Card Number
    NSArray * contentList = [FlashCardResources sharedFlashCardResources].contentList;
    
    NSDictionary *numberItem = [contentList objectAtIndex:[FlashCardResources sharedFlashCardResources].currentCardNumber - 1];
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // NOTE: Add code here to change the number of apples
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    numberGameViewController.NumberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
    



         
}

- (IBAction)returnHome:(id)sender {
    
    if ( Scroller.hidden == YES ) {
        Scroller.hidden = NO;
        
        
        int currentCard = [FlashCardResources sharedFlashCardResources].currentCardNumber;
                
        
        CGRect frame;
        
        frame.origin.x = (currentCard - 1) * 480;
        frame.origin.y = 0;
        frame.size = Scroller.frame.size;
        [Scroller scrollRectToVisible:frame animated:FALSE];    
        
        
        //This code added if not a scrollview delegate. Need to increment card in this code. 
        [ [viewControllers objectAtIndex:(currentCard - 1)] playSound:nil];
        [FlashCardResources sharedFlashCardResources].currentCardNumber = currentCard;
        
        
    } else {
    
        [self dismissModalViewControllerAnimated:YES];
    }

}

- (void)loadScrollViewWithPage:(int)page
{
    
}



// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    Scroller.hidden = YES;
    // numberGameView.hidden = NO;
    [UIView beginAnimations:nil context:@"flipTransitionToBack"];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.numberGameView cache:YES];
    [UIView commitAnimations];
    
    // Reset number in based, and applect selected
    self.numberGameViewController.applePicked = 0;
    self.numberGameViewController.appleCount = 0;

    
       
    
	
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    DebugLog(@"scrollViewDidEndDecelration");
    
    // numberGameView.hidden = NO;
    
        
    int currentCard = [FlashCardResources sharedFlashCardResources].currentCardNumber;
    [ [viewControllers objectAtIndex:currentCard-1] playSound:nil];




}


- (IBAction)changePage:(id)sender
{
    
}



@end
