# JDHashTagModule(ObjectiveC)

***
#Introduction

JDHashTagModule let u can simply make your UITextView and UITableView become "HashTag Detector" & "HashTag Picker" 

Thanks for using.

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

###Delegate(Optional):
Also, you could Implements the delegate, then you will receive notify when User "Click" On HashTag.
```objective-c
   hashtagmodel.delegate = self;
```
```objective-c
-(void)hastapHashTag:(NSString*)tag
{
    NSLog(@"%@",tag);
}
```
