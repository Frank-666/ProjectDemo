//
//  FDefultTool.m
//  ProjectFrameworkDemo
//
//  Created by 冯明珠 on 2019/7/16.
//  Copyright © 2019 Mountain. All rights reserved.
//

#import "FDefultTool.h"


@implementation FDefultTool
SINGLETON_FOR_CLASS(FDefultTool);
- (instancetype)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}
/*
 停止刷新--UITableView
 */
+(void)endRefreshMethodWithTableview:(UITableView *)tableview
{
    
    if ([tableview.mj_header isRefreshing]) {
        [tableview.mj_header endRefreshing];
    }
    if ([tableview.mj_footer isRefreshing]) {
        [tableview.mj_footer endRefreshing];
    }
}
/*
 停止刷新--UICollectionView
 */
+(void)endRefreshMethodWithCollectionview:(UICollectionView *)CollectionView
{
    
    if ([CollectionView.mj_header isRefreshing]) {
        [CollectionView.mj_header endRefreshing];
    }
    if ([CollectionView.mj_footer isRefreshing]) {
        [CollectionView.mj_footer endRefreshing];
    }
}
/*
 获取缓存文件的大小
 */
+(float)readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [FDefultTool folderSizeAtPath :cachePath];
}
/*
 由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
 遍历文件夹获得文件夹大小，返回多少 M
 */
+( float )folderSizeAtPath:(NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [FDefultTool fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0);
}
/*
 计算 单个文件的大小
 */
+( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}
/*
 清除缓存
 */
+ (void)clearFile
{
    [SVProgressHUD showWithStatus:@"正在清除...请稍等"];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    for ( NSString * p in files) {
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    [SVProgressHUD showSuccessWithStatus:@"已清除缓存"];
}
/*
 提示框
 */
+(void)showAlertClearFile:(NSString *)sender WithpresentController:(UIViewController *)controller
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"清理缓存" message:sender preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [FDefultTool clearFile];
    }];
    UIAlertAction *canel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:canel];
    [controller presentViewController:alert animated:YES completion:nil
     ];
}
/*
 提示框(退出登陆)
 */
+(void)showAlertOutLogin:(NSString *)sender WithpresentController:(UIViewController *)controller{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:sender preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
    }];
    UIAlertAction *canel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:canel];
    [controller presentViewController:alert animated:YES completion:nil
     ];
}

/*
 获取视频的第一帧图片
 */
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
/*
 获取当前时间戳
 */
+(NSString *)GetNowTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}
/*
 字典转json字符串
 */
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        XPLog(@"字典转json失败：%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *strUrl = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    //    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //    NSRange range = {0,jsonString.length};
    //    //去掉字符串中的空格
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    //    NSRange range2 = {0,mutStr.length};
    //    //去掉字符串中的换行符
    //    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return strUrl;
}
/*
 json转字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/*
 获取网络图片的宽高
 */
+(CGSize)GetImageSizeWithURL:(NSString *)img{
    NSURL* URL = nil;
    if([img isKindOfClass:[NSURL class]]){
        URL = [NSURL URLWithString:img];
    }if([img isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:img];
    }
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
    CGSize imageSize=CGSizeMake(image.size.width, image.size.height);
    return imageSize;
}
//会话时间显示内容
+(NSString *)ChatgetDateDisplayString:(long long) miliSeconds{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps  = [calendar components:unit fromDate:myDate];
    NSDateFormatter  *dateFmt = [[NSDateFormatter alloc ] init ];
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd hh:mm";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"aaa hh:mm";
            
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = @"昨天";
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"星期日";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"星期一";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"星期二";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"星期三";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"星期四";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"星期五";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"星期六";
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"MM-dd hh:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}
//聊天列表时间显示内容
+(NSString *)ListgetDateDisplayString:(long long) miliSeconds
{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *myCmps  = [calendar components:unit fromDate:myDate];
    NSDateFormatter  *dateFmt = [[NSDateFormatter alloc ] init];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy/MM/dd";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"aaa hh:mm";
            
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"昨天";
            
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                
                dateFmt.AMSymbol = @"上午";
                dateFmt.PMSymbol = @"下午";
                
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"星期日";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"星期一";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"星期二";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"星期三";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"星期四";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"星期五";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"星期六";
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"MM/dd";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}
/*
 获取本地视频的缩略图
 */
+(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}
/**
 * 判断字符串是否包含空格
 */
+(BOOL)isBlank:(NSString *)str{
    
    NSRange _range = [str rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        NSLog(@"有空格");
        return YES;
    }else {
        //没有空格
        NSLog(@"没有空格");
        return NO;
    }
}
/**
 * 判断字符串是否都是空格
 */
+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    }else{
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length]==0) {
            return true;
        }else{
            return false;
        }
    }
}
/**
 * tableView滑到最底部
 */
