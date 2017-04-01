
//  文件夹管理类及本地文件管理类
//  Created by liyunfei on 16/6/13.
//  Copyright © 2016年 liyunfei. All rights reserved.
/*
根目录一旦创建无法更改和删除，所有的操作均在根目录的下面进行
所有创建,获取文件时的目录格式为：  目录名/子目录/...子目录
*/
#import "FileClass.h"
#import "DBClass.h"
static FileClass *manager=nil;
@implementation FileClass
+(instancetype)sharedFileManger
{
    static dispatch_once_t oneTkoen;
    dispatch_once(&oneTkoen, ^{
        if (manager==nil) {
            manager=[[FileClass alloc]init];
        }
       
    });
     return manager;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        _file=[NSFileManager defaultManager];
    }
    return  self;
}
#pragma mark-目录管理
/*
 配置app需要的所有目录
 */
-(BOOL)fileCreate:(NSString *)fileName
{
    if (![self fileIsExistence:fileName]) {
        //创建原生app文件夹
        NSUserDefaults *users=[NSUserDefaults standardUserDefaults];
        [users setValue:fileName forKey:@"UserIdentify"];
        [users synchronize];
         NSString *directryPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat: @"/Library/%@/",fileName]];
        [_file createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        _fileNameArr=[NSArray arrayWithObjects:@"msgdb",@"pic",@"video",@"audio",@"doc",@"plist",nil];
        _fileNameArr1=[NSArray arrayWithObjects:@"img",@"barcode",@"icon",nil];
        //[self fileCreate:fileName];
        for (int i=0; i<_fileNameArr.count; i++) {
            [self fileCreate:fileName childFileName:_fileNameArr[i]];
        }
        for (int i=0; i<_fileNameArr1.count;i++) {
            [self fileCreate:fileName childFileName:[NSString stringWithFormat:@"pic/%@",_fileNameArr1[i]]];
        }
         NSLog(@"%@",[self getFile:fileName]);
        return YES;
        
    }
    else
    {
        NSLog(@"%@",[self getFile:fileName]);
        return YES;
    }
    return NO;
}
//创建h5根目录
-(BOOL)fileCreateH5:(NSString *)fileName
{
    if (![self fileIsExistenceH5:fileName]) {
        //创建H5根目录文件夹
        NSString *directryPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat: @"/Library/Pandora/apps/BossLine/%@/",fileName]];
        [_file createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        return YES;
        
    }
    else
    {
        return YES;
    }
    return NO;
}
/*
 判断h5根目录是否存在,不存在就创建
 */
-(BOOL)fileIsExistenceH5:(NSString *)fileName
{
    BOOL isDIr;
    if ([_file fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat: @"/Library/Pandora/apps/BossLine/%@/",fileName]] isDirectory:&isDIr]) {
        if (isDIr) {
            return YES;
        }
        else
        {
            return  [self fileCreateH5:fileName];
        }
    }
    return NO;
}
/*
 判断根目录是否存在,不存在就创建
 */
-(BOOL)fileIsExistence:(NSString *)fileName
{
    BOOL isDIr;
    if ([_file fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat: @"/Library/%@/",fileName]] isDirectory:&isDIr]) {
        if (isDIr) {
            return YES;
        }
        else
        {
           return  [self fileCreate:fileName];
        }
    }
    return NO;
}
/*
 H5根目录下创建对应目录
 */
-(BOOL)fileCreateH5:(NSString *)fileName  childFileName:(NSString *)childFileName
{
    NSString *directryPath = [self getFileH5:fileName];
    
    //创建子目录
    NSString *childPath=[directryPath stringByAppendingString:[NSString stringWithFormat: @"%@/",childFileName]];
    if (![self fileIsExistenceH5:childPath]) {
        [_file createDirectoryAtPath:childPath withIntermediateDirectories:YES attributes:nil error:nil];
        return YES;
    }
    return NO;
}
/*
 根目录下创建对应目录
 */
-(BOOL)fileCreate:(NSString *)fileName  childFileName:(NSString *)childFileName
{
    NSString *directryPath = [self getFile:fileName];
    
    //创建子目录
    NSString *childPath=[directryPath stringByAppendingString:[NSString stringWithFormat: @"%@/",childFileName]];
    if (![self fileIsExistence:childPath]) {
        [_file createDirectoryAtPath:childPath withIntermediateDirectories:YES attributes:nil error:nil];
        return YES;
    }
    return NO;
}
/*
 判断根目录下面的某一目录是否存在
 */
