//
//  SearchList.m
//  OnlineMusic
//
//  Created by 蓝山工作室 on 16/4/28.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "SearchList.h"
#import "SearchMusicModel.h"

@interface SearchList ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property(nonatomic,assign)NSInteger lastSelectedRow;
@end
#define KInvalid -1
@implementation SearchList

-(void)awakeFromNib{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

//重写setter方法
-(void)setSearchArray:(NSMutableArray *)searchArray{
    if (self.searchArray != searchArray) {
        _searchArray = searchArray;
    }
    //刷新
    
    [_tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        SearchMusicModel *model = [_searchArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = model.singer;
        NSLog(@"model.title----%@ ----%@---%@",model.title,model.singer,model.alt);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        //通知主界面这个cell被选中了
        if ([_delegate respondsToSelector:@selector(musicSearchCellDidSelectedWithIndex:)]) {
            [_delegate musicSearchCellDidSelectedWithIndex:indexPath.row];
        }
    
}


@end
