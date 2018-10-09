//
//  UnicornBinding.h
//  UnicornTest
//
//  Created by Felix Wehnert on 10.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UnicornDelegate <NSObject>

-(void)memoryWriteTo: (int64_t)address value: (int64_t)value size: (size_t)size;
-(void)instructionExecuted: (int64_t)address size: (size_t)size;
-(void)executionFinished;

@end

@interface Unicorn: NSObject

@property (weak) id<UnicornDelegate> delegate;

+ (NSString*) versionString;

-(instancetype)initWithEmulationMode:(int) emulationMode;

-(void)run;

-(void)createMemoryWithPointer: (void*) pointer size: (size_t) size;
-(int)writeCode:(uint8_t*)code length: (size_t) length;
-(void)setRegister:(int) reg toValue:(uint64_t) value;
-(uint64_t)readRegister:(int) reg;
-(uint8_t*)readMemory:(uint64_t)addr size: (size_t)size;
-(void)writeMemory:(uint64_t)address data:(uint8_t*)bytes size:(size_t)size;

@end

NS_ASSUME_NONNULL_END
