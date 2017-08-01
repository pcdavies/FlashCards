//
//  NumberSoundViewController.m
//  PunjabiFlashCards
//
//  Created by Home on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumberSoundViewController.h"
#import "DebugMacro.h"

@implementation NumberSoundViewController

@synthesize PlayButtonOutlet;
@synthesize StopButtonOutlet;
@synthesize RecordButtonOutlet;
@synthesize slider;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PlayButtonOutlet.enabled = NO;
    StopButtonOutlet.enabled = NO;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    DebugLog(@"Getting Sound File");
    
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], 
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], 
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    DebugLog(@"Setting up AudioRecorder");
    
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        DebugLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
    }
    

}

- (void)viewDidUnload
{
    
    [self setPlayButtonOutlet:nil];
    [self setPlayButtonOutlet:nil];
    [self setStopButtonOutlet:nil];
    [self setRecordButtonOutlet:nil];
    
    [self setSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation != UIInterfaceOrientationPortrait);
}


- (IBAction)goHome:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];

}

- (IBAction)RecordButton:(id)sender {
    if (!audioRecorder.recording)
    {
        PlayButtonOutlet.enabled = NO;
        StopButtonOutlet.enabled = YES;
        [audioRecorder record];
    }
}

- (IBAction)StopButton:(id)sender {
    
    StopButtonOutlet.enabled = NO;
    PlayButtonOutlet.enabled = YES;
    RecordButtonOutlet.enabled = YES;
    
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
}
- (IBAction)PlayButton:(id)sender {
    
    if (!audioRecorder.recording)
    {
        StopButtonOutlet.enabled = YES;
        RecordButtonOutlet.enabled = NO;
        
        //if (audioPlayer)
        //    [audioPlayer release];
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc] 
                       initWithContentsOfURL:audioRecorder.url                                    
                       error:&error];
        
        audioPlayer.volume = slider.value;
        
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@", 
                  [error localizedDescription]);
        else
            [audioPlayer play];
    }
}

- (IBAction)changeVolume:(UISlider *)sender {
    
    DebugLog(@"Slider Value = %f",slider.value);
    audioPlayer.volume = slider.value;

    
}

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    RecordButtonOutlet.enabled = YES;
    StopButtonOutlet.enabled = NO;
}
-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player 
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder 
                          successfully:(BOOL)flag
{
}
-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder 
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

@end
