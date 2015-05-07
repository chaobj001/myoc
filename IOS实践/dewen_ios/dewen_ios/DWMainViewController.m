//
//  MainViewController.m
//  dewen_ios
//
//  Created by 王超 on 15/4/29.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "DWMainViewController.h"
#import "DWLeftPanelViewController.h"
#import "DWRightPanelViewController.h"
#import "DWItemsViewController.h"

//#define CORNER_RADIUS;
#define SLIDE_TIMING 0.3
#define PANEL_WIDTH 250

@interface DWMainViewController () <UIGestureRecognizerDelegate>
{
    UIView *_layerShadow;
    UITapGestureRecognizer *_tapGes;
}

@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) DWLeftPanelViewController *leftPanelViewController;
@property (nonatomic, strong) DWRightPanelViewController *rightPanelViewController;

@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showingRightPanel;

@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;

@end

@implementation DWMainViewController

- (instancetype)initWithCenterController:(UIViewController *)centerViewController
{
    self = [super init];
    
    if (self) {
        [self setCenterViewController:centerViewController];
    }
    return self;
}


#pragma mark -
#pragma mark View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加手势
    [self setupGestures];}

#pragma mark Setup View


//重写设置中间视图的set方法
- (void)setCenterViewController:(UIViewController *)centerVC
{
    if (_centerViewController == nil) {
        _centerViewController = centerVC;
        [self.view addSubview:_centerViewController.view];
        [self addChildViewController:_centerViewController];
        [_centerViewController didMoveToParentViewController:self];
        //NSLog(@"不存在");
        
    }else{
        
        UIViewController *oldVC = _centerViewController;
        _centerViewController = centerVC;
        //[self.view addSubview:_centerViewController.view];
        [self.view insertSubview:_centerViewController.view atIndex:0];
        [oldVC removeFromParentViewController];
        [oldVC.view removeFromSuperview];
        [self addChildViewController:_centerViewController];
        [_centerViewController didMoveToParentViewController:self];
    }
}

//- (void)setUpView
//{
//    //setup center view
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[DWItemsViewController alloc] init]];
//
//    self.centerViewController = navController;
//    [self.view addSubview:self.centerViewController.view];
//    [self addChildViewController:_centerViewController];
//    [_centerViewController didMoveToParentViewController:self];
//    
//    //添加手势
//    [self setupGestures];
//}

- (void)resetMainView
{
    if (_leftPanelViewController != nil) {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        self.showingLeftPanel = NO;
    }
    
    if (_rightPanelViewController != nil) {
        [self.rightPanelViewController.view removeFromSuperview];
        self.rightPanelViewController = nil;
        self.showingRightPanel = NO;
    }
    
    [self showCenterViewWithShadow:NO];
}

- (UIView *)getLeftView
{
    //NSLog(@"getLeftView");
    if (_leftPanelViewController == nil) {
        self.leftPanelViewController = [[DWLeftPanelViewController alloc] init];
        
        [self.view addSubview:self.leftPanelViewController.view];
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(-PANEL_WIDTH, 0, PANEL_WIDTH, self.view.frame.size.height);
        
    }
    
    self.showingLeftPanel = YES;
    
    [self showCenterViewWithShadow:YES];
    
    UIView *view = self.leftPanelViewController.view;
    return view;
}

- (UIView *)getRightView
{
    if (_rightPanelViewController == nil) {
        self.rightPanelViewController = [[DWRightPanelViewController alloc] init];
        
        [self.view addSubview:self.rightPanelViewController.view];
        [self addChildViewController:_rightPanelViewController];
        [_rightPanelViewController didMoveToParentViewController:self];
        
        _rightPanelViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, PANEL_WIDTH, self.view.frame.size.height);
    }
    
    self.showingRightPanel = YES;
    
    [self showCenterViewWithShadow:YES];
    UIView *view = self.rightPanelViewController.view;
    return view;
}

- (void)showCenterViewWithShadow:(BOOL)value
{
    if (value) {
        if (_layerShadow == nil) {
            _layerShadow = [[UIView alloc] initWithFrame:self.view.frame];
            //_layerShadow.backgroundColor = [UIColor blackColor];
            //_layerShadow.alpha = .5f;
            _layerShadow.hidden = NO;
            
            [self.view addSubview:_layerShadow];
        }
    } else {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _layerShadow.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
                         } completion:^(BOOL finished) {
                             [_layerShadow removeGestureRecognizer:_tapGes];
                             [_layerShadow removeFromSuperview];
                             _layerShadow = nil;
                         }];

    }
}


#pragma mark -
#pragma mark Actions

