//
//  JDHashTagModule.m
//  MarkDemo_JamesKuo
//
//  Created by JamesDouble on 2016/11/15.
//  Copyright © 2016年 JamesDouble. All rights reserved.
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
        _textview.selectable = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
        tap.delegate = self;
        [_textview addGestureRecognizer:tap];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.hidden = YES;
        _tableview.transform = CGAffineTransformMakeRotation(-M_PI);
        
        
        _hashtagmodel = [[HashTagModel alloc] init];
        _hashtagmodel.delegate = self;
        
        _hashtaghigh = [HashTagHighlight new];
        [_hashtaghigh addLayoutManager: self->_textview.layoutManager];
        [_hashtaghigh replaceCharactersInRange:NSMakeRange(0, 0) withString:@"  "];
        [self setHashTagColor:[UIColor redColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

-(void)setHashTagColor:(UIColor *)color{
    [_hashtaghigh setTagColor:color];
}

-(void)setNameTagColor:(UIColor *)color
{
    [_hashtaghigh setNameColor:color];
}




/**
 
 HashTagModelDelegate
 
 **/

-(void)hasfindHashTag{
    if(_tableview != nil)
    {
        [_tableview reloadData];
       if( [_hashtagmodel getResult].count == 0)
        {
            _tableview.hidden = YES;
        }
        else{
            _tableview.hidden = NO;
        }
    }
}

/**

 HashTagModel
 
 **/

-(void)addToDictionary:(NSString*)input
{
    [_hashtagmodel addExpand:input];
}

-(void)addArrayToDictionary:(NSArray *)inputs
{
    NSString* input = @"";
    for (input in inputs) {
         [_hashtagmodel addExpand:input];
    }
}


/**
 
 TextView Delegate
 
 **/

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
   // [self.view setFrame:CGRectMake(0,-110,320,460)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGRect textviewNewFrame = CGRectMake(_textview.frame.origin.x, _textview.frame.origin.y - keyboardFrameBeginRect.size.height , _textview.frame.size.width, _textview.frame.size.height);
    _textview.frame = textviewNewFrame;

    NSLog(@"%s",__FUNCTION__);
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
     CGRect textviewNewFrame = CGRectMake(_textview.frame.origin.x, _textview.frame.origin.y + keyboardFrameBeginRect.size.height , _textview.frame.size.width, _textview.frame.size.height);
    _textview.frame = textviewNewFrame;

    NSLog(@"%s",__FUNCTION__);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)textViewDidChange:(UITextView *)textView{
    
    [_hashtagmodel analyzeText:_hashtaghigh.string change:@""];
}

- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = _textview;
    NSMutableArray *hashtagrange = [_hashtaghigh gethashtagrange];
 
    if(hashtagrange.count == 0)
    {
        return;
    }
   
    // Location of the tap in text-container coordinates
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    // Find the character that's been tapped on
    
    NSUInteger characterIndex = 0;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    if(characterIndex == [_hashtaghigh string].length -1) //其實是點到字外面
    {
        return;
    }
    
    [self checkClickTagOrNot:characterIndex arr:hashtagrange];
   
}

-(void)checkClickTagOrNot:(NSUInteger)index arr:(NSMutableArray<NSValue*>*)arr
{
    for(int i=0;i<arr.count;i+=1)
    {
    NSRange _temprange = arr[i].rangeValue;
    /*   有無點擊到hashtag   */
    if(index >= _temprange.location && index <= _temprange.location + _temprange.length)
        {
            if(_delegate != NULL)
            {
               [_delegate hastapHashTag:[[_hashtaghigh string] substringWithRange:_temprange]];
                break;
            }
        }
    }

}

/**
 
    Gesture Delegate , this make gesture still working when it is editing~
 
 **/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
