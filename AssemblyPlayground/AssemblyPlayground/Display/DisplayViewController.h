//
//  DisplayViewController.h
//  UnicornTest
//
//  Created by Felix Wehnert on 19.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Display.h"

NS_ASSUME_NONNULL_BEGIN

@interface DisplayViewController : NSViewController

@property (weak) IBOutlet Display *display;

-(void)rand;
-(void)setMemory:(void*)pointer;
@end

NS_ASSUME_NONNULL_END
