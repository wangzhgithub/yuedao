//
//  Voice_ThreedViewCell.m
//  VoiceCopanion
//
//  Created by wangzh on 16/3/9.
//  Copyright © 2016年 米翊米. All rights reserved.
//

#import "Voice_ThreedViewCell.h"

@interface Voice_ThreedViewCell()<UITextFieldDelegate,UITextViewDelegate>{
//    UITextField *titleFiled;
//    UITextView  *contview;
//    UILabel     *placeLabel;
}

@end

@implementation Voice_ThreedViewCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
    }
    return self;
}


- (void)createUI:(NSString*)titleText countText:(NSString*)countText{
    
    [_titleFiled removeFromSuperview];
    _titleFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, SCRW-40, 30)];
    _titleFiled.placeholder = @"请输入模板标题(限10字符以内)";
    _titleFiled.text = titleText;
    [_titleFiled becomeFirstResponder];
    _titleFiled.textColor = LMH_COLOR_GRAYTEXT;
    _titleFiled.font = LMH_FONT_15;
    _titleFiled.layer.borderColor = LMH_COLOR_GRAYTEXT.CGColor;
    _titleFiled.layer.borderWidth = 0.5;
    _titleFiled.delegate = self;
    [_titleFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_titleFiled];
    
    
    [_contview removeFromSuperview];
    _contview = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleFiled.frame)+10, SCRW-40, (SCRW-120)/2)];
    _contview.backgroundColor = [UIColor whiteColor];
    _contview.layer.borderColor = LMH_COLOR_GRAYTEXT.CGColor;
    _contview.text = countText;
    _contview.layer.borderWidth = 0.5;
    _contview.font = LMH_FONT_15;
    _contview.textColor = LMH_COLOR_GRAYTEXT;
    _contview.delegate = self;
    
    placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    placeLabel.text = @"请填写内容，不超过70个字";
    placeLabel.textColor = LMH_COLOR_LGTGRAYTEXT;
    placeLabel.font = LMH_FONT_13;
    [_contview addSubview:placeLabel];
    placeLabel.hidden = YES;
    [self.contentView addSubview:_contview];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
     _FieldText = textField.text;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
     _FieldText = textField.text;
}

- (void) textFieldDidChange:(UITextField *) TextField{
    _FieldText = TextField.text;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    _ViewText = textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //    NSLog(@"textViewDidChange：%@", textView.text);
    if (textView.text.length > 0) {
        placeLabel.hidden = YES;
        _ViewText = textView.text;
    }
    else{
        placeLabel.hidden = NO;
    }
    
    if (textView.text.length > 70) {
        textView.text = [textView.text substringToIndex:70];
        _ViewText = textView.text;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_titleFiled resignFirstResponder];
    [_contview resignFirstResponder];
}



@end
