//
//  ViewController.m
//  QRDeCode
//
//  Created by chens on 16/3/17.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import "QRDecodeVC.h"
#import "CSCaptureView.h"
#import <AVFoundation/AVFoundation.h>
#import "SkipWebVC.h"
@interface QRDecodeVC ()<AVCaptureMetadataOutputObjectsDelegate>{
   
    UILabel *_decodedMessage;
    CSCaptureView* cap;
}

@end

@implementation QRDecodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"扫一扫";
    // Do any additional setup after loading the view, typically from a nib.
     cap=[[CSCaptureView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-164)];
    cap.fuctionType=CSCaptureDecodeQRCodeType;
    [cap startWork];
    [(AVCaptureMetadataOutput*)cap.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    [self.view addSubview:cap];
    
    
    UIButton* bottom=[UIButton buttonWithType:UIButtonTypeCustom];
    [bottom setTitle:@"重新扫描" forState:UIControlStateNormal];
    [bottom addTarget:cap.session action:@selector(startRunning) forControlEvents:UIControlEventTouchUpInside];
    bottom.frame=CGRectMake(0,[UIScreen mainScreen].bounds.size.height-100, [UIScreen mainScreen].bounds.size.width, 100);
    [bottom setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:bottom];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [cap.session startRunning];
}
- (NSArray *)translatePoints:(NSArray *)points fromView:(UIView *)fromView toView:(UIView *)toView
{
    NSMutableArray *translatedPoints = [NSMutableArray new];
    
    // The points are provided in a dictionary with keys X and Y
    for (NSDictionary *point in points) {
        // Let's turn them into CGPoints
        CGPoint pointValue = CGPointMake((1-[point[@"Y"] floatValue])*[UIScreen mainScreen].bounds.size.width, [point[@"X"] floatValue]*[UIScreen mainScreen].bounds.size.height);
        // Now translate from one view to the other
        // Box them up and add to the array
        [translatedPoints addObject:[NSValue valueWithCGPoint:pointValue]];
    }
    
    return [translatedPoints copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata isKindOfClass:[AVMetadataMachineReadableCodeObject class]]){
            AVMetadataMachineReadableCodeObject *transformed = (AVMetadataMachineReadableCodeObject *)metadata;
            NSLog(@"%@",[transformed stringValue]);
            [cap stopWork];
            NSString* string = [[transformed stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
            NSString* url=nil;
            if (!string.length) {
                 url=[NSString stringWithFormat:@"http://tiaoma.cnaidc.com/jbestd.asp?ean=%@",transformed.stringValue];
                NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                SkipWebVC* web=[[SkipWebVC alloc]init];
                web.infoDic=dic;
                web.title=@"扫描结果";
                [self .navigationController pushViewController:web animated:YES];
            }else{
                 url=transformed.stringValue;
                SkipWebVC* web=[[SkipWebVC alloc]init];
                web.url=url;
                web.title=@"扫描结果";
                [self .navigationController pushViewController:web animated:YES];
            }
     
            
        }
    }
}
@end
