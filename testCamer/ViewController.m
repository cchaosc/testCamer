//
//  ViewController.m
//  testCamer
//
//  Created by chaos on 15/2/11.
//  Copyright (c) 2015年 chaos. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CIColor.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"asdasd");
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    [self.view addSubview:picker.view];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing=YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    /*添加处理选中图像代码*/
    NSLog(@"wo");
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
   
   
    
    

    for (int y = 0; y < (int)height; y++) {
         NSArray* ns = [self getRGBAsFromImage:image atX:0 andY:y count:width];
        for(int x = 0;x < (int)width;x++) {
            UIColor * uc =  [ns objectAtIndex:x];
            const CGFloat *components = CGColorGetComponents(uc.CGColor);
            if(20 < components[0] * 255 && 70 > components[0] * 255&& 20 < components[1] * 255&& 70 > components[1] * 255&& 20 < components[2] * 255&& 70 > components[2]* 255) {
                NSLog(@"%d%s%d%s%f%s%d",x,"------",y,"------",components[0],"+++",(int)width);
                
            }
        }
        
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    /*添加代码，处理选中图像又取消的情况*/
}


- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0 ; i < count ; ++i)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}
@end
