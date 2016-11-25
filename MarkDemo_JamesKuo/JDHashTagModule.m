//
//  JDHashTagModule.m
//  MarkDemo_JamesKuo
//
//  Created by waninuser on 2016/11/15.
//  Copyright © 2016年 waninuser. All rights reserved.
//

#import "JDHashTagModule.h"

@implementation JDHashTagModule
{
    HashTagModel *_hashtagmodel;
    HashTagHighlight *_hashtaghigh;
    UITableView *_tableview;
    UITextView *_textview;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithTable_Text:(UITableView *)table txt:(UITextView *)textview
{
    self = [super init];
    if (self) {
        
        _textview = textview;
        _tableview = table;

        _textview.delegate = self;
        _textview.layer.borderWidth = 1.0;
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.transform = CGAffineTransformMakeRotation(-M_PI);
        
        
        _hashtagmodel = [[HashTagModel alloc] init];
        _hashtagmodel.delegate = self;
        
        _hashtaghigh = [HashTagHighlight new];
        [_hashtaghigh addLayoutManager: self->_textview.layoutManager];
        [_hashtaghigh replaceCharactersInRange:NSMakeRange(0, 0) withString:@"  "];
    }
    return self;
}

-(void)setHashTagColor:(UIColor *)color{
    [_hashtaghigh setTagColor:color];
}




/**
 
 HashTagModelDelegate
 
 **/

-(void)hasfindHashTag{
    if(_tableview != nil)
    {
        [_tableview reloadData];
    }
}


/**
 
 TextView Delegate
 
 **/


- (void)textViewDidChange:(UITextView *)textView{
    [_hashtagmodel analyzeText:_hashtaghigh.string change:@""];
}


/**
 
 TableView DataSource
 
 **/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_hashtagmodel getResult].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *_cellName = @"HashTagTableViewCell";
    UINib *_cellNib = [UINib nibWithNibName:_cellName bundle:nil];
    [tableView registerNib:_cellNib forCellReuseIdentifier:_cellName];
    HashTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellName];
    cell.taglabel.text = [_hashtagmodel getResult][indexPath.row];
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    return cell;
}


/**
 
 TableView Delegate
 
 **/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *_selectedTag = [_hashtagmodel getResult][indexPath.row];
    _selectedTag = [_selectedTag stringByAppendingString:@" "];  //製作Tag結尾
    [_hashtagmodel analyzeText:_hashtaghigh.string change:_selectedTag];
    [_hashtaghigh setString:_hashtagmodel.replaced];
    /* 刷新高亮 */
    [_hashtagmodel analyzeText:_hashtaghigh.string change:@""];
}





@end
