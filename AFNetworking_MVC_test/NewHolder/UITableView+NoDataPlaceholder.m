//
//  UITableView+NoDataPlaceholder.m
//  StandardMVVM
//
//  Created by 张绪川 on 2018/2/2.
//  Copyright © 2018年 张绪川. All rights reserved.
//

#import "UITableView+NoDataPlaceholder.h"
#import <objc/runtime.h>
#import "NoDataPlaceHolderView.h"
#import <MJRefresh.h>

const char * imageDelegateKey_tb = "imageDelegateKey_tb";

@implementation UITableView (NoDataPlaceholder)

+ (void)load{

    Method old = class_getInstanceMethod(self, @selector(reloadData));
    Method current = class_getInstanceMethod(self, @selector(zxc_reloadData));
    method_exchangeImplementations(old, current);
}


-(void)zxc_reloadData{
    [self zxc_reloadData];
    if (self.firstReload) {
        [self refreshPlaceholderView];
    }
    self.firstReload = YES;
    
}



- (void)refreshPlaceholderView{
    
    
    [self clearBackgroundView];
    
    //判断-有判断工具并且网络数据不正常
    if ( self.visibleCells.count <= 0) {
        
        [self loadNormalBackgroundView];
        return;
    }
    
    if (self.visibleCells.count <= 0) {

        [self loadNormalBackgroundView];
    }
    
}




#pragma mark -

- (void)loadNormalBackgroundView{
    
    NoDataPlaceHolderView *normalView = [[NoDataPlaceHolderView alloc] initWithFrame:self.frame andWhichKindsOfStatusImageKind:PlaceHolderStatusImageNoData];
    normalView.center = self.center;
    [self.backgroundView addSubview:normalView];
   
    self.mj_footer.hidden = YES;
}

- (void)clearBackgroundView{
    
    
    [self.backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    }
}

- (BOOL)firstReload {
    return [objc_getAssociatedObject(self, @selector(firstReload)) boolValue];
}

- (void)setFirstReload:(BOOL)firstReload {
    objc_setAssociatedObject(self, @selector(firstReload), @(firstReload), OBJC_ASSOCIATION_ASSIGN);
}



@end
