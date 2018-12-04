//
//  PGNumberKeyboard.m
//  edetection
//
//  Created by piggybear on 2017/6/29.
//  Copyright © 2017年 piggybear. All rights reserved.
//  GitHub Address: https://github.com/xiaozhuxiong121/PGNumberKeyboard

#import "PGNumberKeyboard.h"
#define keyboardScreenWidth   [UIScreen mainScreen].bounds.size.width
#define keyboardScreenHeight  [UIScreen mainScreen].bounds.size.height
#define keyboardColor(r,g,b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f]

@interface PGNumberKeyboard ()
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UITextView *textView;
@end

@implementation PGNumberKeyboard

- (instancetype)initWithTextField:(UITextField *)textField {
    if (self = [super init]) {
        self.textField = textField;
        self.verify = true;
        self.backgroundColor = [UIColor greenColor];
        self.frame = CGRectMake(0, keyboardScreenHeight - 150, keyboardScreenHeight, 150);
        [self setupKeyBoard];
        [textField reloadInputViews];
    }
    return self;
}

- (instancetype)initWithTextView:(UITextView *)textView {
    if (self = [super init]) {
        self.textView = textView;
        self.verify = true;
        self.backgroundColor = [UIColor greenColor];
        self.frame = CGRectMake(0, keyboardScreenHeight - 150, keyboardScreenHeight, 150);
        [self setupKeyBoard];
        [textView reloadInputViews];
    }
    return self;
}

