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
#import <SDWebImageDownloader.h>
#import "LMLaunchViewModel.h"
@interface LMLaunchViewController ()
/*
 *  背景图片
 */
@property(nonatomic,weak)UIImageView *bgImageView;
/*
 *  启动图片
 */
@property(nonatomic,weak)UIImageView *splashImageView;

/*
 *  启动viewModel
 */
@property(nonatomic ,strong)LMLaunchViewModel *launchVM;

/** 当前的时间戳是否在模型的时间戳范围内的标志 **/
@property(nonatomic,assign) BOOL timeStampInModelTimesFlag;



@end

@implementation LMLaunchViewController
-(LMLaunchViewModel *)launchVM{
    if (!_launchVM) {
        _launchVM=[[LMLaunchViewModel alloc]init];
    }
    return _launchVM;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    
  self.splashImageView.layer.anchorPoint=CGPointMake(0.5, 0.8);
   NSString *appLaunchTimes=[LMUserDefaults objectForKey:kAppLaunchTimes];
  
    self.bgImageView.hidden=NO;
    self.splashImageView.hidden=YES;
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
      
        if ([LMNetworkManager getCurrentNetworkState] !=NetworkStateNone) {
            [self loadLaunchDataWhenAppFirstOpen];
          
        }
    
    }
    
    




}
-(UIImageView *)splashImageView{
    if (!_splashImageView) {
       UIImageView * splashImageView=[[UIImageView alloc]init];
        splashImageView.image=[UIImage imageNamed:@"bilibili_splash_default_2"];
        [self.bgImageView addSubview:splashImageView];
        [splashImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        
        _splashImageView=splashImageView;
        
    }
    return _splashImageView;
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView *bgImageView=[[UIImageView alloc]init];
        bgImageView.image=[UIImage imageNamed:@"launchBg"];
        [self.view addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.mas_offset(0);
        }];
        _bgImageView=bgImageView;
    }
    return _bgImageView;
}
-(void)loadLaunchDataWhenAppFirstOpen{
    @weakify(self);
    [self loadData:^(NSArray *launchModels) {
        @strongify(self);
        if (launchModels.count !=0) {
            for (LMLaunchModel *launchModel in launchModels) {
                LMLaunchViewModel *vm=[[LMLaunchViewModel alloc]initWithModel:launchModel];
                if ([vm conformNowtimestamp]) {
                    LMLaunchRealModel *realModel=[[LMLaunchRealModel alloc]initWithModel:launchModel];
                    //先缓存图片url到本地
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:realModel.image] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        
                        
                        
                    }];
                    //有符合时间戳的模型 存储的数据库中
                    [self storageLaunchModelInDB:realModel];
                }
            }
        }
        
    }];





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
   
    [self.splashImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(420);
        
    }];
    @weakify(self);
[UIView animateWithDuration:1.5f delay:0.5f usingSpringWithDamping:0.8f initialSpringVelocity:8.0f options:0 animations:^{
    @strongify(self);
    
    
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
    @weakify(self);
    [self loadData:^(NSArray *launchModels) {
        LMLog(@"%@",launchModels);
        @strongify(self);
        if (launchModels.count ==0) {
            //动画形式加载
            [self launchWithAnimation];
        }else{
            for (LMLaunchModel *launchModel in launchModels) {
                LMLaunchViewModel *vm=[[LMLaunchViewModel alloc]initWithModel:launchModel];
                //比较时间戳 取出对应的应该放置的启动页
               if ([vm conformNowtimestamp]) {
                    self.timeStampInModelTimesFlag=YES;
                    LMLaunchRealModel *realmModel=[[LMLaunchRealModel alloc]initWithModel:launchModel];
                    //从网络加载启动页
                    [self launchWithNetwork:realmModel];
                    //有符合时间戳的模型 存储到数据库中
                    [self storageLaunchModelInDB:realmModel];
                    
                }
            }
            if (self.timeStampInModelTimesFlag==NO) {//如果请求到的数据不在时间范围内就动画形式加载
                
                [self launchWithAnimation];
            }
        
        }
        
    }];
    
    
    
}
-(void)counterIncremented{
    //计数器++
    NSString *timesStr =[LMUserDefaults objectForKey:kAppLaunchTimes];
    NSInteger times =[timesStr integerValue];
    if (times ==NSIntegerMax) {
        times=1;
    }else{
        times++;
    
    }
    [LMUserDefaults setValue:[NSString stringWithFormat:@"%ld",times] forKey:kAppLaunchTimes];


}
#pragma mark 存储启动项模型到数据库中
-(void)storageLaunchModelInDB:(LMLaunchRealModel *)launchModel{
    RLMRealm *realm=[RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm addObject:launchModel];
    [realm commitWriteTransaction];



}
#pragma mark  data
-(void)loadData:(void(^)(NSArray *launchModels))block{
    [self.launchVM loadlaunchDataArrFromNetWork];
    NSString *appLaunchTimes=[LMUserDefaults objectForKey:kAppLaunchTimes];
    if ([appLaunchTimes isNotBlank]) {
        [self counterIncremented];
    }
    [[self.launchVM.requestCommand execute:nil] subscribeNext:^(NSArray *launchModels) {
        block(launchModels);
       
    }];
#warning 加载初始化配置信息数据 暂时不用VM 先实现下拉刷新动画之后再回来处理
    NSMutableDictionary *contentDic=[NSMutableDictionary dictionary];
    contentDic[@"appkey"] = @"4f8bed7e5270157bfd00000e";
    contentDic[@"channel"] = @"default";
    contentDic[@"ad_request"] =@1;
    contentDic[@"time"]=@"14:37:54";
    contentDic[@"package"]=@"tv.danmaku.bilianime";
    contentDic[@"type"] =@"online_config";
    contentDic[@"sdk_type"]=@"iOS";
    contentDic[@"sdk_version"] =@"3.4.8";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"content"]=[contentDic modelToJSONString];
    [LMNetworkManager POST:kCheck_config_updateURL params:params pregress:nil success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    


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
