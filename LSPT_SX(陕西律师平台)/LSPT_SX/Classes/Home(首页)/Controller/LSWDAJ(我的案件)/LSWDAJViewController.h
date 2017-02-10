//
//  LSWDAJViewController.h
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSWDAJViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    UISearchBar *_searchBar;//表格视图中的搜索栏控件
    NSMutableArray *_searchArray;//存放搜索结果的数据
    NSMutableArray *_tempArray;//临时存放的位置

}

@end
