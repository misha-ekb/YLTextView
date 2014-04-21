//
//  YLTextView.m
//  YLTextViewDemo
//
//  Created by Yong Li on 14-4-21.
//  Copyright (c) 2014年 Yong Li. All rights reserved.
//

#import "YLTextView.h"

@implementation YLTextView {
    UILabel* _placeholderLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self _setup];
}

- (void)_setup {
    _placeholder = @"";
    _placeholderColor = [UIColor lightGrayColor];
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
    [self addSubview:_placeholderLabel];
    [self sendSubviewToBack:_placeholderLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [self _updatePlaceholderLabel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)_updatePlaceholderLabel {
    if (self.text.length) {
        if (!_placeholderLabel.hidden) {
            _placeholderLabel.hidden = YES;
        }
    }
    else {
        [self _configPlaceholderLabel];
        _placeholderLabel.hidden = NO;
    }
}

- (void)textChanged:(NSNotification*)notification {
    if (self.placeholder.length == 0) {
        return;
    }
    
    [self _updatePlaceholderLabel];
}


- (CGRect)_placeholderRectForBounds:(CGRect)bounds {
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
    
	if ([self respondsToSelector:@selector(textContainer)]) {
		rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
		CGFloat padding = self.textContainer.lineFragmentPadding;
		rect.origin.x += padding;
		rect.size.width -= padding * 2.0f;
	} else {
		if (self.contentInset.left == 0.0f) {
			rect.origin.x += 8.0f;
		}
		rect.origin.y += 8.0f;
	}
    
	return rect;
}


- (void)_configPlaceholderLabel {
    _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.font = self.font;
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.textColor = self.placeholderColor;
    _placeholderLabel.text = self.placeholder;
    [_placeholderLabel sizeToFit];
    
    CGRect rect = [self _placeholderRectForBounds:self.bounds];
    rect.size.height = _placeholderLabel.frame.size.height;
    _placeholderLabel.frame = rect;
}


- (void)setText:(NSString *)string {
    [super setText:string];
    [self _updatePlaceholderLabel];
}


- (void)insertText:(NSString *)string {
    [super insertText:string];
    [self _updatePlaceholderLabel];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self _updatePlaceholderLabel];
}


- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder]) {
        return;
    }
    
    _placeholder = string;
    [self _updatePlaceholderLabel];
}


- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self _updatePlaceholderLabel];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self _updatePlaceholderLabel];
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self _updatePlaceholderLabel];
}

@end