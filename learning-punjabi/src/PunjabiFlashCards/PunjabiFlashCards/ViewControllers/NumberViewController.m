//
//  NumberViewController.m
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumberViewController.h"
#import "FlashCardResources.h"
#import "DebugMacro.h"  



static NSString *ImageKey = @"imageKey";

@implementation NumberViewController


@synthesize numberImage;
@synthesize soundFileURLRef, soundFileObject;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //DebugLog(@"card = %d",[FlashCardResources sharedFlashCardResources].currentCardNumber);
    
    
    
    
    int arraySize = [[FlashCardResources sharedFlashCardResources].contentList count];
    if (   [FlashCardResources sharedFlashCardResources].currentCardNumber > arraySize || [FlashCardResources sharedFlashCardResources].currentCardNumber < 1 ) {
        
        DebugLog(@"Can't go beyound the number of allowed: cardNumber=%d, array size=%d",[FlashCardResources sharedFlashCardResources].currentCardNumber,arraySize);
        return;
    } 
    
    int cardIndex = [FlashCardResources sharedFlashCardResources].currentCardNumber - 1;
    
    
    
    // Get the parameters from a singleton used to hold common data
    NSArray * contentList = [FlashCardResources sharedFlashCardResources].contentList;
    
    NSDictionary *numberItem = [contentList objectAtIndex:cardIndex];
    
    numberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
    
    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: [NSString stringWithFormat:@"%d",[FlashCardResources sharedFlashCardResources].currentCardNumber]
                                                withExtension: @"wav"];
	
    // Store the URL as a CFURLRef instance
    soundFileURLRef = (__bridge CFURLRef) tapSound;
	
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
									  
									  soundFileURLRef,
									  &soundFileObject
									  );
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation != UIInterfaceOrientationPortrait);
}

- (IBAction)showCounterCard:(id)sender {
    DebugLog(@"Counter View button pressed");
    /*
    
    UIStoryboard *storyboard = self.storyboard;
    
    // This is a regular view controller
    NumberCountingViewController *ncvc = [storyboard instantiateViewControllerWithIdentifier:@"NumberCountingViewController"];
    
    // configure the new view controller explicitly here.
    
    [self presentViewController:ncvc animated:YES completion:nil];
     */
}

- (IBAction) playSound: (id) sender {
    
	
    AudioServicesPlaySystemSound (soundFileObject);
}

- (IBAction) vibrate: (id) sender {
	
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}



@end
