//
//  NumberScrollViewController.h
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NumberGameViewController;

@interface NumberScrollViewController : UIViewController  <UIScrollViewDelegate> ;

@property (weak, nonatomic) IBOutlet UIScrollView *Scroller;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@property (nonatomic, retain) NumberGameViewController *numberGameViewController;
@property (weak, nonatomic) IBOutlet UIView *numberGameView;


- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;
- (IBAction)scrollLeft:(id)sender;
- (IBAction)scrollRight:(id)sender;
- (IBAction)returnHome:(id)sender;


@end