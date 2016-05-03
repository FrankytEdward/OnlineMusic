//
//  ViewController.m
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/22.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//  https://api.douban.com/v2/music/search
//  http://douban.fm/j/mine/playlist?channel=1

#import "ViewController.h"
#import "MusicListView.h"
#import "DowLOad.h"
#import "MusicModel.h"
#import "NZCircularImageView.h"
#import "Helper.h"
#import "AVFoundation/AVFoundation.h"
#import "NetWorkingHelper.h"
#import "SearchMusicModel.h"
#import "SearchList.h"

#define kInvalid -1



typedef enum{
    kPlayButtonStatusPlay, //0
    kPlayButtonStatusStop  //1
}kPlayButtonStatus;

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextLable;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet NZCircularImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLable;

@property(nonatomic,strong)NSTimer *rotatingTimer;
@property(nonatomic,strong)MusicListView *MusicList;
@property(nonatomic,strong)SearchList *searchList;
@property(nonatomic,strong) NSMutableArray *musicModelsArray;
@property(nonatomic,assign) NSInteger currentMusic;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)ViewController *timeObersver;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property(nonatomic,assign)CGFloat locationTime;

@property (weak, nonatomic) IBOutlet UILabel *songNameLable;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLable;
@property (nonatomic,strong)NSMutableArray *SearchArray;
//@property (nonatomic,strong)WebView *webView;
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentMusic = kInvalid;
    // Do any additional setup after loading the view, typically from a nib.
    self.rotatingTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotate) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:_rotatingTimer forMode:NSRunLoopCommonModes];
    
    self.MusicList = [[[NSBundle mainBundle]loadNibNamed:@"MusicListView" owner:nil options:nil]firstObject];
    self.MusicList.frame = CGRectMake(20, 42, 206, 348);
    self.MusicList.alpha = 0;
    
    self.searchList = [[[NSBundle mainBundle]loadNibNamed:@"SearchList" owner:nil options:nil]firstObject];
    self.searchList.frame = CGRectMake(98, 48, 180, 200);
    self.searchList.alpha = 0;
    CGRect rect = [UIScreen mainScreen].bounds;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, rect.size.width, rect.size.height-20)];

    self.webView.alpha = 0;
    _searchList.delegate = self;
    _MusicList.delegate = self;
    [self.view addSubview:self.MusicList];
    [self.view addSubview:self.searchList];
    [self.view addSubview:self.webView];
    
    //下载数据
    NSURL *url = [NSURL URLWithString:@"http://douban.fm/j/mine/playlist?channel=1"];
    [[DowLOad sharedInstance] downloadWithURL:url complete:^(NSData *resultData) {
        NSLog(@"%@",resultData);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",dic);
        //得到song对应的数组
        NSArray *sonsArray = [dic objectForKey:@"song"];
        self.musicModelsArray = [NSMutableArray array];
        //遍历数组
        for (NSDictionary *songDic in sonsArray) {
            //创建musicModel对象
            MusicModel *model = [[MusicModel alloc]initWithDic:songDic];
            //将当前这个音乐模型保存到数组里面去
            NSLog(@"%@ ----- %@-----%@",model.title,model.artist,model.picture);
            [self.musicModelsArray addObject:model];
        }
        //NSLog(@"%@",self.musicModelsArray);
        
        //将解析的数据传递给MusicListView
        self.MusicList.musicModelsArray = self.musicModelsArray;
    }];
    _playButton.tag = kPlayButtonStatusPlay;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rotate{
    self.coverImage.transform = CGAffineTransformRotate(self.coverImage.transform, 0.5/180*M_PI);
}

- (IBAction)ListButton:(UIButton *)sender {
    //通过透明度判断播放列表的状态
    if (self.MusicList.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.MusicList.alpha = 0.3;
        }];
        
    }else{
        [self hideMuisicView];
    }
}
//放大和渐变的动画组
-(void)hideMuisicView{
    //放大
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
    //渐变
    CABasicAnimation *opacityAnimation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.3;
    opacityAnimation.toValue = @0;
    
    //动画组
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[scaleAnimation,opacityAnimation];
    groupAnimation.duration = 0.3;
    groupAnimation.delegate = self;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.autoreverses = NO;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//先快后慢
    
    //添加动画
    [self.MusicList.layer addAnimation:groupAnimation forKey:nil];
    
}

-(void)animationDidStart:(CAAnimation *)anim{
    //真正改变透明度
    self.MusicList.alpha = 0;
}

#pragma mark - Touch事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.MusicList.alpha) {
        [self hideMuisicView];
    }
    if (self.searchList.alpha) {
        _searchList.alpha = 0;
    }
    [self.view endEditing:YES];
    
}

