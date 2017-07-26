//
//  YDFMDB.m
//  CRM
//
//  Created by ios on 16/9/29.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDFMDB.h"
#import "FMDB.h"

#define SQLITE_NAME @"YDSqlite.sqlite"

@interface YDFMDB()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

static YDFMDB* YDFmdb;

#warning 键值只能传NSString
@implementation YDFMDB

-(instancetype)init{
    self = [super init];
    if (self) {
        // 0.获得沙盒中的数据库文件名
    
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:SQLITE_NAME];
        // 1.创建数据库队列
        self.queue = [FMDatabaseQueue databaseQueueWithPath:filename];
        NSLog(@"数据库初始化-----");
    }
    return self;
}

/**
 获取单例函数
 */
+(instancetype)intance{
    if(YDFmdb == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            YDFmdb = [[YDFMDB alloc] init];
        });
    }
    return YDFmdb;
}

/**
 数据库中是否存在表
 */
- (BOOL)isExistWithTableName:(NSString*)name{
    if (name==nil){
        NSLog(@"表名不能为空!");
        return NO;
    }
    __block BOOL result;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:name];
    }];
    return result;
}

/**
 默认建立主键id
 创建表(如果存在久不创建) keys 数据存放要求@[字段名称1,字段名称2]
 */
-(BOOL)createTableWithTableName:(NSString*)name keys:(NSArray*)keys{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return NO;
    }else if (keys == nil){
        NSLog(@"字段数组不能为空!");
        return NO;
    }else;
    
    __block BOOL result;
    //创表
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString* header = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer primary key autoincrement",name];//,name text,age integer);
        NSMutableString* sql = [[NSMutableString alloc] init];
        [sql appendString:header];
        for(int i=0;i<keys.count;i++){
            [sql appendFormat:@",%@ text",keys[i]];
            if (i == (keys.count-1)) {
                [sql appendString:@");"];
            }
        }
        result = [db executeUpdate:sql];
    }];
    return result;
}
/**
 插入值
 */
-(BOOL)insertIntoTableName:(NSString*)name Dict:(NSDictionary*)dict{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return NO;
    }else if (dict == nil){
        NSLog(@"插入值字典不能为空!");
        return NO;
    }else;
    
    __block BOOL result;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSArray* keys = dict.allKeys;
        NSArray* values = dict.allValues;
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendFormat:@"INSERT INTO %@(",name];
        for(int i=0;i<keys.count;i++){
            [SQL appendFormat:@"%@",keys[i]];
            if(i == (keys.count-1)){
                [SQL appendString:@") "];
            }else{
                [SQL appendString:@","];
            }
        }
        [SQL appendString:@"values("];
        for(int i=0;i<values.count;i++){
            [SQL appendString:@"?"];
            if(i == (keys.count-1)){
                [SQL appendString:@");"];
            }else{
                [SQL appendString:@","];
            }
        }
        //@"INSERT INTO tableName(name,tag,age,six)VALUES(?,?,?,?);"
        result = [db executeUpdate:SQL withArgumentsInArray:values];
        //NSLog(@"插入 -- %d",result);
    }];
    return result;
}
/**
 根据条件查询字段
 */
-(NSArray*)queryWithTableName:(NSString*)name keys:(NSArray*)keys where:(NSArray*)where;{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return nil;
    }else if (keys == nil){
        NSLog(@"字段数组不能为空!");
        return nil;
    }else;
    
    __block NSMutableArray* arrM = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendString:@"SELECT "];
        for(int i=0;i<keys.count;i++){
            [SQL appendFormat:@"%@",keys[i]];
            if (i != (keys.count-1)) {
                [SQL appendString:@","];
            }
        }
        [SQL appendFormat:@" FROM %@ WHERE ",name];
        if ((where!=nil) && (where.count>0)){
            if(!(where.count%3)){
                for(int i=0;i<where.count;i+=3){
                    [SQL appendFormat:@"%@%@'%@'",where[i],where[i+1],where[i+2]];
                    if (i != (where.count-3)) {
                        [SQL appendString:@" and "];
                    }
                }
            }else{
                NSLog(@"条件数组错误!");
            }
        }
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:SQL];
        // 2.遍历结果集
        while (rs.next) {
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
            for(int i=0;i<keys.count;i++){
                dictM[keys[i]] = [rs stringForColumn:keys[i]];
            }
            [arrM addObject:dictM];
        }
    }];
    //NSLog(@"查询 -- %@",arrM);
    return arrM;
}

