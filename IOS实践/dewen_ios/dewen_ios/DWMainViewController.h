//
//  MainViewController.h
//  dewen_ios
//
//  Created by 王超 on 15/4/29.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWMainViewController : UIViewController

- (void)movePanelLeft;
- (void)movePanelRight;
- (void)setCenterViewController:(UIViewController *)centerVC;
- (void)moveLeftPanelToOriginalPositon;
- (void)moveRightPanelToOriginalPositon;
- (instancetype)initWithCenterController:(UIViewController *)centerViewController;
@end
