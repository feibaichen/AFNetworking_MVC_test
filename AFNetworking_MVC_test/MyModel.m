//
//  MyModel.m
//  AFNetworking_MVC_test
//
//  Created by Derek on 05/11/17.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self=[super init];
    
    if (self) {
        self.Pcountry=[dic valueForKey:@"country"];
        self.Pmall=[dic valueForKey:@"mall"];
        self.Pimage=[dic valueForKey:@"image"];
        self.Pimgh=[NSString stringWithFormat:@"%@",[dic valueForKey:@"imgh"]];
        self.Pimgw=[NSString stringWithFormat:@"%@",[dic valueForKey:@"imgw"]];
        self.Ppubtime=[dic valueForKey:@"pubtime"];
        self.Ptitle=[dic valueForKey:@"title"];
    }
    
    return self;
}

+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}
@end
