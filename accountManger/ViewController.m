//
//  ViewController.m
//  accountManger
//
//  Created by hanfeng on 2017/11/30.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import "ViewController.h"
#import "JPUSHService.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"
#import "NSString+URLParam.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

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
    
    
    
    //"http://47.95.38.15/gm/index.html?loginName=admin"
    
    NSString *urlStr = url.absoluteString;
    NSRange range =  [urlStr  rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        
        NSDictionary *dict = [urlStr getURLParameters];
        NSLog(@"=====%@", dict);
        
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

//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
//    NSString *textJS = @"showAlert('这里是JS中alert弹出的message')";
    
    NSString *deviceId = ApplicationDelegate.deviceToken;
    NSString *registrationId = [JPUSHService registrationID];
    
    NSString *textJS = [NSString stringWithFormat:@"deviceInit('deviceId=%@&registrationId=%@');", deviceId, registrationId];
    
    [self.webView stringByEvaluatingJavaScriptFromString:textJS];
    
    
    /*
     1;原生才能拿到 deviceID 和 registerID
     2；Web才能拿到 userID
     3；后台需要 以上3个参数，执行接口
     4；我们这还看不了 执行结果。
     */

    /*
     1；在web端，加入alert（“参数”），确定参数无误
     2；在执行成功时，弹出alert（成功），确认成功
     3；在执行失败的地方，弹出alert（“失败信息”）
     */
    
    /*
     1；让web传递 userID给 原生，这样原生就获得全部的3个参数
     2；在原生中，请求后台接口
     */
    
//    [context evaluateScript:textJS];
}

@end
