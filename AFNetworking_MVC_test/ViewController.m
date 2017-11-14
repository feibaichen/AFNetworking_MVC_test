//
//  ViewController.m
//  AFNetworking_MVC_test
//
//  Created by Derek on 05/11/17.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.m"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "MyModel.h"
#import "MyTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * Tv;
    NSMutableArray * dataArray;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUI];
    
    [self mjrefresh];
    
    
    
    
    
}

-(void)mjrefresh{
    Tv.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadmydata)];

    [Tv.mj_header beginRefreshing];
    
    
    Tv.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downloadTaskWith)];
    
}
-(void)loadmydata{
    [self getData];
    [Tv.mj_header endRefreshing];
}
-(void)downloadTaskWith{
    [Tv.mj_footer beginRefreshing];
    
    [NSThread sleepForTimeInterval:3];
    
    [Tv.mj_footer endRefreshing];
}
-(void)setUI{

    dataArray=[[NSMutableArray alloc]init];
    Tv=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    
    [Tv registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellid"];
    
    Tv.delegate=self;
    Tv.dataSource=self;
    
    [self.view addSubview:Tv];
    
}

-(void)getData{
    
    AFHTTPSessionManager * session=[AFHTTPSessionManager manager];
    
    [session POST:@"http://guangdiu.com/api/getlist.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * drr=[NSArray arrayWithArray:[responseObject valueForKey:@"data"]];
        //NSLog(@"%@",dic);
        
        for (NSDictionary * dic in drr) {
            MyModel *model=[MyModel modelWithDic:dic];
            [dataArray addObject:model];
        }
        [Tv reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma tableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MyTableViewCell" owner:self options:nil]lastObject];
    }
    MyModel * model=dataArray[indexPath.row];
    
    [cell.producetPic sd_setImageWithURL:[NSURL URLWithString:model.Pimage] placeholderImage:[UIImage imageNamed:@"playholder.jpg"]];
    cell.productName.text=[NSString stringWithFormat:@"%@",model.Ptitle];
    cell.productSite.text=[NSString stringWithFormat:@"电商平台：%@",model.Pmall];
    cell.productMadeIn.text=[NSString stringWithFormat:@"Made In ：%@",model.Pcountry];
    cell.productPublishTime.text=[NSString stringWithFormat:@"发布时间：%@",model.Ppubtime];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
