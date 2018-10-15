//
//  Keystone.m
//  UnicornTest
//
//  Created by Felix Wehnert on 11.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

#import "Keystone.h"
#import <keystone/keystone.h>

@implementation Keystone {
    ks_engine* ks;
}

-(nullable uint8_t*)assemble: (NSString*) string
                        size: (size_t*) size
               emulationMode: (int) emulationMode {
    ks_err err;
    uint8_t *encode;
    int* infoArray;
    size_t infoSize;
    
    char* code = calloc(string.length + 1, sizeof(char));
    
    const char* localcode = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (localcode == NULL) {
        NSLog(@"the receiver cannot be losslessly converted to encoding.");
        free(code);
        return NULL;
    }
    strcpy(code, localcode);
    switch (emulationMode) {
        case 0: // x86
            err = ks_open(KS_ARCH_X86, KS_MODE_64, &ks);
            break;
        case 1: // arm64
            err = ks_open(KS_ARCH_ARM64, KS_MODE_LITTLE_ENDIAN, &ks);
            break;
        default:
            free(code);
            printf("ERROR: Unexpected emulationMode");
            return NULL;

    }
    if (err != KS_ERR_OK) {
        printf("ERROR: failed on ks_open() = %d\n", err);
        free(code);
        return NULL;
    }
    
    ks_option(ks, KS_OPT_SYNTAX, KS_OPT_SYNTAX_NASM);
    
    int result = ks_asm_felix(ks, code, 0, &encode, size, &infoArray, &infoSize);
    
    
    uint8_t* assembly = malloc(*size);
    memcpy(assembly, encode, *size);
    
    for (int i = 0; i < infoSize; i++) {
        NSLog(@"infoArray[%d] = %d", i, infoArray[i]);
    }
    ks_free((unsigned char *)infoArray);
    
    if (result != KS_ERR_OK) {
        printf("Error #%i parsing: %s =>  %s\n",ks_errno(ks), code, ks_strerror(ks_errno(ks)));
        free(assembly);
        free(code);
        return NULL;
    } else {
        
        // NOTE: free encode after usage to avoid leaking memory
        ks_free(encode);
        free(code);
        return assembly;
    }
    return NULL;
}

- (void)dealloc
{
    // close Keystone instance when done
    ks_close(ks);
}

@end
