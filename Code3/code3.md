### dispatch_semphore 实现线程同步    
dispatch_semaphore信号量为基于计数器的一种多线程同步机制。如果semaphore计数大于等于1，计数-1，返回，程序继续运行。如果计数为0，则等待。dispatch_semaphore_signal(semaphore)为计数+1操作,dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)为设置等待时间，这里设置的等待

* 创建信号 
> dispatch_semaphore_t sem = dispatch_semaphore_create(0);  
* 最后一次回调的时候 执行以下代码 程序继续执行    
> dispatch_semaphore_signal(sem);  
* 等待时间  
> dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
