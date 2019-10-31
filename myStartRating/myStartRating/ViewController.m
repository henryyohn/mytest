//
//  ViewController.m
//  myStartRating
//
//  Created by mac on 2019/8/19.
//  Copyright © 2019 henry. All rights reserved.
//

#import "ViewController.h"
#import "CWStarRateView.h"
#import "NXRequest.h"
#import "NXFileTool.h"
#import <MBProgressHUD.h>

@interface ViewController ()<CWStarRateViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *downloadLabel;

@property (nonatomic, strong) MBProgressHUD *mbProgressHUD;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, copy) NSString *pagePath;

@end

@implementation ViewController


-(MBProgressHUD *)mbProgressHUD
{
    if(!_mbProgressHUD) {
        _mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbProgressHUD.mode = MBProgressHUDModeIndeterminate;
    }
    return _mbProgressHUD;
}

- (MBProgressHUD *)hub
{
    if (!_hub) {
        _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hub.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return _hub;
}

- (void)showProgress:(NSString *)tips
{
    self.mbProgressHUD.label.text = tips;
    [self.mbProgressHUD showAnimated:YES];
}

- (void)hideProgress
{
    [self.mbProgressHUD hideAnimated:YES];
}

-(UILabel *)downloadLabel
{
    if (!_downloadLabel) {
        _downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, [[UIScreen mainScreen] bounds].size.width, 30)];
        _downloadLabel.textAlignment = NSTextAlignmentCenter;
        _downloadLabel.font = [UIFont systemFontOfSize:14.0];
        _downloadLabel.textColor = [UIColor blackColor];
    }
    return _downloadLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.view addSubview:self.downloadLabel];
    [self initpageView];
    NSArray *arr = @[
  @[@"1",@"2",@"3",@"4",@"5"],
  @[@"1",@"1",@"1",@"1",@"5"],
  @[@"1",@"1",@"1",@"4",@"5"],
  @[@"1",@"1",@"1",@"4",@"4"],
  @[@"1",@"1",@"3",@"4",@"5"],
  @[@"1",@"1",@"3",@"3",@"5"],
  @[@"1",@"1",@"9",@"4",@"4"],
  @[@"5",@"2",@"4",@"3",@"1"],
  @[@"1",@"1",@"1",@"4",@"5"]];
    for (int i = 0; i < arr.count; i++) {
        NSString *str = [self handleOpenCode:arr[i]];
        NSLog(@"=%@==", str);
        
        // 等差
        //an=a1+(n-1)*d
        NSArray *new = [arr[i] sortedArrayUsingSelector:@selector(compare:)];
        for (int k = 0; k < new.count; k++) {
            if ([new[k] intValue] != [new[0] intValue] + k * 1) {
//                new[i+1] - new[i] != new[1] - new[0]
                NSLog(@"this is not : %@", new);
                break;
            }
        }
        
        
    }
    
    NSArray *arr2 = @[@"5",@"8",@"2",@"9",@"1"];
    NSLog(@"=1===%@===", arr2);
    NSArray *new = [arr2 sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"=2===%@===", new);
    
    
    [self requestPageZip: @"https://down.hoyi52.com/zesheng/static.zip" together: NO showProgressTitle:@"正在下载资源"];
    
}

// 	对子号（下面的逻辑前提是开奖号码是5位数）
-(NSString *)handleOpenCode:(NSArray *)nums
{
    if (nums.count <= 0) return nil;
    NSSet *set = [NSSet setWithArray:nums];
    NSLog(@"arr=%@", nums);
    if (nums.count - set.count == 0) {
        return @"全不同";
    } else if(nums.count - set.count == 1) {
        return @"1对";
    } else if(nums.count - set.count == 2) {
        NSArray *countArr = [self getArrayNumsCount:nums];
        if ([countArr containsObject:@3]) {
            return @"3条";
        } else if([countArr containsObject:@2]) {
            return @"2对";
        }
    } else if(nums.count - set.count == 3) {
        NSArray *countArr = [self getArrayNumsCount:nums];
        if ([countArr containsObject:@4]) {
            return @"4条";
        } else if([countArr containsObject:@3]) {
            return @"葫芦";
        }
    } else if(nums.count - set.count == 4) {
        return @"4条";
    }
    return nil;
//    for (int i = 0; i < nums.count; i++) {
//        <#statements#>
//    }
}
// 统计数组元素出现的次数
-(NSArray *)getArrayNumsCount:(NSArray *)nums
{
    if (nums.count <= 0) return nil;
    NSMutableArray *countArr = [NSMutableArray array];
    NSSet *set = [NSSet setWithArray:nums];
    NSArray *setArr = set.allObjects;
    for (int i = 0; i < setArr.count; i++) {
        int count = 0;
        for (int k = 0; k < nums.count; k++) {
            if (nums[k] == setArr[i]) {
                count++;
            }
        }
        [countArr addObject: [NSNumber numberWithInt:count]];
    }
    return countArr;
}

