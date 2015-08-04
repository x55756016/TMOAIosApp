//
//  FirstViewController.m
//  TMOAAPP
//
//  Created by kenandyu on 15/8/4.
//  Copyright (c) 2015年 xhyorg. All rights reserved.
//

#import "FirstViewController.h"
#import "h5kkContants.h"
#import "KKUtility.h"

@interface FirstViewController ()
{
 ASIFormDataRequest *request;
    NSArray *TaskArry;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAdData];
    // Do any additional setup after loading the view, typically from a nib.
}

//网络请求广告
-(void)loadAdData
{
    NSString *urlStr = GET_FLASH_LIST;
    NSURL *url = [NSURL URLWithString:urlStr];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:5.0];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"0001" forKey:@"CateCode"];
    [request setDidFailSelector:@selector(loadAdDataFail:)];
    [request setDidFinishSelector:@selector(loadAdDataFinish:)];
    [request startAsynchronous];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];    //分组的tableView里才有用
    NSInteger row = [indexPath row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    if (cell == nil)
      {
        cell = [[UITableViewCell alloc]
                
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SectionsTableIdentifier];
        
    }
    cell.textLabel.text = [[myDataSource objectAtIndex:sectionNumber] objectAtIndex:rowNumber];//设置当前单元格的显示内容
    
    cell.textLabel.textColor = [UIColor greenColor];//设置当前单元格的显示字体的颜色
    
    return cell;
}


- (void)loadAdDataFinish:(ASIHTTPRequest *)req
{
    NSError *error;
    NSData *responseData = [req responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"loadAdDataFinish");
    
    if([[dic objectForKey:@"IsSuccess"] integerValue])
    {
        TaskArry = [dic objectForKey:@"ObjData"];
        //    NSLog(@"加载playerArray[%lu][%@]", (unsigned long)playerArray.count, playerArray);
        if([TaskArry count]<1)
        {
            NSLog(@"获取到待办数据为0");
        }
        //结束刷新状态
        [self.tableview reloadData];
    }
}

- (void)loadAdDataFail:(ASIHTTPRequest *)req
{
    [KKUtility showHttpErrorMsg:@"获取首页动态失败 " :req.error];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *TaskArryDict = TaskArry[indexPath.row];
           //打开玩家界面
        NSDictionary *adDic=[NSDictionary dictionaryWithObject:TaskArryDict forKey:@"UserId"];
        [self performSegueWithIdentifier:@"showformdetail" sender:adDic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
