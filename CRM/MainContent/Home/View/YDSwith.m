//
//  YDSwith.m
//  CRM
//
//  Created by YD_iOS on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDSwith.h"

#define kColor1_ON [UIColor colorWithHexString:@"528ECD"]//男
#define kColor1_OFF [UIColor colorWithHexString:@"D37CAA"]//女生
#define kColor2_ON [UIColor colorWithHexString:@"528ECD"]//是
#define kColor2_OFF [UIColor colorWithHexString:@"B8B8B8"]//否

@interface YDSwith(){
    UIColor *colorON;
    UIColor *colorOFF;
    
    NSString *textON;
    NSString *textOFF;
}

@property (weak, nonatomic) IBOutlet UIButton *swithButton;
@property (weak, nonatomic) IBOutlet UILabel *labelON;
@property (weak, nonatomic) IBOutlet UILabel *labelOFF;

@end

@implementation YDSwith

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup{
   [[NSBundle mainBundle]loadNibNamed:@"YDSwith" owner:self options:nil];

    self.view.frame = CGRectMake(0, 0, 77, 27);
    [self addSubview:self.view];
}

-(void)setColorStyle:(ColorStyle)colorStyle{
    _colorStyle = colorStyle;
    
    if (_colorStyle == ColorStyle1) {
        colorON = kColor1_ON;
        colorOFF = kColor1_OFF;
        textON = @"男士";
        textOFF = @"女士";
    }else{
        colorON = kColor2_ON;
        colorOFF = kColor2_OFF;;
        textON = @"是";
        textOFF = @"否";
    }
    
    _labelON.text = textON;
    _labelOFF.text = textOFF;
}
-(void)setOnORoff:(BOOL)onORoff{
    _onORoff = onORoff;
    
    if (onORoff) {
        _view.backgroundColor = colorON;
    }else{
        _view.backgroundColor = colorOFF;
    }
    
    if (onORoff && _swithButton.center.x<22) {
        [self setupOnOrOffWithButton:_swithButton];
    }else if(!onORoff && _swithButton.center.x>22){
        [self setupOnOrOffWithButton:_swithButton];
    }
}

- (void)setupOnOrOffWithButton:(UIButton *)sender
{
    CGPoint buttonCent = sender.center;
    UIColor *color;
    
    if (buttonCent.x <22) {
        buttonCent = CGPointMake(buttonCent.x+35, buttonCent.y);
        color = colorON;
    }else{
        buttonCent = CGPointMake(buttonCent.x-35, buttonCent.y);
        color = colorOFF;
    }
    
    sender.center = buttonCent;
    _view.backgroundColor = color;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self clickSwithButton:_swithButton];
}

- (IBAction)clickSwithButton:(UIButton *)sender {
    
    CGPoint buttonCent = sender.center;
    UIColor *color;
    
    if (buttonCent.x <22) {
        buttonCent = CGPointMake(buttonCent.x+35, buttonCent.y);
        color = colorON;
    }else{
        buttonCent = CGPointMake(buttonCent.x-35, buttonCent.y);
        color = colorOFF;
    }
    
    [UIView animateWithDuration:.25 animations:^{
        sender.center = buttonCent;
        _view.backgroundColor = color;
    }];
    
    if (self.ClickButtonBlack != nil) {
        if (CGColorEqualToColor(_view.backgroundColor.CGColor, colorON.CGColor)) {
            self.ClickButtonBlack(textON);
        }else{
            self.ClickButtonBlack(textOFF);
        }
    }
}


@end
