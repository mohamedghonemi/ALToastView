//
//  ALToastView.h
//
//  Created by Alex Leutgöb on 17.07.11.
//  Copyright 2011 alexleutgoeb.com. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Edited: Daniel Klöck 30.09.2014
// Sumary: updated for ARC/iOS7, only one Toast at a time switch them if a new is created

#import <QuartzCore/QuartzCore.h>
#import "ALToastView.h"

// Set visibility duration
static const CGFloat kDuration = 2;

static ALToastView *toast;


@interface ALToastView ()

- (void)fadeToastOut;
@end


@implementation ALToastView

#pragma mark - NSObject

- (id)initWithText:(NSString *)text {
    if ((self = [self initWithFrame:CGRectZero])) {
        // Add corner radius
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        self.layer.cornerRadius = 5;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.autoresizesSubviews = NO;
        
        // Init and add label
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = text;
        _textLabel.minimumFontSize = 14;
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.adjustsFontSizeToFitWidth = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        [_textLabel sizeToFit];
        
        [self addSubview:_textLabel];
        _textLabel.frame = CGRectOffset(_textLabel.frame, 10, 5);
    }
    
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text
{
    if (toast && toast.alpha==1 && [toast.textLabel.text isEqualToString:text])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:toast];
        [toast performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
        return;
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:toast];
        [toast removeFromSuperview];
    }
    
    // Add new instance to queue
    ALToastView *view = [[ALToastView alloc] initWithText:text];
    
    CGFloat lWidth = view.textLabel.frame.size.width;
    CGFloat lHeight = view.textLabel.frame.size.height;
    CGFloat pWidth = parentView.frame.size.width;
    CGFloat pHeight = parentView.frame.size.height;
    
    // Change toastview frame
    view.frame = CGRectMake((pWidth - lWidth - 20) / 2., pHeight - lHeight - 60, lWidth + 20, lHeight + 10);
    view.alpha = 0.0f;
    
    toast = view;
    
    // Fade into parent view
    [parentView addSubview:view];
    [UIView animateWithDuration:.5  delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         view.alpha = 1.0;
                     } completion:^(BOOL finished){}];
    
    // Start timer for fade out
    [toast performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
}

#pragma mark - Private
- (void)fadeToastOut {
    // Fade in parent view
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0.f;
                     }
                     completion:^(BOOL finished){
                         [NSObject cancelPreviousPerformRequestsWithTarget:toast];
                         [toast removeFromSuperview];
                         toast=nil;
                     }];
}


@end
