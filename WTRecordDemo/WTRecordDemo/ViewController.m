//
//  ViewController.m
//  WTRecordDemo
//
//  Created by 马冰垒 on 2017/12/26.
//  Copyright © 2017年 马冰垒. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EZAudio.h"

@interface ViewController () <EZMicrophoneDelegate>
/** 开始 */
@property (weak, nonatomic) IBOutlet UIButton *startButton;
/** 暂停 */
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@property (weak, nonatomic) IBOutlet EZAudioPlot *audioPlot;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setup {
    [EZMicrophone sharedMicrophone].delegate = self;
    
    //背景颜色（使用iOS的UIColor）
    self.audioPlot.backgroundColor = [UIColor colorWithRed:0.816 green:0.349 blue:0.255 alpha:1];
    //波形颜色（使用iOS的UIColor）
    self.audioPlot.color = [UIColor  colorWithRed:1.000 green:1.000 blue:1.000 alpha:1 ];
    //绘图类型
    self.audioPlot.plotType = EZPlotTypeBuffer;
    //填充
    self.audioPlot.shouldFill = YES ;
    //镜像
    self.audioPlot.shouldMirror = YES ;
}

- (void)microphone:(EZMicrophone *)microphone changedPlayingState:(BOOL)isPlaying {
    NSLog(@"麦克风%@录制", isPlaying ? @"开始" : @"暂停");
}

- (void)microphone:(EZMicrophone *)microphone changedDevice:(EZAudioDevice *)device {
    NSLog(@"切换输入设备%@", device);
    
}

- (void)microphone:(EZMicrophone *)microphone
hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
    
}

- (void)microphone:(EZMicrophone *)microphone
      hasAudioReceived:(float **)buffer
        withBufferSize:(UInt32)bufferSize
  withNumberOfChannels:(UInt32)numberOfChannels {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

- (void)microphone:(EZMicrophone *)microphone
         hasBufferList:(AudioBufferList *)bufferList
        withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    
}

/**
 开始录音
 */
- (IBAction)startRecord:(id)sender {
    [[EZMicrophone sharedMicrophone] startFetchingAudio];
}

/**
 暂停录音
 */
- (IBAction)pauseRecord:(id)sender {
    [[EZMicrophone sharedMicrophone] stopFetchingAudio];
}


@end
