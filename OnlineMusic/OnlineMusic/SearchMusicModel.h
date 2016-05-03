//
//  SearchMusicModel.h
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/28.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseModel/JZBaseModel.h"

@interface SearchMusicModel : JZBaseModel
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *singer;
//-(instancetype)initWithSongName:(NSString *)songName artist:(NSString *)artist;
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) UIImage *picture;
@property(nonatomic,strong) NSString *alt;
@end
