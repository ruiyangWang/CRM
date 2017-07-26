//
//  YDRequestManaget.m
//  CRM
//
//  Created by ios on 2016/12/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDRequestManaget.h"

@implementation YDRequestManaget


#pragma mark   获取逾期未跟进客户列表
- (void)getOverdueCustomerSuccessBlock:(SuccessBlock)result failedBlock:(FailedBlock)error
{
    NSString *url = [NSString stringWithFormat:@"%@type=overdue&sid=%@",kCrmListFollow,getNSUser(@"youdao.CRM_SID")];
    
    [YDDataService startRequest:@{} url:url block:^(id success) {
       
        NSString *state = [success valueForKey:@"code"];
        
        if ([state isEqualToString:@"S_OK"]) {
            
            if (result) {
                result(success);
            }
           
        }else{
            if (error) {
                error(result);
            }
        }
    } failBlock:^(id fail) {
        if (error) {
            error(fail);
        }
    }];
}






@end
