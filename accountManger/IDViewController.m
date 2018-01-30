//
//  IDViewController.m
//  accountManger
//
//  Created by hanfeng on 2018/1/30.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import "IDViewController.h"

@interface IDViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_deviceID;
@property (weak, nonatomic) IBOutlet UITextField *tf_registerID;
@property (weak, nonatomic) IBOutlet UITextView *tv_result;

@end

@implementation IDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    if (dict) {
        self.tf_deviceID.text = [dict objectForKey:@"deviceID"];
        self.tf_registerID.text = [dict objectForKey:@"registerID"];
        
        NSDictionary *result = [dict objectForKey:@"result"];
        self.tv_result.text = [NSString stringWithFormat:@"%@", result];
    }
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
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