- (IBAction)sliderClicked:(UISlider *)sender {
    
    NSLog(@"%f",sender.value);
    if (_player != nil) {
        //[_player pause];
        CGFloat rate = sender.value;
        MusicModel *model = [_musicModelsArray objectAtIndex:_currentMusic];
        NSLog(@"------%@",model);
        self.locationTime = rate*[model.length intValue];
        NSLog(@"-------%f",_locationTime);
        self.currentTimeLable.text = [Helper timeStringWithlength:_locationTime];
        
        //[_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
        CMTime time = CMTimeMakeWithSeconds(_locationTime, _player.currentTime.timescale);
        [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            [_player play];
            [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            _playButton.tag = kPlayButtonStatusStop;
        }];
    }
}

//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint clickedPoint = [touch locationInView:self.view];
//    if (clickedPoint.y > _slider.frame.origin.y - 3 && clickedPoint.y < _slider.frame.origin.y + 3) {
//        _slider.value = clickedPoint.x/([UIScreen mainScreen].bounds.size.width);
//        //让播放器从选中的定位的时间点开始播放
//        CMTime time = CMTimeMakeWithSeconds(_locationTime, _player.currentTime.timescale);
//        [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//            [_player play];
//            
//            _playButton.tag = kPlayButtonStatusStop;
//        }];
//    }
//}
//-(void)changeProgressWithPoint:(CGPoint)clickedPoint{
//    //判断是否需要改变进度条
//    if (_player != nil) {
//        //暂停音乐
//        [_player pause];
//        //手动调整进度
//        if (clickedPoint.y >= 585 && clickedPoint.y <= 605) {
//            CGFloat rate = clickedPoint.x/[[UIScreen mainScreen]bounds].size.width;
//            
//            
//            //计算当前定位的时间点
//            
//            MusicModel *model = [_musicModelsArray objectAtIndex:_currentMusic];
//            self.locationTime = rate*[model.length intValue];
//            self.currentTimeLable.text = [Helper timeStringWithlength:_locationTime];
//        }
//    }
//    
//}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint clickedPoint = [touch locationInView:self.view];
    if (clickedPoint.y > _slider.frame.origin.y + 3 && clickedPoint.y < _slider.frame.origin.y) {
        _slider.value = clickedPoint.x/[UIScreen mainScreen].bounds.size.width;
        //让播放器从选中的定位的时间点开始播放
        CMTime time = CMTimeMakeWithSeconds(_locationTime, _player.currentTime.timescale);
        [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            [_player play];
            
            _playButton.tag = kPlayButtonStatusStop;
        }];
    }
    
}

#pragma mark -- MusicSearchDelegate

-(void)musicSearchCellDidSelectedWithIndex:(NSInteger)index{
    [self.view endEditing:YES];
    self.webView.alpha = 0.95;
    SearchMusicModel *model = [_SearchArray objectAtIndex:index];
    NSString *urlTex = model.alt;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL  URLWithString:urlTex]]];

    UIButton *hideButton = [[UIButton alloc]initWithFrame:CGRectMake(320, 10, 50, 20)];
    [hideButton setTitle:@"退出" forState:UIControlStateNormal];
    hideButton.backgroundColor = [UIColor colorWithRed:67/255.0 green:205/255.0 blue:128/255.0 alpha:0.5];
    [hideButton addTarget:self action:@selector(hideWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.webView addSubview:hideButton];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, 50, 20)];
    backButton.backgroundColor = [UIColor colorWithRed:67/255.0 green:205/255.0 blue:128/255.0 alpha:0.5];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.webView addSubview:backButton];
}

-(void)hideWebView{
    NSLog(@"----");
    if (_webView.alpha) {
        _webView.alpha = 0;
    }
}

-(void)back{
    [_webView goBack];
}

#pragma mark-musicDelegate
-(void)musicModelDidChangedWithModelsArray:(NSArray *)modelsArray{
    if (_currentMusic != kInvalid) {
        //取出index对应的model
        NSLog(@"哈哈哈哈");
        MusicModel *model = [modelsArray objectAtIndex:_currentMusic];
        
        if (model.image != nil) {
            //将图片显示
            _coverImage.image = model.image;
        }
    }
    self.musicModelsArray = [NSMutableArray arrayWithArray:modelsArray];
}

-(void)musicCellDidSelectedWithIndex:(NSInteger)index{
   //播放音乐
    //[_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self playMusicAtIndex:index];
}

#pragma mark -- refreshModel
-(void)refreshModel{
    
    //下载数据
    [self.MusicList.musicModelsArray removeAllObjects];
    [self.musicModelsArray removeAllObjects];
    NSURL *url = [NSURL URLWithString:@"http://douban.fm/j/mine/playlist?channel=1"];
    [[DowLOad sharedInstance] downloadWithURL:url complete:^(NSData *resultData) {
        NSLog(@"%@",resultData);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",dic);
        //得到song对应的数组
        NSArray *sonsArray = [dic objectForKey:@"song"];
        
        //self.musicModelsArray = [NSMutableArray array];
        //遍历数组
        for (NSDictionary *songDic in sonsArray) {
            //创建musicModel对象
            MusicModel *model = [[MusicModel alloc]initWithDic:songDic];
            //将当前这个音乐模型保存到数组里面去
            //NSLog(@"%@ ----- %@-----%@",model.title,model.artist,model.picture);
            [self.musicModelsArray addObject:model];
        }
        //NSLog(@"%@",self.musicModelsArray);
        
        //将解析的数据传递给MusicListView
        
        self.MusicList.musicModelsArray = self.musicModelsArray;
        //NSLog(@"----%@",self.MusicList.musicModelsArray);
    }];
}


