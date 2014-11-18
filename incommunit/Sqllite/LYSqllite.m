//
//  LY_Sqllite.m
//  in_community
//  数据库操作类
//  Created by wangliang on 14-9-15.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//
#import "LYSqllite.h"
#import "sqlite3.h"

static NSDictionary *selectedCommunitInfo;

@implementation LYSqllite
#pragma mark - 打开数据库
-(sqlite3 *)openSqlite:(NSString *)database_name
{
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:database_name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断数据库是否存在
    BOOL find = [fileManager fileExistsAtPath:path];
    //如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
    if (find) {
        if(sqlite3_open([path UTF8String], &database) != SQLITE_OK)
        {
            //如果打开数据库失败则关闭数据库
            sqlite3_close(database);
            NSLog(@"Error: open database file.");
            return nil;
        }else
        {
            return database;
        }
    }
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        return database;
    } else {
        return nil;
    }
}

#pragma mark - 执行SQL语句
-(BOOL)execSql:(NSString *)sql database:(sqlite3 *)database
{
    char *err;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库操作数据失败!");
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
#pragma mark 用户信息表
//创建用户登录信息表信息表
+(void)CreatUserTable
{

    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS USERINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, auth_status TEXT,user TEXT,password TEXT,UserFlag bool,user_id TEXT)";
    [[[LYSqllite alloc] init] execSql:sqlCreateTable database:tempdatabase];
    sqlite3_close(tempdatabase);
}
//向用户表中加入数据
+(BOOL)wuser:(NSMutableDictionary *)userinfo
{
    [self CreatUserTable];
    BOOL bl;
    if (userinfo!=nil) {
        [self deletetable];
        sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
        NSString *sql = [NSString stringWithFormat:
                                         @"INSERT INTO USERINFO ('auth_status',user,password,UserFlag,user_id) VALUES ('%@', '%@', '%@','%d','%@')",
                                         [userinfo objectForKey:@"auth_status"],
                                         [userinfo objectForKey:@"user"],
                                         [userinfo objectForKey:@"password"],
                                        [[userinfo objectForKey:@"UserFlag"] boolValue],
                                        [userinfo objectForKey:@"user_id"]];
       bl = [[[LYSqllite alloc] init]execSql:sql database:tempdatabase];
    }
return bl;
}


//创建小区表
+(void)CreatCommunit
{
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS Communitinfo (ID INTEGER PRIMARY KEY AUTOINCREMENT, city_id TEXT, community_id INTEGER, communitname TEXT,communitaddress TEXT, communitdistance TEXT, communitmax_level TEXT,CurrentFlag bool)";
    [[[LYSqllite alloc] init] execSql:sqlCreateTable database:tempdatabase];
    sqlite3_close(tempdatabase);
}

//向小区记录表插入数据
+(void)WriteComunitInfo:(NSDictionary *)Comunitinfo
{
    [self CreatCommunit];
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    sqlite3_stmt *statementst = nil;
    NSString *sqlstc = [[NSString alloc] initWithFormat:@"SELECT * FROM Communitinfo WHERE community_id = '%@'",[Comunitinfo objectForKey:@"community_id"]];
    if (sqlite3_prepare_v2(tempdatabase, [sqlstc UTF8String], -1, &statementst, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get testValue.");
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"delete from Communitinfo where community_id=%@",[Comunitinfo objectForKey:@"community_id"]];
        [[[LYSqllite alloc] init]execSql:sql database:tempdatabase];
    }
    
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO Communitinfo ('city_id',community_id,communitname,communitaddress,communitdistance,communitmax_level,CurrentFlag) VALUES ('%@', '%@', '%@','%@','%@', '%@','%d')",
                     [Comunitinfo objectForKey:@"city_id"],
                     [Comunitinfo objectForKey:@"community_id"],
                     [Comunitinfo objectForKey:@"communitname"],
                     [Comunitinfo objectForKey:@"communitaddress"],
                     [Comunitinfo objectForKey:@"communitdistance"],
                     [Comunitinfo objectForKey:@"communitmax_level"],
                     [[Comunitinfo objectForKey:@"CurrentFlag"] boolValue]];
    [[[LYSqllite alloc] init]execSql:sql  database:tempdatabase];

    char * errmsg = NULL;
    char **dbResult;
    int nRow, nColumn;
    int result = sqlite3_get_table( tempdatabase, "select * from Communitinfo", &dbResult, &nRow, &nColumn, &errmsg );
    if(SQLITE_OK == result)
    {
        if (nRow>5)
        {
            NSDictionary * temp = [self currentCommnit];
            NSString *sql = [NSString stringWithFormat:@"delete from Communitinfo where ID=%@",[temp objectForKey:@"community_id"]];
            [[[LYSqllite alloc] init]execSql:sql database:tempdatabase];
        }
    }
}

