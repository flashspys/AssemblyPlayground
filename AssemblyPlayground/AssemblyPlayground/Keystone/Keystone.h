//
//  Keystone.h
//  UnicornTest
//
//  Created by Felix Wehnert on 11.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Keystone : NSObject

/// three dimensional metadata array
/// contains a mapping between assembly and opcode
@property NSArray<NSArray<NSArray<NSNumber*>*>*>* metaData;
@property (copy, nullable) NSNumber* lastErrorNumber;
    
-(nullable uint8_t*)assemble: (NSString*) string
                        size: (size_t*) size
               emulationMode: (int) emulationMode;
@end

NS_ASSUME_NONNULL_END
