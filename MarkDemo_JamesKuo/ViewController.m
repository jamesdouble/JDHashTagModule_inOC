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
    hashtagmodel.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setEditing:NO];
}

-(void)hastapHashTag:(NSString*)tag
{
    NSLog(@"%@",tag);
    UIAlertController *_alert = [[UIAlertController alertControllerWithTitle:tag message:@"" preferredStyle:UIAlertControllerStyleAlert] init];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [_alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [_alert addAction:ok];
    [self presentViewController:_alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