-(BOOL)fileIsExistence:(NSString *)fileName childFileName:(NSString *)childFileName
{
    BOOL isDIr;
    if ([_file fileExistsAtPath:[[self getFile:fileName] stringByAppendingString:[NSString stringWithFormat: @"%@/",childFileName]] isDirectory:&isDIr]) {
        if (isDIr) {
            return YES;
        }
        
    }
    else
    {
        return  [self fileCreate:fileName childFileName:childFileName];
    }
    return NO;
}
/*
 判断H5根目录下面的某一目录是否存在
 */
-(BOOL)fileIsExistenceH5:(NSString *)fileName childFileName:(NSString *)childFileName
{
    BOOL isDIr;
    if ([_file fileExistsAtPath:[[self getFileH5:fileName] stringByAppendingString:[NSString stringWithFormat: @"%@/",childFileName]] isDirectory:&isDIr]) {
        if (isDIr) {
            return YES;
        }
        
    }
    else
    {
        return  [self fileCreateH5:fileName childFileName:childFileName];
    }
    return NO;
}
/*
 获取H5根目录下面的所有子目录返回数组
 */
-(NSArray *)getFileArr:(NSString *)fileName
{
    if ([self fileIsExistenceH5:fileName]) {
        NSString *directryPath =[self getFileH5:fileName];
        NSArray *arr=[_file subpathsOfDirectoryAtPath:directryPath error:nil];
        NSLog(@"%@",arr);
        return arr;
    }
    return 0;
}
/*
 获取H5指定目录下面的所有子目录返回数组
 */
-(NSArray *)getFileArr:(NSString *)fileName childFileName:(NSString *)childFileName
{
    if ([self fileIsExistenceH5:fileName childFileName:childFileName]) {
        NSString *directryPath =[[self getFileH5:fileName]stringByAppendingString:[NSString stringWithFormat:@"%@/",childFileName]];
        NSArray *arr=[_file subpathsOfDirectoryAtPath:directryPath error:nil];
         NSLog(@"%@",arr);
        return arr;
    }
    return 0;
}
/*
 删除目录和文件,此操作只针对子目录起作用
 */
-(BOOL)delFile:(NSString *)fileName childFileName:(NSString *)childFileName
{
    if ([self fileIsExistenceH5:fileName]) {
        NSString *directryPath = [[self getFileH5:fileName] stringByAppendingString:[NSString stringWithFormat: @"%@/",childFileName]];
        [_file removeItemAtPath:directryPath error:nil];
        return YES;
    }
    return NO;
}
/*
 删除目录和文件,此操作只针对子目录起作用
 */
-(BOOL)delFilePath:(NSString *)fileName childFileName:(NSString *)childFileName
{
    if ([self fileIsExistence:fileName]) {
        NSString *directryPath = [[self getFile:fileName] stringByAppendingString:[NSString stringWithFormat: @"%@/",childFileName]];
        [_file removeItemAtPath:directryPath error:nil];
        return YES;
    }
    return NO;
}
/*
 获取根目录路径
 */
-(NSString *)getFile:(NSString *)fileName
{
    if ([self fileIsExistence:fileName]) {
        NSString *rootFile=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat: @"/Library/%@/",fileName]];
        return rootFile;
    }
    return 0;
}
/*
 获取H5根目录路径
 */
-(NSString *)getFileH5:(NSString *)fileName
{
    if ([self fileIsExistenceH5:fileName]) {
        NSString *rootFile=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat: @"/Library/Pandora/apps/BossLine/%@/",fileName]];
        return rootFile;
    }
    return 0;
}
/*
 获取某一指定目录的目录名
 */
-(NSString *)getFile:(NSString *)fileName childFileName:(NSString *)childFileName
{
    if ([self fileIsExistence:fileName childFileName:childFileName]) {
        NSString *childFile=[[self getFile:fileName] stringByAppendingString:[NSString stringWithFormat: @"%@/",childFileName]];
        return childFile;
    }
    return 0;
}
/*
 获取H5某一指定目录的目录名
 */
-(NSString *)getFileH5:(NSString *)fileName childFileName:(NSString *)childFileName
{
    if ([self fileIsExistenceH5:fileName childFileName:childFileName]) {
        NSString *childFile=[[self getFileH5:fileName] stringByAppendingString:[NSString stringWithFormat: @"%@/",childFileName]];
        return childFile;
        
    }
    return 0;
}
#pragma mark-plist文件
/*
 根据文件名判断plist文件是否存在
 */
-(BOOL)textIsExistence:(NSString*)fileName textFileName:(NSString *)textFileName textName:(NSString*)textName
{
  
        if ([_file fileExistsAtPath:[[self getFile:fileName childFileName:textFileName] stringByAppendingString:[NSString stringWithFormat: @"%@",textName]]])
        {
            return YES;
        }
    return NO;
}

