//
//  MusicModel.h
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/22.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseModel/JZBaseModel.h"


/*
 (
 {
 aid = 2155115;
 album = "/subject/2155115/";
 albumtitle = "Lullaby Appetite";
 "alert_msg" = "";
 artist = "Alexa Wilkinson";
 "file_ext" = mp3;
 kbps = 128;
 length = 238;
 like = 0;
 picture = "http://img3.doubanio.com/lpic/s2611547.jpg";
 "public_time" = 2007;
 sha256 = eb0f0ec392d39dda59ca1ce40215c48cf82aa80ae678d0636d436ca60f3e74a0;
 sid = 355;
 singers =             (
 {
 id = 8359;
 "is_site_artist" = 0;
 name = "Alexa Wilkinson";
 "related_site_id" = 0;
 }
 );
 ssid = b52e;
 status = 0;
 subtype = "";
 title = "Every Inch";
 url = "http://mr7.doubanio.com/64ba78c4ff1173f942f6e0e82ded2fa3/1/fm/song/p355_128k.mp3";
 }
 );
 }
 */
@interface MusicModel : JZBaseModel

//属性的变量名必须和下载的数据的字段名相同


@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *artist;
@property(nonatomic,strong) NSString *picture;
@property(nonatomic,strong) NSString *length;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong)UIImage *image;//保存这首音乐的图片


@end
