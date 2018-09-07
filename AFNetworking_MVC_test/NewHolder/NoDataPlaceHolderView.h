//
//  NoDataPlaceHolderView.h
//  CPort
//
//  Created by MacOS on 2018/8/16.
//  Copyright © 2018年 shangfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoDataPlaceHolderViewDelegate;

//使用何种图片的枚举
typedef NS_ENUM(NSInteger, PlaceHolderStatusImageKinds) {
    PlaceHolderStatusImageNoNetWork   = 0, //"没网络"
    PlaceHolderStatusImageNoData      = 1, //"有网络 没数据"
    PlaceHolderStatusImageNotFound    = 2, //"找不到"
    PlaceHolderStatusImageNoOrder     = 3, //"没订单"
};

@interface NoDataPlaceHolderView : UIView

@property (nonatomic,weak) id <NoDataPlaceHolderViewDelegate> delegate;
//接收枚举值
@property (nonatomic,assign) PlaceHolderStatusImageKinds statusImage;

- (instancetype) initWithFrame:(CGRect)frame andWhichKindsOfStatusImageKind:(PlaceHolderStatusImageKinds)statusImage;

@end


@protocol NoDataPlaceHolderViewDelegate <NSObject>

@optional

- (void) networkReloaderView:(NoDataPlaceHolderView *)placeHolderView DidClickedReloadBtn:(UIButton *) sender;

@end
