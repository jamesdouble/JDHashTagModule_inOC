//
//  ViewController.m
//  MarkDemo_JamesKuo
//
//  Created by waninuser on 2016/11/4.
//  Copyright © 2016年 waninuser. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *_textview;
@property (weak, nonatomic) IBOutlet UITableView *_tableview;


@end

@implementation ViewController
{
    HashTagModel *hashtagmodel;
    HashTagHighlight *hashtaghigh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __textview.delegate = self;
    __textview.layer.borderWidth = 1.0;
    
    __tableview.delegate = self;
    __tableview.dataSource = self;
     __tableview.transform = CGAffineTransformMakeRotation(-M_PI);
 
    
    hashtagmodel = [HashTagModel alloc];
    hashtagmodel = [hashtagmodel initWithTextView:__textview];
    hashtagmodel.delegate = self;
    
    hashtaghigh = [HashTagHighlight new];
    [hashtaghigh addLayoutManager: self._textview.layoutManager];
    [hashtaghigh replaceCharactersInRange:NSMakeRange(0, 0) withString:@"  "];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 
 
 HashTagModelDelegate
 
 **/

-(void)hasfindHashTag:(NSArray *)pattern{
    if(__tableview != nil)
    {
        [__tableview reloadData];
    }
    [hashtaghigh setHighlightPattern:pattern];
}


/**
 
 TextView Delegate
 
 **/


- (void)textViewDidChange:(UITextView *)textView{
    [hashtagmodel analyzeText:hashtaghigh.string change:@""];
}


/**
 
 TableView DataSource
 
 **/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [hashtagmodel getResult].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *_cellName = @"HashTagTableViewCell";
    UINib *_cellNib = [UINib nibWithNibName:_cellName bundle:nil];
    [tableView registerNib:_cellNib forCellReuseIdentifier:_cellName];
    HashTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellName];
    cell.taglabel.text = [hashtagmodel getResult][indexPath.row];
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    return cell;
}


/**
 
 TableView Delegate
 
 **/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *_selectedTag = [hashtagmodel getResult][indexPath.row];
    _selectedTag = [_selectedTag stringByAppendingString:@"!"];  //製作Tag結尾
    [hashtagmodel analyzeText:hashtaghigh.string change:_selectedTag];
    [hashtaghigh setString:hashtagmodel.replaced];
    [hashtagmodel analyzeText:hashtaghigh.string change:@""];
}



@end
