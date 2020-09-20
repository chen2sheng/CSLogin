//
//  SkipWebVC.m
//  QRDeCode
//
//  Created by chens on 16/3/18.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import "SkipWebVC.h"

@interface SkipWebVC ()

@end

@implementation SkipWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_url) {
        UIWebView* web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        
        [self.view addSubview:web];
    }
    if (_infoDic) {
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        label.text=[_infoDic description];
        label.numberOfLines=0;
        [self.view addSubview:label];
    }
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
