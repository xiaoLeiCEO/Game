//
//  FirstViewController.m
//  Cheers
//
//  Created by 章丘研发 on 2018/1/31.
//  Copyright © 2018年 base. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FirstViewController ()

@property (nonatomic,strong) NSArray *lineArr;

@property (nonatomic,strong) UITextField *lineCountTf;

@property (nonatomic,strong) UIView *lineBackgroundView;

@property (nonatomic,assign) NSInteger random;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;


@property (nonatomic,strong) AVAudioPlayer *kachaAudioPlayer;

@property (nonatomic,assign) NSInteger count;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _count = 10;
    
    // 1.获取要播放音频文件的URL
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"huohua" withExtension:@".wav"];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    // 3.打印歌曲信息
    NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.audioPlayer.numberOfChannels,self.audioPlayer.duration];
    NSLog(@"%@",msg);
    // 4.设置循环播放
    self.audioPlayer.numberOfLoops = -1;
    // 5.开始播放
    [self.audioPlayer play];
    
    [self.view addSubview:self.lineBackgroundView];
    self.random = arc4random()%_count + 200;
    
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"shezhi"] forState:normal];
    setBtn.frame = CGRectMake(375-50, 44, 30, 30);
    [setBtn addTarget:self action:@selector(setBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];

    [self getBoomAnimation];
    
}


- (void)getBoomAnimation
{
    //创建一个CAEmitterLayer,大小同view一样
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = CGRectMake(375/2.0f-25, 17, 50, 100);
    [self.view.layer addSublayer:emitter];
    //渲染模式！！！一共有五个效果，修改了效果会有区分
    emitter.renderMode = kCAEmitterLayerOldestLast;
    emitter.emitterMode = kCAEmitterLayerCircle;
    
    //整体位置
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    emitter.velocity = 1;
    emitter.emitterSize       = CGSizeMake(50, 50);
    
    //每个图像单位
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"FFRing"].CGImage;
    //图像的出现频率（每秒钟图片出现的数量）
    cell.scale = 0.2;
    cell.birthRate = 200;
    //每个图像的生命周期
    cell.lifetime = 0.5;
    //图片背景色，不设置就是原图
    cell.color = [UIColor yellowColor].CGColor;
    //透明度每过一秒就是减少0.5
    cell.alphaSpeed = -0.2;
    //发射速度
    cell.velocity = 100;
    //每个图像速度范围
    cell.velocityRange = 120;
    //散射的范围，目前是向四周
    cell.emissionRange = M_PI;
    //开始动画
    emitter.emitterCells = @[cell];
}


-(void)setBtnAction{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"请输入线条个数"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.1 添加文本框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入线条个数";
    }];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *userName = alertController.textFields.firstObject;
        self.count = userName.text.integerValue;
        
        [self.lineBackgroundView removeFromSuperview];
        self.lineBackgroundView = nil;
        [self.view addSubview:self.lineBackgroundView];
        self.random = arc4random()%_count + 200;
        
    }];
 
    
    
    [alertController addAction:loginAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view addSubview:self.lineBackgroundView];
    self.random = arc4random()%_count + 200;
    [self.audioPlayer play];

}


-(UIView *)lineBackgroundView{
    if (!_lineBackgroundView){
        _lineBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 736/2.0f-80-160, 375-20, 200)];
        _lineBackgroundView.backgroundColor = [UIColor colorWithRed:230/255.0f green:0 blue:18/255.0f alpha:1];

        CGFloat b = (375-20.f)/_count;

        for (int i=0;i<_count;i++){
            UIView *upLineView = [[UIView alloc]initWithFrame:CGRectMake(b/2 + i*b, 10, 5, (200-20.0f)/2)];
            UIView *downLineView = [[UIView alloc]initWithFrame:CGRectMake(b/2 + i*b, 10 + (200-20.0f)/2, 5, (200-20.0f)/2)];
            
            upLineView.userInteractionEnabled = NO;
            downLineView.userInteractionEnabled = NO;
            upLineView.tag = i + 200;
            downLineView.tag = i +300;
            upLineView.backgroundColor = [UIColor blueColor];
            downLineView.backgroundColor = [UIColor blueColor];

            [_lineBackgroundView addSubview:upLineView];
            [_lineBackgroundView addSubview:downLineView];

        }
    }
    return _lineBackgroundView;
}


//当有一个或多个手指触摸事件在当前视图或window窗体中响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //返回与当前接收者有关的所有的触摸对象
    NSSet *allTouches = [event touchesForView:_lineBackgroundView];
    if (allTouches){
        UITouch *touch = [allTouches anyObject];   //视图中的所有对象
        CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
        int x = point.x;
        int y = point.y;
        NSLog(@"touch (x, y) is (%d, %d)", x, y);
        CGFloat b = (375-20.f)/_count;

        for (int i=0;i<_count;i++){
            
            CGRect rect = CGRectMake(_count/2.0f+i*b, 10, b-5, 200-20);
            
            if (CGRectContainsPoint(rect, point)){
                
                // 1.获取要播放音频文件的URL
                NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"kacha" withExtension:@".mp3"];
                // 2.创建 AVAudioPlayer 对象
                self.kachaAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
                // 3.打印歌曲信息
                NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.audioPlayer.numberOfChannels,self.kachaAudioPlayer.duration];
                NSLog(@"%@",msg);
                // 4.设置循环播放
                self.kachaAudioPlayer.numberOfLoops = 1;
                // 5.开始播放
                [self.kachaAudioPlayer play];
                
                UIView *upLineView = [self.view viewWithTag:i+200];
                UIView *downLineView = [self.view viewWithTag:i+300];
                [UIView animateWithDuration:2 animations:^{
                    upLineView.frame = CGRectMake(upLineView.frame.origin.x, -200, upLineView.frame.size.width, upLineView.frame.size.height);
                    upLineView.alpha = 0;
                    downLineView.frame = CGRectMake(upLineView.frame.origin.x, 500, upLineView.frame.size.width, upLineView.frame.size.height);
                    downLineView.alpha = 0;
                    if (self.random==i+200){
                        
                        ViewController *VC = [[ViewController alloc]init];
                        [self presentViewController:VC animated:YES completion:nil];
                        
                    }
                    
                } completion:^(BOOL finished) {
                    [upLineView removeFromSuperview];
                    [downLineView removeFromSuperview];
                    
                }];
            }
        }
    }
}  


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.lineBackgroundView removeFromSuperview];
    self.lineBackgroundView = nil;
    [self.audioPlayer pause];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
