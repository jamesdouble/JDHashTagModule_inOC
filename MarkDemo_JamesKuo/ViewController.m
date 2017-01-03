//
//  ViewController.m
//  MarkDemo_JamesKuo
//
//  Created by JamesDouble on 2016/11/4.
//  Copyright © 2016年 JamesDouble. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *_textview;
@property (weak, nonatomic) IBOutlet UITableView *_tableview;


@end

@implementation ViewController
{
    JDHashTagModule *hashtagmodel;
    NSArray *colorarr;
    int tagcount;
    int namecount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hashtagmodel = [[JDHashTagModule alloc] initWithTable_Text:__tableview txt:__textview];
    hashtagmodel.delegate = self;
    [hashtagmodel addToDictionary:@"JamesDouble"];
    [hashtagmodel addArrayToDictionary:@[@"HashTag",@"GitHub"]];
    colorarr = [[NSArray alloc] initWithObjects:[UIColor greenColor],[UIColor redColor],[UIColor blueColor],[UIColor yellowColor], nil];
    tagcount = 0;
    namecount = 0;
    
};



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

- (IBAction)changeTagColor:(id)sender {
    [hashtagmodel setHashTagColor:colorarr[tagcount]];
    if(tagcount +1 == colorarr.count)
    {
        tagcount = 0;
    }
    else
    {
        tagcount += 1;
    }
}

- (IBAction)changeNameColor:(id)sender {
    [hashtagmodel setNameTagColor:colorarr[namecount]];
    if(namecount +1 == colorarr.count)
    {
        namecount = 0;
    }
    else
    {
        namecount += 1;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