- (void)scrollToBottomWithData:(NSMutableArray *)dataArr WithTableView:(UITableView *)tableView
{
    NSInteger s = [tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO]; //滚动到最后一行
}
/** 将超文本格式化为富文本 */
-(NSMutableAttributedString *)htmlAttributeStringByHtmlString:(NSString *)htmlString{
    NSMutableAttributedString *attributeString;
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *importParams = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSError *error = nil;
    attributeString = [[NSMutableAttributedString alloc] initWithData:htmlData options:importParams documentAttributes:NULL error:&error];
    return attributeString;
}
/* 将富文本格式化为超文本 */
-(NSString *)htmlStringByHtmlAttributeString:(NSMutableAttributedString *)htmlAttributeString{
    NSString *htmlString;
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData =[htmlAttributeString dataFromRange:NSMakeRange(0, htmlAttributeString.length) documentAttributes:exportParams error:nil];
    htmlString = [[NSString alloc] initWithData:htmlData encoding: NSUTF8StringEncoding];
    return htmlString;
}
- (UIWindow *)topWindow
{
    UIWindow *topWindow = nil;
    NSArray <UIWindow *>*windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows.reverseObjectEnumerator) {
        if (window.hidden == YES || window.opaque == NO) {
            // 隐藏的 或者 透明的 跳过
            continue;
        }
        if (CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds) == NO) {
            // 不是全屏的 跳过
            continue;
        }
        topWindow = window;
        break;
    }
    return topWindow?:[UIApplication sharedApplication].delegate.window;
}
/**
* 跳转登录页
*/
- (void)ToLogin
{
    AppDelegate *application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [application pushToLoginVC];
}
/**
* 跳转主页
*/
- (void)ToHome
{
    AppDelegate *application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [application pushToMainVC];
}
/**
* 弹框
*/
- (void)ShowAlert:(NSString *)title WithContent:(NSString *)content WithSure:(NSString *)sure WithNa:(UINavigationController *)na
{
    
}
/**
* 获取当前周几
*/
- (NSString*)getCurrentWeekDay{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return [self getWeekDayFordate:interval];
}
- (NSString *)getWeekDayFordate:(NSTimeInterval)data {
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}
/**
* 根据用户身份获取默认头像
*/
- (NSString*)getCurrentDefultHeaderImage
{
    NSString *iconUrl;
    if ([[AcountItem getidentity] isEqualToString:@"管理员"]) {
        iconUrl=@"default avatar_manager";
    }else if ([[AcountItem getidentity] isEqualToString:@"教师"]){
        iconUrl=@"default avatar_teacher";
    }else if ([[AcountItem getidentity] isEqualToString:@"家长"]){
        iconUrl=@"default avatar_student";
    }else{
        iconUrl=@"default avatar";
    }
    return iconUrl;
}
/**
* 根据用户身份获取拼接身份
*/
- (NSString*)getCurrentDefultIdentity
{
    NSString *name;
    if ([[AcountItem getidentity] isEqualToString:@"管理员"]) {
        name=@"管理员";
    }else if ([[AcountItem getidentity] isEqualToString:@"教师"]){
        name=@"老师";
    }else if ([[AcountItem getidentity] isEqualToString:@"家长"]){
        name=@"家长";
    }else{
        name=@"家长";
    }
    return name;
}
/**
* 获取当前时间戳
*/
+(NSInteger )getNowTimeTimestamp{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSDate *zeroDate = [calendar dateFromComponents:components];
    return (long)[zeroDate timeIntervalSince1970];;
}
+(NSString*)getCurrentTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}
/**
* 登录成功绑定友盟别名
*/
+(void)UMBuildAlias:(NSString *)userId WithType:(NSString *)usertype
{
    [UMessage setAlias:userId type:usertype response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"---responseObject---%@", responseObject);
        NSLog(@"---error----%@", error);
    }];
}
/**
* 登录成功添加标签（友盟）
*/
+(void)UMAddTag:(NSString *)tag
{
    [UMessage addTags:tag response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
        NSLog(@"---responseObject---%@", responseObject);
        NSLog(@"---remain---%ld", remain);
        NSLog(@"---error----%@", error);
    }];
}
/**
* 退出登录移除友盟别名
*/
+(void)UMRemoveAlias:(NSString *)userId WithType:(NSString *)usertype
{
    [UMessage removeAlias:userId type:usertype response:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"---responseObject---%@", responseObject);
        NSLog(@"---error----%@", error);
    }];
}
/**
* 退出登录移除标签（友盟）
*/
+(void)UMRemoveTag:(NSString *)tag
{
    [UMessage deleteTags:tag response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
        NSLog(@"---responseObject---%@", responseObject);
        NSLog(@"---remain---%ld", remain);
        NSLog(@"---error----%@", error);
    }];
}
/*
 检查用户是否允许通知
 */
- (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    // iOS版本 >=8.0 处理逻辑
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    return isEnable;
}
/*
 提示用户设置通知权限
 */
-(void)showAlertView:(UIViewController *)VC
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"\n开启通知提醒\n能第一时间收到最新通知呦" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure=[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goToAppSystemSetting];
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:sure];
    alert.modalPresentationStyle = 0;
    [VC presentViewController:alert animated:YES completion:nil];
}
/*
 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
 */
- (void)goToAppSystemSetting
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}
#pragma mark - 获取未读数量
-(NSInteger)GetMessageUnreadCount
{
    NSInteger UnreadCount=0;
    NSArray* finfAlls = [MessageModel bg_findAll:[NSString stringWithFormat:@"%@%@",APPTabName,[AcountItem getuserId]]];
    if (finfAlls) {
        for (MessageModel *model in finfAlls) {
            UnreadCount=UnreadCount+model.UnRead;
        }
    }
    return UnreadCount;
}
@end
