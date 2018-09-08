//
//  Hello.m
//  Maps
//
//  Created by test on 2017/12/20.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
#import "TestOC.h"
@implementation TestOC

//@property (nonatomic, strong) NSString *nsStr = @"I 是 lineli";

- (void)sayHello   //实例方法，必须使用类的实例才可以调用的
{
    STLog(@"hello to you");
}
- (void)sayWhat:(NSString *)name andAge:(NSString *)age
{
    STLog(@"%@,%@",name,age);
}
+ (void)sayHelloTwo  //类方法，这类方法是可以直接用类名来调用的，它的作用主要是创建一个实例
{
    STLog(@"i want to make friend with you");
}
@end


