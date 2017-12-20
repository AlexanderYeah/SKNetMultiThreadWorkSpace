//
//  ViewController.m
//  SKRawNetDemo
//
//  Created by Alexander on 2017/12/15.
//  Copyright © 2017年 alexander. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/** 创建一个session 对象 */
@property (nonatomic,strong)NSURLSession *session;

/** 第1个图片链接数组 */
@property (nonatomic,strong)NSMutableArray *firstImgArr;

/** 第2个图片链接数组 */
@property (nonatomic,strong)NSMutableArray *secImgArr;

/** 第3个图片链接数组 */
@property (nonatomic,strong)NSMutableArray *thirdImgArr;


/** 第1个图片数组链接下载成功的图片保存到数组 */
@property (nonatomic,strong)NSMutableArray *firstSuccDownloadArr;

/** 第2个图片数组链接下载成功的图片保存到数组 */
@property (nonatomic,strong)NSMutableArray *secSuccDownloadArr;

/** 第3个图片数组链接下载成功的图片保存到数组 */
@property (nonatomic,strong)NSMutableArray *thirdSuccDownloadArr;







@end

@implementation ViewController

#pragma mark - 懒加载
- (NSURLSession *)session{
	if (!_session) {
		// 配置
		NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
		cfg.timeoutIntervalForRequest = 10;
		// 是否允许使用手机自带网络
		cfg.allowsCellularAccess = YES;
		_session = [NSURLSession sessionWithConfiguration:cfg];
	}
	return _session;

}

- (NSMutableArray *)firstImgArr
{
	if (!_firstImgArr) {
		NSArray *arr = @[@"http://img15.3lian.com/2015/h1/280/d/3.jpg"];
		_firstImgArr = [NSMutableArray arrayWithArray:arr];
	}
	return _firstImgArr;

}

- (NSMutableArray *)secImgArr
{
	if (!_secImgArr) {
		NSArray *arr = @[@"http://img3.imgtn.bdimg.com/it/u=689903703,3312238547&fm=214&gp=0.jpg"];
		_secImgArr = [NSMutableArray arrayWithArray:arr];
	}
	return _secImgArr;

}



- (NSMutableArray *)thirdImgArr
{
	if (!_thirdImgArr) {
		NSArray *arr = @[@"http://img2.100bt.com/upload/ttq/20131208/1386496341645_middle.jpg"];
		_thirdImgArr = [NSMutableArray arrayWithArray:arr];
	}
	return _thirdImgArr;

}

- (NSMutableArray *)firstSuccDownloadArr
{
	if (!_firstSuccDownloadArr) {
	
		_firstSuccDownloadArr = [NSMutableArray array];
	}
	return _firstSuccDownloadArr;
	
}

- (NSMutableArray *)secSuccDownloadArr
{
	
	if (!_secSuccDownloadArr) {
	
		_secSuccDownloadArr = [NSMutableArray array];

	}
	return _secSuccDownloadArr;
}


- (NSMutableArray *)thirdSuccDownloadArr
{

	if (!_thirdSuccDownloadArr) {
	
		_thirdSuccDownloadArr = [NSMutableArray array];
		
	}
	
	return _thirdSuccDownloadArr;	
}


- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self letItGo];
}
/**
	 需求说明1: 
	 有三个数组，每个数组中有一个图片链接。先下载三个数组的图片链接,再加载到scrollview 上面
	 * 下载图片
	 * 刷新UI,也就是说刷新UI的时候必须是图片的。
 
*/

/*--------------MARK1: 实现方式1 group 的使用 ---------------*/
/**
	第一种 dispatch_group
*/

- (void)letItGo
{
	
	
	
	dispatch_group_t group = dispatch_group_create();
	
	// 循环下载数组中的图片
	for (int i = 0; i < 3; i ++) {
		// 下载哪个数组的图片 以及 结果保存数组
		NSMutableArray *targetArr = [NSMutableArray array];
		NSMutableArray *succResArr = [NSMutableArray array];
		
		// 根据索引 下载不同数组的图片
		if (i == 0) {
			targetArr = self.firstImgArr;
			succResArr = self.firstSuccDownloadArr;
		}else if (i == 1){
			targetArr = self.secImgArr;
			succResArr = self.secSuccDownloadArr;
		}else{
			targetArr = self.thirdImgArr;
			succResArr = self.thirdSuccDownloadArr;
		}
		
		// 开启for 循环进行下载
		
		for (int i = 0; i < targetArr.count; i ++) {
		
			dispatch_group_enter(group);
			NSURLSession *session = [NSURLSession sharedSession];
			NSString *str = [targetArr[i] stringByReplacingOccurrencesOfString:@"\""  withString:@""];
			NSLog(@"%@",str);
			NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:str] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
				if (!error && data != nil) {
				
					NSLog(@"%lu",data.length);
					
					[succResArr addObject:@"OK"];
					dispatch_group_leave(group);
				}else{
					NSLog(@"error");
					dispatch_group_leave(group);
				}
			}];
			
			[task resume];
			
			
		}
		
	}
	
	// 下载完毕 结果回调 数组中结果各有一个
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		NSLog(@"%lu",(unsigned long)self.firstSuccDownloadArr.count);
		NSLog(@"%lu",(unsigned long)self.secSuccDownloadArr.count);
		NSLog(@"%lu",(unsigned long)self.thirdSuccDownloadArr.count);
	});
	
	
}








@end
