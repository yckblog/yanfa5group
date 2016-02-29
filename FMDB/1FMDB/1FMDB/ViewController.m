//
//  ViewController.m
//  1FMDB
//
//  Created by lanou3g on 16/1/7.
//  Copyright © 2016年 caijin. All rights reserved.
//

#import "ViewController.h"
#import <FMDatabase.h>

@interface ViewController ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)create:(id)sender
{
    // 获取数据库文件路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"Test3.db"];
    
    //    NSLog(@"dbPath:   %@", dbPath);
    
    // 获取数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    // 打开数据库
    if ([db open])
    {
        // 创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
        if (result)
        {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创表失败");
        }
    }
    self.db = db;
}
#pragma mark 插入数据
- (IBAction)insert:(id)sender
{
    for (int i = 0; i < 10; i ++)
    {
        NSString *name = [NSString stringWithFormat:@"stu%d",i];
        
        // executeUpdate : 不确定的参数用?来占位
        [self.db executeUpdate:@"INSERT INTO student (name, age) VALUES (?, ?);", name, @(arc4random() % 40)];
    }
    NSLog(@"插入成功");
}
#pragma mark 更新
- (IBAction)updata:(id)sender
{
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM student;"];      // 执行查询语句 查找表名
    
    // 遍历结果
    while ([resultSet next])
    {
        
        // 获取信息 id name age
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSLog(@"%d %@ %d", ID, name, age);
    }
    
    NSLog(@"更新完毕");
}
#pragma mark 删除
- (IBAction)delete:(id)sender
{
    // 删除表中 name 为 stu2 的
    [self.db executeUpdate:@"DELETE FROM student WHERE name = 'stu2';"];
}
#pragma mark 删除所有
- (IBAction)deleteAll:(id)sender
{
    //删除整个表
    [self.db executeUpdate:@"DROP TABLE IF EXISTS student;"];
    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
    NSLog(@"已全部删除");
}
#pragma mark 查询
- (IBAction)select:(id)sender
{
    // 执行查询语句 查找id为3的
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT *FROM student WHERE id = 3;"];
    if ([resultSet next])
    {
        NSLog(@"有");
    }
    else
    {
        NSLog(@"没有");
    }
}

#pragma mark 修改
- (IBAction)revise:(id)sender
{
    // 将姓名为 stu7 的age修改为80
    [self.db executeUpdate:@"UPDATE student SET age = 80 WHERE name = 'stu7';"];
    NSLog(@"修改完毕");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
