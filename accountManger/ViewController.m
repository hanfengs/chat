//
//  ViewController.m
//  accountManger
//
//  Created by hanfeng on 2017/11/30.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     http://47.95.38.15/gm/login.html
     http://47.95.38.15/gm/login.html
     
     http://maxen.quxueabc.com
     */
    NSURL *url = [NSURL URLWithString:@"http://47.95.38.15/gm/login.html"];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    //加载请求的时候忽略缓存
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [self.webView loadRequest:urlRequest];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
