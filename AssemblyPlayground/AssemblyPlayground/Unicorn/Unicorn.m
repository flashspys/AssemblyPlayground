//
//  UnicornBinding.m
//  UnicornTest
//
//  Created by Felix Wehnert on 10.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

#include <unicorn/unicorn.h>
#import "Unicorn.h"

void memoryHook(uc_engine *uc, uc_mem_type type, uint64_t address, int size, int64_t value, void *user_data) {
    Unicorn *selfPointer = (__bridge Unicorn *)(user_data);
    [[selfPointer delegate] memoryWriteTo: address value: value size: size];
}

void invalidMemoryHook(uc_engine *uc, uc_mem_type type, uint64_t address, int size, int64_t value, void *user_data) {
    //Unicorn *selfPointer = (__bridge Unicorn *)(user_data);
    NSLog(@"Failed to write to: %llu", address);
    
}

void codeHook(uc_engine *uc, uint64_t address, uint32_t size, void *user_data) {
    Unicorn *selfPointer = (__bridge Unicorn *)(user_data);
    [[selfPointer delegate] instructionExecuted:address size:size];
}

@implementation Unicorn {
    uc_engine *uc;
    unsigned long codeLength;
    unsigned long memorySize;
    
    uc_hook memoryWriteHookID;
    uc_hook memoryInvalidHookID;
    uc_hook codeHookID;
}

+(NSString*) versionString {
    unsigned int major;
    unsigned int minor;
    uc_version(&major, &minor);
    return [NSString stringWithFormat:@"%i.%i", major, minor];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self createEngine];
        [self setMemoryWriteHook];
    }
    return self;
}

-(void)createEngine {
    uc_err err = uc_open(UC_ARCH_X86, UC_MODE_64, &uc);
    if (err != UC_ERR_OK) {
        printf("Failed on uc_open() with error returned: %u\n", err);
        return;
    }
}

-(void)createMemoryWithPointer: (void*)pointer size: (size_t)size {
    // map 2MB memory for this emulation
    uc_mem_map_ptr(uc, 0, size, UC_PROT_ALL, pointer);
    memorySize = size;
}

-(void)run {
    // emulate code in infinite time & unlimited instructions
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        uc_err err = uc_emu_start(self->uc, self->memorySize - self->codeLength, self->memorySize, 0, 0);
        if (err) {
            printf("Failed on uc_emu_start() with error returned %u: %s\n", err, uc_strerror(err));
        }
        [self.delegate executionFinished];
    });
}

-(void)writeCode:(uint8_t*)code length: (size_t) length{
    // write machine code to be emulated to memory
    if (uc_mem_write(uc, memorySize-length, code, length)) {
        printf("Failed to write emulation code to memory, quit!\n");
        return;
    }
    codeLength = length;
    //[self setCodeHook];
}

-(void)setRegister:(X86Register) reg toValue:(uint64_t) value {
    uc_reg_write(uc, reg, &value);
}

-(uint64_t)readRegister:(X86Register) reg {
    uint64_t value = 0; // Int is not large enough for some registers
    uc_reg_read(uc, reg, &value);
    return value;
}

-(uint8_t*)readMemory:(uint64_t)addr size: (size_t)size {
    uint8_t* bytes = malloc(size);
    uc_mem_read(uc, addr, bytes, size);
    return bytes;
}

-(void)writeMemory: (uint64_t) address data: (uint8_t*) bytes size:(size_t) size  {
    uc_mem_write(uc, address, bytes, size);
}

-(void)setMemoryWriteHook {
    uc_hook_del(uc, memoryWriteHookID);
    uc_hook_del(uc, memoryInvalidHookID);
    uc_hook_add(uc, &memoryWriteHookID, UC_HOOK_MEM_WRITE, memoryHook, (__bridge void *)(self), 1, 0);
    uc_hook_add(uc, &memoryInvalidHookID, UC_HOOK_MEM_INVALID, invalidMemoryHook, (__bridge void *)(self), 1, 0);
}

-(void)setCodeHook {
    uc_hook_del(uc, codeHookID);
    uc_hook_add(uc, &codeHookID, UC_HOOK_CODE, codeHook, (__bridge void *)(self), memorySize-codeLength, memorySize);
}

-(void)dealloc {
    uc_hook_del(uc, memoryWriteHookID);
    uc_hook_del(uc, codeHookID);
    uc_close(uc);
}

@end
