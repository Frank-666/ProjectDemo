//
//  FDefultTool.h
//  ProjectFrameworkDemo
//
//  Created by 冯明珠 on 2019/7/16.
//  Copyright © 2019 Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDefultTool : NSObject
SINGLETON_FOR_HEADER(FDefultTool);
/*
 停止刷新--UITableView
 */
+(void)endRefreshMethodWithTableview:(UITableView *)tableview;
/*
 停止刷新--UICollectionView
 */
+(void)endRefreshMethodWithCollectionview:(UICollectionView *)CollectionView;
/*
 获取缓存文件的大小
 */
+(float)readCacheSize;
/*
 由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
 遍历文件夹获得文件夹大小，返回多少 M
 */
+( float )folderSizeAtPath:(NSString *) folderPath;
/*
 计算 单个文件的大小
 */
+( long long ) fileSizeAtPath:( NSString *) filePath;
/*
 清除缓存
 */
+ (void)clearFile;
/*
 提示框(清除缓存)
 */
+(void)showAlertClearFile:(NSString *)sender WithpresentController:(UIViewController *)controller;
/*
 提示框(退出登陆)
 */
+(void)showAlertOutLogin:(NSString *)sender WithpresentController:(UIViewController *)controller;
/*
 获取视频的第一帧图片
 */
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;
/*
 获取当前时间戳
 */
+(NSString *)GetNowTimes;
/*
 json转字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/*
 字典转json字符串
 */
+(NSString *)convertToJsonData:(NSDictionary *)dict;
/*
 获取网络图片的宽高
 */
+(CGSize)GetImageSizeWithURL:(NSString *)img;
/*
 数组排序
 */
+ (NSMutableArray *)arrayWithTimeSeq:(NSMutableArray*)inputData;
/*
 会话时间显示内容
 */
+(NSString *)ChatgetDateDisplayString:(long long) miliSeconds;
/*
 聊天列表时间显示内容
 */
+(NSString *)ListgetDateDisplayString:(long long) miliSeconds;
/*
 获取本地视频的缩略图
 */
+(UIImage *)getImage:(NSString *)videoURL;
/**
 * 判断字符串是否包含空格
 */
+ (BOOL) isBlank:(NSString *) str;
/**
 * 判断字符串是否都是空格
 */
+ (BOOL) isEmpty:(NSString *) str;
/**
 * tableView滑到最底部
 */
- (void)scrollToBottomWithData:(NSMutableArray *)dataArr WithTableView:(UITableView *)tableView;
/**
* 获取最上层的window
*/
- (UIWindow *)topWindow;
/**
* 跳转登录页
*/
- (void)ToLogin;
/**
* 跳转主页
*/
- (void)ToHome;
/**
* 弹框
*/
- (void)ShowAlert:(NSString *)title WithContent:(NSString *)content WithSure:(NSString *)sure WithNa:(UINavigationController *)na;
/**
* 获取当前周几
*/
- (NSString*)getCurrentWeekDay;
/**
* 根据用户身份获取默认头像
*/
- (NSString*)getCurrentDefultHeaderImage;
/**
* 根据用户身份获取拼接身份
*/
- (NSString*)getCurrentDefultIdentity;
/**
* 获取当前时间戳
*/
+(NSInteger )getNowTimeTimestamp;
/**
* 获取当前日期
*/
+(NSString*)getCurrentTimes;

/**
* 登录成功绑定别名（友盟）
*/
+(void)UMBuildAlias:(NSString *)userId WithType:(NSString *)usertype;
/**
* 登录成功添加标签（友盟）
*/
+(void)UMAddTag:(NSString *)tag;
/**
* 退出登录移除别名（友盟）
*/
+(void)UMRemoveAlias:(NSString *)userId WithType:(NSString *)usertype;
/**
* 退出登录移除标签（友盟）
*/
+(void)UMRemoveTag:(NSString *)tag;
/*
 检查用户是否允许通知
 */
- (BOOL)isUserNotificationEnable;
/*
 提示用户设置通知权限
 */
-(void)showAlertView:(UIViewController *)VC;
#pragma mark - 获取未读数量
-(NSInteger)GetMessageUnreadCount;
@end

NS_ASSUME_NONNULL_END
