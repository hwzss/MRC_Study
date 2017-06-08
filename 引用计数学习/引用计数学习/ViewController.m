//
//  ViewController.m
//  引用计数学习
//
//  Created by qwkj on 2017/6/8.
//  Copyright © 2017年 qwkj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    [self Demo1];
    [self Demo2];
}

- (void)Demo1{
    NSObject *object = [[NSObject alloc] init];
    NSLog(@"Reference Count = %lu", (unsigned long)[object retainCount]);
    NSObject *another = [object retain];
    NSLog(@"Reference Count = %lu", (unsigned long)[object retainCount]);
    [another release];
    NSLog(@"Reference Count = %lu", (unsigned long)[object retainCount]);
    [object release];

    // 到这里时，object 的内存被释放了
    //此时如果你开启了僵尸对象调试，你可以打断点看看object指针变为_NSZombie_NSObject类型。意思就是僵尸对象，里面没有任何结构。你这你再像boject发消息就会报错，并且会log出错误描述。如果没有开启object指针还是NSObject，并且此时没有报错就只是异常。比如调用下面代码
   NSLog(@"Reference Count = %lu", (unsigned long)[object retainCount]);//将报错，如果开启僵尸对象调试就会打印出*** -[NSObject retainCount]: message sent to deallocated instance 0x174009a00。如果没有开启，则就只是在抛出异常，EXC_BREAKPOINT(code=1,subcode=0x1925e01cc)."僵尸对象调试"相关资料http://www.jianshu.com/p/74754f3b376d


    //retain则对象的引用计数加一，relase减一。当retainCount 减少为0时 object释放
    
    
    //Cocoa提供了“僵尸对象“（Zombie Object）这个非常方便的功能。启用这项调试功能之后，运行期系统会把所有已经回收的实例转化为特殊的”僵尸对象“，而不是真正回收他们。这种对象所在的核心内存无法重用，因此不可能遭到复写。僵尸对象收到消息之后，会抛出异常，其中准确说明了发送过来的消息，并描述了回收之前的那个对象。僵尸对象是调试内存管理问题的最佳方式。将NSZombieEnabled环境变量设为YES，即可开启此功能。给僵尸对象发消息后，控制台会打印消息，而应用程序会终止
}
-(void)Demo2{
    NSObject *object = [[NSObject alloc] init];
    NSLog(@"ob:%@", [object debugDescription]);
    NSLog(@"Reference Count = %lu", (unsigned long)[object retainCount]);
    
    NSObject *another = object;
    NSLog(@"ob:%@", [another debugDescription]);
    NSLog(@"Reference Count = %lu", (unsigned long)[object retainCount]);
    
    [another release];//这里可以看出，作为方法内的局部变量如果在方法内部一直用的到object，我们其实可以只在尾部进行一次release，中间不进行任何retain。
    // 从这里，我们还看不出来引用计数真正的用处。因为该对象的生命期只是在一个函数内，所以在真实的应用场景下，我们在函数内使用一个临时的对象，通常是不需要修改它的引用计数的，只需要在函数返回前将该对象销毁即可。出自http://blog.devtang.com/2016/07/30/ios-memory-management/
    //引用计数真正派上用场的场景是在面向对象的程序设计架构中，用于对象之间传递和共享数据。我们举一个具体的例子：
    //假如对象 A 生成了一个对象 M，需要调用对象 B 的某一个方法，将对象 M 作为参数传递过去。在没有引用计数的情况下，一般内存管理的原则是 “谁申请谁释放”，那么对象 A 就需要在对象 B 不再需要对象 M 的时候，将对象 M 销毁。但对象 B 可能只是临时用一下对象 M，也可能觉得对象 M 很重要，将它设置成自己的一个成员变量，那这种情况下，什么时候销毁对象 M 就成了一个难题。
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
