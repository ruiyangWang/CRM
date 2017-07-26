//
//  YDSearchCarModelTVC.m
//  CRM
//
//  Created by YD_iOS on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDSearchCarModelTVC.h"
#import "YDChineseString.h"
#import "YDSearchCarModelCell.h"

#import "YDNetworkInterface.h"

#define isIOS9 ([[UIDevice currentDevice].systemVersion intValue]>=9?YES:NO)
#define isIOS10 ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)


@interface YDSearchCarModelTVC (){
    NSString *_seleString;//点击cell的title
    NSIndexPath *_index;//点击cell index
}

@property(nonatomic, copy)NSMutableDictionary *datas;
@property(nonatomic, copy)NSMutableArray *indexArray;
@property(nonatomic, copy)NSMutableArray *letterDatas;
@property(nonatomic, copy)NSMutableArray *showDatas;

@property (copy, nonatomic)NSMutableDictionary *listBrands;//品牌字典
@property (copy, nonatomic)NSMutableDictionary *listCars;//车系字典
@property (copy, nonatomic)NSMutableDictionary *listCarType;//车名数组


@property (nonatomic, strong) NSIndexPath *lastSelectIndexPath; //上一次选中的那一行
@property (nonatomic, copy) NSString *lastSelectSubTitle; //上一次选的是车型还是车系

@property (nonatomic, assign) NSInteger selectBrandIndex; //选择的品牌的下标
@property (nonatomic, copy) NSString *selectCar; //选择的车系的名字

@end

@implementation YDSearchCarModelTVC

#pragma mark ----- vc lift cycle 生命周期

- (void)viewWillAppear:(BOOL)animated
{
    [self changeNavigationBarBackgroundColor:kNavigationBackgroundColor];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    _datas = [NSMutableDictionary dictionary];
    _indexArray = [NSMutableArray array];
    _letterDatas = [NSMutableArray array];
    _listBrands = [NSMutableDictionary dictionary];
    _listCars = [NSMutableDictionary dictionary];
    _listCarType = [NSMutableDictionary dictionary];
    _selectBrandIndex = 0;
    
    [self findCarData:@{@"brandsId":@"",@"carsId":@"",@"type":_isALL?@"all":@"corp"}];
}

- (void)createView
{
    self.title = @"选择车型";
    UIView *navBGView = [self.navigationController.navigationBar viewWithTag:30000];
    [self.navigationController.navigationBar sendSubviewToBack:navBGView];
    
    [self.tableView registerNib(@"YDSearchCarModelCell")];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = kViewControllerBackgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- get and setter 属性的set和get方法
#pragma mark ----- event Response 事件响应(手势 通知)
#pragma mark ----- custom action for UI 界面处理有关
#pragma mark ----- custom action for DATA 数据处理有关
//查车
- (void)findCarData:(NSDictionary *)dic{
    
    NSString *url = [NSString stringWithFormat:@"%@sid=%@",kChooseBrands,getNSUser(@"youdao.CRM_SID")];
    
    WEAKSELF
    [self showHudInView:self.view hint:@""];
    
//    [[YDNetworkInterface shareInstance] queryCarInfoWithParameters:dic success:^(id result) {
//        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
//            
//            NSDictionary *varDic = [result objectForKey:@"var"];
//            
//            if ([[varDic objectForKey:@"listBrands"] count] > 0)
//            {
//                [weakSelf brandsListWithBrandsArray:[varDic objectForKey:@"listBrands"]];
//            }
//            else if ([[varDic objectForKey:@"listCars"] count] > 0)
//            {
//                [weakSelf carsListWithCarArray:[varDic objectForKey:@"listCars"]];
//            }
//            else if ([[varDic objectForKey:@"listCarType"] count] > 0)
//            {
//                [weakSelf carTypeListWithCarTypeArray:[varDic objectForKey:@"listCarType"]];
//            }
//            
//        }
//           // [self showHint:@"查询失败"];
//    } failure:^(id error) {
//        //[self hideHud];
//        //[self showHint:@"查询失败"];
//    } isCache:NO];
    
    [YDDataService startRequest:dic url:url block:^(id result) {
        [self hideHud];
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            
            NSDictionary *varDic = [result objectForKey:@"var"];
            
            if ([[varDic objectForKey:@"listBrands"] count] > 0)
            {
                [weakSelf brandsListWithBrandsArray:[varDic objectForKey:@"listBrands"]];
            }
            else if ([[varDic objectForKey:@"listCars"] count] > 0)
            {
                [weakSelf carsListWithCarArray:[varDic objectForKey:@"listCars"]];
            }
            else if ([[varDic objectForKey:@"listCarType"] count] > 0)
            {
                [weakSelf carTypeListWithCarTypeArray:[varDic objectForKey:@"listCarType"]];
            }
    
        }else
            [self showHint:@"查询失败"];
        
    } failBlock:^(id error) {
        [self hideHud];
        [self showHint:@"查询失败"];
    }];
}

