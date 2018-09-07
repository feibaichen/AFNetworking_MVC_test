//
//  NoDataPlaceHolderView.m
//  CPort
//
//  Created by MacOS on 2018/8/16.
//  Copyright © 2018年 shangfang. All rights reserved.
//

#import "NoDataPlaceHolderView.h"

@interface NoDataPlaceHolderView ()

@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIButton * reloadBtn;

@end

@implementation NoDataPlaceHolderView

- (instancetype) initWithFrame:(CGRect)frame andWhichKindsOfStatusImageKind:(PlaceHolderStatusImageKinds)statusImage
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        _statusImage = statusImage;
        [self setup];
    }
    return  self;
}


- (void) setup
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];//图片
    //[self addSubview:self.label];//文字
    //[self addSubview:self.reloadBtn];//刷新按钮
    
}

- (void)setStatusImage:(PlaceHolderStatusImageKinds)statusImage{
    
    _statusImage = statusImage;
    
    
    if (_statusImage == 0) {
        
        //"没网络"
        _imageView.image = [UIImage imageNamed:@"place_noweifi"];
    }
    
    if (_statusImage == 1) {
        
        //"有网络 没数据"
        _imageView.image = [UIImage imageNamed:@"place_nodate"];
    }
    
    if (_statusImage == 2) {
        
        //"找不到"
        _imageView.image = [UIImage imageNamed:@"place_nosearch"];
    }
    
    if (_statusImage == 3) {
        
        //"没订单"
        _imageView.image = [UIImage imageNamed:@"place_noorder"];
    }
    
}

- (UIImageView *) imageView
{
    if(_imageView == nil) {
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - 180 * 0.5,104, 180, 180)];//MakeHeight(104)
        
        
        if (_statusImage == 0) {
            
            //"没网络"
            _imageView.image = [UIImage imageNamed:@"place_noweifi"];
        }
        
        if (_statusImage == 1) {
            
            //"有网络 没数据"
            _imageView.image = [UIImage imageNamed:@"place_nodate"];
        }
        
        if (_statusImage == 2) {
            
            //"找不到"
            _imageView.image = [UIImage imageNamed:@"place_nosearch"];
        }
        
        if (_statusImage == 3) {
            
            //"没订单"
            _imageView.image = [UIImage imageNamed:@"place_noorder"];
        }
        
    }
    
    return  _imageView;
}

- (UILabel *) label
{
    if(_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+10, self.frame.size.width, 15)];
        _label.text = @"暂无搜索结果~";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:15];
    }
    return  _label;
}

- (UIButton *) reloadBtn
{
    if(_reloadBtn == nil) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = 100.0f;
        CGFloat btnH = 40.0f;
        _reloadBtn.frame = CGRectMake(self.center.x-btnW * 0.5, CGRectGetMaxY(self.label.frame)+10, btnW, btnH);
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _reloadBtn.layer.borderWidth = 0.5;
        _reloadBtn.layer.cornerRadius = 3.0;
        _reloadBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [_reloadBtn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchDown];
    }
    return _reloadBtn;
}


// 按钮方法。
- (void) btnDidClicked:(UIButton *) sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(networkReloaderView:DidClickedReloadBtn:)]) {
        [self.delegate networkReloaderView:self DidClickedReloadBtn:sender];
    }
}


@end
