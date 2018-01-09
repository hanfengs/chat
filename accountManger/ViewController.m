//
//  ViewController.m
//  accountManger
//
//  Created by hanfeng on 2017/11/30.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import "ViewController.h"
#import "JPUSHService.h"

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
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

//JS调用OC的方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = request.URL;
//    NSString *scheme = url.scheme;
//    NSString *host = url.host;
//    NSArray *paths = url.pathComponents;
//    NSString *param1 = paths[1];
//    NSString *param2 = paths[2];
    
    NSString *urlStr = url.absoluteString;
    NSRange range =  [urlStr  rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        
        NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
        
        if ([parametersString containsString:@"&"]) {//说明有多个参数，不是我们需要的
            
        }else{//只有一个参数
            NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
            if (pairComponents.count == 2) {
                NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
                NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
                
                NSString *sel = [key stringByAppendingString:@":"];
                SEL selector = NSSelectorFromString(sel);
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:selector withObject:value];
            }
        }
    }
    
//    if([scheme isEqualToString:@"chat"]){
//        //把字符串变成SEL
//        SEL selector = NSSelectorFromString(param1);
//        // 忽略警告
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        //调用方法
//        [self performSelector:selector withObject:param2];
//
//    }
    return YES;
}

-(void)loginName:(NSString *)string{
    
    NSLog(@"%@",string);
    
    if (string) {
        
        [JPUSHService setAlias:string completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
            NSLog(@"isResCode====%ld", (long)iResCode);
            
        } seq:0];
        
    }
    
    
}

@end