#pragma mark 品牌列表数据处理
- (void)brandsListWithBrandsArray:(NSArray *)brandsArray
{
    for (NSDictionary *dic in brandsArray)
    {
        [_listBrands setObject:dic forKey:[dic objectForKey:@"brandsName"]];
        [_datas setObject:@[] forKey:[dic objectForKey:@"brandsName"]];
    }
    
    _indexArray = [YDChineseString indexArray:_datas.allKeys];
    _letterDatas = [YDChineseString letterSortArray:_datas.allKeys];
    
    _showDatas = [[NSMutableArray alloc] initWithArray:_letterDatas copyItems:YES];
    
    if (_showDatas.count == 1) {
        _seleString = [_showDatas.firstObject firstObject];
        [self brandsOrCarClickWithType:@"品牌"];
        return;
    }
    
    [self.tableView reloadData];
}
#pragma mark 车系列表数据处理
- (void)carsListWithCarArray:(NSArray *)carsArray
{
    NSMutableArray *carMA = [NSMutableArray array];
    for (NSDictionary *dic in carsArray)
    {
        [_listCars setObject:dic forKey:[dic objectForKey:@"carsName"]];
        [carMA addObject:[NSMutableDictionary dictionaryWithDictionary:@{[dic objectForKey:@"carsName"]:@[]}]];
    }
    
    [_datas setObject:carMA forKey:_seleString];
    
    [self tableView:self.tableView didSelectRowAtIndexPath:_index];
}

#pragma mark 车型列表数据处理
- (void)carTypeListWithCarTypeArray:(NSArray *)carTypeArray
{
    NSString *bName;
    
    NSMutableArray *carTypeMA = [NSMutableArray array ];
    for (NSDictionary *dic in carTypeArray)
    {
        bName = [dic objectForKey:@"brandsName"];
        [_listCarType setObject:dic forKey:[dic objectForKey:@"modelsName"]];
        
        [carTypeMA addObject:[dic objectForKey:@"modelsName"]];
    }
    
    NSMutableArray *ma  = [_datas objectForKey:bName];
    
    for (NSMutableDictionary *mDic in ma) {
        if ([mDic.allKeys[0] isEqualToString:_seleString]) {
            [mDic setObject:carTypeMA forKey:_seleString]; break;
        }
    }
    
    [self tableView:self.tableView didSelectRowAtIndexPath:_index];
}

#pragma mark 取cell数据
- (NSDictionary *)dicWithShowData:(NSIndexPath *)indexPath{
    
    if (indexPath.row > ([_showDatas[indexPath.section] count] - 1))
    {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    }
    
    NSDictionary *dic;
    id title = _showDatas[indexPath.section][indexPath.row];
    
    if ([title isKindOfClass:[NSString class]]) {
        dic = @{@"title":title,@"subTitle":_datas[title]?@"品牌":@"车型",@"subData":_datas[title]};
        
    }else{
        dic = @{@"title":[((NSDictionary *)title).allKeys firstObject],@"subTitle":@"车系",@"subData":[((NSDictionary *)title).allValues firstObject]};
    }
    return dic;
}

