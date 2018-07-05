//
//  MyModel.h
//  AFNetworking_MVC_test
//
//  Created by Derek on 05/11/17.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject
@property (nonatomic,copy) NSString * Pcountry;
@property (nonatomic,copy) NSString * Pmall;
@property (nonatomic,copy) NSString * Pimage;
@property (nonatomic,copy) NSString * Pimgh;
@property (nonatomic,copy) NSString * Pimgw;
@property (nonatomic,copy) NSString * Ppubtime;
@property (nonatomic,copy) NSString * Ptitle;

;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;
@end
