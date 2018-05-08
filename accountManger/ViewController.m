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
#import "IDViewController.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSDictionary *jsDict;

@end

@implementation ViewController{
    NSDictionary *_dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveDeviceToken) name:@"deviceTokenStr" object:nil];
    
    self.webView.delegate = self;
    /*
     http://47.95.38.15/gm/login.html
     http://47.95.38.15/gm/login.html
     http://101.132.152.101/gm/login.html
     http://maxen.quxueabc.com
     */
    NSURL *url = [NSURL URLWithString:@"http://101.132.152.101/gm/login.html"];
    
    //加载请求的时候忽略缓存
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [self.webView loadRequest:urlRequest];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//
//    NSString *deviceId = ApplicationDelegate.deviceToken;
//    NSString *registrationId = [JPUSHService registrationID];
//
//    NSString *textJS = [NSString stringWithFormat:@"deviceInit('deviceId=%@&registrationId=%@');", deviceId, registrationId];
//    [self.webView stringByEvaluatingJavaScriptFromString:textJS];
//    //@"deviceInit(\"参数\");"
//}

//JS调用OC的方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = request.URL;
    NSString *scheme = url.scheme;
    
//    NSString *host = url.host;
//    NSArray *paths = url.pathComponents;
//    NSString *param1 = paths[1];
//    NSString *param2 = paths[2];
    
    //"http://47.95.38.15/gm/index.html?loginName=admin&userId=1"
    
    NSString *urlStr = url.absoluteString;
    NSRange range =  [urlStr  rangeOfString:@"?"];
    if (range.location != NSNotFound) {
       
        NSDictionary *dict = [urlStr getURLParameters];
        NSLog(@"=====%@", dict);
        self.jsDict = dict;

//        NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
//
//        if ([parametersString containsString:@"&"]) {//说明有多个参数，不是我们需要的
//
//        }else{//只有一个参数
//            NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
//            if (pairComponents.count == 2) {
//                NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
//                NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];

////                [self haveDeviceToken];

//                NSString *sel = [key stringByAppendingString:@":"];
//                SEL selector = NSSelectorFromString(sel);
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//                [self performSelector:selector withObject:value];
//
//            }
//        }
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
    
    //html中，没有Chat，并不会执行此段代码
    if ([scheme isEqualToString:@"chat"]) {
        NSString *deviceId = ApplicationDelegate.deviceToken;
        NSString *registrationId = [JPUSHService registrationID];
        
        NSString *textJS = [NSString stringWithFormat:@"deviceInit('deviceId=%@&registrationId=%@');", deviceId, registrationId];
        [self.webView stringByEvaluatingJavaScriptFromString:textJS];
    }
    
    return YES;
}

- (void)setJsDict:(NSDictionary *)jsDict{
    _jsDict = jsDict;
    
    NSString *userID = [jsDict objectForKey:@"userId"];
    NSString *alias = [jsDict objectForKey:@"loginName"];
    
    [self postUserId:userID withAlias:alias];
}

-(void)loginName:(NSString *)string{
    
    NSLog(@"%@",string);
    
    if (string) {
        
        [JPUSHService setAlias:string completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
            NSLog(@"isResCode====%ld", (long)iResCode);
            
        } seq:0];
    }

    //JavaScriptCore的方式，
//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *textJS = @"showAlert('这里是JS中alert弹出的message')";
    
//    NSString *deviceId = ApplicationDelegate.deviceToken;
//    NSString *registrationId = [JPUSHService registrationID];
//
//    NSString *textJS = [NSString stringWithFormat:@"deviceInit('deviceId=%@&registrationId=%@');", deviceId, registrationId];
//
//    [self.webView stringByEvaluatingJavaScriptFromString:textJS];
    
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

//- (void)haveDeviceToken{
//
//    NSString *deviceId = ApplicationDelegate.deviceToken;
//    NSString *registrationId = [JPUSHService registrationID];
//
//    NSString *textJS = [NSString stringWithFormat:@"deviceInit('deviceId=%@&registrationId=%@');", deviceId, registrationId];
//
//    [self.webView stringByEvaluatingJavaScriptFromString:textJS];
//}

#pragma mark- 原生GET
/*
 注册设备：/push/device/init
 参数：userId=123&deviceId=123&pushRegistrationId=123&type=2&isProduction=true
 注：typeExtra，0:学生；1：资助人；2：chat，默认为2
 isProduction，true：生产环境，false：开发环境，默认为false
 type，isProduction是非必填
 
 ************************
 1001 四位的现在定义的是客户端请求的问题，相当于HTTP的 4开头的
 1001=用户名或密码错误;登陆失败
 1002=用户名不存在;登陆失败
 1003=请重新登录;请重新登录
 1005=没有该用户;消息发送失败
 1006=发送内容不能为空;消息发送失败
 1007=缺少必要参数;消息发送失败
 
 ************************
 10001 五位的是系统服务器这面的错误，相当于HTTP的 5开头的
 10001, "system exception"
 10002, "error_code not found"
 30000, "Interface does not exist/Request is not supported by the HTTP METHOD"
 30001, "Parameters calibration failure"
 30002, "No permission to access, signature verification failed"
 30003, "The HTTP request head parameters cannot be empty"
 3 开头的是系统默认对客户端的提示 也是相当于http4开头的
 sysMessage 这个是代码级别的提示错误给开发者看的，  clientMessage是给使用用户看的
 
 */
- (void)postUserId:(NSString *)userId withAlias:(NSString *)alias{
    
    NSString *deviceId = ApplicationDelegate.deviceToken;
    NSString *registrationId = [JPUSHService registrationID];
    
    NSString *urlstr = @"http://101.132.152.101/get-api/push/device/init?";
    NSString *args = [NSString stringWithFormat:@"userId=%@&deviceId=%@&pushRegistrationId=%@&alias=%@&typeExtra=2&isProduction=true",userId, deviceId, registrationId, alias];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlstr, args]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSLog(@"====dict===%@", dict);
        
        if (deviceId && registrationId) {
            _dic = @{@"deviceID": deviceId, @"registerID":registrationId, @"result":dict};
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:@"ID" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(IDVC) forControlEvents:UIControlEventTouchUpInside];
            
            button.frame = CGRectMake(self.view.bounds.size.width - 75, self.view.bounds.size.height - 60, 75, 60);
            [self.view addSubview:button];
            
        });
    }];

    [sessionDataTask resume];
}

- (void)IDVC{
    
    IDViewController *vc = [[IDViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:^{
        
        vc.dict = _dic;
    }];
}
@end