/*
 创建plist文件
 */
-(BOOL)fileCreateText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName contents:(NSDictionary *)data
{
    if (![self textIsExistence:fileName textFileName:textFileName textName:textName])
    {
        NSString *path=[[self getFile:fileName childFileName:textFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]];
        [data writeToFile:path atomically:YES];
        NSLog(@"%@",path);
        return  YES;
    }
    else
    {
        return  [self fileUpdateText:fileName textFileName:textFileName textName:textName contents:data];
    }
    return NO;
}
/*
 创建plist1文件
 */
-(BOOL)fileCreateText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName arr:(NSArray *)data
{
    if (![self textIsExistence:fileName textFileName:textFileName textName:textName])
    {
        NSString *path=[[self getFile:fileName childFileName:textFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]];
        [data writeToFile:path atomically:YES];
         NSLog(@"%@",path);
         return  YES;
    }
    else
    {
        return  [self fileUpdateText:fileName textFileName:textFileName textName:textName arr:data];
    }
    return NO;
}
/*
 更新plist1文件的键值对
 */
-(BOOL)fileUpdateText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName arr:(NSArray *)data
{
    if ([self textIsExistence:fileName textFileName:textFileName textName:textName])
    {

        [self delFileText:fileName textFileName:textFileName textName:textName];
        [data writeToFile:[[self getFile:fileName childFileName:textFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]] atomically:YES];
        return  YES;
    }
    
    return NO;
}
/*
 更新plist文件的键值对
 */
-(BOOL)fileUpdateText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName contents:(NSDictionary *)data
{
    if ([self textIsExistence:fileName textFileName:textFileName textName:textName])
    {
        //读取文件遍历文件
        NSMutableDictionary *dict=[self getFileText:fileName textFileName:textFileName textName:textName];
        NSDictionary *dicdata=[NSDictionary dictionaryWithDictionary:data];
        NSArray *keyArr=[dict allKeys];
        NSArray *datakeyarr=[dicdata allKeys];
        for (int i=0; i<keyArr.count; i++) {
            for (int j=0; j<datakeyarr.count; j++) {
                if ([keyArr[i] isEqualToString:datakeyarr[j]])
                {
                    dict[keyArr[i]]=dicdata[datakeyarr[j]];
                }
            }
        }
        [self delFileText:fileName textFileName:textFileName textName:textName];
        [dict writeToFile:[[self getFile:fileName childFileName:textFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]] atomically:YES];
        return  YES;
    }
    
    return NO;
}
/*
 获取plist文件
 */
-(NSMutableDictionary *)getFileText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName
{
    if ([self textIsExistence:fileName textFileName:textFileName textName:textName]) {
         NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:[self getFileTextFile:fileName textFileName:textFileName textName:textName]];
         return  dict;
    }
    return 0;
}
-(NSString *)getFileText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName valueName:(NSString *)valueName
    {
    
        if ([self textIsExistence:fileName textFileName:textFileName textName:textName]) {
            NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:[self getFileTextFile:fileName textFileName:textFileName textName:textName]];
            return  [NSString stringWithFormat:@"%@",dict[valueName]];
        }
        return 0;
    }
/*
 删除plist文件
 */
-(BOOL)delFileText:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName
{
    if ([self textIsExistence:fileName textFileName:textFileName textName:textName]) {
        NSString *directryPath = [[self getFile:fileName childFileName:textFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]];
        [_file removeItemAtPath:directryPath error:nil];
        return YES;
    }
    return NO;
}
-(BOOL)delAllFileText:(NSString *)fileName textFileName:(NSString *)textFileName
{
    if ([self fileIsExistence:fileName childFileName:textFileName]) {
        NSString *directryPath =[self getFile:fileName childFileName:textFileName];
        [_file removeItemAtPath:directryPath error:nil];
        return YES;
    }
    return NO;
}
/*
 获取plist文件路径
 */
-(NSString *)getFileTextFile:(NSString *)fileName textFileName:(NSString *)textFileName textName:(NSString *)textName
{
    
    
    if ([self textIsExistence:fileName textFileName:textFileName textName:textName]) {
        
        NSString *directryPath = [[self getFile:fileName childFileName:textFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]];
        
        return  directryPath;
    }
    
    return 0;
}

#pragma mark--数据文件
/*
 根据文件名判断数据文件是否存在
 */
