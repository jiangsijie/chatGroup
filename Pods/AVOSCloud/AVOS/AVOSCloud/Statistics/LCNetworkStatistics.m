//
//  LCNetworkStatistics.m
//  AVOS
//
//  Created by Tang Tianyong on 6/26/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import "LCNetworkStatistics.h"
#import "LCKeyValueStore.h"
#import "AVAnalyticsUtils.h"
#import "AVPaasClient.h"
#import "AVUtils.h"
#import <libkern/OSAtomic.h>

#define LC_INTERVAL_HALF_AN_HOUR 30 * 60

static NSTimeInterval LCNetworkStatisticsCheckInterval  = 60; // A minute
static NSTimeInterval LCNetworkStatisticsUploadInterval = 24 * 60 * 60; // A day

//After v3.7.0, SDK use millisecond instead of second as time unit in networking performance.
static NSString *LCNetworkStatisticsInfoKey       = @"LCNetworkStatisticsInfoKey" @"-" @"v1.0";
static NSString *LCNetworkStatisticsLastUpdateKey = @"LCNetworkStatisticsLastUpdateKey";
static NSInteger LCNetworkStatisticsMaxCount      = 10;
static NSInteger LCNetworkStatisticsCacheSize     = 20;

@interface LCNetworkStatistics ()

@property (nonatomic, assign) BOOL                 enable;
@property (nonatomic, strong) NSMutableDictionary *cachedStatisticDict;
@property (nonatomic, strong) NSRecursiveLock     *cachedStatisticDictLock;
@property (nonatomic, assign) NSTimeInterval       cachedLastUpdatedAt;

@end

@implementation LCNetworkStatistics

+ (instancetype)sharedInstance {
    static LCNetworkStatistics *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _cachedStatisticDictLock = [[NSRecursiveLock alloc] init];
    }

    return self;
}

- (NSMutableDictionary *)statisticsInfo {
    NSMutableDictionary *dict = nil;
    [self.cachedStatisticDictLock lock];
    if (self.cachedStatisticDict) {
        dict = self.cachedStatisticDict;
    } else {
        LCKeyValueStore *store = [LCKeyValueStore sharedInstance];
        NSData *data = [store dataForKey:LCNetworkStatisticsInfoKey];
        if (data) {
            dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else {
            dict = [NSMutableDictionary dictionary];
        }
    }
    [self.cachedStatisticDictLock unlock];
    return dict;
}

- (void)saveStatisticsDict:(NSDictionary *)statisticsDict {
    [self.cachedStatisticDictLock lock];
    self.cachedStatisticDict = [statisticsDict mutableCopy];
    [self.cachedStatisticDictLock unlock];
}

- (void)writeCachedStatisticsDict {
    [self.cachedStatisticDictLock lock];
    if (self.cachedStatisticDict) {
        LCKeyValueStore *store = [LCKeyValueStore sharedInstance];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.cachedStatisticDict];
        [store setData:data forKey:LCNetworkStatisticsInfoKey];
    }
    [self.cachedStatisticDictLock unlock];
}

- (void)addIncrementalAttribute:(NSInteger)amount forKey:(NSString *)key {
    [self.cachedStatisticDictLock lock];
    NSMutableDictionary *statisticsInfo = [self statisticsInfo];
    NSNumber *value = statisticsInfo[key];
    if (value) {
        statisticsInfo[key] = @([value integerValue] + amount);
    } else {
        statisticsInfo[key] = @(amount);
    }
    [self saveStatisticsDict:statisticsInfo];
    [self.cachedStatisticDictLock unlock];
}

- (void)addAverageAttribute:(double)amount forKey:(NSString *)key {
    [self.cachedStatisticDictLock lock];
    NSMutableDictionary *statisticsInfo = [self statisticsInfo];
    NSNumber *value = statisticsInfo[key];
    if (value) {
        statisticsInfo[key] = @(([value doubleValue] + amount) / 2.0);
    } else {
        statisticsInfo[key] = @(amount);
    }
    [self saveStatisticsDict:statisticsInfo];
    [self.cachedStatisticDictLock unlock];
}

