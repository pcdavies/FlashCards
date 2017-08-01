//
//  LetterDrawingViewController.h
//  PunjabiFlashCards
//
//  Created by Home on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawingView;

@interface LetterDrawingViewController : UIViewController
 
@property (weak, nonatomic) IBOutlet DrawingView *drawView;
@property (weak, nonatomic) IBOutlet UIImageView *letterImage;
@property (weak, nonatomic) IBOutlet UILabel *letterText;
@property (weak, nonatomic) IBOutlet UIView *letterDropView;
@property (atomic, retain) NSMutableArray *allButtons;
@property (weak, nonatomic) IBOutlet UILabel *dropDownTabText;
@property (weak, nonatomic) IBOutlet UIImageView *doneImage;

- (IBAction)nextCard:(UIButton *)sender;
- (IBAction)previousCard:(UIButton *)sender;
- (IBAction)showLetterDropDown:(UIButton *)sender;
- (IBAction)loadNewLetter:(UIButton *)sender;
- (IBAction)letterSelected:(UIButton *)sender;
- (IBAction)buttonHighlighted:(UIButton *)sender;
- (IBAction)traceLetter:(UIButton *)sender;


- (IBAction)setRed:(id)sender;
- (IBAction)setGreen:(id)sender;
- (IBAction)setBlue:(id)sender;
- (IBAction)setBlack:(id)sender;
- (IBAction)returnHome:(id)sender;

 

@end