- (void)setup {
    if ([_delegate respondsToSelector:@selector(editChanage:)]) {
        if (self.textField) {
            [_delegate editChanage:self.textField];
        }else if(self.textView) {
            [_delegate editChanage:self.textView];
        }
    }
}
- (void)setupKeyBoard {
    self.frame=CGRectMake(0, keyboardScreenHeight-243, keyboardScreenWidth, 243);
    int space = 1;
    NSInteger leftSpace = 1;
    for (int i=0; i< 9; i++) {
        NSString *str=[NSString stringWithFormat:@"%d",i+1];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        if (i<3) {
            button.frame=CGRectMake(i%3*(keyboardScreenWidth/4)+leftSpace, i/3*61, keyboardScreenWidth/4-1, 60);
        }
        else{
            button.frame=CGRectMake(i%3*(keyboardScreenWidth/4)+leftSpace, i/3*60+i/3*space, keyboardScreenWidth/4-1, 60);
        }
        button.backgroundColor=[UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:24];
        [button setTitle:str forState:UIControlStateNormal];
        button.tag = i + 1;
        [button addTarget:self action:@selector(keyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i == 0 || i == 3 || i == 6) {
            button.frame=CGRectMake(0, button.frame.origin.y, button.frame.size.width + 1, button.frame.size.height);
        }
        [self mapButton:i button:button];
    }
    
    UIButton *dotButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dotButton.frame=CGRectMake(0, 60*3+3 ,keyboardScreenWidth/4, 60);
    dotButton.backgroundColor=[UIColor whiteColor];
    [dotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dotButton.titleLabel.font=[UIFont systemFontOfSize:24];
    [dotButton addTarget:self action:@selector(keyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
    [dotButton setTitle:@"." forState:UIControlStateNormal];
    dotButton.tag = 11;
    [self addSubview:dotButton];
    self.dotButton = dotButton;
    
    UIButton *zeroButton = [UIButton buttonWithType:UIButtonTypeSystem];
    zeroButton.frame = CGRectMake(keyboardScreenWidth/4+1*space,60*3+3, keyboardScreenWidth/4-1, 60);
    zeroButton.backgroundColor = [UIColor whiteColor];
    [zeroButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    zeroButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [zeroButton setTitle:@"0" forState:UIControlStateNormal];
    zeroButton.tag = 0;
    [zeroButton addTarget:self action:@selector(keyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zeroButton];
    self.zeroButton = zeroButton;
    
    UIButton *minusButton=[UIButton buttonWithType:UIButtonTypeSystem];
    minusButton.frame=CGRectMake(keyboardScreenWidth/4*2+space,60*3+3, keyboardScreenWidth/4-1, 60);
    minusButton.backgroundColor=[UIColor whiteColor];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    minusButton.tag=12;
    [minusButton addTarget:self action:@selector(keyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusButton];
    self.minusButton = minusButton;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.backgroundColor = [UIColor redColor];
    deleteButton.frame=CGRectMake(keyboardScreenWidth/4*3 + space, 0, keyboardScreenWidth/4, 122);
    [deleteButton addTarget:self action:@selector(keyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag=10;
    UIImageView *deleteImage=[[UIImageView alloc]initWithFrame:CGRectMake((keyboardScreenWidth/4-1 - 28) * 1.0 / 2, 50, 28, 20)];
    deleteImage.image=[UIImage imageNamed:@"keyboardDelete"];
    [deleteButton addSubview:deleteImage];
    [self addSubview:deleteButton];
    self.deleteButton = deleteButton;
    
    UIButton *confirmbutton=[UIButton buttonWithType:UIButtonTypeSystem];
    confirmbutton.frame=CGRectMake(keyboardScreenWidth/4*3 + space, 61*2, keyboardScreenWidth/4, 122);
    confirmbutton.backgroundColor = [UIColor grayColor];
    [confirmbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmbutton.titleLabel.font=[UIFont systemFontOfSize:20];
    [confirmbutton setTitle:@"确 定" forState:UIControlStateNormal];
    [confirmbutton addTarget:self action:@selector(keyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmbutton.tag=13;
    [self addSubview:confirmbutton];
    self.confirmButton = confirmbutton;
}

- (void)mapButton:(NSInteger)index button:(UIButton *)button {
    switch (index) {
        case 0:
            self.oneButton = button;
            break;
        case 1:
            self.twoButton = button;
            break;
        case 2:
            self.threeButton = button;
            break;
        case 3:
            self.fourButton = button;
            break;
        case 4:
            self.fiveButton = button;
            break;
        case 5:
            self.sixButton = button;
            break;
        case 6:
            self.sevenButton = button;
            break;
        case 7:
            self.eightButton = button;
            break;
        case 8:
            self.nineButton = button;
            break;
            
        default:
            break;
    }
}

- (void)keyBoardAction:(UIButton *)sender {
    UIButton* btn = (UIButton*)sender;
    NSInteger number = btn.tag;
    if (number <= 9 && number >= 0) { // 0 - 9数字
        [self numberKeyBoard:number];
        return;
    }
    if (10 == number) { //删除
        [self cancelKeyBoard];
        return;
    }
    if (11 == number) { //点
        [self periodKeyBoard];
        return;
    }
    if (12 == number) { //负号
        [self minusKeyBoard];
        return;
    }
    
    if (13 == number) { //确定
        [self finishKeyBoard];
        return;
    }
}

#pragma mark - logic

- (void)numberKeyBoard:(NSInteger)number {
    UITextPosition* beginning = self.textField.beginningOfDocument;
    UITextRange* selectedRange = self.textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    NSInteger location = [self.textField offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self.textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    NSString *string = [self.textField.text substringToIndex:location];
    
    NSString *str = @"";
    if (self.textField) {
        str = self.textField.text;
        if (self.verify) {
            if (([string isEqualToString:@"-0"] || [string isEqualToString:@"0"])) {
                return;
            }
        }
    }else if (self.textView) {
        if (self.verify) {
            if (([string isEqualToString:@"-0"] || [string isEqualToString:@"0"])) {
                return;
            }
        }
        str = self.textView.text;
        beginning = self.textView.beginningOfDocument;
        selectedRange = self.textView.selectedTextRange;
        selectionStart = selectedRange.start;
        selectionEnd = selectedRange.end;
        location = [self.textView offsetFromPosition:beginning toPosition:selectionStart];
        length = [self.textView offsetFromPosition:selectionStart toPosition:selectionEnd];
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]initWithString:str];
    NSString *numberStr = [@(number) stringValue];
    [mutableString replaceCharactersInRange:NSMakeRange(location, length) withString:numberStr];
    UITextPosition *end = [self.textField positionFromPosition:selectionStart inDirection:UITextLayoutDirectionRight offset:numberStr.length];
    if (self.textView) {
        end = [self.textView positionFromPosition:selectionStart inDirection:UITextLayoutDirectionRight offset:numberStr.length];
    }
    if (self.textField) {
        self.textField.text = mutableString;
        if (location != str.length) {
            self.textField.selectedTextRange = [self.textField textRangeFromPosition:end toPosition:end];
        }
    }else if (self.textView) {
        NSString *string = [self.textView.text substringToIndex:location];
        if (([string isEqualToString:@"-0"] || [string isEqualToString:@"0"]) && self.verify) {
            return;
        }
        self.textView.text = mutableString;
        if (location != str.length) {
            self.textView.selectedTextRange = [self.textView textRangeFromPosition:end toPosition:end];
        }
    }
    [self setup];
}

- (void)cancelKeyBoard {
    UITextPosition* beginning = self.textField.beginningOfDocument;
    UITextRange* selectedRange = self.textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    NSInteger location = [self.textField offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self.textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    NSString *str = @"";
    if (self.textField) {
        str = self.textField.text;
        if (location == 0 && length == 0) {
            return;
        }
    }else if (self.textView) {
        str = self.textView.text;
        beginning = self.textView.beginningOfDocument;
        selectedRange = self.textView.selectedTextRange;
        selectionStart = selectedRange.start;
        selectionEnd = selectedRange.end;
        location = [self.textView offsetFromPosition:beginning toPosition:selectionStart];
        length = [self.textView offsetFromPosition:selectionStart toPosition:selectionEnd];
        if (location == 0 && length == 0) {
            return;
        }
    }
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:str];
    if (muStr.length <= 0) {
        return;
    }
    CGFloat offset = 0;
    if (length == 0) {
        offset = 1;
        [muStr deleteCharactersInRange:NSMakeRange(location - 1, 1)];
    }else {
        [muStr deleteCharactersInRange:NSMakeRange(location, length)];
    }
    UITextPosition *end = [self.textField positionFromPosition:selectionStart inDirection:UITextLayoutDirectionLeft offset:offset];
    if (self.textView) {
        end = [self.textView positionFromPosition:selectionStart inDirection:UITextLayoutDirectionLeft offset:offset];
    }
    if (self.textField) {
        self.textField.text = muStr;
        if (location != str.length) {
            self.textField.selectedTextRange = [self.textField textRangeFromPosition:end toPosition:end];
        }
    }else if (self.textView) {
        self.textView.text = muStr;
        if (location != str.length) {
            self.textView.selectedTextRange = [self.textView textRangeFromPosition:end toPosition:end];
        }
    }
    [self setup];
}

-(void)periodKeyBoard{
    UITextPosition* beginning = self.textField.beginningOfDocument;
    UITextRange* selectedRange = self.textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    NSInteger location = [self.textField offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self.textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    NSString *str = [self.textField.text substringToIndex:location];
    if (!self.verify) {
        if (self.textField) {
            self.textField.text = [NSString stringWithFormat:@"%@.",self.textField.text];
        }else if (self.textView) {
            self.textView.text = [NSString stringWithFormat:@"%@.",self.textView.text];
        }
        [self setup];
        return;
    }
    if (self.textField) {
        if ([str isEqualToString:@""] || [str isEqualToString:@"-"]) {
            return;
        }
        //判断当前时候存在一个点
        if ([self.textField.text rangeOfString:@"."].location == NSNotFound) {
            //输入中没有点
            NSMutableString *mutableString = [[NSMutableString alloc]initWithString:self.textField.text];
            [mutableString replaceCharactersInRange:NSMakeRange(location, length) withString:@"."];
            self.textField.text = mutableString;
            
            UITextPosition *end = [self.textField positionFromPosition:selectionStart inDirection:UITextLayoutDirectionRight offset:1];
            if (location != self.textField.text.length) {
                self.textField.selectedTextRange = [self.textField textRangeFromPosition:end toPosition:end];
            }
            [self setup];
        }
    }else if (self.textView) {
        beginning = self.textView.beginningOfDocument;
        selectedRange = self.textView.selectedTextRange;
        selectionStart = selectedRange.start;
        selectionEnd = selectedRange.end;
        location = [self.textView offsetFromPosition:beginning toPosition:selectionStart];
        length = [self.textView offsetFromPosition:selectionStart toPosition:selectionEnd];
        str = [self.textView.text substringToIndex:location];
        if ([str isEqualToString:@""] || [str isEqualToString:@"-"]) {
            return;
        }
        //判断当前时候存在一个点
        if ([self.textView.text rangeOfString:@"."].location == NSNotFound) {
            //输入中没有点
            NSMutableString *mutableString = [[NSMutableString alloc]initWithString:self.textView.text];
            [mutableString replaceCharactersInRange:NSMakeRange(location, length) withString:@"."];
            self.textView.text = mutableString;
            
            UITextPosition *end = [self.textView positionFromPosition:selectionStart inDirection:UITextLayoutDirectionRight offset:1];
            if (location != self.textView.text.length) {
                self.textView.selectedTextRange = [self.textView textRangeFromPosition:end toPosition:end];
            }
            [self setup];
        }
    }
}

-(void)minusKeyBoard{
    UITextPosition* beginning = self.textField.beginningOfDocument;
    UITextRange* selectedRange = self.textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    NSInteger location = [self.textField offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self.textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    NSString *str = [self.textField.text substringToIndex:location];
    UITextPosition *end = [self.textField positionFromPosition:selectionStart inDirection:UITextLayoutDirectionRight offset:1];
    if (self.textView) {
        beginning = self.textView.beginningOfDocument;
        selectedRange = self.textView.selectedTextRange;
        selectionStart = selectedRange.start;
        selectionEnd = selectedRange.end;
        location = [self.textView offsetFromPosition:beginning toPosition:selectionStart];
        length = [self.textView offsetFromPosition:selectionStart toPosition:selectionEnd];
        str = [self.textView.text substringToIndex:location];
        end = [self.textView positionFromPosition:selectionStart inDirection:UITextLayoutDirectionRight offset:1];
    }
    
    if (!self.verify) {
        if (self.textField) {
            self.textField.text = [NSString stringWithFormat:@"%@-",self.textField.text];
        }else if (self.textView) {
            self.textView.text = [NSString stringWithFormat:@"%@-",self.textView.text];
        }
        [self setup];
        return;
    }
    if (str.length) {
        return;
    }
    if (self.textField) {
        if ([self.textField.text rangeOfString:@"-"].location != NSNotFound) {
            return;
        }
        if (location == 0 && length == 0 && self.textField.text.length == 0) {
            self.textField.text = @"-";
        }else {
            NSMutableString *mutableString = [[NSMutableString alloc]initWithString:self.textField.text];
            [mutableString replaceCharactersInRange:NSMakeRange(location, length) withString:@"-"];
            self.textField.text = mutableString;
            if (location != self.textField.text.length) {
                self.textField.selectedTextRange = [self.textField textRangeFromPosition:end toPosition:end];
            }
        }
    }else if (self.textView) {
        if ([self.textView.text rangeOfString:@"-"].location != NSNotFound) {
            return;
        }
        if (location == 0 && length == 0 && self.textView.text.length == 0) {
            self.textView.text = @"-";
        }else {
            NSMutableString *mutableString = [[NSMutableString alloc]initWithString:self.textView.text];
            [mutableString replaceCharactersInRange:NSMakeRange(location, length) withString:@"-"];
            self.textView.text = mutableString;
            if (location != self.textView.text.length) {
                self.textView.selectedTextRange = [self.textView textRangeFromPosition:end toPosition:end];
            }
        }
    }
    [self setup];
}

-(void)finishKeyBoard {
    if (self.textField) {
        [self.textField resignFirstResponder];
    }else if (self.textView) {
        [self.textView resignFirstResponder];
    }
}

- (void)reloadInputViews {
    if (self.textField) {
        self.textField.inputView = nil;
        [self.textField reloadInputViews];
    }else if (self.textView) {
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
    }
}

@end