#pragma - mark -- 播放音乐
-(void)playMusicAtIndex:(NSInteger)index{
    
    _currentMusic = index;
    //显示这首音乐的背景图片
    MusicModel *model = [_musicModelsArray objectAtIndex:index];
    _songNameLable.text = model.title;
    _singerNameLable.text = model.artist;
    if (model.image != nil) {
        _coverImage.image = model.image;
    }else{
        //_coverImage.image = [UIImage imageNamed:@"background"];
    }
    //获取音乐的总长度
    int totalLength = [model.length intValue];
    _totalTimeLable.text = [Helper timeStringWithlength:totalLength];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:model.url] options:nil];
    AVPlayerItem *newItem = [AVPlayerItem playerItemWithAsset:asset];
    
    //判断之前是否有在播放
    if (self.player.currentItem) {
        //替换
        [self.player replaceCurrentItemWithPlayerItem:newItem];
    }else{
        self.player = [AVPlayer playerWithPlayerItem:newItem];
    }
    //开始
    [_player play];
    
    //[_playButton setBackgroundColor:[UIColor redColor]];
    //判断是否已在播放音乐
    if (_timeObersver != nil) {
        [_player removeTimeObserver:_timeObersver];
    }
    
    //创建时间的间隔
    CMTime interval = CMTimeMake(1, 1);
    
    __weak ViewController *wSelf = self;
    self.timeObersver =  [_player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //获取总时间
        CGFloat duration = CMTimeGetSeconds(wSelf.player.currentItem.duration);
        //获取当前的播放时间
        CGFloat currentTime = CMTimeGetSeconds(wSelf.player.currentTime);
        //显示当前的播放时间
        wSelf.currentTimeLable.text = [Helper timeStringWithlength:currentTime];
        
        //设置进度条
        wSelf.slider.value = (CGFloat)currentTime/(CGFloat)duration;
        
    }];
   [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    _playButton.tag = kPlayButtonStatusStop;
}

#pragma mark -- ButtonAction
- (IBAction)playBUttonClicked:(UIButton *)sender {
    if (sender.tag == kPlayButtonStatusPlay) {
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        sender.tag = kPlayButtonStatusStop;
        [self.player play];
    }else{
        //暂停音乐
        [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        sender.tag = kPlayButtonStatusPlay;
        [self.player pause];
    }
}



- (IBAction)next:(id)sender {
    
    
}

- (IBAction)previours:(id)sender {
}

#pragma mark -- search

- (IBAction)searchButtonClicked:(UIButton *)sender {
    
    NSString *searchText = self.searchTextLable.text;
    
    if (self.searchTextLable.text.length > 0) {
        
        NSString *searchString = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *urlText = [NSString stringWithFormat:@"search?q=%@&&count=5",searchString];
        NSLog(@"urlText---%@",urlText);
        [[NetWorkingHelper sharedHttpManager]GET:urlText parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject != nil) {
                NSDictionary *dict = responseObject;
                //NSArray *resultArray = dict[@"results"];
                
                //得到song对应的数组
                
                
                
                NSArray *sonsArray = [dict objectForKey:@"musics"];
                //NSDictionary *singer = [sonsArray objectForKey:@"attrs"];
//                NSDictionary *musics = [dict objectForKey:@"musics"];
//                NSArray *attrs = [musics objectForKey:@"attrs"];
//                //NSArray *singers = [attrs objectForKey:@"singer"];
//                NSLog(@"－－－－－singer%@",attrs);
                self.SearchArray = [NSMutableArray array];
                //遍历数组
                for (NSDictionary *songDic in sonsArray) {
                    //创建musicModel对象
                    SearchMusicModel *searchModel = [[SearchMusicModel alloc]initWithDic:songDic];
                    NSDictionary *attrs = [songDic objectForKey:@"attrs"];
                    //NSLog(@"-----%@",attrs);
                    NSArray *singer = [attrs objectForKey:@"singer"];
                    NSString *singerStr = singer.firstObject;
                    //NSLog(@"singer------%@",singer);
                    NSLog(@"------%@",singerStr);
                    searchModel.singer = singerStr;
                    //将当前这个音乐模型保存到数组里面去
                    //NSLog(@"-----%@",songDic);
                    //NSLog(@"%@ ----- %@-----%@",searchModel.title,searchModel.singer,searchModel.image);
                    [self.SearchArray addObject:searchModel];
                }
                //将解析的数据传递给
                self.searchList.searchArray = self.SearchArray;
            }
            //NSLog(@"－－－－－－－%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        if (_searchList.alpha == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.searchList.alpha = 0.4;
            }];
        }
        
    }
    
}



- (IBAction)exitButtonClicked:(UIButton *)sender {
    exit(0);
}


@end
