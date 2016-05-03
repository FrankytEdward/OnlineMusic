//
//  MusicListView.h
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/22.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MusicDekegate<NSObject>
//当model改变 通过这个方法可以获知改变的内容
-(void)musicModelDidChangedWithModelsArray:(NSArray *)modelsArray;

//当cell被点击了，通过这个方法通知viewcontroller
-(void)musicCellDidSelectedWithIndex:(NSInteger)index;

-(void)refreshModel;
@end


@interface MusicListView : UIView

@property(nonatomic,strong) NSMutableArray *musicModelsArray;//保存音乐的models

@property(nonatomic,assign)id<MusicDekegate> delegate;
@end
