//
//  NumberViewController.h
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface NumberViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIImageView *numberImage;
@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;
- (IBAction)showCounterCard:(id)sender;

- (IBAction) playSound: (id) sender;
- (IBAction) vibrate: (id) sender;

@end