- (void)movePanelLeft // to show right panel
{
    //NSLog(@" %s", self.showingRightPanel ? "true" : "false");

    UIView *childView = [self getRightView];
    //[self.view sendSubviewToBack:childView];
    [self.view bringSubviewToFront:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _rightPanelViewController.view.frame = CGRectMake(self.view.frame.size.width-PANEL_WIDTH, 0, PANEL_WIDTH, self.view.frame.size.height);
                     } completion:^(BOOL finished) {
                         if (finished) {
                         }
                     }];
    
    //shadow
    _layerShadow.hidden = NO;
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _layerShadow.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveRightPanelToOriginalPositon)];
                             [_layerShadow addGestureRecognizer:_tapGes];
                         }
                     }];


}

- (void)movePanelRight // to show left panel
{
    //NSLog(@" %s", self.showingLeftPanel ? "true" : "false");
    UIView *childView = [self getLeftView];
    //[self.view sendSubviewToBack:childView];
    [self.view bringSubviewToFront:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _leftPanelViewController.view.frame = CGRectMake(0, 0, PANEL_WIDTH, self.view.frame.size.height);
                     } completion:^(BOOL finished) {
                         if (finished) {
                         }
                     }];
    
    //shadow
    _layerShadow.hidden = NO;
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _layerShadow.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveLeftPanelToOriginalPositon)];
                             [_layerShadow addGestureRecognizer:_tapGes];
                         }
                     }];

}

- (void)moveLeftPanelToOriginalPositon
{
    [UIView animateWithDuration:SLIDE_TIMING
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _leftPanelViewController.view.frame = CGRectMake(-PANEL_WIDTH, 0, PANEL_WIDTH, self.view.frame.size.height);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}

- (void)moveRightPanelToOriginalPositon
{
    [UIView animateWithDuration:SLIDE_TIMING
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _rightPanelViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, PANEL_WIDTH, self.view.frame.size.height);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}

#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup
- (void) setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
    //NSLog(@"setup ges");
}

- (void)movePanel:(id)sender
{
    
    
//    [[[(UITapGestureRecognizer *)sender view] layer] removeAllAnimations];
    CGPoint translatedPoint = [(UIPanGestureRecognizer *) sender translationInView:self.view]; // 移动的距离
    CGPoint velocity = [(UIPanGestureRecognizer *) sender velocityInView:[sender view]]; // 移动的速度
    CGPoint location = [(UIPanGestureRecognizer *) sender locationInView:self.view];
    //NSLog(@"move velocity:%f, translate.x:%f, sv center:%f, loc.x:%f", velocity.x, translatedPoint.x, [sender view].center.x, location.x);
    
    
    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        //UIView *childView = nil;
        if (velocity.x>0) {
            //NSLog(@"ges go right");
        } else {
            //NSLog(@"ges go left");
        }
        if (velocity.x > 0) {
            
            //打开左侧panel
            if (!_showingLeftPanel && !_showingRightPanel && location.x<20) {
                //childView = [self getLeftView];
                [self movePanelRight];
            }
            
            //关闭右侧panel
            if (_showingRightPanel && location.x > self.view.frame.size.width - PANEL_WIDTH) {
                [self moveRightPanelToOriginalPositon];
            }
        } else {
            
            //NSLog(@"left:%s", _showingLeftPanel == YES ? "true" : "false");
            //关闭左侧panel
            if (_showingLeftPanel && location.x < PANEL_WIDTH) {
                [self moveLeftPanelToOriginalPositon];
            }
            
            
            //打开右侧panel
            if (!_showingRightPanel && !_showingLeftPanel && location.x > self.view.frame.size.width - 20) {
                //childView = [self getRightView];
                [self movePanelLeft];
            }
        }
//
//        [self.view bringSubviewToFront:childView];
//        //[[sender view] bringSubviewToFront:[(UIPanGestureRecognizer *)sender view]];
    }
    
    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateChanged) {
        if (velocity.x>0) {
            //NSLog(@"ges going right");
        } else {
            //NSLog(@"ges going left");
        }
        
//        //判断是否过半
        //_showPanel = fabs([sender view].center.x - self.view.frame.size.width/2) > self.view.frame.size.width/2;
//
//        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
//        
//        [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0, 0) inView:self.view];
//        
//        if (velocity.x * _preVelocity.x + velocity.y * _preVelocity.y > 0) {
//            NSLog(@"相同方向");
//        } else {
//            NSLog(@"相反方向");
//        }
//        
//        _preVelocity = velocity;
        
        _showPanel = fabs(translatedPoint.x) > self.view.frame.size.width/2;
    }
    
    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
        if (velocity.x>0) {
            //NSLog(@"ges went right");
        } else {
            //NSLog(@"ges went left");
        }

    }
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
