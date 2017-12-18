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

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self letDownlaodTypeOne];
}

/**
	
	还是有必要总结一下用NSURLSession 进行网络请求的必要性
	温故而知❤️
	
	NSURLSessionTask  父类 又分为
	1> NSURLSessionDataTask  ---> NSURLSessionUploadTask
	
	2> NSURLSessionDownloadTask 
	

	
*/

/*--------------MARK1: GET 请求---------------*/
/** 第一种get 请求  直接用链接*/
- (void)letGetTypeOne
{
	NSString *str = @"";
	// URL
	NSURL *url = [NSURL URLWithString:str];
	// 创建一个task
	NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
	
		// 获取响应状态码
		NSHTTPURLResponse *rep = (NSHTTPURLResponse *)response;
		NSLog(@"%ld",(long)rep.statusCode);
		
	}];
	// 开启task
	[task resume];
	
}

/** 第二种get 请求 创建一个Request 对象 */
- (void)letGetTypeTwo
{

	NSString *str = @"";
	// URL
	NSURL *url = [NSURL URLWithString:str];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	// 可选项 根据需要设置对应的header字段
	[req setValue:@"" forHTTPHeaderField:@""];
	[req setValue:@"" forHTTPHeaderField:@""];
	
	// 创建一个task
	NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
	}];
	// 开启task
	[task resume];
	
}


/*--------------MARK2: POST 请求---------------*/
- (void)letPostTypeOne
{
	 // 2 创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://123.123.123.123:8080/login"]];
	
	// 设置请求方法 不设置 默认为GET
	request.HTTPMethod = @"POST";
	// 设置请求体
	request.HTTPBody = [@"username=alex&pwd=12345" dataUsingEncoding:NSUTF8StringEncoding];
	
	    // 3 创建任务
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		// 解析响应
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
		
		
    }];
    // 3启动任务
    [task resume];

}


/*--------------MARK3: 文件的下载---------------*/
- (void)letDownlaodTypeOne
{
	// 创建下载任务
	
	NSString *str = @"http://f.hiphotos.baidu.com/image/pic/item/63d0f703918fa0ec1d0441e62c9759ee3c6ddb1d.jpg";
	NSURL *url = [NSURL URLWithString:str];;
	
	NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (!error) {
		// 文件存储路径
		// suggestedFilename 表示服务器文件的名字
		NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
		
		NSLog(@"%@",filePath);
		
		NSFileManager *mgr = [NSFileManager defaultManager];
		
		[mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath ] error:nil];
		}else{
			NSLog(@"error happend");
			
		}
		
		
		}];
	
	[task resume];
	
}

/*--------------MARK4: PUT 方式---------------*/
- (void)letPutTypeOne{
	
	NSDictionary *userInfo = @{
		@"username":@"alex",
		@"password":@"123456",
	};
	
	NSURL *url = [NSURL URLWithString:@""];
	NSMutableURLRequest *req  = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:@"PUT"];
	
	NSData *bodyData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
	// 上传任务
	NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:req fromData:bodyData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (error) {
			NSLog(@"%@",error.description);
		}else{
			NSLog(@"upload success");
		}
	}];
	
	[task resume];
	
	
	
}







@end
