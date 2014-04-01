//
//  DTBeaconRegion.h
//  DTMacBeaconEmitter
//
//  Created by 田單單 on 2014/4/1.
//  Copyright (c) 2014年 Tien Wei Shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTBeaconRegion : NSObject

@property (strong,nonatomic) NSUUID *proximityUUID;
@property (assign,nonatomic) uint16_t major;
@property (assign,nonatomic) uint16_t minor;
@property (assign,nonatomic) int8_t measuredPower;

- (id)initWithProximityUUID:(NSUUID *)proximityUUID major:(uint16_t)major minor:(uint16_t)minor identifier:(NSString *)identifier;
- (NSDictionary *)peripheralDataWithMeasuredPower:(NSNumber *)measuredPower;
@end
