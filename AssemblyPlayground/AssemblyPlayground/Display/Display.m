//
//  Display.m
//  UnicornTest
//
//  Created by Felix Wehnert on 19.08.18.
//  Copyright © 2018 Felix Wehnert. All rights reserved.
//

#import "Display.h"


static const size_t kComponentsPerPixel = 1;
static const size_t kBitsPerComponent = sizeof(unsigned char) * 8;

static const NSInteger layerHeight = 160;
static const NSInteger layerWidth = 160;

static const size_t bufferLength = layerWidth * layerHeight * kComponentsPerPixel;


@implementation Display {
    CGDataProviderRef provider;
    CGColorSpaceRef colorSpace;
}

- (void)awakeFromNib {
    [NSLayoutConstraint activateConstraints:@[
                                              [self.widthAnchor constraintEqualToConstant:layerWidth],
                                              [self.heightAnchor constraintEqualToConstant:layerHeight]
                                              ]];
}

- (void) initMemory:(Byte*) pointer {
    
    // The real function does something more interesting with the buffer, but I cut it
    // to reduce the complexity while I figure out the crash.
    for (NSInteger i = 0; i < bufferLength; ++i)
    {
        //pointer[i] = i % 0xFF;
    }
    //memset(buffer, 255, bufferLength);
    
    
    provider = CGDataProviderCreateWithData(NULL, pointer, bufferLength, NULL);//freeBitmapBuffer);
    
    colorSpace = CGColorSpaceCreateDeviceGray();
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    /*CGRect rect = CGRectMake(0, 0, 16, 16);
    
    CGContextDrawImage(context, rect, )
    */
    
    //CGContextSaveGState(context);
    
    CGImageRef imageRef =
    CGImageCreate(layerWidth, layerHeight, kBitsPerComponent,
                  kBitsPerComponent * kComponentsPerPixel,
                  kComponentsPerPixel * layerWidth,
                  colorSpace,
                  kCGBitmapByteOrderDefault | kCGImageAlphaNone,
                  provider, NULL, false, kCGRenderingIntentDefault);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 160, 160), imageRef);
    
    CGImageRelease(imageRef);
    
    //CGContextRestoreGState(context);
}

- (void)dealloc
{
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
}

@end