#pragma mark ----- xxxxxx delegate 各种delegate回调
#pragma mark - Table view data source

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_showDatas.count < 10) {
        return nil;
    }
    return _indexArray;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_showDatas.count < 10) {
        return nil;
    }
    return _indexArray[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_showDatas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YDSearchCarModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDSearchCarModelCell" forIndexPath:indexPath];
    
    NSDictionary *showDic = [self dicWithShowData:indexPath];
    cell.t = showDic[@"title"];
    cell.subT = showDic[@"subTitle"];
    cell.subDate = showDic[@"subData"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //设置阴影效果
    if ([_showDatas.firstObject count] > 1 || _showDatas.count > 1) {
        
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        NSDictionary *lastCellDic = [self dicWithShowData:lastIndexPath];
        
        BOOL b1 = [lastCellDic[@"subTitle"] isEqualToString:@"品牌"] && [showDic[@"subTitle"] isEqualToString:@"车系"];
        BOOL b2 = [lastCellDic[@"subTitle"] isEqualToString:@"车系"] && [showDic[@"subTitle"] isEqualToString:@"车型"];
        
        if (b1 | b2) {
            cell.isShowShadow = YES;
        } else {
            cell.isShowShadow = NO;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *showDic = [self dicWithShowData:indexPath];
    NSString *subTitle = showDic[@"subTitle"];
    if ([subTitle isEqualToString:@"车型"]) {
        return 45.0f;
    }
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cellDic = [self dicWithShowData:indexPath];
    
    //点击的cell右边的类型
    NSString *selectType = [cellDic objectForKey:@"subTitle"];
    
    //点击没有数据的，请求数据
    if (![cellDic[@"subTitle"] isEqualToString:@"车型"] && [[cellDic objectForKey:@"subData"] count] == 0) {
        //请求 再次进入这个方法
        _seleString = [cellDic objectForKey:@"title"];
        _index = indexPath;
        [self brandsOrCarClickWithType:selectType];
        return;
    }
    
    //点击有数据的
    if([selectType isEqualToString:@"车型"]){
        //点击车型，直接返回
        if (self.SearchCarRowBlack != nil) {
            NSDictionary *d = [_listCarType objectForKey:cellDic[@"title"]];
            NSString *bID = d[@"brandsId"];
            NSString *cID = d[@"carsId"];
            NSString *ctID = d[@"carTypeId"];
            NSString *selectName = [NSString stringWithFormat:@"%@ %@", _selectCar, cellDic[@"title"]];
            self.SearchCarRowBlack(bID, cID, ctID, selectName);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        //关闭某组
        if (indexPath.row != [_showDatas[indexPath.section] count]-1) {
            
            NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            NSDictionary *nextCellDic = [self dicWithShowData:nextIndexPath];
            
            BOOL b1 = [cellDic[@"subTitle"] isEqualToString:@"品牌"] && [nextCellDic[@"subTitle"] isEqualToString:@"车系"];
            BOOL b2 = [cellDic[@"subTitle"] isEqualToString:@"车系"] && [nextCellDic[@"subTitle"] isEqualToString:@"车型"];
            
            if (b1 | b2) {
                
                do {
                    NSLog(@"移除下一个数据后，判断是否存在下一个，然后判断subT是否相等");
                    
                    NSMutableArray *mArray = _showDatas[indexPath.section];
                    [mArray removeObjectAtIndex:indexPath.row+1];
                    if (indexPath.row == [_showDatas[indexPath.section] count]-1) {
                        break;
                    }
                    
                    nextCellDic = [self dicWithShowData:nextIndexPath];
                    
                } while (![cellDic[@"subTitle"] isEqualToString:nextCellDic[@"subTitle"]]);
                
                [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
                return;
            }
        }
        
        
        NSArray *subDataA = cellDic[@"subData"];
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:_showDatas[indexPath.section]];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(indexPath.row+1, subDataA.count)];
        
        //如果只有一个品牌，删掉品牌显示
        if (_listBrands.count == 1 && [mArray.firstObject isKindOfClass:[NSString class]]) {
            [mArray removeAllObjects];
            indexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(indexPath.row, subDataA.count)];
        }
        
        [mArray insertObjects:subDataA atIndexes:indexSet];
        
        [_showDatas insertObject:mArray atIndex:indexPath.section];
        [_showDatas removeObjectAtIndex:indexPath.section+1];
        
        //删除上一组
        if ([selectType isEqualToString:@"车系"])
        {
            //点击车系
            NSMutableArray *currentArray = _showDatas[indexPath.section];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:currentArray];
            
            for (NSInteger i = currentArray.count - 1; i > 0  ; i--)
            {
                BOOL isSave = (i > indexPath.row && i < indexPath.row + subDataA.count);
                
                if (isSave) {
                    continue;
                }
                
                id valueType = currentArray[i];
                
                if ([valueType isKindOfClass:[NSString class]]) {
                    [tempArray removeObject:valueType];
                }
            }
            _showDatas[indexPath.section] = tempArray;
            
            //记录选择的车系
            _selectCar = [cellDic valueForKey:@"title"];
        }
        else if ([selectType isEqualToString:@"品牌"])
        {
            //点击品牌
            for (NSInteger i = 0; i < _showDatas.count; i++) {
                NSMutableArray *brandArray = _showDatas[i];
                if (i == indexPath.section) continue;
                if (brandArray.count == 1) continue;
                if (![brandArray respondsToSelector:@selector(removeAllObjects)]) continue;
                NSString *brandString = brandArray[0];
                [brandArray removeAllObjects];
                [brandArray addObject:brandString];
            }
            
            if (indexPath) {
                [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _showDatas.count)] withRowAnimation:(UITableViewRowAnimationFade)];
            } else {
                [tableView reloadData];
            }
            return;
            
        }
        
        if (indexPath) {
            [tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
        } else {
            [tableView reloadData];
        }
        
    }
}