/**
 全部查询
 */
-(NSArray*)queryWithTableName:(NSString*)name{
    if (name==nil){
        NSLog(@"表名不能为空!");
        return nil;
    }
    
    __block NSMutableArray* arrM = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString* SQL = [NSString stringWithFormat:@"SELECT * FROM %@",name];
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:SQL];
        // 2.遍历结果集
        while (rs.next) {
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
            for (int i=0;i<[[[rs columnNameToIndexMap] allKeys] count];i++) {
                dictM[[rs columnNameForIndex:i]] = [rs stringForColumnIndex:i];
            }
            [arrM addObject:dictM];
        }
    }];
    //NSLog(@"查询 -- %@",arrM);
    return arrM;
    
}

/**
 根据key更新value
 */
-(BOOL)updateWithTableName:(NSString*)name valueDict:(NSDictionary*)valueDict where:(NSArray*)where{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return NO;
    }else if (valueDict == nil){
        NSLog(@"更新值数组不能为空!");
        return NO;
    }else;
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendFormat:@"UPDATE %@ SET ",name];
        for(int i=0;i<valueDict.allKeys.count;i++){
            [SQL appendFormat:@"%@='%@'",valueDict.allKeys[i],valueDict[valueDict.allKeys[i]]];
            if (i == (valueDict.allKeys.count-1)) {
                [SQL appendString:@" "];
            }else{
                [SQL appendString:@","];
            }
        }
        if ((where!=nil) && (where.count>0)){
            if(!(where.count%3)){
                [SQL appendString:@"WHERE "];
                for(int i=0;i<where.count;i+=3){
                    [SQL appendFormat:@"%@%@'%@'",where[i],where[i+1],where[i+2]];
                    if (i != (where.count-3)) {
                        [SQL appendString:@" and "];
                    }
                }
            }else{
                NSLog(@"条件数组错误!");
            }
        }
        result = [db executeUpdate:SQL];
        //NSLog(@"更新:  %@",SQL);
    }];
    return result;
}

/**
 删除
 */
-(BOOL)deleteWithTableName:(NSString*)name where:(NSArray*)where{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return NO;
    }else if (where==nil || (where.count%3)){
        NSLog(@"条件数组错误!");
        return NO;
    }else;
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendFormat:@"DELETE FROM %@ WHERE ",name];
        for(int i=0;i<where.count;i+=3){
            [SQL appendFormat:@"%@%@'%@'",where[i],where[i+1],where[i+2]];
            if (i != (where.count-3)) {
                [SQL appendString:@" and "];
            }
        }
        result = [db executeUpdate:SQL];
    }];
    return result;
}
/**
 根据表名删除表格全部内容
 */
-(BOOL)clearTable:(NSString *)name{
    if (name==nil){
        NSLog(@"表名不能为空!");
        return NO;
    }
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString* SQL = [NSString stringWithFormat:@"DELETE FROM %@;",name];
        result = [db executeUpdate:SQL];
    }];
    return result;
}

/**
 删除表
 */
-(BOOL)dropTable:(NSString*)name{
    if (name==nil){
        NSLog(@"表名不能为空!");
        return NO;
    }
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString* SQL = [NSString stringWithFormat:@"DROP TABLE %@;",name];
        result = [db executeUpdate:SQL];
    }];
    return result;
}

@end
