
//  本地目录管理类
//  Created by liyunfei on 16/6/13.
//  Copyright © 2016年 liyunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileClass : NSObject
@property (nonatomic,strong)NSFileManager *file;
@property (nonatomic,strong)NSArray  *fileNameArr;
@property (nonatomic,strong)NSArray  *fileNameArr1;
+(instancetype)sharedFileManger;
-(BOOL)fileCreate:(NSString *)fileName;
-(BOOL)fileCreateH5:(NSString *)fileName;
-(NSString *)getFile:(NSString *)fileName;
/*
 根目录下创建对应目录
 */
-(BOOL)fileCreate:(NSString *)fileName  childFileName:(NSString *)childFileName;
-(BOOL)fileCreateH5:(NSString *)fileName  childFileName:(NSString *)childFileName;
-(NSString *)getFileH5:(NSString *)fileName;
/*
 获取根目录下面的所有子目录返回数组
 */
-(NSArray *)getFileArr:(NSString *)fileName;
/*
 获取指定目录下面的所有子目录返回数组
 */
-(NSArray *)getFileArr:(NSString *)fileName childFileName:(NSString *)childFileName;
/*
 删除目录和文件,此操作只针对子目录起作用
 */
-(BOOL)delFile:(NSString *)fileName childFileName:(NSString *)childFileName;
-(BOOL)delFilePath:(NSString *)fileName childFileName:(NSString *)childFileName;
/*
 创建plist文件
 */
-(BOOL)fileCreateText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName contents:(NSDictionary *)data;
-(BOOL)fileCreateText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName arr:(NSArray *)data;
/*
 更新plist文件的键值对
 */
-(BOOL)fileUpdateText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName contents:(NSDictionary *)data;
-(BOOL)fileUpdateText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName arr:(NSArray *)data;
/*
 获取plist文件
 */
-(NSMutableDictionary *)getFileText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName;
-(NSString *)getFileText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName valueName:(NSString *)valueName;
/*
 删除plist文件
 */
-(BOOL)delFileText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName;
/*
 删除某一目录下的所有文件
 */
-(BOOL)delAllFileText:(NSString *)fileName textFileName:(NSString *)textFileName;
/*
 获取plist文件路径
 */
-(NSString *)getFileTextFile:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName;
/*
 创建二进制文件,包含图片和文档,声音，视频 返回路径
 */
-(BOOL)fileCreateData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName contents:(NSData *)data;
-(BOOL)fileCreateData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName url:(NSString *)url;
/*
 获取二进制文件,包含图片和文档,声音，视频,返回路径
 */
-(NSString *)getFileData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName;
-(NSData *)getData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName;
/*
 删除二进制文件,包含图片和文档，声音，视频
 */
-(BOOL)delFileData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName;
/*
 更新二进制文件,包含图片和文档，声音，视频 返回路径
 */
-(BOOL)fileUpdateData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName contents:(NSData *)data;
-(BOOL)fileUpdateData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName url:(NSString *)url;
/*
 获取某一目录下面的所有文件列表，用于收藏和本地文件选择
 */
-(NSArray *)getTextList:(NSString *)fileName dataFileName:(NSString *)dataFileName;
/*
 获取某一文件的属性用于前端判断是图片还是语音或者问文档
 */
-(NSDictionary *)getTextAttri:(NSString *)fileName dataFileName:(NSString *)dataFileName;
-(NSString *)getFile:(NSString *)fileName childFileName:(NSString *)childFileName;
-(BOOL)fileIsExistence:(NSString *)fileName childFileName:(NSString *)childFileName;
-(NSString *)getFileH5:(NSString *)fileName childFileName:(NSString *)childFileName;
@end
