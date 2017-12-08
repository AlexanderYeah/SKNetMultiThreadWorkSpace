//
//  ViewController.m
//  SKNetDemo
//
//  Created by Alexander on 2017/12/7.
//  Copyright © 2017年 alexander. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong)NSURLSession *session;
/** 请求成功 装图片的数组 */
@property (nonatomic,strong)NSMutableArray *succImgArr;

/**  展示第一张 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *firstShowImgView;
/**  展示第二张 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *secondShowImgView;
/**  展示第三张 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *thirdShowImgview;

@end

@implementation ViewController

- (NSURLSession *)session
{
	if (!_session) {
		_session = [NSURLSession sharedSession];
	}
	
	return _session;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_succImgArr = [NSMutableArray arrayWithCapacity:0];
	
	
}

/** 网络请求 */
// NSOPeration  实现顺序回调
- (IBAction)loadDataBtnClick:(id)sender {
	/*
		http://g.hiphotos.baidu.com/image/h%3D220/sign=25515a55865494ee9822081b1df4e0e1/c2fdfc039245d68802b0694eaec27d1ed31b24ae.jpg
		
		http://h.hiphotos.baidu.com/image/pic/item/d4628535e5dde711e70b7e1dadefce1b9c16617b.jpg
		
		http://g.hiphotos.baidu.com/image/pic/item/95eef01f3a292df54e6346fbb6315c6035a873b8.jpg
	*/
	
	// 去下载图片,等待所有的图片下载完成 去进行展示
	// 因此就有了一个同步的概念
	NSArray *imgUrlArr = @[@"http://g.hiphotos.baidu.com/image/h%3D220/sign=25515a55865494ee9822081b1df4e0e1/c2fdfc039245d68802b0694eaec27d1ed31b24ae.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/d4628535e5dde711e70b7e1dadefce1b9c16617b.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/95eef01f3a292df54e6346fbb6315c6035a873b8.jpg"];
	

	// 创建操作数组
	NSMutableArray *operArr = [[NSMutableArray alloc]initWithCapacity:0];
	
	
	
	for (int i = 0; i < imgUrlArr.count; i ++) {
	
		// 开启一个op
		NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
			NSURL *url = [NSURL URLWithString:imgUrlArr[i]];
			NSURLRequest *req = [NSURLRequest requestWithURL:url];
		
			NSURLSessionDataTask *task = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
				if (!error) {
					// 没有错误 请求成功
					UIImage *image = [UIImage imageWithData:data];
					[_succImgArr addObject:image];
					NSLog(@"download %d img success",i);
				}else{
					NSLog(@"error happend");
				}

				
			}];
		
			[task resume];
		}];
		
		// 添加到数组中
		[operArr addObject:op];
		// 循环的添加依赖，后一个依赖前一个
		if (i > 0) {
			NSBlockOperation *op1 = operArr[i - 1];
			NSBlockOperation *op2 = operArr[i];
			[op2 addDependency:op1];
		}
		
	}
	
	// 等待完成
	NSOperationQueue *queue = [[NSOperationQueue alloc]init];
	
	// 传入YES 会阻断主线程 不要再主线程中等待一个Operation
	[queue addOperations:operArr waitUntilFinished:NO];
		
	/*
	
	输出结果:

2017-12-08 11:27:55.741356+0800 SKNetDemo[32336:6378066] download 0 img success
2017-12-08 11:27:55.743986+0800 SKNetDemo[32336:6378068] download 1 img success
2017-12-08 11:27:55.745406+0800 SKNetDemo[32336:6378068] download 2 img success

		

	*/

}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
