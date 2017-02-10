//
//  LHRAlerView.h
//  LHRAlerView
//
//  Created by 李海瑞 on 15/10/23.
//  Copyright © 2015年 李海瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHRAlertViewDelegate;
@interface LHRAlerView : UIView
{
   
}
@property (nonatomic,weak) IBOutlet UILabel *contenlabel;
@property (nonatomic, weak) IBOutlet UIView *bgview;
@property (nonatomic, weak) IBOutlet UIView *contenview;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightlaycontraint;
@property (nonatomic, assign) id<LHRAlertViewDelegate>lhrdelegate;
@property (nonatomic, copy) NSString *contenstr;
-(void)show;
-(void)dimiss;
-(IBAction)closedbtnclick:(UIButton *)sender;
-(IBAction)surebtnclick:(UIButton *)sender;
-(IBAction)cancebtnclick:(UIButton *)sender;
@end

@protocol LHRAlertViewDelegate <NSObject>

@optional

- (void)LHRAlertView:(LHRAlerView *)LHRAlertView cancelBtnTapped:(id)sender;
- (void)LHRAlertView:(LHRAlerView *)LHRAlertView okBtnTapped:(id)sender;
- (void)LHRAlertView:(LHRAlerView *)LHRAlertView closeBtnTapped:(id)sender;

- (void)LHRAlertView:(LHRAlerView *)LHRAlertView textChanged:(NSString *)text;

@end