#pragma mark 点击车型或品牌
- (void)brandsOrCarClickWithType:(NSString *)type
{
    if ([type isEqualToString:@"品牌"]) {
        
        NSDictionary *d = [_listBrands objectForKey:_seleString];
        [self findCarData:@{@"brandsId":[d objectForKey:@"modelId"],@"carsId":@"",@"type":_isALL?@"all":@"corp"}];
        
    }else if ([type isEqualToString:@"车系"]){
        
        NSDictionary *d = [_listCars objectForKey:_seleString];
        [self findCarData:@{@"brandsId":[d objectForKey:@"brandsId"], @"carsId":[d objectForKey:@"modelId"], @"type":_isALL?@"all":@"corp"}];
    }
}

#pragma mark 关闭某组，会移除与点击的这行不相同的
- (void)closeGroupDataWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellDic = [self dicWithShowData:indexPath];
    
    if (indexPath.row != [_showDatas[indexPath.section] count]-1) {
        
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        NSDictionary *nextCellDic = [self dicWithShowData:nextIndexPath];
        
        BOOL b1 = [cellDic[@"subTitle"] isEqualToString:@"品牌"] && [nextCellDic[@"subTitle"] isEqualToString:@"车系"];
        BOOL b2 = [cellDic[@"subTitle"] isEqualToString:@"车系"] && [nextCellDic[@"subTitle"] isEqualToString:@"车型"];
        if (b1) return;
        
        if (b1 | b2) {
            
            do {
                NSLog(@"移除下一个数据后，判断是否存在下一个，然后判断subT是否相等");
                
                NSMutableArray *mArray = _showDatas[indexPath.section];
                [mArray removeObjectAtIndex:indexPath.row+1];
                if (indexPath.row == [_showDatas[indexPath.section] count]-1) {
                    break;
                }
                
                nextCellDic = [self dicWithShowData:nextIndexPath];
                
            } while (![cellDic[@"subTitle"] isEqualToString:nextCellDic[@"subTitle"]]);
            
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
        }
    }
}

#pragma mark - 动态修改状态栏跟顶部导航栏的颜色
-(void)changeNavigationBarBackgroundColor:(UIColor *)barBackgroundColor{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *subviews =self.navigationController.navigationBar.subviews;
        for (id viewObj in subviews) {
            if (isIOS10) {
                //iOS10,改变了状态栏的类为_UIBarBackground
                NSString *classStr = [NSString stringWithUTF8String:object_getClassName(viewObj)];
                if ([classStr isEqualToString:@"_UIBarBackground"]) {
                    UIImageView *imageView=(UIImageView *)viewObj;
                    imageView.hidden=YES;
                }
            }else{
                //iOS9以及iOS9之前使用的是_UINavigationBarBackground
                NSString *classStr = [NSString stringWithUTF8String:object_getClassName(viewObj)];
                if ([classStr isEqualToString:@"_UINavigationBarBackground"]) {
                    UIImageView *imageView=(UIImageView *)viewObj;
                    imageView.hidden=YES;
                }
            }
        }
        UIImageView *imageView = [self.navigationController.navigationBar viewWithTag:111];
        if (!imageView) {
            imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, 64)];
            imageView.tag = 111;
            [imageView setBackgroundColor:barBackgroundColor];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.navigationBar insertSubview:imageView atIndex:0];
            });
        }else{
            [imageView setBackgroundColor:barBackgroundColor];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.navigationBar sendSubviewToBack:imageView];
            });
            
        }
        
    }
}


@end