+(NSMutableArray *)AllCommunit:(NSString *)communitName
{
    [self CreatCommunit];
    NSMutableArray * communitlist = [[NSMutableArray alloc] init];
    NSMutableDictionary *temp;
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    sqlite3_stmt *statementst = nil;
     NSString *sqlst = [[NSString alloc] initWithFormat:@"SSELECT * FROM Communitinfo WHERE communitname!='%@'",communitName];
    if (sqlite3_prepare_v2(tempdatabase, [sqlst UTF8String], -1, &statementst, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get testValue.");
        return nil;
    }
    else
    {
        while (sqlite3_step(statementst)  == SQLITE_ROW)
        {
            temp = [[NSMutableDictionary alloc] init];
            char* strText   = (char*)sqlite3_column_text(statementst, 1);
            [temp setValue:[NSString stringWithUTF8String:strText] forKey:@"city_id"];
            char* strText01   = (char*)sqlite3_column_text(statementst, 2);
            [temp setValue:[NSString stringWithUTF8String:strText01] forKey:@"community_id"];
            char* strText02   = (char*)sqlite3_column_text(statementst, 3);
            [temp setValue:[NSString stringWithUTF8String:strText02] forKey:@"communitname"];
            char* strText03   = (char*)sqlite3_column_text(statementst, 4);
            [temp setValue:[NSString stringWithUTF8String:strText03] forKey:@"communitaddress"];
            char* strText04   = (char*)sqlite3_column_text(statementst, 5);
            [temp setValue:[NSString stringWithUTF8String:strText04] forKey:@"communitdistance"];
            char* strText05   = (char*)sqlite3_column_text(statementst, 6);
            [temp setValue:[NSString stringWithUTF8String:strText05] forKey:@"communitmax_level"];
            char* strText06   = (char*)sqlite3_column_text(statementst, 7);
            [temp setValue:[NSString stringWithUTF8String:strText06] forKey:@"CurrentFlag"];
            [communitlist addObject:temp];
        }
    }
    return communitlist;

}

+(NSMutableDictionary *)currentCommnit
{
    [self CreatCommunit];
    NSMutableDictionary *temp;
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    sqlite3_stmt *statementst = nil;

    char *sqlst = "SELECT * FROM Communitinfo LIMIT 1 OFFSET (SELECT COUNT(*) - 1  FROM Communitinfo)" ;
    if (sqlite3_prepare_v2(tempdatabase, sqlst, -1, &statementst, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get testValue.");
        return nil;
    }
    else
    {
        while (sqlite3_step(statementst)  == SQLITE_ROW)
        {
            temp = [[NSMutableDictionary alloc] init];
            char* strText   = (char*)sqlite3_column_text(statementst, 1);
            [temp setValue:[NSString stringWithUTF8String:strText] forKey:@"city_id"];
            char* strText01   = (char*)sqlite3_column_text(statementst, 2);
            [temp setValue:[NSString stringWithUTF8String:strText01] forKey:@"community_id"];
            char* strText02   = (char*)sqlite3_column_text(statementst, 3);
            [temp setValue:[NSString stringWithUTF8String:strText02] forKey:@"communitname"];
            char* strText03   = (char*)sqlite3_column_text(statementst, 4);
            [temp setValue:[NSString stringWithUTF8String:strText03] forKey:@"communitaddress"];
            char* strText04   = (char*)sqlite3_column_text(statementst, 5);
            [temp setValue:[NSString stringWithUTF8String:strText04] forKey:@"communitdistance"];
            char* strText05   = (char*)sqlite3_column_text(statementst, 6);
            [temp setValue:[NSString stringWithUTF8String:strText05] forKey:@"communitmax_level"];
            char* strText06   = (char*)sqlite3_column_text(statementst, 7);
            [temp setValue:[NSString stringWithUTF8String:strText06] forKey:@"CurrentFlag"];
        }
    }
    return temp;
}
//删除一条记录
+(void)deleteuserinfo :(NSString *)name

{
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString *sql = [NSString stringWithFormat:@"delete from USERINFO where user=%@",name];
    [[[LYSqllite alloc] init]execSql:sql database:tempdatabase];
}
//读取用户信息表
+(NSMutableDictionary *)Ruser
{

    [self CreatUserTable];
    NSMutableDictionary *temp;
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    sqlite3_stmt *statementst = nil;
    char *sqlst = "SELECT * FROM USERINFO";
    if (sqlite3_prepare_v2(tempdatabase, sqlst, -1, &statementst, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get testValue.");
        return nil;
    }
    else
    {
        while (sqlite3_step(statementst)  == SQLITE_ROW)
        {
            temp = [[NSMutableDictionary alloc] init];
            char* strText   = (char*)sqlite3_column_text(statementst, 1);
            [temp setValue:[NSString stringWithUTF8String:strText] forKey:@"auth_status"];
            char* strText01   = (char*)sqlite3_column_text(statementst, 2);
            [temp setValue:[NSString stringWithUTF8String:strText01] forKey:@"user"];
            char* strText02   = (char*)sqlite3_column_text(statementst, 3);
            [temp setValue:[NSString stringWithUTF8String:strText02] forKey:@"password"];
            char* strText03   = (char*)sqlite3_column_text(statementst, 4);
            [temp setValue:[NSString stringWithUTF8String:strText03] forKey:@"UserFlag"];
            char* strText04   = (char*)sqlite3_column_text(statementst, 5);
            [temp setValue:[NSString stringWithUTF8String:strText04] forKey:@"user_id"];
            
        }
    }
    return temp;
}
    
//删除用户表中数据
+(void)deletecommnuittable
{
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString *sql = @"drop table Communitinfo";
    [[[LYSqllite alloc] init] execSql:sql database:tempdatabase];
    sqlite3_close(tempdatabase);
    [self CreatCommunit];
}



//删除用户表中数据
+(void)deletetable
{
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString *sql = @"drop table USERINFO";
    [[[LYSqllite alloc] init] execSql:sql database:tempdatabase];
    sqlite3_close(tempdatabase);
    [self CreatUserTable];
}



#pragma mark -购物车信息表
//创建购物车表
+(void)CreatShoppingcart
{
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString *sql = @"create table if not exists ShoppingCart(ID INTEGER PRIMARY KEY AUTOINCREMENT, name text,price text,quantity text,commodity_id text,cover_path text,Storesid text,Storesname text,selectState text)";
    [[[LYSqllite alloc] init] execSql:sql database:tempdatabase];
    //创建店铺表
    NSString *sqlst = @"create table if not exists StoresTable(ID INTEGER PRIMARY KEY AUTOINCREMENT, Storesid text,StoresName text)";
    [[[LYSqllite alloc] init] execSql:sqlst database:tempdatabase];
    sqlite3_close(tempdatabase);
}

//向购物车中加入数据
+(BOOL)addShoppingcart:(NSMutableDictionary *)Goods number:(NSString *)numbers StoresID:(NSString *)Storesid Storesname:(NSString *)StoresName selectState:(NSString *)State
{
    BOOL bl;
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    sqlite3_stmt *statementst = nil;
    NSString *sqlstc = [[NSString alloc] initWithFormat:@"SELECT * FROM StoresTable where Storesid = '%@'",Storesid];
    if (sqlite3_prepare_v2(tempdatabase, [sqlstc UTF8String], -1, &statementst, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get testValue.");
        return FALSE;
    }
    else
    {
        NSString *quantity;
        while (sqlite3_step(statementst)  == SQLITE_ROW)
        {
            // NSDictionary *temp = [[NSDictionary alloc] init];
            char* strText03   = (char*)sqlite3_column_text(statementst, 1);
            quantity = [NSString stringWithUTF8String:strText03];
            //[temp setValue:[NSString stringWithUTF8String:strText03] forKey:@"commodity_id"];
        }
        if (quantity==nil||[quantity isEqual:@""])
        {
            NSString *sql = [NSString stringWithFormat:
                             @"INSERT INTO StoresTable ('Storesid', 'StoresName') VALUES ('%@', '%@')",Storesid,StoresName];
            bl = [[[LYSqllite alloc] init]execSql:sql database:tempdatabase];
        }
    }
    
    sqlite3_stmt *statement = nil;
    NSString *sqlc = [[NSString alloc] initWithFormat:@"SELECT * FROM ShoppingCart where commodity_id = '%@'",[Goods objectForKey:@"id"]];
    if (sqlite3_prepare_v2(tempdatabase, [sqlc UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get testValue.");
        return FALSE;
    }
    else
    {
        NSString *quantity;
        while (sqlite3_step(statement)  == SQLITE_ROW)
        {
            // NSDictionary *temp = [[NSDictionary alloc] init];
            char* strText03   = (char*)sqlite3_column_text(statement, 3);
            quantity = [NSString stringWithUTF8String:strText03];
            //[temp setValue:[NSString stringWithUTF8String:strText03] forKey:@"commodity_id"];
        }
        if (quantity!=nil||[quantity isEqual:@""])
        {
            int n =  [quantity intValue]+[numbers intValue];
            NSString * sqlup = [[NSString alloc] initWithFormat:@"UPDATE  ShoppingCart SET  quantity = '%d' WHERE commodity_id = '%@'",n,[Goods objectForKey:@"id"]];
            bl = [[[LYSqllite alloc] init]execSql:sqlup database:tempdatabase];
        }else
        {
            NSString *sql = [NSString stringWithFormat:
                             @"INSERT INTO ShoppingCart ('name', 'price', 'quantity','commodity_id','cover_path','Storesid',Storesname,selectState) VALUES ('%@', '%@', '%@','%@','%@','%@','%@','%@')",[Goods objectForKey:@"name"], [[NSString alloc]initWithFormat:@"%@",[Goods objectForKey:@"price"]] , numbers ,[[NSString alloc]initWithFormat:@"%@",[Goods objectForKey:@"id"]],[Goods objectForKey:@"logo"],Storesid,StoresName,State];
            bl = [[[LYSqllite alloc] init]execSql:sql database:tempdatabase];
        }
    }
    return bl;
}

//查询购物车数据
+ (NSMutableArray*)GetGoods
{
    NSMutableArray *backlist = [[NSMutableArray alloc] init];
    NSMutableArray *Storeslist = [[NSMutableArray alloc] init];
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    sqlite3_stmt *statementst = nil;
    NSMutableArray *goodslist;
    char *sqlst = "SELECT * FROM StoresTable";
    if (sqlite3_prepare_v2(tempdatabase, sqlst, -1, &statementst, NULL) != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message:get testValue.");
        return nil;
    }
    else
    {
        while (sqlite3_step(statementst)  == SQLITE_ROW)
        {
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
            char* strText   = (char*)sqlite3_column_text(statementst, 1);
            [temp setValue:[NSString stringWithUTF8String:strText] forKey:@"Storesid"];
            char* strText01   = (char*)sqlite3_column_text(statementst, 2);
            [temp setValue:[NSString stringWithUTF8String:strText01] forKey:@"StoresName"];
            [Storeslist addObject:temp];
        }
    }
    
    for (int i = 0; i<Storeslist.count; i++)
    {
        NSMutableDictionary *temp = [Storeslist objectAtIndex:i];
        sqlite3_stmt *statement = nil;
        NSString * sql = [[NSString alloc] initWithFormat:@"SELECT * FROM ShoppingCart WHERE Storesid = '%@'",[temp objectForKey:@"Storesid"]];
        if (sqlite3_prepare_v2(tempdatabase, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            NSLog(@"Error: failed to prepare statement with message:get testValue.");
            return nil;
        }
        else
        {
            goodslist = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement)  == SQLITE_ROW)
            {
                NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                char* strText   = (char*)sqlite3_column_text(statement, 1);
                [temp setValue:[NSString stringWithUTF8String:strText] forKey:@"name"];//商品名字
                char* strText01   = (char*)sqlite3_column_text(statement, 2);
                [temp setValue:[NSString stringWithUTF8String:strText01] forKey:@"price"];//商品价格
                char* strText02   = (char*)sqlite3_column_text(statement, 3);
                [temp setValue:[NSString stringWithUTF8String:strText02] forKey:@"quantity"];//商品数量
                char* strText03   = (char*)sqlite3_column_text(statement, 4);
                [temp setValue:[NSString stringWithUTF8String:strText03] forKey:@"commodity_id"];//商品ID
                char* strText04   = (char*)sqlite3_column_text(statement, 5);
                [temp setValue:[NSString stringWithUTF8String:strText04] forKey:@"logo"]; //商品logo
                char* strText05   = (char*)sqlite3_column_text(statement, 6);
                [temp setValue:[NSString stringWithUTF8String:strText05] forKey:@"Storesid"];//店铺id
                char* strText06   = (char*)sqlite3_column_text(statement, 7);
                [temp setValue:[NSString stringWithUTF8String:strText06] forKey:@"Storesname"];//店铺名字
                char* strText07   = (char*)sqlite3_column_text(statement, 8);
                [temp setValue:[NSString stringWithUTF8String:strText07] forKey:@"selectState"];//是否选中
                [goodslist addObject:temp];
                //        sqlTestList* sqlList = [[sqlTestList alloc] init] ;
                //        sqlList.sqlID    = sqlite3_column_int(statement,0);
                //        char* strText   = (char*)sqlite3_column_text(statement, 1);
                //        sqlList.sqlText = [NSString stringWithUTF8String:strText];
                //        char *strName = (char*)sqlite3_column_text(statement, 2);
                //        sqlList.sqlname = [NSString stringWithUTF8String:strName];
            }
        }
        if(goodslist.count>0)
        {
            [backlist addObject:goodslist];
        }
        sqlite3_finalize(statement);
        sqlite3_close(tempdatabase);
    }
    sqlite3_finalize(statementst);
    sqlite3_close(tempdatabase);
    return backlist ;
}

//删除指定的商品
+(void)delectGoods:(NSString *)selectState
{
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString * sqlstr = [[NSString alloc] initWithFormat:@"delete from ShoppingCart WHERE selectState=%@",selectState];
    [[[LYSqllite alloc]init]execSql:sqlstr database:tempdatabase];
}

+(BOOL)Modifystate:(NSString *)GoodsID state:(NSString *)statestr
{
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString * sqlstr = [[NSString alloc] initWithFormat:@"UPDATE ShoppingCart SET selectState = '%@' WHERE commodity_id = '%@'",statestr,GoodsID];
    BOOL bl = [[[LYSqllite alloc]init]execSql:sqlstr database:tempdatabase];
    return bl;
}

//修改商品数量
+(BOOL)Modifyquantity:(NSString *)GoodsID quantity:(NSString *)quantitystr
{
    sqlite3 *tempdatabase =  [[[LYSqllite alloc] init] openSqlite:@"LY_db.db"];
    NSString * sqlstr = [[NSString alloc] initWithFormat:@"UPDATE ShoppingCart SET quantity = '%@' WHERE commodity_id = '%@'",quantitystr,GoodsID];
    BOOL bl = [[[LYSqllite alloc]init]execSql:sqlstr database:tempdatabase];
    return bl;
}

+ (NSDictionary *)selectedCommunit {
    return selectedCommunitInfo;
}

+ (void)setSelectedCommunit:(NSDictionary *)communitInfo {
    selectedCommunitInfo = communitInfo;
}

@end
