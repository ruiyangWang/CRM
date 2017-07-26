//
//  UIButton+XZ.m
//  CRM
//
//  Created by YD_iOS on 16/9/30.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "UIButton+XZ.h"
#import <objc/runtime.h>

static void * XZSecKey = &XZSecKey;

@implementation UIButton (XZ)

- (void)startCountdown{
    
    
    self.userInteractionEnabled = NO;
    self.alpha = 0.6;
    self.sec = self.sec == 0 ? 59 : self.sec;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setNewTitle:) userInfo:@{@"title":self.titleLabel.text} repeats:YES];
}

- (void)setNewTitle:(NSTimer *)timer{
    
    NSString *title = timer.userInfo[@"title" ];
    

    if (self.sec == 0) {
        [self setTitle:title forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        self.alpha = 1;
        
        [timer invalidate];
    }else{
        [self setTitle:[NSString stringWithFormat:@"%@ %ld秒",title ,self.sec--] forState:UIControlStateNormal];
    }
}

-(void)setSec:(NSInteger)sec{
    objc_setAssociatedObject(self, XZSecKey, @(sec), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSInteger)sec{
    
    return [objc_getAssociatedObject(self, XZSecKey) unsignedIntegerValue];
}
@end
