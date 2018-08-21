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

-(uint8_t*)assemble: (NSString*) string size: (size_t*) size {
    ks_err err;
    size_t count;
    uint8_t *encode;
    const char* code = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    err = ks_open(KS_ARCH_X86, KS_MODE_64, &ks);
    if (err != KS_ERR_OK) {
        printf("ERROR: failed on ks_open(), quit\n");
        return NULL;
    }
    
    ks_option(ks, KS_OPT_SYNTAX, KS_OPT_SYNTAX_NASM);
    
    if (ks_asm(ks, code, 0, &encode, size, &count) != KS_ERR_OK) {
        printf("Error #%i parsing: %s =>  %s",ks_errno(ks), code, ks_strerror(ks_errno(ks)));
        return NULL;
    } else {
        uint8_t* assembly = malloc(*size);
        memcpy(assembly, encode, *size);
        
        // NOTE: free encode after usage to avoid leaking memory
        ks_free(encode);
        
        return assembly;
    }
}

- (void)dealloc
{
    // close Keystone instance when done
    ks_close(ks);
}

@end
