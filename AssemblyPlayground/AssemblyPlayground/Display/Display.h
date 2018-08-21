//
//  Display.h
//  UnicornTest
//
//  Created by Felix Wehnert on 19.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface Display : NSView
- (void) initMemory:(Byte*) pointer;
@end

NS_ASSUME_NONNULL_END