- (void)uploadStatisticsInfo:(NSDictionary *)statisticsInfo
{
    NSMutableDictionary *payloadDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if (statisticsInfo) { payloadDic[@"attributes"] = statisticsInfo; }
    
    NSMutableDictionary *clientDic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    NSDictionary *deviceInfo = [AVAnalyticsUtils deviceInfo];
    
#if !TARGET_OS_WATCH
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    id deviceId = deviceInfo[@"device_id"];
    if (deviceId) { clientDic[@"id"] = deviceId; }
#endif
#endif
    
    id platform = deviceInfo[@"os"];
    if (platform) { clientDic[@"platform"] = platform; }
    
    id appVersion = deviceInfo[@"app_version"];
    if (appVersion) { clientDic[@"app_version"] = appVersion; }
    
    id sdkVersion = deviceInfo[@"sdk_version"];
    if (sdkVersion) { clientDic[@"sdk_version"] = sdkVersion; }
    
    payloadDic[@"client"] = clientDic;

    AVPaasClient *client = [AVPaasClient sharedInstance];
    NSURLRequest *request = [client requestWithPath:@"always_collect" method:@"POST" headers:nil parameters:payloadDic];

    [client
     performRequest:request
     success:^(NSHTTPURLResponse *response, id responseObject) {
         [self statisticsInfoDidUpload];
     }
     failure:nil];
}

- (void)statisticsInfoDidUpload {
    [self.cachedStatisticDictLock lock];
    // Reset network statistics data
    LCKeyValueStore *store = [LCKeyValueStore sharedInstance];
    [store deleteKey:LCNetworkStatisticsInfoKey];
    // Clean cached statistic dict
    [self.cachedStatisticDict removeAllObjects];
    // Increase check interval to save CPU time
    LCNetworkStatisticsCheckInterval = LC_INTERVAL_HALF_AN_HOUR;
    [self updateLastUpdateAt];
    [self.cachedStatisticDictLock unlock];
}

- (void)updateLastUpdateAt {
    LCKeyValueStore *store = [LCKeyValueStore sharedInstance];

    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSData *dateData = [NSData dataWithBytes:&now length:sizeof(now)];

    [store setData:dateData forKey:LCNetworkStatisticsLastUpdateKey];

    self.cachedLastUpdatedAt = now;
}

- (NSTimeInterval)lastUpdateAt {
    if (self.cachedLastUpdatedAt > 0) {
        return self.cachedLastUpdatedAt;
    }

    LCKeyValueStore *store = [LCKeyValueStore sharedInstance];
    NSData *dateData = [store dataForKey:LCNetworkStatisticsLastUpdateKey];

    if (dateData) {
        NSTimeInterval lastUpdateAt = 0;
        [dateData getBytes:&lastUpdateAt length:sizeof(lastUpdateAt)];

        self.cachedLastUpdatedAt = lastUpdateAt;

        return lastUpdateAt;
    }

    return 0;
}

- (BOOL)atTimeToUpload {
    NSTimeInterval lastUpdateAt = [self lastUpdateAt];

    if (lastUpdateAt <= 0) {
        return YES;
    }

    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

    if (now - lastUpdateAt > LCNetworkStatisticsUploadInterval) {
        return YES;
    } else {
        return NO;
    }
}

- (void)startInBackground
{
    NSAssert(![NSThread isMainThread], @"This method must run in background.");

    AV_WAIT_WITH_ROUTINE_TIL_TRUE(!self.enable, LCNetworkStatisticsCheckInterval, ({
        NSDictionary *statisticsInfo = [[self statisticsInfo] copy];

        NSInteger total = [statisticsInfo[@"total"] integerValue];

        if (total > 0) {
            if ([self atTimeToUpload] || total > LCNetworkStatisticsMaxCount) {
                [self uploadStatisticsInfo:statisticsInfo];
            }
            if (total % LCNetworkStatisticsCacheSize == 0) {
                [self writeCachedStatisticsDict];
            }
        }
    }));
}

- (void)start {
    if (!self.enable) {
        self.enable = YES;
        [self performSelectorInBackground:@selector(startInBackground) withObject:nil];
    }
}

- (void)stop {
    self.enable = NO;
}

@end
