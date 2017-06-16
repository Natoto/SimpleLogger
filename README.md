
### 一个简易的日志系统
>
>1. 按照日期创建日志
>2. 分等级存放日志，debug，info，warning，error
>3. 自动删除七天后的日志
>4. 操作高效简单

用法

```

    logDebug(@"logdebug hello world");
    
    logInfo(@"log info hello world");
    
    logWarn(@"log hello world");
```



#### 根据创建日期删除七天前的日志


```


- (void)cleanLogFiles
{
    NSFileManager *fileManager    = [NSFileManager defaultManager];
    NSString      *finalLogFolder = [self calculateLogFolder];
    NSError       *error;
    NSArray       *logFiles       = [fileManager contentsOfDirectoryAtPath:finalLogFolder error:&error];
    
    if (logFiles == nil)
    {
        NSLog(@"failed to get log files array:%@", error);
    
        return;
    }
#ifdef DEBUG
    NSDate* date =[[NSDate date] dateByAddingTimeInterval:-7*24*60*60];
#else
    NSDate* date =[[NSDate date] dateByAddingTimeInterval:-2*24*60*60];
#endif
    
    for (NSString *logFile in logFiles)
    {
        NSString     *logFilePath = [finalLogFolder stringByAppendingPathComponent:logFile];
        NSDictionary *fileAttr    = [fileManager attributesOfItemAtPath:logFilePath error:&error];
        
        if (fileAttr)
        {
            NSDate *creationDate = [fileAttr valueForKey:NSFileCreationDate];
            
            if ([creationDate compare:date] == NSOrderedAscending)
            {
                NSLog(@"%@ will be deleted", logFile);
                [fileManager removeItemAtPath:logFilePath error:&error];
                NSLog(@"%@ was deleted, error number is %ld", logFilePath, (long)error.code);
            }
        }
    }
}


```


#### 根据文件名删除七天前日志
```

/**  * 根据文件名删除七天前的日志  
 *  假设文件名格式是：hb_20160606.log  */
-(void)remove7dayAgoLogfile{
    
    @try {
        NSFileManager *fileManager    = [NSFileManager defaultManager];
        NSString      *finalLogFolder = [self.currentLogFilePath stringByDeletingLastPathComponent];
        NSError       *error;
        NSArray       *logFiles       = [fileManager contentsOfDirectoryAtPath:finalLogFolder error:&error];
        
        if (logFiles == nil)
        {
            NSLog(@"failed to get log files array:%@", error);
            
            return;
        }
#ifdef DEBUG
        NSDate* date =[[NSDate date] dateByAddingTimeInterval:-7*24*60*60];
#else
        NSDate* date =[[NSDate date] dateByAddingTimeInterval:-2*24*60*60];
#endif
        
        for (NSString *logFile in logFiles)
        {
            NSString     *logFilePath = [finalLogFolder stringByAppendingPathComponent:logFile];
            NSDictionary *fileAttr    = [fileManager attributesOfItemAtPath:logFilePath error:&error];
            
            if (fileAttr)
            {
                NSString * filename = logFile.lastPathComponent;
                NSString * filedatestring = [filename.stringByDeletingPathExtension componentsSeparatedByString:@"_"].lastObject;
                if (!filedatestring) {
                    continue;
                }
                // 1.创建一个时间格式化对象
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 2.格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
                formatter.dateFormat = @"yyyyMMdd";
                // 3.利用时间格式化对象让字符串转换成时间 (自动转换0时区/东加西减)
                NSDate *filedate = [formatter dateFromString:filedatestring];
                
                //            NSDate *creationDate = [fileAttr valueForKey:NSFileCreationDate];
                
                if ([filedate compare:date] == NSOrderedAscending)
                {
                    NSLog(@"%@ will be deleted", logFile);
                    [fileManager removeItemAtPath:logFilePath error:&error];
                    NSLog(@"%@ was deleted, error number is %ld", logFilePath, (long)error.code);
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"删除过期日志失败");
    } @finally {
        
    }
  
}

```