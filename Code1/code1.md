### Code1 dispatch_group 实现线程同步  
比如说，第一步我想先下载三张图片，然后第二步再去主线程刷新imgview 显示图片。  
利用dispatch_group 来进行实现 ，简单来讲就四行代码. 就可以让代码按照你想要的顺序进行发生。  
  
 * 创建一个dispatch_group_t  
   
 > dispatch_group_t downloadGroup = dispatch_group_create();

* 每次网络请求前先dispatch_group_enter  
> dispatch_group_enter(downloadGroup);  

* 请求回调后再dispatch_group_leave  
> dispatch_group_leave(downloadGroup);  

* 当所有enter的block都leave后，会执行dispatch_group_notify的block  
> dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{});
