//
//  CatchCrash.h
//  CRM
//
//  Created by ios on 2017/4/19.
//  Copyright © 2017年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatchCrash : NSObject

void uncaughtExceptionHandler(NSException *exception);
@end
