//
//  YDImportCustModel.h
//  CRM
//
//  Created by ios on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDBaseModel.h"

@interface YDImportCustModel : YDBaseModel

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) BOOL isSelected;

@end
