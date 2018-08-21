//
//  DisplayViewController.m
//  UnicornTest
//
//  Created by Felix Wehnert on 19.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController

@synthesize display;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(void)setMemory:(void *)pointer {
    [display initMemory:(Byte*)pointer];
}

-(void)rand {
    
    [display rand];
    
}

@end
