//
//  LMLaunchViewController.m
//  BilibiliShow
//
//  Created by iOSDev on 17/4/26.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "LMLaunchViewController.h"
#import "LMTabBarViewController.h"
#import <Realm.h>
#import "LMLaunchRealModel.h"
#import <UIImageView+WebCache.h>
@interface LMLaunchViewController ()
/*
 **  背景图片
 */
@property(nonatomic,weak)UIImageView *bgImageView;
/*
 **  启动图片
 */
@property(nonatomic,weak)UIImageView *splashImageView;

@end

@implementation LMLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    self.splashImageView.layer.anchorPoint=CGPointMake(0.5, 0.8);
   NSString *appLaunchTimes=[LMUserDefaults objectForKey:kAppLaunchTimes];
    if ([appLaunchTimes isNotBlank]) {//如果不是第一次启动
        //正常形式加载
        [self setupLaunchImage];
    }else{
    //第一次启动 (动画形式加载)
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self launchWithAnimation];
        });
        /**
         *动画加载之后如果有网进行网络请求缓存图片
         *如果没有网络那么不必开启计数器,因此计数器要放到网络请求成功之后开启
         */
        RLMResults *results=[LMLaunchRealModel allObjects];
        if (results.count) {
            LMLaunchRealModel *model=[results firstObject];
            //获取时间戳
            long long timestamp=(long long)[[NSDate date] timeIntervalSince1970];
            if (timestamp > [model.start_time longLongValue] &&
                timestamp < [model.end_time longLongValue]) {
                [self launchWithNetwork:model];
            }
            
        }
    
    
    }
    
    




}
#pragma mark  网络形式加载
-(void)launchWithNetwork:(LMLaunchRealModel *)model{
    self.splashImageView.hidden=YES;
    
    //加载广告页
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"launchBg"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([model.duration floatValue]* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //根据模型中的持续时间 切换根控制器
        [UIApplication sharedApplication].keyWindow.rootViewController = [[LMTabBarViewController alloc]init];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    });





}
#pragma mark 动画形式加载启动页
-(void)launchWithAnimation{
    self.splashImageView.hidden=NO;
    @weakify(self);
[UIView animateWithDuration:1.5f delay:0.5f usingSpringWithDamping:0.2f initialSpringVelocity:8.0f options:0 animations:^{
    [self.view layoutIfNeeded];
    
} completion:^(BOOL finished) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController=[[LMTabBarViewController alloc]init];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    });
    
}];
    


}
-(void)setupLaunchImage{
    NSString *appLaunchTimes=[LMUserDefaults objectForKey:kAppLaunchTimes];
    if ([appLaunchTimes integerValue] == 3) {
        //弹出好评框
        
    }
   
    if ([LMNetworkManager getCurrentNetworkState]==NetworkStateNone) {
        //没有网络
        
        [self counterIncremented];
        /**
         *  先从数据库加载启动页 判断是否符合时间戳 如果符合加载启动页
         *  如果不符合 动画形式加载
         */
        
        
        
        
        
    }else{//有网状态
    
        [self loadLaunchData];
    
    }



}
-(void)loadLaunchData{
    
    
    
}
-(void)counterIncremented{


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
