//
//  DTBeaconRegion.m
//  DTMacBeaconEmitter
//
//  Created by 田單單 on 2014/4/1.
//  Copyright (c) 2014年 Tien Wei Shin. All rights reserved.
//

#import "DTBeaconRegion.h"

@implementation DTBeaconRegion
- (id)initWithProximityUUID:(NSUUID *)proximityUUID major:(uint16_t)major minor:(uint16_t)minor identifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        self.proximityUUID = proximityUUID;
		self.major = major;
		self.minor = minor;
    }
    return self;
}

- (NSDictionary *)peripheralDataWithMeasuredPower:(NSNumber *)measuredPower
{
    if (!measuredPower) {
        measuredPower = @-59;
    }

	NSString *beaconKey = @"kCBAdvDataAppleBeaconKey";

    unsigned char advertisementBytes[21] = {0};

    [self.proximityUUID getUUIDBytes:(unsigned char *)&advertisementBytes];

    advertisementBytes[16] = (unsigned char)(self.major >> 8);
    advertisementBytes[17] = (unsigned char)(self.major & 255);

    advertisementBytes[18] = (unsigned char)(self.minor >> 8);
    advertisementBytes[19] = (unsigned char)(self.minor & 255);

    advertisementBytes[20] = measuredPower.shortValue;

    NSMutableData *advertisement = [NSMutableData dataWithBytes:advertisementBytes length:21];

    return [NSDictionary dictionaryWithObject:advertisement forKey:beaconKey];
}
@end
