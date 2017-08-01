//
//  NumberGameViewController.h
//  PunjabiFlashCards
//
//  Created by Home on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberGameViewController : UIViewController;

@property (weak, nonatomic) IBOutlet UIImageView *NumberImage;
@property (weak, nonatomic) IBOutlet UIImageView *apple1;
@property (weak, nonatomic) IBOutlet UIImageView *apple2;
@property (weak, nonatomic) IBOutlet UIImageView *apple3;
@property (weak, nonatomic) IBOutlet UIImageView *apple4;
@property (weak, nonatomic) IBOutlet UIImageView *apple5;
@property (weak, nonatomic) IBOutlet UIImageView *apple6;
@property (weak, nonatomic) IBOutlet UIImageView *apple7;
@property (weak, nonatomic) IBOutlet UIImageView *apple8;
@property (weak, nonatomic) IBOutlet UIImageView *apple9;
@property (weak, nonatomic) IBOutlet UIImageView *apple10;

@property (weak, nonatomic) IBOutlet UIImageView *basket;

@property (weak, nonatomic) UIImageView *currentApple;


@property int applePicked;
@property int appleCount;


@property CGPoint startPoint;



@end