-(void)initpageView
{
    // 反馈产品
    
    //评价
    [self initStarsViewWithFrame:CGRectMake(20, 100, 200, 30) andTag:1];
    [self initStarsViewWithFrame:CGRectMake(20, 140, 200, 30) andTag:2];
    [self initStarsViewWithFrame:CGRectMake(20, 180, 200, 30) andTag:3];
    //反馈的问题
    
    //上传截图
    
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1000.0)];
    }
    return _contentView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = self.contentView.frame.size;
    }
    return _scrollView;
}

-(void)initStarsViewWithFrame: (CGRect)frme  andTag:(int) tag
{
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:frme numberOfStars:5];
    starRateView.tag = tag;
    starRateView.allowIncompleteStar = NO;
    starRateView.hasAnimation = YES;
    starRateView.delegate = self;
    [self.view addSubview: starRateView];
}

- (void)starRateView:(CWStarRateView *)starRateView scroesDidChange:(NSUInteger)newScores
{
    if (starRateView.tag == 1) {
        NSLog(@"%lu==%ld",(unsigned long)newScores, (long)starRateView.tag);
    }
}


#pragma mark - request page
- (void)requestPageZip:(NSString *)zipPath together:(BOOL)together showProgressTitle: (NSString *)progressTitle
{
    NSString *platformString = @"zesheng";
    NSURLSessionDownloadTask *pageZipTask = [[NXRequest sharedRequest] AFDownLoadFileWithUrl:zipPath progress:^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *text = [NSString stringWithFormat:@"%.0f",progress.fractionCompleted * 100];
            NSString *totalSize = [NSString stringWithFormat:@"%.1fM",progress.totalUnitCount/1024.0/1024.0];
            NSString *finishedSize = [NSString stringWithFormat:@"%.1fM",progress.completedUnitCount/1024.0/1024.0];
//            self.hub.label.text = [NSString stringWithFormat:@"%@：%@%@ (%@/%@)",progressTitle,text,@"%",finishedSize,totalSize]; //正在下载资源：50%（15M/30M）
            self.downloadLabel.text = [NSString stringWithFormat:@"%@：%@%@ (%@/%@)",progressTitle,text,@"%",finishedSize,totalSize];
            NSLog(@"Page：%F",(1.0 * progress.completedUnitCount / progress.totalUnitCount));
        });
    } fileLocalUrl:nil success:^(NSURL * _Nonnull fileUrlPath, NSURLResponse * _Nonnull response) {
//        [self hideProgress];
        NSString *downloadFilePath = [fileUrlPath path]; // 将NSURL转成NSString
        self.pagePath = downloadFilePath;
        if (together) {
//            dispatch_group_leave(self.group);
        } else {
            // 更新page资源后处理沙盒文件
            [NXFileTool processStaticZipPath:self.pagePath platform:platformString success:^(bool isSuccess) {
                if (isSuccess) {
//                    self.lastPageUpdateTime = [[NSDate date] timeIntervalSince1970];
//                    [[CacheModel sharedCacheModel] savePageUpdateVersions: self.firebaseDic[@"v_page"]];
//                    [[CacheModel sharedCacheModel] saveHtmlUpdateState:YES]; // 本地html资源下载状态更新
//                    [self loadWebview];
                    NSLog(@"解压成功了");
                    self.downloadLabel.text = @"解压成功了";
                } else {
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.mode = MBProgressHUDModeIndeterminate;
//                    hud.label.text = @"资源处理失败,请退出重试[5]";
                    self.downloadLabel.text = @"资源处理失败,请退出重试[5]";
//                    [hud showAnimated: YES];
                }
            }];
        }
    } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
        [self hideProgress];
        if (together) {
//            dispatch_group_leave(self.group);
        }
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeIndeterminate;
//        hud.label.text = @"资源下载失败,请退出重试[6]";
        self.downloadLabel.text = @"资源下载失败,请退出重试[6]";
//        [hud showAnimated: YES];
    }];
}

@end
