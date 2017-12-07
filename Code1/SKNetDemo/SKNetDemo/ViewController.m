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
- (IBAction)loadDataBtnClick:(id)sender {
	/*
		http://g.hiphotos.baidu.com/image/h%3D220/sign=25515a55865494ee9822081b1df4e0e1/c2fdfc039245d68802b0694eaec27d1ed31b24ae.jpg
		
		http://h.hiphotos.baidu.com/image/pic/item/d4628535e5dde711e70b7e1dadefce1b9c16617b.jpg
		
		http://g.hiphotos.baidu.com/image/pic/item/95eef01f3a292df54e6346fbb6315c6035a873b8.jpg
	*/
	
	// 去下载图片,等待所有的图片下载完成 去进行展示
	// 因此就有了一个同步的概念
	NSArray *imgUrlArr = @[@"http://g.hiphotos.baidu.com/image/h%3D220/sign=25515a55865494ee9822081b1df4e0e1/c2fdfc039245d68802b0694eaec27d1ed31b24ae.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/d4628535e5dde711e70b7e1dadefce1b9c16617b.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/95eef01f3a292df54e6346fbb6315c6035a873b8.jpg"];
	
	// 创建一个dispatch_group 来进行网络请求
	
	dispatch_group_t group = dispatch_group_create();

	
	for (int i = 0; i < imgUrlArr.count; i ++) {
	
			// 每一次请求之前  enter 到group 中
			dispatch_group_enter(group);
	
			NSURL *url = [NSURL URLWithString:imgUrlArr[i]];
			NSURLRequest *req = [NSURLRequest requestWithURL:url];
		
			NSURLSessionDataTask *task = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
				if (!error) {
					// 没有错误 请求成功
					UIImage *image = [UIImage imageWithData:data];
					[_succImgArr addObject:image];
					NSLog(@"download %d img success",i);
				}
				
				// 请求完成之后 离开
				dispatch_group_leave(group);
			}];
		
			[task resume];
		
	}
	
	// 等待group 里面所有的enter 进去的 leave 完。就会调用下面方法
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		NSLog(@"Job has done!!!");
		
		_firstShowImgView.image = self.succImgArr[0];
		_secondShowImgView.image = self.succImgArr[1];
		_thirdShowImgview.image = self.succImgArr[2];
	});
	
	/*
	
	输出结果:
	
	2017-12-07 21:27:02.359 SKNetDemo[85647:3406802] download 0 img success
	2017-12-07 21:27:02.360 SKNetDemo[85647:3406802] download 2 img success
	2017-12-07 21:27:02.360 SKNetDemo[85647:3406802] download 1 img success
	2017-12-07 21:27:02.361 SKNetDemo[85647:3406258] Job has done!!!

	
	*/

}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
