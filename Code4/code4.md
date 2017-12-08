### NSBlockOperation 实现按照次序进行网络请求  

### 即执行完第一个网络请求后，第二个网络请求回调才可被执行，简单来讲就是输出得是0,1,2,3...9这种方式的。


原理如下:
   
``` 
    //1 创建一个队列 （非主队列）
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    // 2 设置最大并发数, 同一时间只能并发两条，保证系统的性能。
    queue.maxConcurrentOperationCount = 2;
    //3 添加操作到队列中 （自动异步执行,并发）
    NSBlockOperation *op1 =[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 =[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    }];

```
