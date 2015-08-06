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
#define KFirstSegmentedIndex 0
#define KSecondSegmentedIndex 1



@interface FirstViewController ()
{
    ASIFormDataRequest *request;
    NSArray *TaskArray;
    NSMutableArray *taskRelust;
}

@end

@implementation FirstViewController
@synthesize TaskArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self loadAdData];
    
    TaskArray = [[NSArray alloc]initWithObjects:@"待处理1",@"待处理2",@"待处理3",@"已办1",@"已办2",nil];
    taskRelust=[[NSMutableArray alloc] initWithArray:TaskArray];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)initSegmentControl
{
    //NSArray *TaskArray = [[NSArray alloc]initWithObjects:@"待处理",@"已处理",nil];
}

- (IBAction)SegmentPressed:(id)sender {
    [taskRelust removeAllObjects];
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
          //  [TaskArray removeFromSuperview];
            for (NSString * theStr in TaskArray) {
               
                NSRange range = [theStr rangeOfString:@"待处理"];//判断字符串是否包含
                if (range.length >0)//包含
                {
                    [taskRelust addObject:theStr];
                }
                
            }
            break;
        case 1:
            for (NSString * theStr in TaskArray) {
                NSRange range = [theStr rangeOfString:@"已办"];//判断字符串是否包含
                if (range.length >0)//包含
                {
                    [taskRelust addObject:theStr];
                }
            }
            break;
        default:
            NSLog(@"segmentActionDefault");
            break;
    }
    
    //结束刷新状态
    [self.tableview reloadData];
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [taskRelust count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimlpeTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [taskRelust objectAtIndex:row];
    
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
        TaskArray = [dic objectForKey:@"ObjData"];
        //    NSLog(@"加载playerArray[%lu][%@]", (unsigned long)playerArray.count, playerArray);
        if([TaskArray count]<1)
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
    NSDictionary *TaskArryDict = TaskArray[indexPath.row];
           //打开玩家界面
        NSDictionary *adDic=[NSDictionary dictionaryWithObject:TaskArryDict forKey:@"UserId"];
        [self performSegueWithIdentifier:@"showformdetail" sender:adDic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
