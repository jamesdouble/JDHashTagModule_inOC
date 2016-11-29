# JDHashTagModule(ObjectiveC)

***
#Introduction

JDHashTagModule let u can simply make your UITextView and UITableView become "HashTag Detector" & "HashTag Picker" 

Thanks for using.

![Alt text](/../master/Readme_img/JDhashtagmodule_demo.gif?raw=true "")
***
#Usage

```objective-c
@implementation ViewController
{
    JDHashTagModule *hashtagmodel;
}

-(void)viewDidLoad {
hashtagmodel = [[JDHashTagModule alloc] initWithTable_Text:__tableview txt:__textview];
}
```

###Method:



Change HashTagColor, it will change the color of hashtag which is displaying.
```objective-c
-(void)setHashTagColor:(UIColor *)color; 
```
Change NameTagBackgroundColor, it will change the color of hashtag which is displaying.
```objective-c
-(void)setNameTagColor:(UIColor *)color;
```

![Alt text](/../master/Readme_img/hashcolor_setting.gif?raw=true "")

###Delegate(Optional):
Also, you could Implements the delegate, then you will receive notify when User "Click" On HashTag.
```objective-c
   hashtagmodel.delegate = self;
```
```objective-c
-(void)hastapHashTag:(NSString*)tag
{
  UIAlertController *_alert = [[UIAlertController alertControllerWithTitle:tag message:@"" preferredStyle:UIAlertControllerStyleAlert] init];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [_alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [_alert addAction:ok];
    [self presentViewController:_alert animated:YES completion:nil];

}
```

![Alt text](/../master/Readme_img/delegate_test.gif?raw=true "")
