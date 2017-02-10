//
//  LHRAlerView.m
//  LHRAlerView
//
//  Created by 李海瑞 on 15/10/23.
//  Copyright © 2015年 李海瑞. All rights reserved.
//

#import "LHRAlerView.h"
#import "UIView+Extension.h"
#define rgba(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation LHRAlerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.translatesAutoresizingMaskIntoConstraints  = NO;
    self.contenview.layer.cornerRadius = 5;
    self.bgview.backgroundColor=rgba(0, 0, 0, 0.7);
}
-(void)show
{
    UIWindow *rtView = [[UIApplication sharedApplication] keyWindow];
    //    UIView *rtView  = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    self.translatesAutoresizingMaskIntoConstraints  = NO;
    
   CGRect rect= [self.contenlabel.text boundingRectWithSize:CGSizeMake(205, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.heightlaycontraint.constant=rect.size.height+130;
    [rtView addSubview:self];
    NSLog(@"-----%@",self.contenlabel.text);
    NSDictionary *dic = @{@"alert":self};
    
    [rtView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[alert]|" options:0 metrics:0 views:dic]];
    [rtView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[alert]|" options:0 metrics:0 views:dic]];
    [rtView layoutIfNeeded];
    //弹出的动画效果
    [self.contenview reboundEffectAnimationDuration:0.5];
}
-(void)dimiss
{
    [self removeFromSuperview];
}
-(IBAction)closedbtnclick:(UIButton *)sender
{
    [self dimiss];
    if (self.lhrdelegate!=nil&&[self.lhrdelegate respondsToSelector:@selector(LHRAlertView:closeBtnTapped:)]) {
        [self.lhrdelegate LHRAlertView:self closeBtnTapped:sender];
    }
}
-(IBAction)surebtnclick:(UIButton *)sender
{
    [self dimiss];
    if (self.lhrdelegate!=nil&&[self.lhrdelegate respondsToSelector:@selector(LHRAlertView:okBtnTapped:)]) {
        [self.lhrdelegate LHRAlertView:self okBtnTapped:sender];
    }
}
-(IBAction)cancebtnclick:(UIButton *)sender
{
    [self dimiss];
    if (self.lhrdelegate!=nil&&[self.lhrdelegate respondsToSelector:@selector(LHRAlertView:cancelBtnTapped:)]) {
        [self.lhrdelegate LHRAlertView:self cancelBtnTapped:sender];
    }
}
@end
