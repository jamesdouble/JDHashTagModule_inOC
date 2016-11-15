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
    JDHashTagModule *hashtagmodel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hashtagmodel = [[JDHashTagModule alloc] initWithTable_Text:__tableview txt:__textview];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
