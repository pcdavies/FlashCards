//
//  NumberSoundViewController.h
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface NumberSoundViewController  : UIViewController  <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}
- (IBAction)goHome:(UIButton *)sender;
- (IBAction)RecordButton:(id)sender;
- (IBAction)StopButton:(id)sender;
- (IBAction)PlayButton:(id)sender;
- (IBAction)changeVolume:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UIButton *PlayButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *StopButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *RecordButtonOutlet;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end
