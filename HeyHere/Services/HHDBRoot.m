//
//  HHDBRoot.m
//  HeyHere
//
//  Created by 虞鸿礼 on 16/1/26.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HHDBRoot.h"
#import "HHFileManager.h"
#import "HHColors.h"

static const long ddLogLevel = DDLogLevelAll;

@interface HHDBRoot()

@property (nonatomic, copy) NSString *databasePath;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation HHDBRoot
DEFINE_SINGLETON_FOR_CLASS(HHDBRoot);

- (instancetype)init {
    self = [super init];
    if(self) {
        _tableName = @"HHCOLORSDATA";
        _databasePath = [NSString stringWithFormat:@"%@/%@", [HHFileManager CachesDirectory], @"HHColors.sqlite3"];
        _database = [FMDatabase databaseWithPath:_databasePath];
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
        if (![_database open]) {
            [_database close];
            DDLogError(@"DB Open Error");
        }
    }
    return self;
}

- (void)dealloc {
    [_database close];
}

- (BOOL)checkDatabaseIfNeedRawData {
    return [self getTableItemsCount:self.tableName] == 0;
}

- (void)createDatabaseWithMainColors:(NSMutableArray *)mainColors { // 第一次初始化 plist 数据同步到DB
    if ([self checkTableIfExists:self.tableName]) {
        DDLogDebug(@"HHCOLORSDATA exists");
    } else {
        NSString *sql = @"create table HHCOLORSDATA (colorsID integer primary key, colorsName string, colorsData blob)";
        if ([self.database executeStatements:sql]) {
            DDLogDebug(@"HHCOLORSDATA created");
        } else {
            DDLogError(@"cteate table Error");
        }
    }
    for (HHColors *colors in mainColors) {
        NSData *colorsData = [NSKeyedArchiver archivedDataWithRootObject:colors.colors];
        BOOL success = [self.database executeUpdate:@"insert into HHCOLORSDATA values (?,?,?)",
                        colors.colorsID, colors.colorsName, colorsData];
        if (!success) {
            DDLogError(@"insert raw data Error");
        }
    }
}

- (void)restoreDataFromeDataBase:(mutableArrayComplitionHandler)complition {
    NSString *insertSqlStr = @"SELECT * FROM HHCOLORSDATA";
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *resaultSet = [database executeQuery:insertSqlStr];
        NSMutableArray *mainColors = [[NSMutableArray alloc] init];
        while ([resaultSet next]) {
            NSString *colorsID = [NSString stringWithFormat:@"%ld", [resaultSet longForColumn:@"colorsID"]];
            NSString *colorsName = [resaultSet stringForColumn:@"colorsName"];
            NSData *colorsData = [resaultSet dataForColumn:@"colorsData"];
            if (colorsData && [colorsData length] > 0) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[colorsID, colorsName, colorsData]
                                                                                forKeys:@[@"colorsID", @"colorsName", @"colorsData"]];
                HHColors *colors = [[HHColors alloc] initWithDataBaseInfo:dic];
                [mainColors addObject:colors];
            } else {
                continue;
            }
        }
        [resaultSet close];
        if (complition) {
            complition(mainColors);
        }
    }];
}

- (void)deleteDatabse {
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // delete the old db.
    if ([fileManager fileExistsAtPath:self.databasePath]) {
        [self.database close];
        success = [fileManager removeItemAtPath:self.databasePath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
}

#pragma mark Table
- (BOOL)checkTableIfExists:(NSString *)tableName {
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([resultSet next]) {
        NSInteger count = [resultSet intForColumn:@"count"];
        return (count > 0);
    }
    return NO;
}

- (NSInteger)getTableItemsCount:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *resultSet = [self.database executeQuery:sqlstr];
    NSInteger count = 0;
    while ([resultSet next]) {
        count = [resultSet intForColumn:@"count"];
    }
    [resultSet close];
    return count;
}

- (BOOL)createTable:(NSString *)tableName
       withArguments:(NSString *)arguments {
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];
    return [self.database executeUpdate:sqlstr];
}

- (BOOL)dropTable:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    return [self.database executeUpdate:sqlstr];
}

- (BOOL)deleteTable:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    return [self.database executeUpdate:sqlstr];
}

#pragma mark Business
- (void)addColors:(HHColors *)colors {
    NSData *colorsData = [NSKeyedArchiver archivedDataWithRootObject:colors.colors];
    [self.database executeUpdate:@"INSERT INTO HHCOLORSDATA (colorsID, colorsName, colorsData) VALUES (?,?,?)",
     colors.colorsID, colors.colorsName, colorsData];
}

@end
