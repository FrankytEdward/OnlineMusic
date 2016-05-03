//
//  MusicListView.m
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/22.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "MusicListView.h"
#import "MusicCell.h"
#import "MusicModel.h"
#import "DowLOad.h"

#define KInvalid -1
@interface MusicListView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
@property(nonatomic,assign)NSInteger lastSelectedRow;
@end


@implementation MusicListView


//当xib加载完毕就会来调用这个方法
-(void)awakeFromNib{
    self.musicTableView.delegate = self;
    self.musicTableView.dataSource = self;
    
    _lastSelectedRow = KInvalid;
}

//重写setter方法
-(void)setMusicModelsArray:(NSMutableArray *)musicModelsArray{
    if (self.musicModelsArray != musicModelsArray) {
        _musicModelsArray = musicModelsArray;
    }
    //刷新
   
    [_musicTableView reloadData];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicModelsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"musicCell";
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MusicCell" owner:nil options:nil]firstObject];
    }
    //1.显示的序号
    cell.numLable.text = [NSString stringWithFormat:@"%@%ld",indexPath.row<9?@"0":@"",indexPath.row+1];
    
    //2.显示歌名
    //获取这个音乐的model
    MusicModel *model = [_musicModelsArray objectAtIndex:indexPath.row];
    
    cell.nameLable.text = model.title;
    
    //判断是否应该显示还是隐藏图片
    //if (_lastSelectedRow == indexPath.row) {
    
        cell.iconImageView.hidden = NO;
        cell.numLable.hidden = YES;
    //3.显示图片
        if (model.image != nil) {
            cell.iconImageView.image = model.image;
            NSLog(@"-----image%@",model.image);
        }else{
            //下载一张
            NSURL *url = [NSURL URLWithString:model.picture];
            [[DowLOad sharedInstance]downloadWithURL:url complete:^(NSData *resultData) {
                //NSData转换成UiImage
                UIImage *image = [UIImage imageWithData:resultData];
                cell.iconImageView.image = image;
                NSLog(@"-------%@",image);
                //缓存
                model.image = image;
                //改变原始数据
                [_musicModelsArray replaceObjectAtIndex:indexPath.row withObject:model];
                
                //通知viewcontroller model改变了
                if ([_delegate respondsToSelector:@selector(musicModelDidChangedWithModelsArray:)]) {
                    [_delegate musicModelDidChangedWithModelsArray:_musicModelsArray];
                }
            }];
            cell.iconImageView.image = model.image;
        }
//}
//else{
//        //隐藏图片
//        cell.iconImageView.hidden = YES;
//        cell.numLable.hidden = NO;
//    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"----%ld",indexPath.row);
    [self changeCellStatusAtIndexPath:indexPath];
}

//实现cell选中的操作
-(void)changeCellStatusAtIndexPath:(NSIndexPath *)indexPath{
    //获得indexPath对应的cell
    
    if (indexPath.row != _lastSelectedRow) {
        MusicCell *cell = [_musicTableView cellForRowAtIndexPath:indexPath];
        cell.iconImageView.hidden = NO;
        cell.numLable.hidden = YES;
        
        //将上一次选中的状态切换回来
//        if (_lastSelectedRow != KInvalid) {
//            NSIndexPath *oldPath = [NSIndexPath indexPathForRow:_lastSelectedRow inSection:0];
//            MusicCell *cell = [_musicTableView cellForRowAtIndexPath:oldPath];
//            cell.iconImageView.hidden = YES;
//            cell.numLable.hidden = NO;
//        }
        //通知主界面这个cell被选中了
        if ([_delegate respondsToSelector:@selector(musicCellDidSelectedWithIndex:)]) {
            [_delegate musicCellDidSelectedWithIndex:indexPath.row];
        
        }
        
    }
    //记录上一次选中的值
    _lastSelectedRow = indexPath.row;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (IBAction)refreshButton:(UIButton *)sender {
    _lastSelectedRow = KInvalid;
    [_delegate refreshModel];
}

@end
