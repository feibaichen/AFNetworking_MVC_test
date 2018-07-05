//
//  ViewController.m
//  AFNetworking_MVC_test
//
//  Created by Derek on 05/11/17.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.m"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "MyModel.h"
#import "MyTableViewCell.h"

static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView * myTableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUI];
    
    [self mjrefresh];
    
    
    
    
    
}

-(void)mjrefresh{
    _myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadmydata)];

    [_myTableView.mj_header beginRefreshing];
    
    
    _myTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downloadTaskWith)];
    
}
-(void)loadmydata{
    [self getData];
}
-(void)downloadTaskWith{
    [_myTableView.mj_footer beginRefreshing];
    

    [_myTableView.mj_footer endRefreshing];
}
-(void)setUI{

    _dataArray=[[NSMutableArray alloc]init];
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellid"];
    
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    
    [self.view addSubview:_myTableView];
    
}

-(void)getData{
    
    AFHTTPSessionManager * session=[AFHTTPSessionManager manager];
    
    [session POST:@"http://guangdiu.com/api/getlist.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * drr=[NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
        //NSLog(@"%@",dic);
        
        for (NSDictionary * dic in drr) {
            MyModel *model=[MyModel modelWithDic:dic];
            [_dataArray addObject:model];
        }
        [_myTableView reloadData];
        [_myTableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma tableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MyTableViewCell" owner:self options:nil]lastObject];
    }
   
    if (_dataArray.count > 0 ) {
        
        
        MyModel * model=_dataArray[indexPath.row];
        
        
        cell.productName.text=[NSString stringWithFormat:@"%@",model.Ptitle];
        cell.productSite.text=[NSString stringWithFormat:@"电商平台：%@",model.Pmall];
        cell.productMadeIn.text=[NSString stringWithFormat:@"Made In ：%@",model.Pcountry];
        cell.productPublishTime.text=[NSString stringWithFormat:@"发布时间：%@",model.Ppubtime];
        
        NSString *URLString = [NSString stringWithFormat:@"%@",model.Pimage];
        
        ///初始化一个缓存池
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        //NSLog(@"\n第%02ld行的图片缓存是否存在 : %@",(long)indexPath.row,[imageCache diskImageExistsWithKey:model.Pimage completion:nil] ? @"YES" : @"NO");
        
        ///从缓存中取图片
        [imageCache queryCacheOperationForKey:model.Pimage done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
            
            //图片存在就直接加载图片，否则就加载默认图片blank.png
            
            
            if (image) {
                
                cell.producetPic.alpha = 0;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIView animateWithDuration:1 animations:^{
                        
                        cell.producetPic.alpha = 1;
                        cell.producetPic.image = image;
                    }];
                    
                });
                
            }else{
                
                ///如果缓存里没找到对应的图片,当停止滑动时下载并缓存图片
                if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO) {
                    ///异步下载图片
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        SDWebImageDownloader *downLoader = [SDWebImageDownloader sharedDownloader];
                        
                        [downLoader downloadImageWithURL:[NSURL URLWithString:URLString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                             //此处可以设置下载进度（receivedSize/expectedSize）
                        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                            
                            if (image && finished) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    cell.producetPic.image = image;
                                });
                                ///以图片的下载地址作为key缓存图片
                                
                                ///缓存图片
                                //[[SDImageCache sharedImageCache]storeImage:image imageData:data forKey:URLString toDisk:YES completion:nil];
                            }
                        }];
                        
                    });
                }
                
                cell.producetPic.alpha = 0;
                
                [UIView animateWithDuration:1 animations:^{
                    
                    cell.producetPic.alpha = 1;
                    ///按理说应该写在这里,但是写在这里的话不加载默认图片,还没找到原因
                    cell.producetPic.image = [UIImage imageNamed:@"playholder.jpg"];
                }];
                
                
            }
        }];
        
    }
    

    return cell;
}
-(void)loadImagesForOnscreenRows{
    
    if (self.dataArray.count > 0) {
        
        ///获取到当期屏幕里的cell的indexPath
        NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            
            MyTableViewCell *cell = (MyTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
            
            MyModel *model = self.dataArray[indexPath.row];
            
            NSString *imageString = [NSString stringWithFormat:@"%@",model.Pimage];
            
            SDImageCache *imageCache = [[SDImageCache alloc]initWithNamespace:@"myCacheSpace"];
            
            [imageCache queryCacheOperationForKey:imageString done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                
                if (!image) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        SDWebImageDownloader *downLoader = [SDWebImageDownloader sharedDownloader];
                        
                        [downLoader downloadImageWithURL:[NSURL URLWithString:imageString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            //这里可以设置下载进度
                        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                            
                            if (image && finished) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    cell.producetPic.image = image;
                                });
                                ///缓存图片
                                [[SDImageCache sharedImageCache]storeImage:image imageData:data forKey:imageString toDisk:YES completion:nil];
                            }
                        }];
                        
                    });
                    
                }
                
            }];
            
        }
        //[self.tableView reloadData];
    }
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (decelerate) {
        [self loadImagesForOnscreenRows];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self loadImagesForOnscreenRows];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
