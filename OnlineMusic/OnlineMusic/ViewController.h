//
//  ViewController.h
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/22.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicListView;
@protocol MusicDekegate;
@class SearchList;
@protocol MusicSearchDelegate;


@interface ViewController : UIViewController<MusicDekegate,MusicSearchDelegate>


@end

