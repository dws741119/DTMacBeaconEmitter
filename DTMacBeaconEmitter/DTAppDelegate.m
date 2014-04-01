//
//  DTAppDelegate.m
//  DTMacBeaconEmitter
//
//  Created by 田單單 on 2014/3/31.
//  Copyright (c) 2014年 Tien Wei Shin. All rights reserved.
//

#import "DTAppDelegate.h"
#import <IOBluetooth/IOBluetooth.h>
#import "DTBeaconRegion.h"
@interface DTAppDelegate () <CBPeripheralManagerDelegate>
@property (weak,nonatomic) IBOutlet NSTextField *uuidTextField;
@property (weak,nonatomic) IBOutlet NSTextField *identifierTextField;
@property (weak,nonatomic) IBOutlet NSTextField *majorTextField;
@property (weak,nonatomic) IBOutlet NSTextField *minorTextField;
@property (weak,nonatomic) IBOutlet NSTextField *powerTextField;
@property (weak,nonatomic) IBOutlet NSTextField *stateTextField;
@property (weak,nonatomic) IBOutlet NSButton *controlButton;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@end

@implementation DTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];

	self.uuidTextField.stringValue = @"08D4A950-80F0-4D42-A14B-D53E063516E6";
	self.identifierTextField.stringValue = @"TestBeacon";
	self.majorTextField.stringValue = @"1000";
	self.minorTextField.stringValue = @"999";
	self.powerTextField.stringValue = @"-59";
}

#pragma mark - Action

- (IBAction) autoUUID:(id)sender
{
	NSUUID *proximityUUID = [NSUUID UUID];
	[self.uuidTextField setStringValue:[proximityUUID UUIDString]];
}

- (IBAction)changeState:(id)sender
{
	if (self.peripheralManager.isAdvertising) {
		[self.peripheralManager stopAdvertising];
		[self.controlButton setTitle:@"Start"];
	}
	else {
		[self loadBeacon];
	}
}

- (IBAction)reloadSetting:(id)sender
{
    if ([self.peripheralManager isAdvertising]) {
        [self.peripheralManager stopAdvertising];
		[self loadBeacon];
    }
}

- (void)loadBeacon
{
	NSString *UUID = self.uuidTextField.stringValue;
	NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:UUID];
	if (proximityUUID) {
		DTBeaconRegion *beacon = [[DTBeaconRegion alloc] initWithProximityUUID:proximityUUID major:self.majorTextField.integerValue minor:self.minorTextField.integerValue identifier:self.identifierTextField.stringValue];
		NSNumber *measuredPower = nil;
		if (self.powerTextField.intValue != 0) {
			measuredPower = [NSNumber numberWithInt:self.powerTextField.intValue];
		}
		[self.peripheralManager startAdvertising:[beacon peripheralDataWithMeasuredPower:measuredPower]];
		[self.controlButton setTitle:@"Stop"];
	}
	else {
		NSAlert *alert =[NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"The UUID format is invalid"];
		[alert runModal];
		[self.controlButton setTitle:@"Start"];
	}
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
	[self.controlButton setEnabled:peripheral.state == CBPeripheralManagerStatePoweredOn];
	self.stateTextField.stringValue = @[
										@"CBPeripheralManagerStateUnknown",
										@"CBPeripheralManagerStateUnauthorized",
										@"CBPeripheralManagerStateResetting",
										@"CBPeripheralManagerStatePoweredOff",
										@"CBPeripheralManagerStateUnsupported",
										@"CBPeripheralManagerStatePoweredOn"][peripheral.state];
}

@end
