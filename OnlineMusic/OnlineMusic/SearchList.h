//
//  SearchList.h
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/28.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicSearchDelegate<NSObject>
//当model改变 通过这个方法可以获知改变的内容
-(void)musicModelDidChangedWithModelsArray:(NSArray *)searchModelsArray;

//当cell被点击了，通过这个方法通知viewcontroller
-(void)musicSearchCellDidSelectedWithIndex:(NSInteger)index;
@end

@interface SearchList : UIView

@property(nonatomic,assign)id<MusicSearchDelegate>delegate;
@property(nonatomic,strong) NSMutableArray *searchArray;

@end