-(BOOL)dataIsExistence:(NSString*)fileName dataFileName:(NSString *)dataFileName textName:(NSString*)textName
{
    
    if ([_file fileExistsAtPath:[[self getFile:fileName childFileName:dataFileName] stringByAppendingString:[NSString stringWithFormat: @"%@",textName]]]) {
        
        
        return YES;
    }
    
    return NO;
}
/*
 创建二进制文件,包含图片和文档,根据二进制数据
 */
-(BOOL)fileCreateData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName contents:(NSData *)data
{
    if (![self dataIsExistence:fileName dataFileName:dataFileName textName:textName])
    {
        [data writeToFile:[[self getFile:fileName childFileName:dataFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]] atomically:YES];
        return  YES;
    }
    else
    {
        return [self fileUpdateData:fileName dataFileName:dataFileName textName:textName contents:data];
    }
    return NO;
}

//根据网络路径生成文件,更新来自网络的文件同样适用
-(BOOL)fileCreateData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName url:(NSString *)url
{
    if (![self dataIsExistence:fileName dataFileName:dataFileName textName:textName])
    {
        NSURL *neturl=[NSURL URLWithString:url];
        NSData *data=[NSData dataWithContentsOfURL:neturl];
        return  [self fileCreateData:fileName dataFileName:dataFileName textName:textName contents:data];
    }
    else
    {   NSURL *neturl=[NSURL URLWithString:url];
        NSData *data=[NSData dataWithContentsOfURL:neturl];
        return [self fileUpdateData:fileName dataFileName:dataFileName textName:textName contents:data];
    }
    return NO;
}
//更新二进制文件
-(BOOL)fileUpdateData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName contents:(NSData *)data
{
    if (![self dataIsExistence:fileName dataFileName:dataFileName textName:textName])
    {
        [data writeToFile:[[self getFile:fileName childFileName:dataFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]] atomically:YES];
        return  YES;
    }
    else
    {
        if ([self delFileData:fileName dataFileName:dataFileName textName:textName]) {
            
            [data writeToFile:[[self getFile:fileName childFileName:dataFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]] atomically:YES];
            return  YES;
        }
    }
    return NO;
}
-(BOOL)fileUpdateData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName url:(NSString *)url
{
    if (![self dataIsExistence:fileName dataFileName:dataFileName textName:textName])
    {
        NSURL *neturl=[NSURL URLWithString:url];
        NSData *data=[NSData dataWithContentsOfURL:neturl];
        return [self fileUpdateData:fileName dataFileName:dataFileName textName:textName contents:data];
    }
    return YES;
}
/*
 获取二进制文件，返回路径
 */
-(NSString *)getFileData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName
{
    
    
    if ([self dataIsExistence:fileName dataFileName:dataFileName textName:textName]) {
        
        
        NSString *newstr=[[NSString stringWithFormat:@"%@/",dataFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]];
        return  newstr;
    }
    
    return 0;
}
/*
 获取二进制文件，返回数据
 */
-(NSData *)getData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName
{
    
    
    if ([self dataIsExistence:fileName dataFileName:dataFileName textName:textName]) {
        NSData *data=[NSData dataWithContentsOfFile:[self getFileData:fileName dataFileName:dataFileName textName:textName]];
        return  data;
    }
    
    return 0;
}
/*
 删除二进制文件
 */
-(BOOL)delFileData:(NSString *)fileName dataFileName:(NSString *)dataFileName textName:(NSString *)textName
{
    if ([self dataIsExistence:fileName dataFileName:dataFileName textName:textName]) {
        NSString *directryPath = [[self getFile:fileName childFileName:dataFileName] stringByAppendingString:[NSString  stringWithFormat:@"%@",textName]];
        [_file removeItemAtPath:directryPath error:nil];
        return YES;
    }
    return NO;
}
/*
获取某一目录下面的所有文件列表，用于收藏和本地文件选择
 */
-(NSArray *)getTextList:(NSString *)fileName dataFileName:(NSString *)dataFileName
{
    if ([self fileIsExistenceH5:fileName childFileName:dataFileName])
    {
        NSError *error;
        NSArray *listArr=[_file contentsOfDirectoryAtPath:[self getFile:fileName childFileName:dataFileName] error:&error];
        NSLog(@"%@",listArr);
        return listArr;
    }
    return 0;
}
/*
 获取某一文件的属性，用于收藏和本地文件选择
 */
-(NSDictionary *)getTextAttri:(NSString *)fileName dataFileName:(NSString *)dataFileName
{
   
        NSError *error;
        NSDictionary *textAttri=[_file attributesOfItemAtPath:[[self getFile:fileName] stringByAppendingString:dataFileName]  error:&error];
        NSLog(@"%@",textAttri);
        return textAttri;
    

}
@end
